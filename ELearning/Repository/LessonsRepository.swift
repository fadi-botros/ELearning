//
//  LessonsRepository.swift
//  ELearning
//
//  Created by fadi on 03/07/2022.
//

import Foundation

protocol LessonsRepository {
    func lessons(completionHandler: @escaping ([Lesson], Error?) -> Void)
}
