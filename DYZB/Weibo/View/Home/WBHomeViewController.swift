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
    private var listViewModel = StatusListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView?.setupInfo(imageName: nil,title:"登录后，别人评论你的微博")
        
        prepareTabaleView()
        
        loadStatus() {}
    }
    
    private func prepareTabaleView() {
        guard let tableView = tableView  else {return}
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 400
        // tableView.rowHeight =  UITableView.automaticDimension//400
        tableView.register(StatusNormalCell.self,forCellReuseIdentifier:StatusCellNormalId)
        tableView.register(StatusRetweetedCell.self,forCellReuseIdentifier:StatusCellRetweetedId)
    }
}


//MARK:- loadStatus

extension WBHomeTableViewController {
    /// - see:[https://open.weibo.com/wiki/2/statuses/home_timeline](获取当前登录用户及其所关注（授权）用户的最新微博)
    func loadStatus(finished:()->()) {
        listViewModel.loadStatus { (isSuccess) in
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

