//
//  PermissionsViewController.swift
//  GreenCircle
//
//  Created by Екатерина Шрайнер on 08.10.2026.
//
import UIKit
import CoreLocation

final class LocationRequestViewController: UIViewController {
    private let user: User
    private let permissionService = LocationPermissionService()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconView, titleLabel, subtitleLabel, actionStack, bottomNote])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.paddingLarge
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var iconView: UIImageView = {
        let img = UIImage(systemName: "location.fill")?.withTintColor(Constants.colorPrimary ?? .gcNavy, renderingMode: .alwaysOriginal)
        let view = UIImageView(image: img)
        view.contentMode = .scaleAspectFit
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Доступ к геолокации"
        label.font = UIFont.systemFont(ofSize: Constants.fontTitleSize, weight: .bold)
        label.textColor = Constants.colorPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Чтобы видеть, где сейчас находятся ваши близкие, и получать уведомления, когда кто-то из круга приходит домой или уходит из школы, приложение запрашивает доступ к геолокации."
        label.font = UIFont.systemFont(ofSize: Constants.fontCaptionSize)
        label.textColor = Constants.colorSecondary
        label.textAlignment = .center
        label.numberOfLines = 5
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var actionStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [alwaysButton, whenInUseButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.paddingLarge
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var alwaysButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Разрешить всегда", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.fontButtonSize, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.colorPrimary
        button.layer.cornerRadius = Constants.defaultRadius
        button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
        button.addTarget(self, action: #selector(didTapAlways), for: .touchUpInside)
        return button
    }()
    
    private lazy var whenInUseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Только при использовании", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.fontButtonSize)
        button.setTitleColor(Constants.colorSecondary, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 0.85, alpha: 1.0).cgColor
        button.layer.cornerRadius = Constants.defaultRadius
        button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
        button.addTarget(self, action: #selector(didTapWhenInUse), for: .touchUpInside)
        return button
    }()
    
    private lazy var bottomNote: UILabel = {
        let label = UILabel()
        label.text = "Вы сможете изменить это в настройках iOS в любое время."
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        let currentStatus = permissionService.checkStatus()
        if currentStatus == .authorizedWhenInUse || currentStatus == .authorizedAlways {
            showNotificationsScreen()
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkAndHandleExistingPermission()
    }
    
    @objc private func didTapAlways() {
        disableButtons()
        permissionService.requestAlways { [weak self] success in
            DispatchQueue.main.async {
                self?.handlePermissionResult(success: success)
            }
        }
    }
    
    @objc private func didTapWhenInUse() {
        disableButtons()
        permissionService.requestWhenInUse { [weak self] success in
            DispatchQueue.main.async {
                self?.handlePermissionResult(success: success)
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = Constants.colorBackground
        view.addSubview(mainStack)
        
        setupConstraint()
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.paddingLarge),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.paddingLarge),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.paddingLarge),
            
            actionStack.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            actionStack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor)
            
        ])
    }
    
    // MARK: - Handlers
    private func disableButtons() {
        alwaysButton.isEnabled = false
        whenInUseButton.isEnabled = false
    }
    
    private func enableButtons() {
        alwaysButton.isEnabled = true
        whenInUseButton.isEnabled = true
    }
    
    private func checkAndHandleExistingPermission() {
        let currentStatus = permissionService.checkStatus()
        if currentStatus == .authorizedWhenInUse || currentStatus == .authorizedAlways {
            showNotificationsScreen()
        }
    }
    
    private func handlePermissionResult(success: Bool) {
        enableButtons()
        
        if success {
            showNotificationsScreen()
        } else {
            showDenyAlert()
        }
    }
    
    private func showNotificationsScreen() {
        let notificationsVC = NotificationsPermissionViewController(user: user)
        navigationController?.pushViewController(notificationsVC, animated: true)
    }
    
    private func showDenyAlert() {
        let alert = UIAlertController(
            title: "Доступ запрещён",
            message: "Без геолокации приложение не сможет показывать местоположение ребёнка и присылать уведомления. Вы можете изменить это в настройках.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Открыть настройки", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        alert.addAction(UIAlertAction(title: "Позже", style: .cancel))
        present(alert, animated: true)
    }
}
