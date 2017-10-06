//
//  ProfileEditingViewController.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/5/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import UIKit
import APESuperHUD
import SDWebImage

class ProfileViewController: UITableViewController {
    
    struct Constants {
        struct SegueID {
            static let showInterests = "showInterests"
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var interestsTextView: UITextView!
    @IBOutlet weak var interestChangeButton: UIButton!
    @IBOutlet weak var agePickerView: UIPickerView!
    
    var user: UserData!
    lazy var selectedInterests: Set<String> = {
        guard let interests = user.interests else {
            return []
        }
        let list = Set(user.interests)
        return list
    }()
    var isEditable: Bool!
    private var isImageChanged = false
    private var isAgePickerVisible = false

    private func toggleShowPicker () {
        isAgePickerVisible = !isAgePickerVisible
        agePickerView.isHidden = !isAgePickerVisible
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    var navBarImage: UIImage!
    var navBarShadowImge: UIImage!
    var navBarIsTranslucent: Bool!
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addActions()
        NotificationCenter.default.addObserver(forName: .ulapp_userImageChanged, object: nil, queue: .main) { notif in
            if let avatarURL = self.user.avatarURL {
                self.userImageView.sd_setImage(
                    with: URL(string: avatarURL),
                    placeholderImage: #imageLiteral(resourceName: "User")
                )
            }
        }
        agePickerView.delegate = self
        agePickerView.dataSource = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    func configureUI(){
        navigationController?.navigationBar.tintColor = UIColor.white
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2.0
        userImageView.layer.borderColor = UIColor.white.cgColor
        userImageView.layer.borderWidth = 2.0
        userImageView.layer.masksToBounds = true
        userImageView.tintColor = .white
        [nameTextField, ageTextField].forEach {
            $0?.isEnabled = self.isEditable
        }
        interestsTextView.isEditable = self.isEditable
        interestChangeButton.isHidden = !self.isEditable
        //configure user data
        if let avatarURL = user.avatarURL {
            userImageView.sd_setImage(
                with: URL(string: avatarURL),
                placeholderImage: #imageLiteral(resourceName: "User")
            )
        }
        nameTextField.text = user.name
        emailTextField.text = user.email
        if let userAge = user.age {
            ageTextField.text =  String(userAge)
        }
        if let age = user.age {
            agePickerView.selectedRow(inComponent: age + 16)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var interestsString = ""
        for (index, interest) in self.selectedInterests.enumerated() {
            interestsString  += (index == 0 ? "" : ", ") + interest
        }
        interestsTextView.text = interestsString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let idnetifer = segue.identifier else {
            return
        }
        switch idnetifer {
        case Constants.SegueID.showInterests:
            let controller = segue.destination as! InterestsListViewController
            controller.selectedInterests = Set(self.selectedInterests)
        default:
            break
        }
    }
    
    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        saveUserData()
        navigationController?.popViewController(animated: true)
    }
    @IBAction func agePickerDoneButtonTapped(_ sender: UIButton) {
        toggleShowPicker()
    }
    
}

//MARK: - Table view
extension ProfileViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !isAgePickerVisible && indexPath.row == 2 {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
}

// MARK: - Picker view
extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 84
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 16)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ageTextField.text = String(row + 16)
    }
    
//    private func pickerShowChanged () {
//        ageTextField.text = "agePickerView.compone"
//    }
    
}

// MARK: - Text Fileds
extension ProfileViewController: UITextFieldDelegate {
    
    func saveUserData() {
        //change name if needed
        let userData = UserManager.currentUserData!
        if let newName = nameTextField.text,
            userData.name != newName {
            UserManager.updateUser(name: newName)
        }
        //change age if needed
        if let newAgeText = ageTextField.text,
            let newAge = Int(newAgeText),
            userData.age != newAge {
            UserManager.updateUser(age: newAge)
        }
        //change image if needed
        if isImageChanged, let image = userImageView.image {
            UserManager.updateUser(image: image) {
            }
        }
        //change interest if needed
        UserManager.updateUser(interests: Array(selectedInterests))
    }
    
    func addActions() {
        
        ageTextField.addTarget(self,
                               action: #selector(textFieldDidChange(textField:)),
                               for: .editingChanged)
        nameTextField.addTarget(self,
                                action: #selector(textFieldDidChange(textField:)),
                                for: .editingChanged)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.ageTextField {
            toggleShowPicker()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}


// MARK: - UIImagePickerControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func cameraButtonTapped(sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            APESuperHUD.showOrUpdateHUD(icon: .sadFace,
                                        message: "U dont have camera man",
                                        presentingView: self.view)
            return
        }
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func galleryButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "Uploading image", presentingView: self.view)
            self.userImageView.image = pickedImage
            self.isImageChanged = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
