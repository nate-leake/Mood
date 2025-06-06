//
//  ColorExtension.swift
//  Mood
//
//  Created by Nate Leake on 9/14/23.
//

import Foundation
import SwiftUI

extension UIColor {
    func toSwiftUIColor() -> Color {
        Color(self)
    }
}

extension Color {
    
    /// Gets the dark mode varient of the color
    func darkModeVariant() -> Color {
        UIColor(self).resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark)).toSwiftUIColor()
    }
    
    /// Gets the light mode varient of the color
    func lightModeVariant() -> Color {
        UIColor(self).resolvedColor(with: UITraitCollection(userInterfaceStyle: .light)).toSwiftUIColor()
    }
    
    /// Returns the inverted mode varient of the color
    func invertModeVarient() -> Color {
        let currentStyle = UITraitCollection.current.userInterfaceStyle
        
        switch currentStyle {
        case .dark :
            return self.lightModeVariant()
        case .light:
            return self.darkModeVariant()
        default:
            return self
        }
    }
    
    /// Returns the optimal foreground color for the receiving color
    func optimalForegroundColor() -> Color {
        if self.isLight() {
            return .black
        } else {
            return .white
        }
    }
    
    /// Initialize the Color with a hex value
    /// - Parameter hex: The hex value as a string of the desired color
    init(hex: String) {
        let hex = hex.trimmingCharacters(
            in: CharacterSet.alphanumerics.inverted
        )
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (
                255,
                (int >> 8) * 17,
                (int >> 4 & 0xF) * 17,
                (int & 0xF) * 17
            )
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (
                int >> 24,
                int >> 16 & 0xFF,
                int >> 8 & 0xFF,
                int & 0xFF
            )
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func isLight() -> Bool {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
                
        // Get the RGBA components of the color
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                
        // Calculate brightness using the formula for perceived luminance
        let brightness = (red * 299 + green * 587 + blue * 114) / 1000
                        
        // Return true if brightness is greater than 0.5 (light color)
        return brightness > 0.5
    }
    
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
    
}
