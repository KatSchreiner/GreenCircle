//
//  MapViewController.swift
//  GreenCircle
//
//  Created by Екатерина Шрайнер on 01.10.2026.
//
import UIKit

final class MapViewController: UIViewController {
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = Constants.colorBackground
        navigationItem.hidesBackButton = true
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
    }
}
