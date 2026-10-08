//
//  AuthViewModel.swift
//  GreenCircle
//
//  Created by Екатерина Шрайнер on 01.10.2026.
//
import UIKit

protocol AuthServiceProtocol {
    func requestCode(for phoneDigits: String, completion: @escaping (Result<Void, Error>) -> Void)
    func submitCode(for phoneDigits: String, code: String, completion: @escaping (Result<User, Error>) -> Void)
}

final class AuthViewModel {
    private(set) var canRequestCode = false
    private(set) var errorMessage: String?
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = MockAuthService()) {
        self.authService = authService
    }
    
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
    
    func startRequestCode(for digits: String, completion: @escaping (Bool) -> Void) {
        authService.requestCode(for: digits) { result in
            var success = false
            var message: String?
            
            switch result {
            case .success:
                success = true
            case .failure(let error):
                if let authError = error as? AuthError {
                    switch authError {
                    case .invalidPhone: message = "Некорректный номер"
                    case .network: message = "Ошибка сети"
                    default: message = "Произошла ошибка"
                    }
                } else {
                    message = "Произошла ошибка"
                }
                self.errorMessage = message
                success = false
            }
            
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
    
    func submitCode(for phoneDigits: String, code: String, completion: @escaping (Result<User, Error>) -> Void) {
        authService.submitCode(for: phoneDigits, code: code) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
