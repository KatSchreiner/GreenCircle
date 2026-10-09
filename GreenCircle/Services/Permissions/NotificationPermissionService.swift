//
//  NotificationPermissionService.swift
//  GreenCircle
//
//  Created by Екатерина Шрайнер on 09.10.2026.
//
import UserNotifications

final class NotificationPermissionService {
    static let shared = NotificationPermissionService()
    
    private let center = UNUserNotificationCenter.current()
    
    func requestAuthorisation(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false)
                    
                } else {
                    completion(granted)
                }
            }
        }
    }
    
    func getStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        center.getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }
}
