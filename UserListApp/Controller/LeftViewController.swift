//
//  LeftViewController.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/5/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import UIKit
import SDWebImage
import MessageUI
import APESuperHUD

protocol LeftViewDelegate: class {
    
    func profileRowTapped()
    func feedbackRowTapped()
    func infoRowTapped()
    func signOutRowTapped()
    
}

class LeftViewController: UITableViewController {

    private var leftborderAdded = false
    @IBOutlet weak var profileImageView: UIImageView!
    weak var leftViewDelegate: LeftViewDelegate!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        counfigureUI()
    }
    
    func counfigureUI(){
        guard !leftborderAdded else {
            return
        }
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.layer.borderWidth = 3.0
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.masksToBounds = true
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.appBlue.cgColor
        border.frame = CGRect(x: tableView.frame.width - width,
                              y: 0,
                              width: width,
                              height: tableView.frame.height)
        border.borderWidth = width
        tableView.layer.addSublayer(border)
        tableView.layer.masksToBounds = true
        leftborderAdded = true
        //User ui
        let currentUser = UserManager.currentUserData
        if let avatarURL = currentUser?.avatarURL {
            profileImageView.sd_setImage(
                with: URL(string: avatarURL),
                placeholderImage: #imageLiteral(resourceName: "User")
            )
        }
        profileNameLabel.text = currentUser?.name

    }

}

// MARK: - TableView Delegate
extension LeftViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            leftViewDelegate.profileRowTapped()
        case 1:
            leftViewDelegate.feedbackRowTapped()
            sendMail()
        case 2:
            leftViewDelegate.infoRowTapped()
        case 4:
            leftViewDelegate.signOutRowTapped()
        default:
            break
        }
    }
}

extension LeftViewController: MFMailComposeViewControllerDelegate {
    
    func sendMail() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
       
        let mailComposerVC = MFMailComposeViewController()
        let emailAdress = UserManager.currentUserData.email
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([emailAdress])
        mailComposerVC.setSubject("Test message")
        mailComposerVC.setMessageBody("Firebase here!", isHTML: false)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        APESuperHUD.showOrUpdateHUD(icon: .sadFace,
                                    message: "Can't send mail",
                                    presentingView: self.view)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
