//
//  SecurityService.swift
//  Mood
//
//  Created by Nate Leake on 9/23/24.
//

import Foundation
import CryptoKit
import Security

class SecurityService {
    private let keyTag = "com.nateleake.moodEncryptionKey"
    
    // Custom error type
    enum SecurityServiceError: Error {
        case keychainError(OSStatus)
        case encryptionError(Error)
        case decryptionError(Error)
        case dataEncodingError(Error)
        case dataDecodingError(Error)
    }
    
    static func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    @available(iOS 13, *)
    static func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Generate or retrieve symmetric key
    func getEncryptionKey() throws -> SymmetricKey {
        if let existingKey = try retrieveKeyFromiCloudKeychain() {
            return existingKey
        } else {
            let newKey = generateSymmetricKey()
            try saveKeyToiCloudKeychain(key: newKey)
            return newKey
        }
    }
    
    // Generate a new symmetric key for encryption
    private func generateSymmetricKey() -> SymmetricKey {
        return SymmetricKey(size: .bits256)
    }
    
    // Store the symmetric key in the iCloud Keychain
    private func saveKeyToiCloudKeychain(key: SymmetricKey) throws {
        let keyData = key.withUnsafeBytes { Data(Array($0)) }
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: keyTag,
            kSecValueData as String: keyData,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
            kSecAttrSynchronizable as String: true
        ]
        
        SecItemDelete(query as CFDictionary) // Ensure no duplicates
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            throw SecurityServiceError.keychainError(status)
        }
    }
    
    // Retrieve the key from iCloud Keychain
    private func retrieveKeyFromiCloudKeychain() throws -> SymmetricKey? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: keyTag,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrSynchronizable as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess, let keyData = item as? Data {
            return SymmetricKey(data: keyData)
        } else if status != errSecItemNotFound {
            throw SecurityServiceError.keychainError(status)
        }
        
        return nil
    }
    
    // Remove the key from iCloud Keychain
    func removeKeyFromiCloudKeychain() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: keyTag
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess {
            throw SecurityServiceError.keychainError(status)
        }
    }
    
    // Encrypt data
    func encryptData<T: Codable>(from object: T) throws -> Data {
        let key = try getEncryptionKey()
        
        let jsonData: Data
        do {
            jsonData = try JSONEncoder().encode(object)
        } catch {
            throw SecurityServiceError.dataEncodingError(error)
        }
        
        do {
            let sealedBox = try AES.GCM.seal(jsonData, using: key)
            guard let combinedData = sealedBox.combined else {
                throw SecurityServiceError.encryptionError(NSError(domain: "EncryptionError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to combine sealed box"]))
            }
            return combinedData
        } catch {
            throw SecurityServiceError.encryptionError(error)
        }
    }
    
    // Decrypt AES-GCM encrypted data
    private func decrypt<T: Codable>(_ data: Data, using key: SymmetricKey) throws -> T {
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: data)
            let decryptedData = try AES.GCM.open(sealedBox, using: key)
            let object = try JSONDecoder().decode(T.self, from: decryptedData)
            return object
        } catch {
            throw SecurityServiceError.decryptionError(error)
        }
    }
    
    // Decrypt data
    func decryptData<T: Codable>(_ encryptedData: Data) throws -> T {
        let key = try getEncryptionKey()
        return try decrypt(encryptedData, using: key)
    }
}
