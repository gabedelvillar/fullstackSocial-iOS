//
//  LoginController.swift
//  fullstacksocial
//
//  Created by Gabriel Del VIllar De Santiago on 1/6/20.
//  Copyright © 2020 Gabriel Del VIllar De Santiago. All rights reserved.
//

import LBTATools
import Alamofire
import JGProgressHUD

class LoginController: LBTAFormController {
    // MARK: UI Elements
       
       let logoImageView = UIImageView(image: #imageLiteral(resourceName: "icon"), contentMode: .scaleAspectFit)
       let logoLabel = UILabel(text: "FullStack Social", font: .systemFont(ofSize: 32, weight: .heavy), textColor: .black, numberOfLines: 0)
       
       let emailTextField = IndentedTextField(placeholder: "Email", padding: 24, cornerRadius: 25, keyboardType: .emailAddress)
       let passwordTextField = IndentedTextField(placeholder: "Password", padding: 24, cornerRadius: 25)
       lazy var loginButton = UIButton(title: "Login", titleColor: .white, font: .boldSystemFont(ofSize: 18), backgroundColor: .black, target: self, action: #selector(handleLogin))
       
       let errorLabel = UILabel(text: "Your login credentials were incorrect, please try again.", font: .systemFont(ofSize: 14), textColor: .red, textAlignment: .center, numberOfLines: 0)
       
       lazy var goToRegisterButton = UIButton(title: "Need an account? Go to register.", titleColor: .black, font: .systemFont(ofSize: 16), target: self, action: #selector(goToRegister))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(white: 0.95, alpha: 1)
        
        emailTextField.autocapitalizationType = .none
        emailTextField.backgroundColor = .white
        passwordTextField.backgroundColor = .white
        passwordTextField.isSecureTextEntry = true
        loginButton.layer.cornerRadius = 25
        navigationController?.navigationBar.isHidden = true
        errorLabel.isHidden = true
        
        let formView = UIView()
        formView.stack(
            formView.stack(formView.hstack(logoImageView.withSize(.init(width: 80, height: 80)), logoLabel.withWidth(160), spacing: 16, alignment: .center).padLeft(12).padRight(12), alignment: .center),
            UIView().withHeight(12),
            emailTextField.withHeight(50),
            passwordTextField.withHeight(50),
            loginButton.withHeight(50),
            errorLabel,
            goToRegisterButton,
            UIView().withHeight(80),
            spacing: 16).withMargins(.init(top: 48, left: 32, bottom: 0, right: 32))
        
        formContainerStackView.padBottom(-24)
        formContainerStackView.addArrangedSubview(formView)
    }
    
    
    @objc fileprivate func goToRegister() {
        let controller = RegisterController(alignment: .center)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc fileprivate func handleLogin() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loggin in"
        hud.show(in: view)
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        errorLabel.isHidden = true
        
        Service.shared.login(email: email, password: password) { (res) in
            hud.dismiss()
            
            switch res {
            case .failure:
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Your credentials are not correct, Please try again."
            case .success:
                self.dismiss(animated: true)
            }
        }
    }
}
