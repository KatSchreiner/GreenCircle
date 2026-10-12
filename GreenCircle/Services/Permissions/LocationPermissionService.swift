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
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
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
        locationManager.requestWhenInUseAuthorization()
    }

    func requestAlways(completion: @escaping (Bool) -> Void) {
        self.completion = completion
        locationManager.requestAlwaysAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let completion = self.completion else {
            return
        }

        let status = checkStatus()
        let granted = status == .authorizedWhenInUse || status == .authorizedAlways

        completion(granted)
        self.completion = nil
    }
}
