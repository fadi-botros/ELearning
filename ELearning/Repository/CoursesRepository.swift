//
//  CoursesRepository.swift
//  ELearning
//
//  Created by fadi on 01/07/2022.
//

import UIKit

protocol CoursesRepository {
    func courses(completionHandler: @escaping ([Course], Error?) -> Void)
}

class CoursesRepositoryImpl: CoursesRepository {
    let jwtToken: String
    let urlSession: URLSession

    init(urlSession: URLSession, jwtToken: String) {
        self.urlSession = urlSession
        self.jwtToken = jwtToken
    }

    func courses(completionHandler: @escaping ([Course], Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://fssrlms.online/wp-json/wp/v2/sfwd-courses")!)
        request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler([], error)
                return
            }
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let json = try JSONDecoder().decode([Course].self, from: data ?? Data())
                completionHandler(json, nil)
            } catch let err {
                completionHandler([], err)
            }
//            print(String(data: data ?? Data(), encoding: .utf8) ?? "")
        }.resume()
    }
}

class LessonRepositoryImpl: LessonsRepository {
    let jwtToken: String
    let urlSession: URLSession
    let course: Course

    init(urlSession: URLSession, jwtToken: String, course: Course) {
        self.urlSession = urlSession
        self.jwtToken = jwtToken
        self.course = course
    }

    func lessons(completionHandler: @escaping ([Lesson], Error?) -> Void) {
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
}

