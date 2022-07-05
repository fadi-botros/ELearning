//
//  Lesson.swift
//  ELearning
//
//  Created by fadi on 03/07/2022.
//

import Foundation

struct Lesson: Codable {
    let id: Int
    let title: Rendered
    let content: Rendered
}
