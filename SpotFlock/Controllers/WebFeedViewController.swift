//
//  WebFeedViewController.swift
//  SpotFlock
//
//  Created by Nuviso Infore on 31/07/19.
//  Copyright © 2019 Spotflock. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class WebFeedViewController: UIViewController {

    @IBOutlet weak var wkWebView: WKWebView!
    var jsContext: JSContext!
    var jsVirtualMachine: JSVirtualMachine!

    var feedsList: [Feed]!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        title = "Web UI"
        
        loadWebPage()//Loading web page
        
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
                        self!.parseNewsFeedData()
                    }
                }
                appDelegate.hideProgressBar()
            }
        } else {
            self.view.makeToast(message: NSLocalizedString("No internet connection", comment: ""), fadeIn: Constants.ToastFadeDuration, duration: 2, position: .center, backgroundColor: AppHelper.COLOR_TWO, messageColor: UIColor.white, font: UIFont.systemFont(ofSize: 14))
        }
    }
    
    func loadWebPage() -> Void {
        initializeJS()
    }
    
    func initializeJS() {
        jsVirtualMachine = JSVirtualMachine()
        self.jsContext = JSContext(virtualMachine: jsVirtualMachine)
        
        // Add an exception handler.
        self.jsContext.exceptionHandler = { context, exception in
            if let exc = exception {
                print("JS Exception:", exc.toString())
            }
        }

        self.jsContext.setObject(Feed.self, forKeyedSubscript: "Feed" as (NSCopying & NSObjectProtocol)!)
        
        self.jsContext.setObject(FeedDrawable.self, forKeyedSubscript: "FeedDrawable" as (NSCopying & NSObjectProtocol)!)

        // Set the DeviceInfo class to the JSContext.
        
//        self.jsContext.setObject(FeedDrawable.self, forKeyedSubscript: "FeedDrawable" as (NSCopying & NSObjectProtocol)!)
        
        let addToView_script: @convention(block) (JSValue) -> Void = { value in
            let drawableValue: JSManagedValue = JSManagedValue(value: value)
            let dic = drawableValue.value.toObject() as! FeedDrawable
            let drawable = FeedDrawable(script: dic.script)
            drawable.webView.frame = self.wkWebView.frame
            self.jsContext.virtualMachine.addManagedReference(drawable, withOwner: self.wkWebView)
            self.wkWebView.addSubview(drawable.webView)
//            self.jsContext.virtualMachine.removeManagedReference(drawable, withOwner: self.wkWebView)
        }
        
        self.jsContext.setObject(unsafeBitCast(addToView_script, to: AnyObject.self), forKeyedSubscript: "addToView" as NSCopying & NSObjectProtocol)
        
        // Load the PapaParse library.
        if let papaParsePath = Bundle.main.path(forResource: "News", ofType: "js") {
            do {
                let papaParseContents = try String(contentsOfFile: papaParsePath)
                self.jsContext.evaluateScript(papaParseContents)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        
        let gettingLocalNews = self.jsContext.objectForKeyedSubscript("loadLocalData();")
        if let _ = gettingLocalNews?.call(withArguments: []) {
        }
        
        
    }
    
    
    func parseNewsFeedData() {
        if let newsList: [Feed] = self.feedsList {
            let jsonData = try! JSONEncoder().encode(newsList)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            do {
                if let parseNewsList = self.jsContext.objectForKeyedSubscript("loadNewsData();") {
                    if let parsedFeedData = parseNewsList.call(withArguments: [jsonString]).toArray() as? [Feed] {
                        print("Json parsed: \(parsedFeedData)")
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
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

    

    /*
    private func loadContentFromResources(){
        
        if let htmlPath = Bundle.main.path(forResource: "main", ofType: "html"){
            
            do{
                let contents =  try String(contentsOfFile: htmlPath, encoding: .utf8)
                let baseUrl = URL(fileURLWithPath: htmlPath)
                wkWebView.loadHTMLString(contents, baseURL: baseUrl)
            }catch{
                print("Error")
            }
            
        }
    }
    
    // MARK: JS CALLS
    @IBAction func executeJS(){
        evaluateWithJavaScriptExpression(jsExpression: "loadNewsData();")//Execute js scripts
    }
    
    fileprivate func evaluateWithJavaScriptExpression(jsExpression: String) {
        
        wkWebView.evaluateJavaScript(jsExpression, completionHandler: {(_, error) in
            if((error) != nil) {
                print(error?.localizedDescription ?? "")
            } else {
                
            }
        })
    }
     */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension WebFeedViewController: WKNavigationDelegate, WKUIDelegate {
    
    // MARK: Webview Navigation Delegates
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        
        switch navigationAction.navigationType {
        case .linkActivated:
            // Navigate to any internal links clicked
            wkWebView.load(navigationAction.request)
        case .reload:
            print("reloaded")
        default:
            break
        }
        decisionHandler(.allow)
    }
    // Handle alert
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void){
        
        let alertController = UIAlertController(title: message, message: nil,
                                                preferredStyle: .alert);
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel) {
            _ in completionHandler()}
        );
        
        self.present(alertController, animated: true, completion: {});
    }
}
