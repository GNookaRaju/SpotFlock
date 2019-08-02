//
//  AppHelper.swift
//  SpotFlock
//
//  Created by SpotFlock on 31/07/19.
//  Copyright © 2019 Spotflock. All rights reserved.
//

import UIKit

class AppHelper {
    static let APP_TITLE = "DemoProject"
    static let COLOR_ONE: UIColor =  UIColor(hexString: "#EC715D")
    static let COLOR_TWO: UIColor =  UIColor(hexString: "#395D73")
    static let COLOR_LIGHT_GRAY: UIColor =  UIColor(hexString: "#DDDDDD")
    
    static let SERVER_DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
    static let CLIENT_DATE_FORMAT_1 = "dd MMM"
    static let CLIENT_DATE_FORMAT_2 = "MMM dd, yyyy"
    static let CLIENT_DATE_FORMAT_3 = "yyyy-MM-dd"
}

/// View controllers related
extension AppHelper {
    
    class func topMostController() -> UIViewController {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        return topController!
    }
    
    class func showAlertOnRootViewController(title: String?, message: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            
            AppHelper.topMostController().present(alert, animated: true, completion: nil)
        }
    }
}


extension AppHelper {
    
    func getServerFullDate(serverDateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppHelper.SERVER_DATE_FORMAT
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let finalDate: Date! = dateFormatter.date(from: serverDateStr as String)
        return finalDate!
    }
    
    func convertDateToString(convertStr: NSString, currentDateFormat: NSString , convertFormat: NSString ) -> NSString
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentDateFormat as String
        let finalDate = dateFormatter.date(from: convertStr as String)
        dateFormatter.dateFormat = convertFormat as String
        let dateString = dateFormatter.string(from: finalDate!)
        return dateString as NSString
    }
    
    func convertDateToString(convertDate: Date, currentDateFormat: NSString , convertFormat: NSString ) -> NSString
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentDateFormat as String
        var finalDateStr = dateFormatter.string(from: convertDate as Date)
        finalDateStr = finalDateStr + "T00:00:00.000Z"
        dateFormatter.dateFormat = convertFormat as String
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        let finalDate = dateFormatter.date(from: finalDateStr as String)
        if let _: Date = finalDate {
            let dateString = dateFormatter.string(from: finalDate!)
            return dateString as NSString
        }
        return ""
    }
    
    func phoneNumberFormatter(_ text: String?, _ range: NSRange, _ string: String) -> (String, Bool) {
        let newString = (text! as NSString).replacingCharacters(in: range, with: string)
        let digitsString = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        let decimalString = digitsString.joined(separator: "") as NSString
        let length = decimalString.length
        let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
        if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
            let newLength = (text! as NSString).length + (string as NSString).length - range.length as Int
            return (newLength > 10) ? (text!, false) : (text!, true)
        }
        var index = 0 as Int
        let formattedString = NSMutableString()
        if hasLeadingOne {
            formattedString.append("1")
            index += 1
        }
        if (length - index) > 3 {
            let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("%@-", areaCode)
            index += 3
        }
        if length - index > 3 {
            let prefix = decimalString.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("%@-", prefix)
            index += 3
        }
        let remainder = decimalString.substring(from: index)
        formattedString.append(remainder)
        let finalText = formattedString as String
        return (finalText, false)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}

extension AppHelper {
    
    func printJSONObject(data: Data) {
        do {
            let json = try? JSONSerialization.jsonObject(with: data, options : .allowFragments)
            dump(json)
        }
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}









