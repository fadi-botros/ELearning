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
