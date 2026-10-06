//
//  AuthViewController.swift
//  GreenCircle
//
//  Created by Екатерина Шрайнер on 01.10.2026.
//
import UIKit

final class AuthViewController: UIViewController {
    
    private lazy var mainStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [phoneTitleLabel, phoneSubtitleLabel,  phoneTextField, requestCodeButton, errorLabel, codeInputContainer])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constants.paddingSmall
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var phoneTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите номер телефона"
        label.font = UIFont.systemFont(ofSize: Constants.fontTitleSize)
        label.textColor = Constants.colorPrimary
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var phoneSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Чтобы создать свой круг самых близких"
        label.font = UIFont.systemFont(ofSize: Constants.fontCaptionSize)
        label.textColor = Constants.colorSecondary
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        textField.text = "+7  "
        textField.placeholder = nil
        textField.keyboardType = .phonePad
        textField.autocapitalizationType = .none
        textField.textColor = Constants.colorSecondary
        textField.font = UIFont.systemFont(ofSize: Constants.fontTextFieldSize, weight: .regular)
        textField.backgroundColor = .white
        textField.contentVerticalAlignment = .center
        
        textField.layer.cornerRadius = Constants.defaultRadius
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.867, green: 0.886, blue: 0.925, alpha: 1.0).cgColor
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 60))
        textField.leftView = paddingView
        textField.rightView = paddingView 
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        
        textField.textContentType = .telephoneNumber   
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.smartInsertDeleteType = .no
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var requestCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Получить код", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.fontButtonSize)
        button.setTitleColor(Constants.colorSecondary, for: .normal)
        button.isEnabled = false
        button.backgroundColor = Constants.colorAccent
        button.layer.cornerRadius = Constants.defaultRadius
        button.addTarget(self, action: #selector(didTapRequestCode), for: .touchUpInside)
        return button
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private lazy var codeInputContainer: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private lazy var familyCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти по коду семьи", for: .normal)
        button.setTitleColor(Constants.colorAccent, for: .normal)
        button.tintColor = Constants.colorAccent
        button.setImage(UIImage(systemName: "person.fill.checkmark"), for: .normal)
        button.semanticContentAttribute = .forceLeftToRight
        button.contentHorizontalAlignment = .center
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.fontButtonSize)
        button.addTarget(self, action: #selector(didTapFamilyCode), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc private func didTapRequestCode() {
        
    }
    
    @objc private func didTapFamilyCode() {
        
    }
    
    private func setupView() {
        view.backgroundColor = Constants.colorBackground
        
        [mainStack, familyCodeButton]
            .forEach {
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.paddingLarge),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.paddingLarge),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.paddingLarge),
            
            phoneTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
            requestCodeButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            
            familyCodeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.paddingLarge),
            familyCodeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.paddingLarge),
            familyCodeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.paddingLarge),
            familyCodeButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
        
        mainStack.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -Constants.paddingLarge)
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField === phoneTextField else { return true }
        
        guard string.isEmpty || string.allSatisfy({ $0.isNumber }) else { return false }
        
        let current = textField.text ?? ""
        var bodyDigits = phoneDigits(from: current)
        
        if string.isEmpty {
            if !bodyDigits.isEmpty { bodyDigits.removeLast() }
        } else {
            bodyDigits += string.filter { $0.isNumber }
            if bodyDigits.count > 10 {
                bodyDigits = String(bodyDigits.prefix(10))
            }
        }
        
        let newText = formatPhoneNumber(bodyDigits)
        
        if newText == textField.text {
            return false
        }
        
        textField.text = newText
        return false
    }
    
    private func phoneDigits(from text: String) -> String {
        let prefix = "+7"
        let body = text.hasPrefix(prefix) ? String(text.dropFirst(prefix.count)) : text
        return body.filter { $0.isNumber }
    }
    
    private func formatPhoneNumber(_ digits: String) -> String {
        guard !digits.isEmpty else { return "+7" }
        
        let mask = "+7 (XXX) XXX-XX-XX"
        var result = ""
        var index = digits.startIndex
        
        for char in mask {
            guard index < digits.endIndex else { break }
            if char == "X" {
                result.append(digits[index])
                index = digits.index(after: index)
            } else {
                result.append(char)
            }
        }
        return result
    }
}
