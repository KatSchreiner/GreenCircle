//
//  LocationPermissionService.swift
//  GreenCircle
//
//  Created by Екатерина Шрайнер on 01.10.2026.
//
import CoreLocation

final class LocationPermissionService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var completion: ((Bool) -> Void)?

    func checkStatus() -> LocationPermissionStatus {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined: return .notDetermined
        case .authorizedWhenInUse: return .authorizedWhenInUse
        case .authorizedAlways: return .authorizedAlways
        case .denied: return .denied
        case .restricted: return .restricted
        @unknown default: return .notDetermined
        }
    }

    func requestWhenInUse(completion: @escaping (Bool) -> Void) {
        self.completion = completion
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func requestAlways(completion: @escaping (Bool) -> Void) {
        self.completion = completion
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.requestAlwaysAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = checkStatus()
        let granted = status == .authorizedWhenInUse || status == .authorizedAlways
        completion?(granted)
        completion = nil
    }
}
