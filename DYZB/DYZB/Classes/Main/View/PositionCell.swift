
//
//  PositionCell.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/12.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

class PositionCell: UITableViewCell {
    
    var obj:Position? {
        didSet {
            nameLabel.text = obj?.name
            ageLabel.text = "\(obj?.age ?? 0)"
        }
    }
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!

}
