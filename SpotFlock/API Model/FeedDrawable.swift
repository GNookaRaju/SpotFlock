//
//  FeedDrawable.swift
//  SpotFlock
//
//  Created by Nuviso Infore on 01/08/19.
//  Copyright © 2019 Spotflock. All rights reserved.
//

import Foundation
import WebKit
import JavaScriptCore

@objc protocol FeedDrawableExport: JSExport {
    var script: String { get set }
}

@objc class FeedDrawable: NSObject, FeedDrawableExport {
    var webView: WKWebView!
    var config: WKWebViewConfiguration!
    var html: String!
    
    dynamic var script: String = ""
    
    init(script: String) {
        self.script = script
        self.config = WKWebViewConfiguration()
        let scriptContent = WKUserScript(source: self.script, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        self.config.userContentController.addUserScript(scriptContent)
        self.webView = WKWebView(frame: CGRect.zero, configuration: self.config)
        
        guard let html_path = Bundle.main.path(forResource: "mail", ofType: "html") else {
            self.html = """
            <!DOCTYPE html>
            <html>
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
            <meta charset="utf-8" />
            <meta name="description" content=""/>
            <script type="text/javascript" src="./News.js"></script>
            
            <body>
            <h1> Welcome </h1>
            <div id="NewsFeed-list">
            </div>
            </body>
            </html>
            """
            self.webView.loadHTMLString(self.html, baseURL: nil)
            self.webView.evaluateJavaScript("loadLocalData();", completionHandler: {(_, error) in
                if((error) != nil) {
                    print(error?.localizedDescription ?? "")
                } else {
                    
                }
            })

            return
        }
        self.html = html_path
        
        self.webView.loadHTMLString(self.html, baseURL: nil)
        
        self.webView.evaluateJavaScript("loadLocalData();", completionHandler: {(_, error) in
            if((error) != nil) {
                print(error?.localizedDescription ?? "")
            } else {
                
            }
        })

    }
}
