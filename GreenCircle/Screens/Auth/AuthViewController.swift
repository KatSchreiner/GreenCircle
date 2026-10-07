//
//  AuthViewController.swift
//  GreenCircle
//
//  Created by Екатерина Шрайнер on 01.10.2026.
//
import UIKit

final class AuthViewController: UIViewController {
    let viewModel = AuthViewModel()
    
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
    
    private lazy var mainStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [phoneTitleLabel, phoneSubtitleLabel,  phoneTextField, requestCodeButton, codeInputContainer])
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
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
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
        button.addTarget(self, action: #selector(didTapRequestCode), for: .touchUpInside)
        button.isEnabled = false
        return button
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
        guard let text = phoneTextField.text else { return }
        let digits = viewModel.extractPhoneDigits(from: text)

        print("Запрос кода для номера: \(digits)")
    }
    
    @objc private func didTapFamilyCode() {
        
    }
    
    private func setupView() {
        view.backgroundColor = Constants.colorBackground
        isRequestCodeButtonEnabled = viewModel.canRequestCode

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

    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        guard textField === phoneTextField else { return true }
        
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
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard textField === phoneTextField else { return }
        
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
