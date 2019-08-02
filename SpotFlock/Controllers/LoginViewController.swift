//
//  LoginViewController.swift
//  SpotFlock
//
//  Created by SpotFlock on 30/07/19.
//  Copyright © 2019 Spotflock. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class LoginViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!

    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var emailTF: SFTextField!
    
    @IBOutlet weak var pwdTF: SFTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let email: String = KeychainWrapper.standard.string(forKey: "email") ?? ""
        let userPassword: String = KeychainWrapper.standard.string(forKey: "password") ?? ""
        if email.count > 0 && userPassword.count > 0 {
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.showProgressBar()
            let apiCntrl = APIController.sharedInstance
            apiCntrl.login(userEmail: email, userPassword: userPassword) { (status, response) in
                if status {
                    if let responseDetails: ResponseDetails = response as? ResponseDetails {
                        if responseDetails.status ?? "" == "true" {
                            DispatchQueue.main.async { [weak self] in
                                self!.view.makeToast(message: NSLocalizedString("Succefully login in", comment: ""), fadeIn: Constants.ToastFadeDuration, duration: 1, position: .center, backgroundColor: AppHelper.COLOR_TWO, messageColor: UIColor.white, font: UIFont.systemFont(ofSize: 14))
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                    // Put your code which should be executed with a delay here
                                    let dashboardVC: DashboardViewController = DashboardViewController.create() as! DashboardViewController
                                    self!.navigationController?.pushViewController(dashboardVC, animated: true)
                                })
                            }
                        } else if let msg = responseDetails.message {
                            DispatchQueue.main.async { [weak self] in
                                self!.view.makeToast(message: NSLocalizedString(msg, comment: ""), fadeIn: Constants.ToastFadeDuration, duration: 2, position: .center, backgroundColor: AppHelper.COLOR_TWO, messageColor: UIColor.white, font: UIFont.systemFont(ofSize: 14))
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
                        self!.view.makeToast(message: NSLocalizedString("Failed", comment: ""), fadeIn: Constants.ToastFadeDuration, duration: 2, position: .center, backgroundColor: AppHelper.COLOR_TWO, messageColor: UIColor.white, font: UIFont.systemFont(ofSize: 14))
                    }
                }
                appDelegate.hideProgressBar()
            }
        }

        
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
//        emailTF.placeholder = NSLocalizedString("Email", comment: "")
//        pwdTF.placeholder = NSLocalizedString("Password", comment: "")

        self.hideKeyboardWhenTappedAround()

    }
    
    @IBAction func clickToLogin(_ sender: Any) {
        let emailStr = emailTF.text ?? ""
        let pwdStr = pwdTF.text ?? ""

        //Local validations are commented below
//        if emailStr.isEmpty {
//            emailTF.showErrorMessage(NSLocalizedString("Please provide your email", comment: ""))
//            return
//        }
        
//        if !AppHelper().isValidEmail(testStr: emailStr) {
//            emailTF.showErrorMessage(NSLocalizedString("Please enter a valid e-mail ID", comment: ""))
//            return
//        }
        
//        if pwdStr.isEmpty {
//            pwdTF.showErrorMessage(NSLocalizedString("Please provide your password", comment: ""))
//            return
//        }
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.startConnectivityChecks()
        if appDelegate.isNetworkEnable {
            appDelegate.showProgressBar()
            let apiCntrl = APIController.sharedInstance
            apiCntrl.login(userEmail: emailStr, userPassword: pwdStr) { (status, response) in
                if status {
                    if let responseDetails: ResponseDetails = response as? ResponseDetails {
                        if responseDetails.status ?? "" == "true" {
                            DispatchQueue.main.async { [weak self] in
                                self!.view.makeToast(message: NSLocalizedString("Succefully login in", comment: ""), fadeIn: Constants.ToastFadeDuration, duration: 1, position: .center, backgroundColor: AppHelper.COLOR_TWO, messageColor: UIColor.white, font: UIFont.systemFont(ofSize: 14))
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                    // Put your code which should be executed with a delay here
                                    let dashboardVC: DashboardViewController = DashboardViewController.create() as! DashboardViewController
                                    self!.navigationController?.pushViewController(dashboardVC, animated: true)
                                })
                            }
                        } else if let msg = responseDetails.message {
                            DispatchQueue.main.async { [weak self] in
                                if msg == "Authentication Failed" {
                                    self!.pwdTF.showErrorMessage(NSLocalizedString("Please provide correct password", comment: ""))
                                }
                                self!.view.makeToast(message: NSLocalizedString(msg, comment: ""), fadeIn: Constants.ToastFadeDuration, duration: 2, position: .center, backgroundColor: AppHelper.COLOR_TWO, messageColor: UIColor.white, font: UIFont.systemFont(ofSize: 14))
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
                        self!.view.makeToast(message: NSLocalizedString("Failed", comment: ""), fadeIn: Constants.ToastFadeDuration, duration: 2, position: .center, backgroundColor: AppHelper.COLOR_TWO, messageColor: UIColor.white, font: UIFont.systemFont(ofSize: 14))
                    }
                }
                appDelegate.hideProgressBar()
            }
        } else {
            self.view.makeToast(message: NSLocalizedString("No internet connection", comment: ""), fadeIn: Constants.ToastFadeDuration, duration: 2, position: .center, backgroundColor: AppHelper.COLOR_TWO, messageColor: UIColor.white, font: UIFont.systemFont(ofSize: 14))
        }
    }    
    
    @IBAction func clickToRegister(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let registerVC = storyBoard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterViewController
        self.navigationController?.pushViewController(registerVC, animated: true)
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
