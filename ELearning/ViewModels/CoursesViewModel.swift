//
//  CoursesViewModel.swift
//  ELearning
//
//  Created by fadi on 24/06/2022.
//

import Foundation

class CoursesViewModel {
    private(set) var pagination: PaginatedCrudViewModel<Course>?
    weak var paginationView: AbstractPaginatedCrudView<Course>? {
        didSet {
            guard let paginationView = paginationView else {
                return
            }
            self.pagination?.view = paginationView
        }
    }

    let screenManager: ScreenManager
    let userToken: String

    init(repository: AbstractPaginatedRepository<Course>, userToken: String, screenManager: ScreenManager) {
        self.pagination = PaginatedCrudViewModel(repository: repository)
        self.userToken = userToken
        self.screenManager = screenManager
    }

    func showCourse(course: Course) {
        _ = self.screenManager.showLessonsScreen(userToken: userToken, course: course)
    }

}

class SingleLessonViewModel {

}
