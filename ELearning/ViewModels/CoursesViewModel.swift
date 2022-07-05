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
        self.pagination = PaginatedCrudViewModel(repository: repository, onSelect: { [weak screenManager] course in
            _ = screenManager?.showLessonsScreen(userToken: userToken, course: course)
        })
        self.userToken = userToken
        self.screenManager = screenManager
    }

    func showCourse(course: Course) {
        _ = self.screenManager.showLessonsScreen(userToken: userToken, course: course)
    }

}

protocol SingleLessonView: AnyObject {
    func load(string: String)
}

class SingleLessonViewModel {
    let screenManager: ScreenManager
    let userToken: String
    let repository: LessonsRepository
    let lesson: Lesson

    init(repository: LessonsRepository, userToken: String, screenManager: ScreenManager, lesson: Lesson) {
        self.screenManager = screenManager
        self.userToken = userToken
        self.repository = repository
        self.lesson = lesson
    }

    weak var view: SingleLessonView? {
        didSet {
            repository.lessonDetails(lesson: lesson) { lessonDetails, error in
                self.view?.load(string: lessonDetails?.content.rendered ?? "")
            }
        }
    }
}
