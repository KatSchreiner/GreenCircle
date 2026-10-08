//
//  WelcomeViewController.swift
//  GreenCircle
//
//  Created by Екатерина Шрайнер on 03.10.2026.
//
import UIKit

final class WelcomeViewController: UIViewController {

    private lazy var logoImageView: UIImageView = {
        let image = UIImage(named: "GCLogo.png")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Добро пожаловать в\nЗелёный Круг"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center

        let fullText = "Добро пожаловать в\n"
        let accentText = "Зелёный Круг"

        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24, weight: .regular),
            .foregroundColor: Constants.colorPrimary
        ]

        let accentAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 28, weight: .bold),
            .foregroundColor: Constants.colorAccent
        ]

        let attributedString = NSMutableAttributedString(string: fullText, attributes: normalAttributes)
        attributedString.append(NSAttributedString(string: accentText, attributes: accentAttributes))
        label.attributedText = attributedString
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Знай, что у близких всё хорошо — держи их в своём круге"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Constants.colorSecondary
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    private lazy var helperTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Давайте создадим аккаунт — это займёт минуту"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Constants.colorSecondary
        return label
    }()

    private lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать аккаунт", for: .normal)
        button.backgroundColor = Constants.colorPrimary
        button.setTitleColor(Constants.colorWhite, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.fontButtonSize, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCreateAccount), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, logoImageView, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc private func handleCreateAccount() {
        let authVC = AuthViewController()
        navigationController?.pushViewController(authVC, animated: true)
    }

    private func setupView() {
        view.backgroundColor = Constants.colorBackground
        view.addSubview(stackView)
        view.addSubview(helperTextLabel)
        view.addSubview(createAccountButton)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.paddingLarge),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.paddingLarge),

            helperTextLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: Constants.paddingLarge),
            helperTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.paddingLarge),
            helperTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.paddingLarge),

            createAccountButton.topAnchor.constraint(equalTo: helperTextLabel.bottomAnchor, constant: Constants.paddingSmall),
            createAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.paddingLarge),
            createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.paddingLarge),
            createAccountButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
        ])
    }
}
