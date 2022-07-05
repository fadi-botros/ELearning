//
//  SingleLessonViewController.swift
//  ELearning
//
//  Created by fadi on 05/07/2022.
//

import UIKit
import WebKit

class SingleLessonViewController: UIViewController, SingleLessonView {
    weak var wkWebView: WKWebView!

    func load(string: String) {
        wkWebView.loadHTMLString(string, baseURL: URL(string: "https://fssrlms.online")!)
    }

    var viewModel: SingleLessonViewModel? {
        didSet {
            bindUI()
        }
    }

    func bindUI() {
        viewModel?.view = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        wkWebView.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let wkWebView = WKWebView(frame: view.bounds)
        view.addSubview(wkWebView)
        self.wkWebView = wkWebView
        bindUI()
    }

}
