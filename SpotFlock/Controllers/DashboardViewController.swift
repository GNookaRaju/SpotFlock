//
//  DashboardViewController.swift
//  SpotFlock
//
//  Created by Nuviso Infore on 31/07/19.
//  Copyright © 2019 Spotflock. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var roleLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!

    static func create() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        title = "Dashboard"
        
        let apiCntrl = APIController.sharedInstance
        self.nameLbl.text = apiCntrl.userInfo?.name ?? ""
        self.roleLbl.text = apiCntrl.userInfo?.userType ?? ""
        self.emailLbl.text = apiCntrl.userInfo?.email ?? ""
        
        let logoutBtn = UIBarButtonItem(title: NSLocalizedString("Logout", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(didTapLogoutButton))
        navigationItem.leftBarButtonItem = logoutBtn
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.startConnectivityChecks()
        if appDelegate.isNetworkEnable {
            appDelegate.showProgressBar()
            apiCntrl.gettingNewsFeedList { (response) in
                appDelegate.hideProgressBar()
            }
        } else {
            self.view.makeToast(message: NSLocalizedString("No internet connection", comment: ""), fadeIn: Constants.ToastFadeDuration, duration: 2, position: .center, backgroundColor: AppHelper.COLOR_TWO, messageColor: UIColor.white, font: UIFont.systemFont(ofSize: 14))
        }

    }
    
    @objc func didTapLogoutButton(_ sender: UIBarButtonItem) {
        let apiCntrl = APIController.sharedInstance
        apiCntrl.logoutApp()
        self.view.makeToast(message: NSLocalizedString("Succefully logout", comment: ""), fadeIn: Constants.ToastFadeDuration, duration: 1, position: .center, backgroundColor: AppHelper.COLOR_TWO, messageColor: UIColor.white, font: UIFont.systemFont(ofSize: 14))
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.navigationController?.popToRootViewController(animated: true)
        })
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
