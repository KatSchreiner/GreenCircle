//
//  PhoneFormatter.swift
//  GreenCircle
//
//  Created by Екатерина Шрайнер on 07.10.2026.
//

import UIKit

struct PhoneFormatter {
    static let prefix = "+7 "
    static func format(digits: String) -> String {
        guard !digits.isEmpty else { return "+7 --- --- ----" }
        var result = "+7"
        var i = 0
        for c in digits {
            if i == 0 || i == 3 || i == 6 { result += " " }
            result += String(c)
            i += 1
        }
        return result
    }
    
    func cursorOffset(forDigitCount n: Int, in text: String) -> Int {
        let prefixLength = 3
        guard n > 0 else { return min(prefixLength, text.count) }
        
        var digitCount = 0
        for (offset, char) in text.enumerated() {
            if offset < prefixLength { continue }
            if char.isNumber {
                digitCount += 1
                if digitCount == n {
                    return offset + 1
                }
            }
        }
        return text.count
    }
}
