//
//  DateExtension.swift
//  Mood
//
//  Created by Nate Leake on 7/5/25.
//

import Foundation

extension Date {
    func shortDate(includeTime: Bool = false) -> String {
        return ShortDate().string(from: self, includeTime: includeTime)
    }
}
