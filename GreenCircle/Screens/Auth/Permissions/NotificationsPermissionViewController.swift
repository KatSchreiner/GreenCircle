//
//  NotificationsPermissionViewController.swift
//  GreenCircle
//
//  Created by Екатерина Шрайнер on 09.10.2026.
//
import UIKit
import UserNotifications

final class NotificationsPermissionViewController: UIViewController {
    
    private let notificationService = NotificationPermissionService()
    private let user: User
    
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
        let img = UIImage(systemName: "bell.fill")?.withTintColor(Constants.colorPrimary ?? .gcNavy, renderingMode: .alwaysOriginal)
        let view = UIImageView(image: img)
        view.contentMode = .scaleAspectFit
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Уведомления о местоположении"
        label.font = UIFont.systemFont(ofSize: Constants.fontTitleSize, weight: .bold)
        label.textColor = Constants.colorPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Чтобы получать уведомления, когда ребёнок приходит домой или уходит из школы, разрешите приложению присылать уведомления."
        label.font = UIFont.systemFont(ofSize: Constants.fontCaptionSize)
        label.textColor = Constants.colorSecondary
        label.textAlignment = .center
        label.numberOfLines = 5
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var actionStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [allowButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.paddingLarge
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var allowButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Разрешить уведомления", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.fontButtonSize, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.colorPrimary
        button.layer.cornerRadius = Constants.defaultRadius
        button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
        button.addTarget(self, action: #selector(didTapAllow), for: .touchUpInside)
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
    }
    
    @objc private func didTapAllow() {
        allowButton.isEnabled = false
        notificationService.requestAuthorisation { granted in
            DispatchQueue.main.async {
                self.allowButton.isEnabled = true
                if granted {
                    self.showMapScreen()
                } else {
                    self.showNotificationsDenyAlert()
                }
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = Constants.colorBackground
        view.addSubview(mainStack)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.paddingLarge),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.paddingLarge),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.paddingLarge)
        ])
    }
    
    private func showMapScreen() {
        let mapViewController = MapViewController()
        mapViewController.user = user
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    private func showNotificationsDenyAlert() {
        let alert = UIAlertController(
            title: "Уведомления отключены",
            message: "Вы не будете получать уведомления о входе/выходе из геозон. Это можно изменить в настройках iOS.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Понятно", style: .cancel))
        present(alert, animated: true) {
            self.showMapScreen()
        }
    }
}
