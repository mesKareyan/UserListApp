//
//  AboutViewController.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/6/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var buildVersionLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    var navBarImage: UIImage!
    var navBarShadowImge: UIImage!
    var navBarIsTranslucent: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        buildVersionLabel.text = "Build version: " + UIApplication.appBuild()
        appVersionLabel.text   = "App version: " + UIApplication.appVersion()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent != nil {
            navBarImage = navigationController?.navigationBar.backgroundImage(for: .default)
            navBarShadowImge = navigationController?.navigationBar.shadowImage
            navBarIsTranslucent = navigationController?.navigationBar.isTranslucent
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = true
        } else {
            navigationController?.navigationBar.setBackgroundImage(navBarImage, for: .default)
            navigationController?.navigationBar.shadowImage = navBarShadowImge
            navigationController?.navigationBar.isTranslucent = navBarIsTranslucent
        }
    }

}
