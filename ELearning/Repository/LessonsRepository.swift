//
//  LessonsRepository.swift
//  ELearning
//
//  Created by fadi on 03/07/2022.
//

import Foundation

protocol LessonsRepository {
    func lessons(page: Int, completionHandler: @escaping ([Lesson], Error?) -> Void)
    func lessonDetails(lesson: Lesson, completionHandler: @escaping (Lesson?, Error?) -> Void)
}

class LessonsRepositoryImpl: AbstractPaginatedRepository<Lesson>, LessonsRepository {
    let jwtToken: String
    let urlSession: URLSession
    let course: Course

    init(urlSession: URLSession, jwtToken: String, course: Course) {
        self.urlSession = urlSession
        self.jwtToken = jwtToken
        self.course = course
    }

    func lessons(page: Int = 1, completionHandler: @escaping ([Lesson], Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://fssrlms.online/wp-json/wp/v2/sfwd-lessons?course=\(course.id)")!)
        request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        urlSession.dataTask(with: request) { data, response, error in
            print(String(data: data!, encoding: .utf8)!)
            if let error = error {
                completionHandler([], error)
                return
            }
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let json = try JSONDecoder().decode([Lesson].self, from: data ?? Data())
                completionHandler(json, nil)
            } catch let err {
                completionHandler([], err)
            }
        }.resume()
    }

    override func load(page: Int, completionHandler: @escaping ([Lesson], Error?) -> Void) {
        lessons(page: page, completionHandler: completionHandler)
    }

    func lessonDetails(lesson: Lesson, completionHandler: @escaping (Lesson?, Error?) -> Void) {
//        var request = URLRequest(url: URL(string: "https://fssrlms.online/wp-json/wp/v2/sfwd-lessons/\(lesson.id)")!)
//        lessons/ms500-lecture-07-2/
//        var request = URLRequest(url: URL(string: "https://fssrlms.online/wp-json/wp/v2/media?parent=\(lesson.id)")!)
        var request = URLRequest(url: URL(string: "https://fssrlms.online/wp-json/wp/v2/sfwd-lessons/\(lesson.id)")!)
        request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        urlSession.dataTask(with: request) { data, response, error in
            print(String(data: data!, encoding: .utf8)!)
            if let error = error {
                completionHandler(nil, error)
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let json = try JSONDecoder().decode(Optional<Lesson>.self, from: data ?? Data())
                completionHandler(json, nil)
            } catch let err {
                completionHandler(nil, err)
            }
        }.resume()

    }
}
