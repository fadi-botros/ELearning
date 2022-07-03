//
//  LessonsViewModel.swift
//  ELearning
//
//  Created by fadi on 03/07/2022.
//

import Foundation

class LessonsViewModel {
    let pagination: PaginatedCrudViewModel<Lesson>
    let screenManager: ScreenManager
    let userToken: String

    init(view: AbstractPaginatedCrudView<Lesson>, repository: AbstractPaginatedRepository<Lesson>, userToken: String, screenManager: ScreenManager) {
        self.pagination = PaginatedCrudViewModel(repository: repository)
        self.userToken = userToken
        self.screenManager = screenManager
    }

    func showLesson(lesson: Lesson) {
        _ = self.screenManager.showSingleLessonScreen(userToken: userToken, lesson: lesson)
    }

}
