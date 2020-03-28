//
//  HomeViewController.swift
//  DW_iOS
//
//  Created by hairong chen on  9/14.
//  Copyright @huse.cn All rights reserved.
//

import UIKit

private let kTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {
    
    // MARK:- 懒加载属性
    fileprivate lazy var pageTitleView : PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: (isIPhoneXType() ?kxStatusBarH : kStatusBarH)  + kNavigationBarH , width: kScreenW, height: kTitleViewH)
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    fileprivate lazy var pageContentView : PageContentView = {[weak self] in
        
        // 1.确定内容的frame
        let contentH = kScreenH - kStatusBarH - kNavigationBarH - kTitleViewH - kTabbarH
        let contentFrame = CGRect(x: 0, y: (isIPhoneXType() ?kxStatusBarH : kStatusBarH)  + kNavigationBarH + kTitleViewH, width: kScreenW, height: contentH)
        
        // 2.确定所有的子控制器
        var childVcs = [UIViewController]()
        childVcs.append(RecommendViewController())
        childVcs.append(GameViewController())
        childVcs.append(AmuseViewController())
        childVcs.append(FunnyViewController())
        
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        contentView.delegate = self
        return contentView
    }()
    
    fileprivate lazy  var newsModels:[NewsModel] = [NewsModel]()
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //-------------------------//
//        KeyTest()
//        let httpTools = HttpTools()
//        //1.
//        weak var weakSelf :HomeViewController? = self
//        httpTools.loadData ({(jsonData:String) in
//                   print("jsonData")
//                   weakSelf?.view.backgroundColor = UIColor.red
//               })
//        //2.
//        httpTools.loadData ({[weak self] (jsonData:String) in
//            print("jsonData")
//            self?.view.backgroundColor = UIColor.red
//        })
//
//        //3.
//        httpTools.loadData ({[unowned self] (jsonData:String) in
//            print("jsonData")
//            self.view.backgroundColor = UIColor.red
//        })
//
//        // 1.如果在函数中，闭包是最后一个参数，那么可以写成尾随闭包
//        // 2.如果是唯一的参数，也可以将前的（）省田略掉
//        httpTools.loadData(){[weak self](jsonData:String) in
//            print("jsonData")
//            self?.view.backgroundColor = UIColor.red
//        }
//
//        httpTools.loadData {[weak self](jsonData:String) in
//            print("jsonData")
//            self?.view.backgroundColor = UIColor.red
//        }
        let url = "http://c.m.163.com/nc/article/list/T1348649079062/0-20.html";
        NetworkTools.requestData(.get, URLString: url) { (result) in
            guard let resultDict = result as?[String:Any]else {return}
            guard let dataArray = resultDict["T1348649079062"]as?[[String:Any]]else{return}
            for dic in dataArray {
                self.newsModels.append(NewsModel(dict: dic))
            }
        }
     
        //-------------------------//
        
        // 设置UI界面
        setupUI()
    }
    
}


// MARK:- 设置UI界面
extension HomeViewController {
    fileprivate func setupUI() {
       // edgesForExtendedLayout = []
        // 0.不需要调整UIScrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
        
        // 1.设置导航栏
        setupNavigationBar()
        
        // 2.添加TitleView
        view.addSubview(pageTitleView)
        
        // 3.添加ContentView
        view.addSubview(pageContentView)
    }
    
    fileprivate func setupNavigationBar() {
        // 1.设置左侧的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        // 2.设置右侧的Item
        let size = CGSize(width: 40, height: 40)
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem]
    }
}


// MARK:- 遵守PageTitleViewDelegate协议
extension HomeViewController : PageTitleViewDelegate {
    func pageTitleView(_ titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(index)
    }
}


// MARK:- 遵守PageContentViewDelegate协议
extension HomeViewController : PageContentViewDelegate {
    func pageContentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
