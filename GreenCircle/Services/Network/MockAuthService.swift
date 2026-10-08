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
}
