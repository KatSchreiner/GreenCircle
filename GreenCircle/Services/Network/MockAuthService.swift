//
//  MockAuthService.swift
//  GreenCircle
//
//  Created by Екатерина Шрайнер on 07.10.2026.
//
import UIKit

final class MockAuthService: AuthServiceProtocol {
    func requestCode(for phoneDigits: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.2) {
            if phoneDigits.count != 10 {
                completion(.failure(AuthError.invalidPhone))
            } else if phoneDigits == "9999999999" {
                completion(.failure(AuthError.network))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func submitCode(for phoneDigits: String, code: String, completion: @escaping (Result<User, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            if code == "0000" {
                completion(.failure(AuthError.invalidPhone))
            } else {
                let user = User(id: "user-\(phoneDigits)", phone: "+7\(phoneDigits)")
                completion(.success(user))
            }
        }
    }
}
