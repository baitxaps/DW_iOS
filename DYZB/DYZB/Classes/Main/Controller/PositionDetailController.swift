//
//  PositionDetailController.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/13.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

class PositionDetailController: UIViewController {
    var didSaveCallBack:(()->())?
    var position:Position?
//    {
//        didSet {
//            // 一旦使用了view，如果是nil，会调用loadView() 创建view以及子视图
//            print(view)
//            nameTextField.text = position?.name
//            ageTextField.text = "\(position?.age ?? 0)"
//        }
//    }
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    
    @IBAction func save(_ sender: Any) {
        position?.age = Int(ageTextField.text!) ?? 0
        position?.name = nameTextField.text
        print(position ?? "")
        
        didSaveCallBack?()
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func textchanged() {
        navigationItem.rightBarButtonItem?.isEnabled = nameTextField.hasText && ageTextField.hasText
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameTextField.text = position?.name
        ageTextField.text = "\(position?.age ?? 0)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
