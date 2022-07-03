//
//  LoginViewModel.swift
//  ELearning
//
//  Created by fadi on 24/06/2022.
//

import UIKit

protocol LoginView: AnyObject {
    var username: String { get set }
    var password: String { get set }

    var error: String? { get set }
}

class LoginViewModel {
    private(set) var screenManager: ScreenManager?
    weak var loginView: LoginView?
    let loginRepository: LoginRepository

    init(loginRepository: LoginRepository, screenManager: ScreenManager) {
        self.screenManager = screenManager
        self.loginRepository = loginRepository
    }

    var username: String { get { loginView!.username } set { loginView!.username = newValue } }
    var password: String { get { loginView!.password } set { loginView!.password = newValue } }

    func login() {
        loginRepository.login(username: username, password: password) { token, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.loginView?.error = error.localizedDescription
                    return
                }
                if let token = token {
                    _ = self.screenManager?.showCoursesScreen(userToken: token)
                    return
                }
                self.loginView?.error = "Unknown error"
            }
        }
    }
}
