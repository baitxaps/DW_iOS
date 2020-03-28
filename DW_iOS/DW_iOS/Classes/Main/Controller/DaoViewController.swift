//
//  WeiBoMainViewController.swift
//  DW_iOS
//
//  Created by hairong chen on 2020/1/13.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

class DaoViewController: UIViewController {
    private lazy var tableView :UITableView = {
        let tb = UITableView(frame:CGRect.zero,style:UITableView.Style.plain)
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tb.delegate = self
        tb.dataSource = self
        return tb
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func loadView() {
        view = tableView
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
    }
}

// MARK:- UITableViewDataSource,UITableViewDelegate

extension DaoViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "hello\(indexPath.row)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  self.tableView(tableView,didSelectRowAt: indexPath)
    }
}

