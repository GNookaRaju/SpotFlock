//
//  NativeFeedViewController.swift
//  SpotFlock
//
//  Created by Nuviso Infore on 31/07/19.
//  Copyright © 2019 Spotflock. All rights reserved.
//

import UIKit

class NativeFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var feedsList: [Feed]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        title = "Native UI"

        self.tableView.register(UINib(nibName: "NewsFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "newsfeedCell")
        
        let backBtn = UIBarButtonItem(title: NSLocalizedString("Back", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = backBtn
        
        let logoutBtn = UIBarButtonItem(title: NSLocalizedString("Logout", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(didTapLogoutButton))
        navigationItem.rightBarButtonItem = logoutBtn
        
        self.feedsList = []
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.startConnectivityChecks()
        if appDelegate.isNetworkEnable {
            appDelegate.showProgressBar()
            let apiCntrl = APIController.sharedInstance
            apiCntrl.gettingNewsFeedList { (response) in
                if let feeds: [Feed] = response as? [Feed] {
                    DispatchQueue.main.async { [weak self] in
                        self!.feedsList = feeds
                        self!.tableView.reloadData()
                    }
                }
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
    
    @objc func didTapBackButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    


    // MARK: - TableView
    public func numberOfSections(in tableView: UITableView) -> Int {
        if let feeds: [Feed] = self.feedsList {
            return feeds.count
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    // create a cell for each table view row
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell: NewsFeedTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "newsfeedCell") as! NewsFeedTableViewCell
        if let feed: Feed = self.feedsList[indexPath.section] {
            cell.titleLbl.text = feed.title
        }
        return cell
    }
    
    // method to run when table view cell is tapped
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
