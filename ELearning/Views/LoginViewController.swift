//
//  LoginViewController.swift
//  ELearning
//
//  Created by fadi on 22/06/2022.
//

import UIKit

class LoginViewController: UIViewController, LoginView {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityControl: UIActivityIndicatorView!

    var viewModel: LoginViewModel? {
        didSet {
            viewModel?.loginView = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    var username: String { get { return userNameTextField.text ?? "" } set { userNameTextField.text = newValue } }
    var password: String { get { return passwordTextField.text ?? "" } set { passwordTextField.text = newValue } }

    var error: String? {
        didSet {
            guard let error = error else {
                return
            }

            let alertView = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alertView, animated: true)
            activityControl.stopAnimating()
        }
    }

    @IBAction func login(_ sender: Any) {
        activityControl.startAnimating()
        viewModel?.login()
    }
}
