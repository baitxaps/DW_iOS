//
//  HomeWebViewControler.swift
//  DW_iOS
//
//  Created by hairong chen on 2020/3/8.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class HomeWebViewControler: UIViewController {
    
    private lazy var webView = UIWebView()
    private var url:URL
    private lazy var indicator = NVActivityIndicatorView()
    
    init(url:URL) {
        self.url = url
        super.init(nibName:nil,bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = webView
        webView.delegate = self
        webView.addSubview(indicator)
        title = "网页"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: url))
    }
}

extension HomeWebViewControler:UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
       indicator.startAnimating()
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        indicator.stopAnimating()
    }
}
