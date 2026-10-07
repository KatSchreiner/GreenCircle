//
//  AuthViewModel.swift
//  GreenCircle
//
//  Created by Екатерина Шрайнер on 01.10.2026.
//
import UIKit

final class AuthViewModel {
    private(set) var canRequestCode = false
    private(set) var errorMessage: String?
    
    func extractPhoneDigits(from text: String) -> String {
        let prefix = "+7"
        let body = text.hasPrefix(prefix) ? String(text.dropFirst(prefix.count)) : text
        return body.filter { $0.isNumber }
    }
    
    func formatPhoneNumber(_ digits: String) -> String {
        guard !digits.isEmpty else {
            return "+7 --- --- ----"
        }
        
        let mask = "+7 --- --- ----"
        var result = ""
        var index = digits.startIndex
        
        for char in mask {
            if char == "-" {
                if index < digits.endIndex {
                    result.append(digits[index])
                    index = digits.index(after: index)
                } else {
                    result.append("-")
                }
            } else {
                result.append(char)
            }
        }
        return result
    }
    
    func validatePhoneNumber(_ digits: String) {
        canRequestCode = digits.count == 10
        errorMessage = canRequestCode ? nil : "Введите корректный номер"
    }
    
    func setErrorMessage(_ message: String) {
        errorMessage = message
    }
}
