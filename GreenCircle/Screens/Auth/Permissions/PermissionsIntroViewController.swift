//
//  PermissionsIntroViewController.swift
//  GreenCircle
//
//  Created by Екатерина Шрайнер on 09.10.2026.
//
import UIKit

final class PermissionsIntroViewController: UIViewController {
    private let user: User
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconView, titleLabel, subtitleLabel, continueButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.paddingLarge
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var iconView: UIImageView = {
        let img = UIImage(systemName: "location.circle.fill")?.withTintColor(Constants.colorPrimary ?? .gcNavy, renderingMode: .alwaysOriginal)
        let view = UIImageView(image: img)
        view.contentMode = .scaleAspectFit
        view.heightAnchor.constraint(equalToConstant: 120).isActive = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Знайте, где близкие, и будьте спокойны"
        label.font = UIFont.systemFont(ofSize: Constants.fontTitleSize, weight: .bold)
        label.textColor = Constants.colorPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Разрешите доступ к геолокации, чтобы видеть местоположение близких и получать уведомления о важных событиях в вашем круге."
        label.font = UIFont.systemFont(ofSize: Constants.fontCaptionSize)
        label.textColor = Constants.colorSecondary
        label.textAlignment = .center
        label.numberOfLines = 6
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Продолжить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.fontButtonSize, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.colorPrimary
        button.layer.cornerRadius = Constants.defaultRadius
        button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
        button.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        return button
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
        view.backgroundColor = Constants.colorBackground
        view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -Constants.paddingLarge),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.paddingLarge),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.paddingLarge)
        ])
    }
    
    @objc private func didTapContinue() {
        let permissionsVC = LocationRequestViewController(user: user)
        navigationController?.pushViewController(permissionsVC, animated: true)
    }
}

