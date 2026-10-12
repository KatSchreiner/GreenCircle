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
    
    func checkStatus(completion: @escaping (LocationPermissionStatus) -> Void) {
        let raw = locationManager.authorizationStatus
        
        switch raw {
        case .notDetermined:
            completion(.notDetermined)
        case .authorizedWhenInUse:
            completion(.authorizedWhenInUse)
        case .authorizedAlways:
            completion(.authorizedAlways)
        case .denied:
            completion(.denied)
        case .restricted:
            completion(.restricted)
        @unknown default:
            completion(.notDetermined)
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

        let status = checkStatus { status in
            let granted = status == .authorizedWhenInUse || status == .authorizedAlways
            completion(granted)
        }
    }
}
