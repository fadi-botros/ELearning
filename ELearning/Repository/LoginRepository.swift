//
//  LoginRepository.swift
//  ELearning
//
//  Created by fadi on 01/07/2022.
//

import Foundation

protocol LoginRepository {
    func login(username: String, password: String, completionHandler: @escaping (String?, Error?) -> Void)
}

struct Token: Codable {
    let tokenType: String
    let iat: Int
    let expiresIn: UInt64
    let jwtToken: String
}

class LoginRepositoryJWT: LoginRepository {
    let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func login(username: String, password: String, completionHandler: @escaping (String?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://fssrlms.online/wp-json/api/v1/token")!)
//        request.addValue("keep-alive", forHTTPHeaderField: "Connection")
//        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        var data = Data(capacity: 4096)
        request.httpMethod = "POST"
        data.append(form: "username", value: username)
        data.append("&".data(using: .utf8)!)
        data.append(form: "password", value: password)
        request.httpBody = data
        urlSession.dataTask(with: request) { data, response, error in
//            if error != nil {
//
//            }
//            guard let data = data else {
//                return
//            }
//            DispatchQueue.main.async {
//                webViewCallback.webKitView.loadHTMLString(String(data: data, encoding: .utf8) ?? "", baseURL: request.url!)
//                webViewCallback.afterLoad = {
//                    let _ = webViewCallback
//                    completionHandler($0, $1)
//                }
//            }
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let json = try? decoder.decode(Token.self, from: data)
            completionHandler(json?.jwtToken, error)
        }.resume()
    }
}

//class LoginRepositoryWK: LoginRepository {
//    let urlSession: URLSession
//
//    init(urlSession: URLSession) {
//        self.urlSession = urlSession
//    }
//
//    func login(username: String, password: String, completionHandler: @escaping (String?, Error?) -> Void) {
//        var request = URLRequest(url: URL(string: "https://fssrlms.online/my-account")!)
//        request.addValue("keep-alive", forHTTPHeaderField: "Connection")
//        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        let webViewCallback = WebViewCallback(urlSession: urlSession, username: username, password: password)
//        urlSession.dataTask(with: request) { data, response, error in
//            if error != nil {
//
//            }
//            guard let data = data else {
//                return
//            }
//            DispatchQueue.main.async {
//                webViewCallback.webKitView.loadHTMLString(String(data: data, encoding: .utf8) ?? "", baseURL: request.url!)
//                webViewCallback.afterLoad = {
//                    let _ = webViewCallback
//                    completionHandler($0, $1)
//                }
//            }
//        }.resume()
////        webKitView.
////        webKitView.load(URLRequest(url: URL(string: "https://fssrlms.online/my-account")!))
//    }
//}

//class WebViewCallback: NSObject, WKNavigationDelegate {
//    let webKitView = WKWebView()
//    let username: String
//    let password: String
//    let urlSession: URLSession
//
//    var afterLoad: ((String?, Error?) -> Void)?
//
//    var nonce: String?
//
//    init(urlSession: URLSession, username: String, password: String) {
//        self.urlSession = urlSession
//        self.username = username
//        self.password = password
//        super.init()
//        webKitView.navigationDelegate = self
//    }
//
//    func requestData(_ object: NSDictionary, replacingUsername username: String, password: String) -> Data {
//        var data = Data(capacity: 4096)
//        object.forEach {
//            guard let key = ($0.key as? String), let value = ($0.value as? String) else { return }
//            if key == "username" {
//                data.append(form: key, value: username)
//            } else if key == "password" {
//                data.append(form: key, value: password)
//            } else if key == "rememberme" {
//                // do nothing
//            } else {
//                if key == "woocommerce-login-nonce" { self.nonce = value }
//                data.append(form: key, value: value)
//            }
//            data.append("&".data(using: .utf8) ?? Data())
//        }
//        return data
//    }
//
//    func sendRequest(_ object: NSDictionary, replacingUsername username: String, password: String) {
//        let url = URL(string: "https://fssrlms.online/my-account")!
//        var request = URLRequest(url: url)
//        request.mainDocumentURL = URL(string: "https://fssrlms.online")!
////        request.url = URL(string: "https://fssrlms.online/my-account")!
//        request.addValue("keep-alive", forHTTPHeaderField: "Connection")
//        request.httpMethod = "POST"
//        request.httpBody = requestData(object, replacingUsername: username, password: password) + "login=Log+in&action=wp_rest".data(using: .utf8)!
//        urlSession.dataTask(with: request) { data, response, error in
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
//                  statusCode >= 200 && statusCode < 300 else {
//                print("PROBLEM")
//                self.afterLoad?(nil, error ?? NSError.init(domain: NSURLErrorDomain, code: -11111))
//                return
//            }
//            print(String(data: data!, encoding: .utf8)!)
//            print(((response as? HTTPURLResponse)?.allHeaderFields ?? [:]).map { "\($0.key) : \($0.value)" })
//            let cookies = HTTPCookie.cookies(withResponseHeaderFields: [String: String].init(uniqueKeysWithValues: ((response as? HTTPURLResponse)?.allHeaderFields ?? [:]).map { ("\($0.key)", "\($0.value)") }), for: url)
//            self.urlSession.configuration.httpCookieStorage?.setCookies(cookies, for: url, mainDocumentURL: request.mainDocumentURL)
////            self.urlSession.configuration.httpCookieStorage.
//            self.afterLoad?(self.nonce, nil)
//            print("Success")
//        }.resume()
//    }
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        webKitView.evaluateJavaScript("""
//var array = Object(); for(var i of document.getElementsByClassName("login")[0].getElementsByTagName("input")) { array[i.name] = i.value; }; array
//""") { result, error in
//            if let object = result as? NSDictionary {
//                self.sendRequest(object, replacingUsername: self.username, password: self.password)
//            }
//        }
//    }
//
//}

extension Data {
    mutating func append(urlEncoded string: String) {
        self += string.addingPercentEncoding(withAllowedCharacters: .alphanumerics.union(["_", "-"]))?.data(using: .utf8) ?? Data()
    }

    mutating func append(form key: String, value: String) {
        append(urlEncoded: key)
        append("=".data(using: .utf8) ?? Data())
        append(urlEncoded: value)
    }
}
