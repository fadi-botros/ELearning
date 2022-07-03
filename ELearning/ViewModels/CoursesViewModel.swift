//
//  CoursesViewModel.swift
//  ELearning
//
//  Created by fadi on 24/06/2022.
//

import Foundation

class CoursesViewModel {
    let pagination: PaginatedCrudViewModel<Course>
    let screenManager: ScreenManager
    let userToken: String

    init(view: AbstractPaginatedCrudView<Course>, repository: AbstractPaginatedRepository<Course>, userToken: String, screenManager: ScreenManager) {
        self.pagination = PaginatedCrudViewModel(view: view, repository: repository)
        self.userToken = userToken
        self.screenManager = screenManager
    }

    func showCourse(course: Course) {
        _ = self.screenManager.showLessonsScreen(userToken: userToken, course: course)
    }

}

class SingleLessonViewModel {

}
