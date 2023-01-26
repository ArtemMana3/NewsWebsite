//
//  ViewController.swift
//  NewsWebsite
//
//  Created by Artem Manakov on 23.01.2023.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    private var webView: WKWebView!
    private var progressView: UIProgressView!
    var url: URL = URL(string: "https://theatlasnews.co/ml-api/v2/list")!

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
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
        setToolbar()
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)
    }
    
    func setToolbar() {
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButtom = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [space, progressButtom, space, refresh, space]
        navigationController?.isToolbarHidden = false
    }
    
    func setupWebView() {
        guard let path = Bundle.main.path(forResource: "jsCode", ofType: "js") else {
            print("Incorrect filepath")
            return
        }
        guard let jsCode = try? String(contentsOfFile: path) else {
            print("Something went wrong with converting path into string")
            return
        }
                
        let userScript = WKUserScript.init(source: jsCode, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(userScript)
        webView.configuration.userContentController.add(self, name: "messenger")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if let host = url?.host {
            if host.contains("theatlasnews.co") {
                decisionHandler(.allow)
                return
            }
        }
        decisionHandler(.cancel)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Feed") as? ViewController {
            guard let url = URL(string: "https://theatlasnews.co/ml-api/v2/post?post_id=\(message.body)") else {
                print("Incorrect URL")
                return
            }
            vc.url = url
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}



