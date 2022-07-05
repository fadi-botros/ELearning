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
    func showSingleLessonScreen(repository: LessonsRepository, userToken: String, lesson: Lesson) -> SingleLessonViewModel
}

protocol RepositoryFactory {
    func loginRepository() -> LoginRepository
    func coursesRepository(jwtToken: String) -> AbstractPaginatedRepository<Course> & CoursesRepository
    func lessonsRepository(jwtToken: String, course: Course) -> AbstractPaginatedRepository<Lesson> & LessonsRepository
}

class RepositoryFactoryImpl: RepositoryFactory {
    func loginRepository() -> LoginRepository {
        return LoginRepositoryJWT(urlSession: URLSession.shared)
    }

    func coursesRepository(jwtToken: String) -> AbstractPaginatedRepository<Course> & CoursesRepository {
        return CoursesRepositoryImpl(urlSession: URLSession.shared, jwtToken: jwtToken)
    }

    func lessonsRepository(jwtToken: String, course: Course) -> AbstractPaginatedRepository<Lesson> & LessonsRepository {
        return LessonsRepositoryImpl(urlSession: URLSession.shared, jwtToken: jwtToken, course: course)
    }
}

class ScreenManagerImpl<Factory: RepositoryFactory>: ScreenManager {
    let window: UIWindow
    let repositoryFactory: Factory

    init(window: UIWindow, repositoryFactory: Factory) {
        self.window = window
        self.repositoryFactory = repositoryFactory
    }

    func showLoginScreen() -> LoginViewModel {
        let viewModel = LoginViewModel(loginRepository: repositoryFactory.loginRepository(), screenManager: self)
        let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as? LoginViewController
        viewController?.viewModel = viewModel
        window.rootViewController = viewController
        return viewModel
    }

    func showCoursesScreen(userToken: String) -> CoursesViewModel {
        let viewModel = CoursesViewModel(repository: repositoryFactory.coursesRepository(jwtToken: userToken), userToken: userToken, screenManager: self) //(loginRepository: repositoryFactory.loginRepository(), screenManager: self)
        guard let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "courses") as? CoursesViewController else {
            fatalError("View not found")
        }
        viewController.coursesViewModel = viewModel
        let navigation = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigation
        navigation.navigationBar.backgroundColor = .init(white: (0xee as CGFloat) / 256.0, alpha: 1)
        navigation.navigationBar.barTintColor = .init(white: (0xee as CGFloat) / 256.0, alpha: 1)
        return viewModel
    }

    func showLessonsScreen(userToken: String, course: Course) -> LessonsViewModel {
        let viewModel = LessonsViewModel(repository: repositoryFactory.lessonsRepository(jwtToken: userToken, course: course), userToken: userToken, screenManager: self) //(loginRepository: repositoryFactory.loginRepository(), screenManager: self)
        guard let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "lessons") as? LessonsViewController else {
            fatalError("View not found")
        }
        viewController.navigationItem.title = course.title.rendered
        viewController.lessonsViewModel = viewModel
        (window.rootViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
        return viewModel
    }

    func showSingleLessonScreen(repository: LessonsRepository, userToken: String, lesson: Lesson) -> SingleLessonViewModel {
        let viewModel = SingleLessonViewModel(repository: repository, userToken: userToken, screenManager: self, lesson: lesson) //(loginRepository: repositoryFactory.loginRepository(), screenManager: self)
        guard let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "singleLesson") as? SingleLessonViewController else {
            fatalError("View not found")
        }
        viewController.navigationItem.title = lesson.title.rendered
        viewController.viewModel = viewModel
        (window.rootViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
        return viewModel
    }

}
