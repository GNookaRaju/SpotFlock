//
//  AppDelegate.swift
//  SpotFlock
//
//  Created by SpotFlock on 30/07/19.
//  Copyright © 2019 Spotflock. All rights reserved.
//

import UIKit
import Connectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    fileprivate let connectivity: Connectivity = Connectivity()
    var hideHudTimer: Timer?
    var isShowingActivity: Bool! = false
    var isNetworkEnable: Bool! = false



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.startHost()
        self.startConnectivityChecks()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - ProgressBar
    
    func showProgressBar() {
        if self.isShowingActivity == false {
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    self.isShowingActivity = true
                    if self.hideHudTimer?.isValid ?? false {
                        self.hideHudTimer?.invalidate()
                    }
                    self.hideHudTimer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(self.hideProgressBar), userInfo: nil, repeats: false)
                    
                    let window = UIApplication.shared.keyWindow!
                    window.makeToastActivity()
                }
            }
        }
    }
    
    @objc func hideProgressBar() {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.isShowingActivity = false
                if self.hideHudTimer?.isValid ?? false {
                    self.hideHudTimer?.invalidate()
                }
                let window = UIApplication.shared.keyWindow!
                window.hideToastActivity()
            }
        }
    }

    
    
    // MARK: - Network Connectivity
    
    func startHost() {
        connectivity.framework = .systemConfiguration
        performSingleConnectivityCheck()
        configureConnectivityNotifier()
    }
    
    func configureConnectivityNotifier() {
        let connectivityChanged: (Connectivity) -> Void = { [weak self] connectivity in
            self?.updateConnectionStatus(connectivity.status)
        }
        connectivity.whenConnected = connectivityChanged
        connectivity.whenDisconnected = connectivityChanged
    }
    
    func performSingleConnectivityCheck() {
        connectivity.checkConnectivity { connectivity in
            self.updateConnectionStatus(connectivity.status)
        }
    }
    
    func startConnectivityChecks() {
        connectivity.startNotifier()
    }
    
    func stopConnectivityChecks() {
        connectivity.stopNotifier()
        connectivity.startNotifier()
    }
    
    func updateConnectionStatus(_ status: Connectivity.Status) {
        switch status {
        case .connectedViaWiFi, .connectedViaCellular, .connected:
            isNetworkEnable = true
        case .connectedViaWiFiWithoutInternet, .connectedViaCellularWithoutInternet, .notConnected:
            isNetworkEnable = false
        }
    }

}

