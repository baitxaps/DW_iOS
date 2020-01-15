//
//  PositionTableViewController.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/12.
//  Copyright @huse.cn All rights reserved.
//

import UIKit

// MARK:- data
extension PositionTableViewController {
    
    private func loadData(completion:@escaping(_ array: [Position]) ->() ) {
        DispatchQueue.global().async {
            print("data loading.")
            var dataList = [Position]()
            for i in 0..<50 {
                let name = "ball\(i)"
                let age = arc4random()%20 + 10
            //  let dict = ["name":name,"age":age] as [String : Any]
                let dict: [String : Any] = ["name":name,"age":age]
                dataList.append(Position(dict:dict))
            }
            DispatchQueue.main.async {
                print("finished.")
                completion(dataList)
            }
        }
    }
}

class PositionTableViewController: UITableViewController {
    private var position:[Position]?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData {(data)->() in
               //print(data)
               self.position = data
               self.tableView.reloadData()
           }
//        loadData {(data) in
//            //print(data)
//            self.position = data
//            self.tableView.reloadData()
//        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.position?.count ?? 0
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PositionCell
        cell.obj = position![indexPath.row];
       
        //let obj:Position =  position![indexPath.row]
        //cell.textLabel?.text = position![indexPath.row].name
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        guard let detailVC = segue.destination as?PositionDetailController else {
            return
        }
        guard  let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        detailVC.position = position![indexPath.row]
//        detailVC.didSaveCallBack = {
//            //()->() in 可以省略
//            self.tableView.reloadData()
//        }
        // 简写
        detailVC.didSaveCallBack = self.tableView.reloadData
    }
}


