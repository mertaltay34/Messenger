//
//  LoginViewController.swift
//  Messenger
//
//  Created by Mert Altay on 15.08.2023.
//

import UIKit
import SnapKit
import FirebaseAuth
import FacebookLogin
import GoogleSignIn
import JGProgressHUD

class LoginViewController: UIViewController {
    //MARK: - Properties
    private let spinner = JGProgressHUD(style: .dark)
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Email address..."
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode  = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.rightViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done // klavyede done çıkıyor
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Password..."
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode  = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.rightViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .link
        button.isEnabled = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    private let facebookLoginButton: FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["public_profile", "email"]
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        return button
    }()
    private let googleLoginButton : GIDSignInButton = {
        let button = GIDSignInButton()
        button.colorScheme = .dark
        button.style = .wide
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        return button
    }()
    private var stackView = UIStackView()
    //MARK: - Lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .white
        style()
        addSubviews()
        layout()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                    style: .done,
                                                    target: self,
                                                    action: #selector(didTapRegister))
    }

}
    //MARK: - Selectors
extension LoginViewController{
    @objc private func loginButtonTapped(){
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder() // resignFirstResponder klavyenin kapatılmasını sağlıyor
        guard let email = emailTextField.text, let password = passwordTextField.text,
              !email.isEmpty, !password.isEmpty, password.count >= 6 else {
                    alertUserLoginError()
                    return
        }
        spinner.show(in: view)
        //Firebase Log In
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email: \(email)")
                return
            }
            let user = result.user
            print("Logged In User: \(user)")
            strongSelf.navigationController?.dismiss(animated: true)
        }
    }
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
}
    //MARK: - Helpers
extension LoginViewController{
    private func style(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
        facebookLoginButton.delegate = self
        // stackview
        stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, facebookLoginButton, googleLoginButton])
        stackView.axis = .vertical
        stackView.spacing = 20
//        stackView.distribution = .fillEqually
        stackView.distribution = .fillProportionally
    }
    private func addSubviews(){
        view.addSubview(logoImageView)
        view.addSubview(stackView)
    }
    private func layout(){
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalToSuperview().dividedBy(3)
            make.height.equalTo(logoImageView.snp.width)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
    }
    func alertUserLoginError(){
        let alert = UIAlertController(title: "Woops",
                                   message: "Please enter all information to log in. ",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert,animated: true)
    }
}
    //MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate{
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField{
            loginButtonTapped()
        }
        return true
    }
}
    //MARK: FacebookLoginButtonDelegate
extension LoginViewController: LoginButtonDelegate{
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        // log out göstermek için başka sayfayı kullanıyoruz zaten facebook log out kısmını göstermeyeceğiz.
    }
    
    func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed to log in with facebook")
            return
        }
        let facebookRequest  = GraphRequest(graphPath: "me", parameters: ["fields": "email, name"],tokenString: token, version: nil ,httpMethod: .get)
        facebookRequest.start { _, result, error in
            guard let result = result as? [String:Any], error == nil else {
                print("Failed to make facebook graph request")
                return
            }
//            print("\(result)")
//            ["id": 10222608560913999, "name": Mert Altay, "email": mertaltay_34__@hotmail.com] result böyle dönüyor

            guard let userName = result["name"] as? String,
                  let email = result["email"] as? String else {
                  print("Failed to get email and name from fb result")
                  return
            }
            let nameComponents = userName.components(separatedBy: " ")
            guard nameComponents.count == 2 else {
                return
            }
            let firstName = nameComponents[0]
            let lastName = nameComponents[1]
            DatabaseManager.shared.userExists(with: email) { exists in
                if !exists{
                    DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
                }
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            self.spinner.show(in: self.view)
            FirebaseAuth.Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                DispatchQueue.main.async {
                    strongSelf.spinner.dismiss()
                }
                guard  authResult != nil, error == nil else {
                    if error != nil {
                        print("Facebook credential login failed, MFA may be needed.")
                    }
                    return
                }
                print("Successfully logged user in")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
