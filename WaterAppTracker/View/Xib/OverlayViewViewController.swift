//
//  OverlayViewViewController.swift
//  WaterAppDemo
//
//  Created by Egor Markov on 20.12.2020.
//  Copyright © 2020 Egor Markov. All rights reserved.
//


import UIKit


class OverlayViewViewController: UIViewController, UITextFieldDelegate {

   
    //MARK: - IBOutlet
    @IBOutlet weak var labelCreated: UILabel!
    @IBOutlet weak var labelComleted: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var toDoLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var saveUserInfo: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var createTasks: UILabel!
    @IBOutlet weak var completedTasks: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var containerView: CircularProgressView!
    @IBOutlet weak var containerView2: CircularProgressView!
    @IBOutlet weak var containerView3: CircularProgressView!
    
    //MARK: - Propirties
    var delegateAction: ActionDelegate!
    var countFired: CGFloat = 0
    var countFired2: CGFloat = 0
    var countFired3: CGFloat = 0
    var userDAO = DaoUserImpl.current
    var user: User!
    var userName: String!
    var userSurname: String!
    var userProfile: Data!
    
    
    var completedTasksCount = 0
    var timer: Timer?
    var timer2: Timer?
    var timer3: Timer?
    
    var selectedImageProfile: UIImage!
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        nameTF.delegate = self
        surnameTF.delegate = self
        
        saveUserInfo.isHidden = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        

        registerForKeyboardNotifications()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageuser))
        imageUser.addGestureRecognizer(tapGesture)
        imageUser.isUserInteractionEnabled = true
        
        if let user = user {
            userName = user.name
            userSurname = user.surname
            userProfile = user.image
        }
        
        if let imageProfile = user?.image {
            imageUser.image = UIImage(data: imageProfile)
        }else{
            imageUser.image = UIImage(named: "user")
        }
        
        nameTF.text = userName
        surnameTF.text = userSurname
        
        if let topView = topView {
            topView.layer.cornerRadius = 3
        }
        if let imageUser = imageUser {
            imageUser.layer.cornerRadius = 60
        }
       
        setupTF()
        setupLabelLocalizable()
        
    }
    

    
    //MARK: - IBAction
    @IBAction func saveTapedUserInfo(_ sender: Any) {
        DispatchQueue.main.async {
            self.user.name = self.userName
            self.user.surname = self.userSurname
            if let selectedImageProfile = self.imageUser.image {
                self.user.image = selectedImageProfile.pngData()
            }
            self.delegateAction.done(source: self, data: self.user)
        }
    }
    

    //MARK: - Func
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupLabelLocalizable() {
        saveButton.setTitle("Save", for: .normal)
        nameTF.placeholder =  "Name"
        surnameTF.placeholder = "Surname"

    }

    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
          
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
     
        if let name = nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           !name.isEmpty,
         let surname = surnameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines),
         !surname.isEmpty {
            saveUserInfo.isHidden = false
            userName = name
            userSurname = surname
        }
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
       
        if let name = nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           !name.isEmpty,
         let surname = surnameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines),
         !surname.isEmpty {
            saveUserInfo.isHidden = false
            userName = name
            userSurname = surname
        }
        
        return true
    }
    

    // проверяет пустое ли значение, с учетом удаления пробелов и перевода каретки
    func isEmptyTrim(_ str:String?) -> Bool{
        if let value = str?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty{
            return false // значит не пусто
        }else{
            return true
        }
    }
    
    func setupTF() {
        
        nameTF.backgroundColor = .clear
        nameTF.tintColor = .white
        nameTF.textColor = .white
        nameTF.attributedPlaceholder = NSAttributedString(string: nameTF.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1.0 , alpha: 0.6)])
        let bottomLayeremailTF = CALayer()
        bottomLayeremailTF.frame = CGRect(x: 0, y: 29, width: 200, height: 0.6)
        bottomLayeremailTF.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1).cgColor
        nameTF.layer.addSublayer(bottomLayeremailTF)
        nameTF.delegate = self
        
        surnameTF.backgroundColor = .clear
        surnameTF.tintColor = .white
        surnameTF.textColor = .white
        surnameTF.attributedPlaceholder = NSAttributedString(string: surnameTF.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1.0 , alpha: 0.6)])
        let bottomLayerpassWordTF = CALayer()
        bottomLayerpassWordTF.frame = CGRect(x: 0, y: 29, width: 200, height: 0.6)
        bottomLayerpassWordTF.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1).cgColor
        surnameTF.layer.addSublayer(bottomLayerpassWordTF)
        surnameTF.delegate = self
        
    }
    
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        
    }
    
    @objc func kbWillShow(_ notification: Notification) {
        UIView.animate(withDuration: 0.3, animations: {
            self.moveView(state: .full)
        })
    }
    @objc func kbWillHide() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.moveView(state: .partial)
            })
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.moveView(state: .partial)
            })
        }
        
        
    }
    
    private func moveView(state: State) {
        let yPosition = state == .partial ? Constant.partialViewYPosition : Constant.fullViewYPosition
        view.frame = CGRect(x: 0, y: yPosition, width: view.frame.width, height: view.frame.height)
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {

                self.dismiss(animated: true, completion: nil)
               
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
                
            }
            
        }
        
        
    }
    
    @objc func handleTapContainerView3() {
        print("handleTapContainerView3")
    }
    
    // Func Profile user image
   @objc func handleProfileImageuser() {
       
       let photoSourceRequestController = UIAlertController(title: " ", message:NSLocalizedString( "Choose your photo source", comment:  "Choose your photo source"), preferredStyle: .actionSheet)
       
       let cameraAction = UIAlertAction(title: NSLocalizedString( "Camera", comment: "Camera"), style: .default, handler: { (action) in
           if UIImagePickerController.isSourceTypeAvailable(.camera) {
               let imagePicker = UIImagePickerController()
               imagePicker.allowsEditing = true
               imagePicker.sourceType = .camera
               imagePicker.delegate = self
               
               self.present(imagePicker, animated: true, completion: nil)
           }
       })
       
       let photoLibraryAction = UIAlertAction(title: NSLocalizedString( "Photo library", comment:  "Photo library"), style: .default, handler: { (action) in
           if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
               let imagePicker = UIImagePickerController()
               imagePicker.allowsEditing = true
               imagePicker.sourceType = .photoLibrary
               imagePicker.delegate = self
               
               self.present(imagePicker, animated: true, completion: nil)
           }
       })
       
       let cancelAction = UIAlertAction(title:  NSLocalizedString( "Cancel", comment:  "Cancel"), style: .cancel, handler: nil)
       
       photoSourceRequestController.addAction(cameraAction)
       photoSourceRequestController.addAction(photoLibraryAction)
       photoSourceRequestController.addAction(cancelAction)
       
       present(photoSourceRequestController, animated: true, completion: nil)
   }

}

//MARK: - Extension

extension OverlayViewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.editedImage.rawValue)] as? UIImage {
            selectedImageProfile = selectedImage
            imageUser.image = selectedImage
           }
        if let oroginalImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
               selectedImageProfile = oroginalImage
               imageUser.image = oroginalImage
        }

        picker.dismiss(animated: true, completion: nil)
        
        if let selectedImageProfile = selectedImageProfile {
            user.image = selectedImageProfile.pngData()
        }
        delegateAction.done(source: self, data: user)
    }
    
  

}

//MARK: - Extension
extension OverlayViewViewController {
    private enum State {
        case partial
        case full
    }
    
    private enum Constant {
        static let fullViewYPosition: CGFloat = 240
        static var partialViewYPosition: CGFloat { UIScreen.main.bounds.height - 375 }
    }
}
