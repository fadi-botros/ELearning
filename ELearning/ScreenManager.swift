//
//  ScreenManager.swift
//  ELearning
//
//  Created by fadi on 26/06/2022.
//

import UIKit

protocol ScreenManager: AnyObject {
    func showLoginScreen() -> LoginViewModel
    func showCoursesScreen(userToken: String) -> CoursesViewModel
    func showLessonsScreen(userToken: String, course: Course) -> LessonsViewModel
    func showSingleLessonScreen(userToken: String, lesson: Lesson) -> SingleLessonViewModel
}

protocol RepositoryFactory {
    func loginRepository() -> LoginRepository
    func coursesRepository() -> CoursesRepository
    func lessonsRepository() -> LessonsRepository
}

class ScreenManagerImpl<Factory: RepositoryFactory>: ScreenManager {
    let window: UIWindow
    let repositoryFactory: Factory

    init(window: UIWindow, repositoryFactory: Factory) {
        self.window = window
        self.repositoryFactory = repositoryFactory
    }

    func showLoginScreen() -> LoginViewModel {
        let viewModel = LoginViewModel(loginRepository: LoginRepositoryJWT(urlSession: URLSession.shared), screenManager: self)
        let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as? LoginViewController
        viewModel.loginView = viewController
        window.rootViewController = viewController
        return viewModel
    }

    func showCoursesScreen(userToken: String) -> CoursesViewModel {
        fatalError("")
    }

    func showLessonsScreen(userToken: String, course: Course) -> LessonsViewModel {
        fatalError("")
    }

    func showSingleLessonScreen(userToken: String, lesson: Lesson) -> SingleLessonViewModel {
        fatalError("")
    }
    
}
