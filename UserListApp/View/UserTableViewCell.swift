//
//  UserTableViewCell.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/5/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var cardViewbackground: UIView!
    var userData: UserData! {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardViewbackground.backgroundColor = UIColor.white
        cardViewbackground.layer.cornerRadius = 5.0
        cardViewbackground.layer.masksToBounds = false
        cardViewbackground.layer.shadowColor = UIColor.appBlue.withAlphaComponent(0.4).cgColor
        cardViewbackground.layer.shadowOpacity = 0.8
        cardViewbackground.layer.shadowRadius = 2.0
        cardViewbackground.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.cardViewbackground.backgroundColor = selected ? .appLightBlue : .white
        self.userNameLabel.textColor = selected ? .white : .appLightBlue
    }
    
    func updateUI() {
        if let urlString = userData.avatarURL,
            let url = URL(string: urlString) {
            self.userImageView.sd_setImage(with: url)
        }
        self.userNameLabel.text = userData.name
    }

}
