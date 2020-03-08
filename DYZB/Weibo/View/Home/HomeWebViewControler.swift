//
//  HomeWebViewControler.swift
//  DYZB
//
//  Created by hairong chen on 2020/3/8.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

class HomeWebViewControler: UIViewController {
    
    private lazy var webView = UIWebView()
    private var url:URL
    
    init(url:URL) {
        self.url = url
        super.init(nibName:nil,bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = webView
        title = "网页"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: url))
    }

}
