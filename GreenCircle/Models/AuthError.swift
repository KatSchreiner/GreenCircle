//
//  AuthError.swift
//  GreenCircle
//
//  Created by Екатерина Шрайнер on 07.10.2026.
//
import Foundation

enum AuthError: Error {
    case invalidPhone
    case invalidCode
    case network
    case unknown
}
