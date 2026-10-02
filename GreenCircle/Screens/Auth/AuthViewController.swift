//
//  AuthViewController.swift
//  GreenCircle
//
//  Created by Екатерина Шрайнер on 01.10.2026.
//

import UIKit

final class AuthViewController: UIViewController {
    
    lazy var logoImageView: UIImageView = {
        let image = UIImage(named: "GCLogo.png")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Добро пожаловать в Зелёный Круг"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Constants.colorPrimary
        
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
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Знай, что у близких всё хорошо — держи их в своём круге"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Constants.colorPrimary
        return label
    }()
    

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, logoImageView, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 66
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = Constants.colorBackground
        view.addSubview(stackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
}
