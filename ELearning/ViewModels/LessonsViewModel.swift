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
    let repository: LessonsRepository

    init(repository: AbstractPaginatedRepository<Lesson> & LessonsRepository, userToken: String, screenManager: ScreenManager) {
        self.repository = repository
        self.pagination = PaginatedCrudViewModel(repository: repository, onSelect: { [weak screenManager] lesson in
            _ = screenManager?.showSingleLessonScreen(repository: repository, userToken: userToken, lesson: lesson)
//            _ = screenManager?.showSingleLessonScreen(userToken: userToken, lesson: lesson)
        })
        self.userToken = userToken
        self.screenManager = screenManager
    }

}
