//
//  OAuthViewController.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/18.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit
import Foundation
import NVActivityIndicatorView

class OAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    private lazy var indicator = NVActivityIndicatorView()
    
    override func loadView() {
        view = webView
        webView.delegate = self
        title = "登录新浪微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style:.plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", style: .plain, target: self, action: #selector(autoFill))
        webView.addSubview(indicator)
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func autoFill() {
        let js = "document.getElementById('userId').value = 'chenhairong_2008@sina.com'; " +
        "document.getElementById('passwd').value = '~Vs059581004';"
        webView.stringByEvaluatingJavaScript(from: js)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.addSubview(indicator)
        /// OAuth URL
        /// - see:[http://open.weibo.com/wiki/Oauth2/authorize](http://open.weibo,com/wiki/Oquth2/authorize)
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirectURI)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }
}

extension OAuthViewController:UIWebViewDelegate {
     func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
       
        if request.url?.absoluteString.hasPrefix(WBRedirectURI) == false {
            return true
        }
        
        if request.url?.query?.hasPrefix("code=") == false {
            print("取消授权")
            close()
            return false
        }
    
        guard let query = request.url?.query else {return false }
        
        if query.count<4 { return false}
           
        /* code=15be12d79321e474c599210ef637c978*/
        let code = (query as NSString).substring(from:"code=".count)
        UserAccountViewModel.shared.loacAccessToken(code: code) { (isSuccess) in
            if isSuccess {
                print("success.")
                print(UserAccountViewModel.shared.account ?? "")
               // self.close()
                self.dismiss(animated: false) {
                   NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBSwitchRootViewControllerNotification), object: "welcome")
                }
            }else {
                print("failure.")
            }
        }
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
       indicator.startAnimating()
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        indicator.stopAnimating()
    }
}
