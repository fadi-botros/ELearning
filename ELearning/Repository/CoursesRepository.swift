//
//  CoursesRepository.swift
//  ELearning
//
//  Created by fadi on 01/07/2022.
//

import UIKit

protocol CoursesRepository {
    func courses(page: Int, completionHandler: @escaping ([Course], Error?) -> Void)
}

class CoursesRepositoryImpl: AbstractPaginatedRepository<Course>, CoursesRepository {
    let jwtToken: String
    let urlSession: URLSession

    init(urlSession: URLSession, jwtToken: String) {
        self.urlSession = urlSession
        self.jwtToken = jwtToken
    }

    func courses(page: Int = 1, completionHandler: @escaping ([Course], Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://fssrlms.online/wp-json/wp/v2/sfwd-courses?page=\(page)")!)
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

    override func load(page: Int, completionHandler: @escaping ([Course], Error?) -> Void) {
        courses(page: page, completionHandler: completionHandler)
    }
}
