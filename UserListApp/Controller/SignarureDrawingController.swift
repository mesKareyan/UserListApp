//
//  SignarureDrawingController.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/7/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import UIKit
import ACEDrawingView

class SignarureDrawingController: UIViewController {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var drawingView: ACEDrawingView!

    override func viewDidLoad() {
        super.viewDidLoad()
        drawingView.lineWidth = 2.0
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
