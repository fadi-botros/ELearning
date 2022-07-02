//
//  CoursesRepository.swift
//  ELearning
//
//  Created by fadi on 01/07/2022.
//

import UIKit

struct Course: Codable {
    let name: String
}

protocol CoursesRepository {
    func courses(completionHandler: @escaping ([Course]) -> Void)
}

class CoursesRepositoryImpl: CoursesRepository {
    let jwtToken: String
    let urlSession: URLSession

    init(urlSession: URLSession, jwtToken: String) {
        self.urlSession = urlSession
        self.jwtToken = jwtToken
    }

    func courses(completionHandler: @escaping ([Course]) -> Void) {
        var request = URLRequest(url: URL(string: "https://fssrlms.online/wp-json/wp/v2/sfwd-courses/9408")!)
        request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        urlSession.dataTask(with: request) { data, response, error in
            print(String(data: data ?? Data(), encoding: .utf8) ?? "")
        }.resume()
    }
}
