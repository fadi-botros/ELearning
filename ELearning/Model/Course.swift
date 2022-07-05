//
//  Course.swift
//  ELearning
//
//  Created by fadi on 03/07/2022.
//

import Foundation

struct Rendered: Codable {
    let rendered: String
}

struct Course: Codable {
    let id: Int
    let title: Rendered
    let slug: String
}
