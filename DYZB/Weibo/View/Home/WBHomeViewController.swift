//
//  HomeViewController.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/15.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit
private let StatusCellNormalId = "StatusCellNormalId"
class WBHomeTableViewController: VisitorTableViewController {
    private var listViewModel = StatusListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView?.setupInfo(imageName: nil,title:"登录后，别人评论你的微博")
        prepareTabaleView()
        
        loadStatus() {}
    }
    
    private func prepareTabaleView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: StatusCellNormalId)
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
        let cell = tableView.dequeueReusableCell(withIdentifier:StatusCellNormalId, for: indexPath)
        cell.textLabel?.text = self.listViewModel.statusList[indexPath.row].text
        
        return cell
    }
}

