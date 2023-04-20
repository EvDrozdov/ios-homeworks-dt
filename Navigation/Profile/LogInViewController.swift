//
//  LogInViewController.swift
//  Navigation
//
//  Created by Евгений Дроздов on 04.10.2022.
//

import UIKit
import Firebase
import FirebaseAuth


class LogInViewController: UIViewController {
    
    var loginDelegate: LoginViewControllerDelegate?
    static var loginFactoryDelegate: LoginFactory?
    
    let concurrentQuee = DispatchQueue(label: "queueForPassword",
                                       qos: .userInteractive,
                                       attributes: [.concurrent])
    
    // Чтобы упростить себе жизнь кнопка брутфорса с прошлых ДЗ переделана на Регистрация
    // весь код брутфорса удален
    
    private lazy var registerNewUserButton: CustomButton = {
        let buttom = CustomButton(title: "Регистрация", titleColor: .white, backgroundButtonColor: .blue, clipsToBoundsOfButton: true, cornerRadius: 10, autoLayout: false)
        buttom.addTargetForButton = { self.registerNewUser() }
        return buttom
        
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.startAnimating()
        indicator.color = .black
        indicator.hidesWhenStopped = true
        indicator.isHidden = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
        
    }()
    
    private lazy var vkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    private lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(registerNewUserButton)
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.layer.borderWidth = 0.5
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.cornerRadius = 10
        stackView.clipsToBounds = true
        stackView.setCustomSpacing(0.5, after: loginTextField)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
        
    }()
    
    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Email or Phone"
        textField.text = "Evgeny"
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.autocorrectionType = .no
        return textField
        
    }()
    
    private lazy var passwordTextField: UITextField = {
        let pwTextField = UITextField()
        pwTextField.text = "Drozdov"
        pwTextField.backgroundColor = .systemGray6
        pwTextField.placeholder = "Password"
        pwTextField.textColor = .black
        pwTextField.font = .systemFont(ofSize: 16, weight: .regular)
        pwTextField.autocorrectionType = .no
        pwTextField.isSecureTextEntry = true
        return pwTextField
        
    }()
    
    private lazy var loginButton: CustomButton = {
        let button = CustomButton (title: "Log In",
                                   titleColor: .white,
                                   backgroundButtonColor: UIColor(named: "CustomColor")!,
                                   clipsToBoundsOfButton: true,
                                   cornerRadius: 10,
                                   autoLayout: false)
        button.tag = 1005
        button.addTargetForButton = { self.goToProfileViewController(sender: button) }
        return button
        
        
    }() 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGesture()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(didShowKeyboard(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didHideKeyboard(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //loginTextField.becomeFirstResponder()
        
    }
    
    @objc private func goToProfileViewController(sender: UIButton) {
        if sender.tag == 1005 {
            setupActivityIndicator()
            hideKeyboard()
            if ( (loginTextField.text != "") && (passwordTextField.text != "") ) {
                
                let checkerService = CheckerService()
                checkerService.checkCredentials(for: loginTextField.text!, and: passwordTextField.text!) { result in
                    switch result {
                    case .success(_):
                        self.deSetupActivityIndicator()
                        let goToProfileViewController = ProfileViewController()
                        goToProfileViewController.modalPresentationStyle = .currentContext
                        self.navigationController?.pushViewController(goToProfileViewController, animated: true)
                        
                    case .failure(let error):
                        self.deSetupActivityIndicator()
                        let alarm = UIAlertController(title: "Ошибка при входе", message: error.localizedDescription, preferredStyle: .alert)
                        let alarmAction = UIAlertAction(title: "Ok", style: .default)
                        alarm.addAction(alarmAction)
                        self.present(alarm, animated: true)
                        print(String(describing: error))
                    }
                }
            } else {
                deSetupActivityIndicator()
                // логин или пароль неверный
                let alarm = UIAlertController(title: "Неверный логин или пароль", message: "Проверьте информацию и попробуйте снова", preferredStyle: .alert)
                let alarmAction = UIAlertAction(title: "Ок", style: .default)
                alarm.addAction(alarmAction)
                present(alarm, animated: true)
            }} else {
                deSetupActivityIndicator()
                // логин или пароль не ввели
                let alarm = UIAlertController(title: "Не заполнено обязательное поле", message: "Проверьте информацию и попробуйте снова", preferredStyle: .alert)
                let alarmAction = UIAlertAction(title: "Ok", style: .default)
                alarm.addAction(alarmAction)
                present(alarm, animated: true)
            }
    }
    
    @objc private func registerNewUser(){
        setupActivityIndicator()
        hideKeyboard()
        // если поля заполнены, то можно идти дальше
        if ( (loginTextField.text != "") && (passwordTextField.text != "") ) {
            
            let checkerService = CheckerService()
            checkerService.signUp(for: loginTextField.text!, and: passwordTextField.text!) { result in
                switch result {
                case .success(_):
                    self.deSetupActivityIndicator()
                    let goToProfileViewController = ProfileViewController()
                    goToProfileViewController.modalPresentationStyle = .currentContext
                    self.navigationController?.pushViewController(goToProfileViewController, animated: true)
                case .failure(let error):
                    self.deSetupActivityIndicator()
                    let alarm = UIAlertController(title: "Ошибка при регистрации", message: error.localizedDescription, preferredStyle: .alert)
                    let alarmAction = UIAlertAction(title: "Ok", style: .default)
                    alarm.addAction(alarmAction)
                    self.present(alarm, animated: true)
                    print(String(describing: error))
                }
            }
        } else  {
            deSetupActivityIndicator()
            // логин или пароль не ввели
            let alarm = UIAlertController(title: "Не заполнено обязательное поле", message: "Проверьте информацию и попробуйте снова", preferredStyle: .alert)
            let alarmAction = UIAlertAction(title: "Ok", style: .default)
            alarm.addAction(alarmAction)
            present(alarm, animated: true)
        }
        
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(textFieldStackView)
        scrollView.addSubview(vkImageView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            vkImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 120),
            vkImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            vkImageView.widthAnchor.constraint(equalToConstant: 100),
            vkImageView.heightAnchor.constraint(equalToConstant: 100),
            vkImageView.bottomAnchor.constraint(equalTo: textFieldStackView.topAnchor, constant: -120),
            
            
            textFieldStackView.topAnchor.constraint(equalTo: vkImageView.bottomAnchor, constant: 120),
            textFieldStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textFieldStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldStackView.heightAnchor.constraint(equalToConstant: 100),
            
            
            loginButton.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: textFieldStackView.trailingAnchor),
            loginButton.leadingAnchor.constraint(equalTo: textFieldStackView.leadingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.leadingAnchor.constraint(equalTo: loginTextField.trailingAnchor, constant: -26),
            activityIndicator.centerYAnchor.constraint(equalTo: loginTextField.centerYAnchor, constant: 28),
            
            
        ])
        
        
    }
    
    private func setupGesture() {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gesture)
        
    }
    
    @objc private func didShowKeyboard(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let loginButtonPointY = loginButton.frame.origin.y + loginButton.frame.height
            let keyboardOriginY = view.frame.height - keyboardHeight
            
            let offset = keyboardOriginY <= loginButtonPointY ? loginButtonPointY - keyboardOriginY + 16 : 0
            
            scrollView.contentOffset = CGPoint(x: 0, y: offset)
            
        }
    }
    
    @objc private func didHideKeyboard(_ notification: Notification) {
        
        hideKeyboard()
        
    }
    
   
    
    
    private func setupActivityIndicator(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func deSetupActivityIndicator(){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    @objc private func hideKeyboard() {
        
        view.endEditing(true)
        scrollView.setContentOffset(.zero, animated: true)
        
    }
    
}


