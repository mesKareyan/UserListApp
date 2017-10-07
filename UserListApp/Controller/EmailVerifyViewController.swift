//
//  EmailVerifyViewController.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/7/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import UIKit
import FirebaseAuth
import APESuperHUD

class EmailVerifyViewController: UIViewController {
    
    @IBOutlet weak var toplabel: UILabel!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    var timer: Timer!
    var verifyComletion: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        congigureUI()
    }
    
    private func congigureUI() {
        verifyButton.clipsToBounds = true
        verifyButton.layer.cornerRadius = emailLabel.bounds.height / 2.0
        configureFiled(emailLabel)
        emailLabel.text = UserManager.currentUserData?.email
    }
    
    private func configureFiled(_ textFiled: UITextField) {
        let image: UIImage = #imageLiteral(resourceName: "User")
        let leftImageView = UIImageView(image: image)
        leftImageView.tintColor =  UIColor.groupTableViewBackground
        if let size = leftImageView.image?.size {
            leftImageView.frame = CGRect(x: 0.0,
                                         y: 0.0,
                                         width: size.width + 30,
                                         height: size.height)
        }
        leftImageView.contentMode = .center
        textFiled.leftView = leftImageView
        textFiled.leftViewMode = .always
        textFiled.backgroundColor = UIColor.white.withAlphaComponent(0.2)
    }
    
    //MARK: - Actoins
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func emailSendButtonTapped(_ sender: UIButton) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        func showSuccess() {
            let emailAdress = emailLabel.text ?? ""
            let message = "Email sent to \(emailAdress)"
            APESuperHUD.showOrUpdateHUD(icon: .email,
                                        message: message,
                                        presentingView: self.view)
        }
        func showFail(error: Error) {
            APESuperHUD.showOrUpdateHUD(icon: .sadFace,
                                        message: error.localizedDescription,
                                        presentingView: self.view)
        }
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "Sending mail", presentingView: self.view)
        user.sendEmailVerification(completion: { error in
            if error == nil {
                showSuccess()
                self.verifyButton.isEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.verifyComletion?()
                    self.dismiss(animated: true, completion: nil)
                })
            } else {
                showFail(error: error!)
            }
        })
    }
    
}
