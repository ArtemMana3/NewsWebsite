//
//  ViewController.swift
//  NewsWebsite
//
//  Created by Artem Manakov on 23.01.2023.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let forwardButton = UIBarButtonItem(image: UIImage(systemName: "chevron.forward"), style: .plain, target: webView, action: #selector(webView.goForward))
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: webView, action: #selector(webView.goBack))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButtom = UIBarButtonItem(customView: progressView)

        toolbarItems = [backButton, space, forwardButton, space, progressButtom, space, refresh]
        navigationController?.isToolbarHidden = false
        
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: "https://theatlasnews.co/ml-api/v2/list")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            if host.contains("theatlasnews") {
                decisionHandler(.allow)
                return
            }
        }
        decisionHandler(.cancel)

    }
}

