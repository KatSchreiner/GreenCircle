//
//  AuthViewController.swift
//  GreenCircle
//
//  Created by Екатерина Шрайнер on 01.10.2026.
//
import UIKit

final class AuthViewController: UIViewController {
    let viewModel = AuthViewModel(authService: MockAuthService())
    
    private var isRequestCodeButtonEnabled: Bool = false {
        didSet {
            requestCodeButton.isEnabled = isRequestCodeButtonEnabled
            
            let isActive = isRequestCodeButtonEnabled
            if isActive {
                requestCodeButton.backgroundColor = Constants.colorPrimary
                requestCodeButton.setTitleColor(Constants.colorWhite, for: .normal)
            } else {
                requestCodeButton.backgroundColor = Constants.colorPrimary?.withAlphaComponent(0.4)
                requestCodeButton.setTitleColor(Constants.colorWhite?.withAlphaComponent(0.4), for: .normal)
            }
        }
    }
    
    private var currentStep: AuthStep = .enterPhone
    
    private lazy var mainStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [phoneTitleLabel, phoneSubtitleLabel, phoneTextField, codeInputContainer, requestCodeButton])
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
        textField.placeholder = nil
        textField.text = viewModel.formatPhoneNumber("")
        textField.keyboardType = .phonePad
        textField.autocapitalizationType = .none
        textField.textColor = Constants.colorSecondary
        textField.font = UIFont.systemFont(ofSize: Constants.fontTextFieldSize, weight: .regular)
        textField.backgroundColor = .white
        textField.contentVerticalAlignment = .center
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 44))
        textField.leftViewMode = .always
        
        textField.layer.cornerRadius = Constants.defaultRadius
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.867, green: 0.886, blue: 0.925, alpha: 1.0).cgColor
        
        textField.textContentType = .telephoneNumber
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.smartInsertDeleteType = .no
        textField.delegate = self
        
        textField.clearButtonMode = .whileEditing
        
        return textField
    }()
    
    private lazy var requestCodeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Получить код", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.fontButtonSize)
        button.layer.cornerRadius = Constants.defaultRadius
        button.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var codeInputContainer: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var codeTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Введите код"
        field.keyboardType = .numberPad
        field.font = UIFont.systemFont(ofSize: Constants.fontTextFieldSize, weight: .regular)
        field.textAlignment = .center
        field.layer.cornerRadius = Constants.defaultRadius
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor(red: 0.867, green: 0.886, blue: 0.925, alpha: 1.0).cgColor
        field.backgroundColor = .white
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight).isActive = true
        field.delegate = self
        return field
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
    
    @objc private func didTapActionButton() {
        switch currentStep {
        case .enterPhone:
            handleRequestCode()
        case .enterCode:
            handleSubmitCode()
        }
    }
    
    @objc private func didTapFamilyCode() {
        // TODO: логика входа по коду семьи
    }
    
    private func setupView() {
        view.backgroundColor = Constants.colorBackground
        isRequestCodeButtonEnabled = viewModel.canRequestCode
        
        [mainStack, familyCodeButton]
            .forEach {
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        codeInputContainer.addSubview(codeTextField)
        NSLayoutConstraint.activate([
            codeTextField.topAnchor.constraint(equalTo: codeInputContainer.topAnchor),
            codeTextField.leadingAnchor.constraint(equalTo: codeInputContainer.leadingAnchor),
            codeTextField.trailingAnchor.constraint(equalTo: codeInputContainer.trailingAnchor),
            codeTextField.bottomAnchor.constraint(equalTo: codeInputContainer.bottomAnchor)
        ])
        
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
    
    private func handleRequestCode() {
        guard let text = phoneTextField.text else { return }
        let digits = viewModel.extractPhoneDigits(from: text)
        
        print("[Auth] Нажата кнопка, digits = \(digits)")
        
        requestCodeButton.isEnabled = false
        
        viewModel.startRequestCode(for: digits) { success in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.requestCodeButton.isEnabled = true
                
                if success {
                    self.switchToCodeStep()
                } else {
                    guard let message = self.viewModel.errorMessage else { return }
                    self.showError(message)
                }
            }
        }
    }
    
    private func switchToCodeStep() {
        currentStep = .enterCode
        
        phoneTextField.isEnabled = false
        phoneTextField.resignFirstResponder()
        
        phoneTextField.isHidden = true
        codeInputContainer.isHidden = false
        
        codeTextField.becomeFirstResponder()
        
        requestCodeButton.setTitle("Отправить код", for: .normal)
        
        let codeText = codeTextField.text ?? ""
        isRequestCodeButtonEnabled = !codeText.isEmpty
        
        UIView.animate(withDuration: 0.3) {
            self.mainStack.layoutIfNeeded()
        }
    }
    
    private func handleSubmitCode() {
        guard let code = codeTextField.text, !code.isEmpty else { return }
        
        let phoneText = phoneTextField.text ?? ""
        let digits = viewModel.extractPhoneDigits(from: phoneText)
        
        guard !digits.isEmpty else {
            showError("Введите номер телефона")
            return
        }
        
        print("[Auth] Отправлен код: \(code)")
        
        requestCodeButton.isEnabled = false
        
        viewModel.submitCode(for: digits, code: code) { [weak self] result in
            guard let self = self else { return }
            self.requestCodeButton.isEnabled = true
            
            switch result {
            case .success(let user):
                print("[Auth] Успешный вход, пользователь: \(user)")
                self.showPermissionsScreen(for: user)
                
            case .failure(let error):
                var message: String
                if let authError = error as? AuthError {
                    switch authError {
                    case .invalidCode: message = "Неверный код"
                    case .network: message = "Ошибка сети"
                    default: message = "Произошла ошибка"
                    }
                } else {
                    message = "Произошла ошибка"
                }
                self.showError(message)
            }
        }
    }
    
    private func showPermissionsScreen(for user: User) {
        let vc = PermissionsIntroViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField === phoneTextField {
            guard string.isEmpty || string.allSatisfy({ $0.isNumber }) else { return false }
            
            let current = textField.text ?? ""
            var bodyDigits = viewModel.extractPhoneDigits(from: current)
            
            if string.isEmpty {
                if !bodyDigits.isEmpty {
                    bodyDigits.removeLast()
                }
            } else {
                bodyDigits += string.filter { $0.isNumber }
                if bodyDigits.count > 10 {
                    bodyDigits = String(bodyDigits.prefix(10))
                }
            }
            
            viewModel.validatePhoneNumber(bodyDigits)
            isRequestCodeButtonEnabled = viewModel.canRequestCode
            
            let newText = viewModel.formatPhoneNumber(bodyDigits)
            textField.text = newText
            
            let offset = viewModel.cursorOffset(forDigitCount: bodyDigits.count, in: newText)
            if let position = textField.position(from: textField.beginningOfDocument, offset: offset) {
                textField.selectedTextRange = textField.textRange(from: position, to: position)
            }
            return false
        }
        
        if textField === codeTextField {
            let currentText = (textField.text ?? "") as NSString
            let newText = currentText.replacingCharacters(in: range, with: string)
            isRequestCodeButtonEnabled = !newText.isEmpty && newText.count <= 7
            return true
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField === phoneTextField {
            viewModel.validatePhoneNumber("")
            isRequestCodeButtonEnabled = viewModel.canRequestCode
            
            let newText = viewModel.formatPhoneNumber("")
            phoneTextField.text = newText
            
            let targetOffset = 3
            if let position = phoneTextField.position(from: phoneTextField.beginningOfDocument, offset: targetOffset) {
                let desiredRange = phoneTextField.textRange(from: position, to: position)
                phoneTextField.selectedTextRange = desiredRange
            }
            return false
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField === phoneTextField {
            let text = textField.text ?? ""
            let digits = viewModel.extractPhoneDigits(from: text)
            let target = viewModel.cursorOffset(forDigitCount: digits.count, in: text)
            
            guard let position = textField.position(from: textField.beginningOfDocument, offset: target) else { return }
            let desiredRange = textField.textRange(from: position, to: position)
            
            if textField.selectedTextRange != desiredRange {
                textField.selectedTextRange = desiredRange
            }
        }
    }
}
