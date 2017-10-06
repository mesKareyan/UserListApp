//
//  LeftViewCell.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/6/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import UIKit

class LeftViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        guard selected else {
            return
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .autoreverse, animations: {
            self.backgroundColor = .appLightBlue
        }) { fin in
            self.backgroundColor = .white
        }
    }

}
