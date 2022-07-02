//
//  CoursesViewModel.swift
//  ELearning
//
//  Created by fadi on 24/06/2022.
//

import UIKit

enum ArrayChange {
    case insert([Int])
    case delete([Int])
}

struct ArrayWithChange<T> {
    fileprivate init(array: [T], change: ArrayChange) {
        self.array = array
        self.change = change
    }

    let array: [T]
    let change: ArrayChange
}

struct ObservableArray<Element> {
    private(set) var array: [Element]

    mutating func managedAppend(contentsOf: [Element]) -> ArrayWithChange<Element> {
        array.append(contentsOf: contentsOf)
        return ArrayWithChange(array: array, change: .insert([Int](array.count..<(array.count + contentsOf.count))))
    }

    mutating func managedDelete(indices: Array<Element>.Indices) -> ArrayWithChange<Element> {
        array.removeSubrange(indices)
        return ArrayWithChange(array: array, change: .insert([Int](indices)))
    }

}

enum Cell<T> {
    case loadingCell
    case dataCell(data: T)
}

protocol PaginatedCrudView {
    associatedtype T
    func postChange(arrayChange: ArrayWithChange<Cell<T>>)
}

protocol PaginatedRepository {
    associatedtype T
    func load(page: Int, completionHandler: @escaping ([T], Error?) -> Void)
}

class AbstractPaginatedRepository<T>: PaginatedRepository {
    func load(page: Int, completionHandler: @escaping ([T], Error?) -> Void) {
        fatalError("Not implemented")
    }
}

class AbstractPaginatedCrudView<T>: PaginatedCrudView {
    func postChange(arrayChange: ArrayWithChange<Cell<T>>) {
        fatalError("Not implemented")
    }
}

class PaginatedCrudViewModel<T> {
    private var observableArray = ObservableArray<Cell<T>>(array: [.loadingCell])
    private var page = 1
    var count: Int { get { observableArray.array.count } }

    let view: AbstractPaginatedCrudView<T>
    let repository: AbstractPaginatedRepository<T>

    init(view: AbstractPaginatedCrudView<T>, repository: AbstractPaginatedRepository<T>) {
        self.view = view
        self.repository = repository
    }

    func cell(for row: Int) -> Cell<T> {
        let cell = observableArray.array[row]
        if case .loadingCell = cell {
            repository.load(page: page) { [weak self] data, error in
                guard let self = self else { return }
                self.view.postChange(arrayChange: self.observableArray.managedDelete(indices: (self.observableArray.array.count - 1..<self.observableArray.array.count)))
                self.view.postChange(arrayChange: self.observableArray.managedAppend(contentsOf: data.map { .dataCell(data: $0) }))
            }
        }
        return cell
    }

}

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

struct Lesson {

}

class LessonsViewModel {
    let pagination: PaginatedCrudViewModel<Lesson>
    let screenManager: ScreenManager
    let userToken: String

    init(view: AbstractPaginatedCrudView<Lesson>, repository: AbstractPaginatedRepository<Lesson>, userToken: String, screenManager: ScreenManager) {
        self.pagination = PaginatedCrudViewModel(view: view, repository: repository)
        self.userToken = userToken
        self.screenManager = screenManager
    }

    func showLesson(lesson: Lesson) {
        _ = self.screenManager.showSingleLessonScreen(userToken: userToken, lesson: lesson)
    }

}

class SingleLessonViewModel {

}
