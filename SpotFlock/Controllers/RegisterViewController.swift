//
//  RegisterViewController.swift
//  SpotFlock
//
//  Created by SpotFlock on 30/07/19.
//  Copyright © 2019 Spotflock. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registerBtn: UIButton!

    @IBOutlet weak var nameTF: SFTextField!
    
    @IBOutlet weak var emailTF: SFTextField!
    
    @IBOutlet weak var pwdTF: SFTextField!

    @IBOutlet weak var confirmPwdTF: SFTextField!
    
    @IBOutlet weak var mobileTF: SFTextField!
    
    @IBOutlet weak var maleButton: UIButton!
    
    @IBOutlet weak var femaleButton: UIButton!
    
    @IBOutlet weak var genderSelection: SFSelectionIcon!
    
    var genderSelect: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        title = "Register"
        
//        nameTF.placeholder = NSLocalizedString("Name", comment: "")
//        emailTF.placeholder = NSLocalizedString("Email", comment: "")
//        pwdTF.placeholder = NSLocalizedString("Password", comment: "")
//        confirmPwdTF.placeholder = NSLocalizedString("Password confirmation", comment: "")
//        mobileTF.placeholder = NSLocalizedString("Mobile", comment: "")
        
        maleButton.layer.borderWidth = 0.5
        femaleButton.layer.borderWidth = 0.5
        maleButton.layer.borderColor = UIColor.lightGray.cgColor
        femaleButton.layer.borderColor = UIColor.lightGray.cgColor
        
        genderSelection.selectionIconHeight = 30
        genderSelection.selectionIconWidth = 30
        genderSelection.pointerDirection = .vertical
        genderSelection.image = #imageLiteral(resourceName: "Male")
        genderSelection.initialButton(object: maleButton)

        maleButton.backgroundColor = AppHelper.COLOR_ONE
        femaleButton.backgroundColor = AppHelper.COLOR_LIGHT_GRAY

        genderSelect = "Male"
        
        let backBtn = UIBarButtonItem(title: NSLocalizedString("Back", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = backBtn
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func didTapBackButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func maleButtonAction(_ sender: UIButton) {
        maleButton.backgroundColor = AppHelper.COLOR_ONE
        femaleButton.backgroundColor = AppHelper.COLOR_LIGHT_GRAY
        genderSelection.image = #imageLiteral(resourceName: "Male")
        genderSelection.setSelection(object: sender)
        genderSelect = "Male"
    }
    
    @IBAction func femaleButtonAction(_ sender: UIButton) {
        maleButton.backgroundColor = AppHelper.COLOR_LIGHT_GRAY
        femaleButton.backgroundColor = AppHelper.COLOR_ONE
        genderSelection.image = #imageLiteral(resourceName: "Female")
        genderSelection.setSelection(object: sender)
        genderSelect = "Female"
    }
    
    @IBAction func clickToRegister(_ sender: Any) {
        let name = nameTF.text ?? ""
        let email = emailTF.text ?? ""
        let pwd = pwdTF.text ?? ""
        let confirmPwd = confirmPwdTF.text ?? ""
        let mobile = mobileTF.text ?? ""
        
        //Local validations are commented below
//        if name.isEmpty {
//            nameTF.showErrorMessage(NSLocalizedString("Please provide your name", comment: ""))
//            return
//        }
        
//        if email.isEmpty {
//            emailTF.showErrorMessage(NSLocalizedString("Please provide your email", comment: ""))
//            return
//        }
        
//        if !AppHelper().isValidEmail(testStr: email) {
//            emailTF.showErrorMessage(NSLocalizedString("Please enter a valid e-mail ID", comment: ""))
//            return
//        }
        
//        if pwd.isEmpty {
//            pwdTF.showErrorMessage(NSLocalizedString("Please provide your password", comment: ""))
//            return
//        }
        
//        if confirmPwd.isEmpty {
//            confirmPwdTF.showErrorMessage(NSLocalizedString("Please provide your confirmation password", comment: ""))
//            return
//        }
        
//        if pwd != confirmPwd {
//            confirmPwdTF.showErrorMessage(NSLocalizedString("doesn't match Password", comment: ""))
//            return
//        }
        
//        if mobile.isEmpty {
//            mobileTF.showErrorMessage(NSLocalizedString("Please provide your mobile number", comment: ""))
//            return
//        }
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.startConnectivityChecks()
        if appDelegate.isNetworkEnable {
            appDelegate.showProgressBar()
            let apiCntrl = APIController.sharedInstance

            let userData: [String: String] = ["name": name, "email": email, "password": pwd, "password_confirmation": confirmPwd, "mobile": mobile, "gender": genderSelect]
            apiCntrl.registerNewUser(userInfo: userData, completion: { (status, response) in
                if status {
                    DispatchQueue.main.async { [weak self] in
                        if let responseDetails: ResponseDetails = response as? ResponseDetails {
                            if responseDetails.success ?? false {
                                self!.view.makeToast(message: NSLocalizedString(responseDetails.message ?? "Succefully registered new user", comment: ""), fadeIn: Constants.ToastFadeDuration, duration: 2, position: .center, backgroundColor: AppHelper.COLOR_TWO, messageColor: UIColor.white, font: UIFont.systemFont(ofSize: 14))
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                                    // Put your code which should be executed with a delay here
                                    self!.navigationController?.popViewController(animated: true)
                                })
                            } else if let error: Errors = responseDetails.errors {
                                if let name: [String] = error.name {
                                    if name.count > 0 {
                                        self!.nameTF.showErrorMessage(NSLocalizedString(name[0], comment: ""))
                                    }
                                }
                                if let email: [String] = error.email {
                                    if email.count > 0 {
                                        self!.emailTF.showErrorMessage(NSLocalizedString(email[0], comment: ""))
                                    }
                                }
                                if let password: [String] = error.password {
                                    if password.count > 0 {
                                        self!.pwdTF.showErrorMessage(NSLocalizedString(password[0], comment: ""))
                                    }
                                }
                                if let mobile: [String] = error.mobile {
                                    if mobile.count > 0 {
                                        self!.mobileTF.showErrorMessage(NSLocalizedString(mobile[0], comment: ""))
                                    }
                                }
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
                        self!.view.makeToast(message: NSLocalizedString("Failed", comment: ""), fadeIn: Constants.ToastFadeDuration, duration: 2, position: .center, backgroundColor: AppHelper.COLOR_TWO, messageColor: UIColor.white, font: UIFont.systemFont(ofSize: 14))
                    }
                }
                appDelegate.hideProgressBar()
            })
        } else {
            self.view.makeToast(message: NSLocalizedString("No internet connection", comment: ""), fadeIn: Constants.ToastFadeDuration, duration: 1, position: .center, backgroundColor: AppHelper.COLOR_TWO, messageColor: UIColor.white, font: UIFont.systemFont(ofSize: 14))
        }
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
