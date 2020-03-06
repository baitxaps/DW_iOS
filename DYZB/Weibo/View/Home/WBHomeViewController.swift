//
//  HomeViewController.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/15.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit
let StatusCellNormalId = "StatusCellNormalId"
let StatusCellRetweetedId = "StatusCellRetweetedId"

class WBHomeTableViewController: VisitorTableViewController {
   
    // MARK:- deinit
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView?.setupInfo(imageName: nil,title:"登录后，别人评论你的微博")
        
        prepareTabaleView()
        
        loadData()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(selectedPhoto),name: NSNotification.Name(WBStatusSelectedPhotoNotification), object: nil)
        // notification->self
        NotificationCenter.default.addObserver(forName:NSNotification.Name( WBStatusSelectedPhotoNotification), object: nil, queue:nil) {[weak self] (n) in
           // print(n)
            guard let indexPath = n.userInfo?[WBStatusSelectedPhotoIndexPathKey] as? NSIndexPath else {
                return
            }
            
            guard let urls = n.userInfo?[WBStatusSelectedPhotoURLsKey] as? [URL] else {
                return
            }
            
            // 判断是否cell 是否遵守了展现动画协议
            guard let cell = n.object as? PhotoBrowserPresentDelegate else {
                return
            }
           // print(indexPath,urls)
            
            let vc = PhotoBrowserViewController(urls: urls, indexPath: indexPath)
            vc.modalPresentationStyle = UIModalPresentationStyle.custom //.fullScreen
            vc.transitioningDelegate = self?.photoBrowserAnimator
            
            self?.photoBrowserAnimator.setPresentDelegate(presentDelegate: cell, indexPath: indexPath,dismissDelegate: vc)
         
            self?.present(vc, animated: true, completion: nil)
        }
    }
    
    private func prepareTabaleView() {
        guard let tableView = tableView  else {return}
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 400
     // tableView.rowHeight =  UITableView.automaticDimension//400
        tableView.register(StatusNormalCell.self,forCellReuseIdentifier:StatusCellNormalId)
        tableView.register(StatusRetweetedCell.self,forCellReuseIdentifier:StatusCellRetweetedId)
        
        //h:60
        refreshControl = WBRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadData), for: UIControl.Event.valueChanged)
        
        tableView.tableFooterView = pullupView
    }
    
    private var listViewModel = StatusListViewModel()
    private lazy var pullupView:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = UIColor.lightGray
        return indicator
    }()
    
    private lazy var photoBrowserAnimator:PhotoBrowserAnimator = PhotoBrowserAnimator()
}


//MARK:- loadData

extension WBHomeTableViewController {
    /// - see:[https://open.weibo.com/wiki/2/statuses/home_timeline](获取当前登录用户及其所关注（授权）用户的最新微博)
    @objc func loadData() {
        refreshControl?.beginRefreshing()
    
        let since_id = self.listViewModel.statusList.first?.status.id ?? 0
        let max_id = self.listViewModel.statusList.last?.status.id ?? 0
        
        listViewModel.loadStatus(withPullup:pullupView.isAnimating, since_id:since_id, max_id:max_id) { (isSuccess) in
            self.refreshControl?.endRefreshing()
            self.pullupView.stopAnimating()
            
            if !isSuccess {
                return
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.listViewModel.statusList.count 
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = listViewModel.statusList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier:vm.cellId, for: indexPath) as! StatusCell
        
        cell.viewModel = vm
        
        if indexPath.row == listViewModel.statusList.count - 1  && !pullupView.isAnimating {
            pullupView.startAnimating()
            loadData()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let vm = listViewModel.statusList[indexPath.row]
        
        return vm.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("clicked:\(indexPath.row)")
    }
    
    
    
    //MARK: - ----------test---------------
    func testFunc() {
        // 1.
        self.callBack (finished:{()->() in
            print("hello")
        })
        // 2.
        self.callBack(finished:hi)
    }
    
    func hi()-> () {
        print("hi")
    }
    
    func callBack(finished:()->()) {
        finished()
    }
    //-------------------------
}

