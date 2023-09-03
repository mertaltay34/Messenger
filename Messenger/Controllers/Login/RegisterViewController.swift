//
//  RegisterViewController.swift
//  Messenger
//
//  Created by Mert Altay on 15.08.2023.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
    //MARK: - Properties
    private let spinner = JGProgressHUD(style: .dark)
    private lazy var addProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera.circle")
        imageView.tintColor = .lightGray
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 150 / 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 2.0
        imageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePic))
        imageView.addGestureRecognizer(gesture)
        return imageView
    }()
    private let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "First Name..."
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode  = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.rightViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    private let lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Last Name..."
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode  = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.rightViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
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
        textField.returnKeyType = .continue // bir sonraki textfield kısmına dönmesini sağlıyor
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Password address..."
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode  = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.rightViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.isEnabled = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()
    private var stackView = UIStackView()
    //MARK: - Lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()
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
extension RegisterViewController{
    @objc private func didTapProfilePic(){
        presentPhotoActionSheet()
    }
    @objc private func registerButtonTapped(){
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        guard let firstname = firstNameTextField.text,
             let lastname = lastNameTextField.text,
             let email = emailTextField.text,
             let password = passwordTextField.text,
              !firstname.isEmpty, !lastname.isEmpty, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
                    alertUserLoginError()
                    return
        }
        //MARK: - FirseBase Log in
        DatabaseManager.shared.userExists(with: email) { [weak self] exists in
            guard let strongSelf = self else { return } // Eğer self hala geçerli ise, bu güçlü referans üzerinden işlemler gerçekleştirilir. Eğer self geçerli değilse (yani nesne yok edildiyse), kapanışın geri kalanı çalıştırılmadan çıkılır. Sonuç olarak, bu yöntem hafıza sızıntılarını önler ve asenkron işlem tamamlandığında güvenli bir şekilde işlemlerin gerçekleştirilmesini sağlar.
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            guard !exists else {
                // user already exists
                strongSelf.alertUserLoginError(message: "Looks like a user account for that email address already exists.")
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                guard authResult != nil , error == nil else {
                    print("Error creating user")
                    return
                }
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstname, lastName: lastname, emailAddress: email))
                strongSelf.navigationController?.dismiss(animated: true)
            }
        }
    }
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
}
    //MARK: - Helpers
extension RegisterViewController{
    private func style(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // stackview
        stackView = UIStackView(arrangedSubviews: [firstNameTextField, lastNameTextField, emailTextField, passwordTextField, registerButton])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.distribution = .fillEqually
    }
    private func addSubviews(){
        view.addSubview(addProfileImage)
        view.addSubview(stackView)
    }
    private func layout(){
        addProfileImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
//            make.width.equalToSuperview().dividedBy(3)
//            make.height.equalTo(addCameraButton.snp.width)
            make.width.height.equalTo(150)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(addProfileImage.snp.bottom).offset(10)
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
    func alertUserLoginError(message: String = "Please enter all information to create a new account."){
        let alert = UIAlertController(title: "Woops",
                                   message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert,animated: true)
    }
}
extension RegisterViewController: UITextFieldDelegate{
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField{
            registerButtonTapped()
        }
        return true
    }
}
    //MARK: - UIImagePickerControllerDelegate
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture",
                                        message: "How would like to select a picture?",
                                        preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet,  animated: true)
    }
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.addProfileImage.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
