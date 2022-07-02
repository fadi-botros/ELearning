//
//  ViewController.swift
//  ELearning
//
//  Created by fadi on 22/06/2022.
//

import UIKit
import WebKit

//class CookieHandler: HTTPCookieStorage {
//
//    var _cookies: [String: HTTPCookie] = [:]
//
//    override var cookies: [HTTPCookie]? { get { [HTTPCookie].init(_cookies.values) } }
//
//    override func setCookie(_ cookie: HTTPCookie) {
//        _cookies[cookie.name] = cookie
//    }
//
//
//    /**
//     @method deleteCookie:
//     @abstract Delete the specified cookie
//     */
//    override func deleteCookie(_ cookie: HTTPCookie) {
//        _cookies[cookie.name] = nil
//    }
//
//
//    override func removeCookies(since date: Date) {
//        _cookies = _cookies.filter { ($0.value.expiresDate ?? Date.distantPast) > date }
//    }
//
//
//    /**
//     @method cookiesForURL:
//     @abstract Returns an array of cookies to send to the given URL.
//     @param URL The URL for which to get cookies.
//     @result an NSArray of NSHTTPCookie objects.
//     @discussion The cookie manager examines the cookies it stores and
//     includes those which should be sent to the given URL. You can use
//     <tt>+[NSCookie requestHeaderFieldsWithCookies:]</tt> to turn this array
//     into a set of header fields to add to a request.
//     */
//    override func cookies(for URL: URL) -> [HTTPCookie]? {
//        return _cookies.filter { $0.value.commentURL == URL }
//    }
//
//
//    /**
//     @method setCookies:forURL:mainDocumentURL:
//     @abstract Adds an array cookies to the cookie store, following the
//     cookie accept policy.
//     @param cookies The cookies to set.
//     @param URL The URL from which the cookies were sent.
//     @param mainDocumentURL The main document URL to be used as a base for the "same
//     domain as main document" policy.
//     @discussion For mainDocumentURL, the caller should pass the URL for
//     an appropriate main document, if known. For example, when loading
//     a web page, the URL of the main html document for the top-level
//     frame should be passed. To save cookies based on a set of response
//     headers, you can use <tt>+[NSCookie
//     cookiesWithResponseHeaderFields:forURL:]</tt> on a header field
//     dictionary and then use this method to store the resulting cookies
//     in accordance with policy settings.
//     */
//    open func setCookies(_ cookies: [HTTPCookie], for URL: URL?, mainDocumentURL: URL?)
//
//
//    /**
//     @abstract The cookie accept policy preference of the
//     receiver.
//     */
//    open var cookieAcceptPolicy: HTTPCookie.AcceptPolicy
//
//
//    /**
//     @method sortedCookiesUsingDescriptors:
//     @abstract Returns an array of all cookies in the store, sorted according to the key value and sorting direction of the NSSortDescriptors specified in the parameter.
//     @param sortOrder an array of NSSortDescriptors which represent the preferred sort order of the resulting array.
//     @discussion proper sorting of cookies may require extensive string conversion, which can be avoided by allowing the system to perform the sorting.  This API is to be preferred over the more generic -[NSHTTPCookieStorage cookies] API, if sorting is going to be performed.
//     */
//    @available(iOS 5.0, *)
//    open func sortedCookies(using sortOrder: [NSSortDescriptor]) -> [HTTPCookie]
//
//}

//class CookieHandler: HTTPCookie {
//
//}

class ViewController: UIViewController {
    var repository: LoginRepositoryJWT?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

//        CoursesRepositoryImpl().courses { courses in
//            print("Courses read")
//        }


        let configuration = URLSessionConfiguration.default.copy() as! URLSessionConfiguration
        HTTPCookieStorage.shared.cookieAcceptPolicy = .always
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        configuration.httpShouldSetCookies = true
        configuration.httpCookieAcceptPolicy = .always
        let urlSession = URLSession(configuration: configuration)

        repository = LoginRepositoryJWT(urlSession: urlSession)
        repository?.login(username: "fadi", password: "XWHdQECdyPOVwhPB$1kdvFl1", completionHandler: { nonce, error in
//            print("\(error ?? "No error")")
            CoursesRepositoryImpl(urlSession: urlSession, jwtToken: nonce!).courses { courses in
                print("Courses read")
            }
        })
    }

}

