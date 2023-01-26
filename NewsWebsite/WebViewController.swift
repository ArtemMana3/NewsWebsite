//
//  ViewController.swift
//  NewsWebsite
//
//  Created by Artem Manakov on 23.01.2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    private var webView: WKWebView!
    private var progressView: UIProgressView!
    var url: URL = URL(string: "https://theatlasnews.co/ml-api/v2/list")!

    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebView()
        setupWebView()
    }
    
    func configureWebView() {
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        title = "Atlas News"
        configureToolbar()
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)
    }
    
    func configureToolbar() {
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButtom = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [space, progressButtom, space, refresh, space]
        navigationController?.isToolbarHidden = false
    }
    
    func setupWebView() {
        guard let jsCodePath = Bundle.main.path(forResource: "jsCode", ofType: "js") else {
            print("Incorrect filepath")
            return
        }
        guard let jsCode = try? String(contentsOfFile: jsCodePath) else {
            print("Something went wrong when converting the path to a string")
            return
        }
                
        let userScript = WKUserScript.init(source: jsCode,
                                           injectionTime: .atDocumentEnd,
                                           forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(userScript)
        webView.configuration.userContentController.add(self, name: "messenger")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
}

extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let url = URL(string: "https://theatlasnews.co/ml-api/v2/post?post_id=\(message.body)") else {
            print("Incorrect URL")
            return
        }
        let webVC = WebViewController()
        webVC.url = url
        navigationController?.pushViewController(webVC, animated: true)
    }
}



