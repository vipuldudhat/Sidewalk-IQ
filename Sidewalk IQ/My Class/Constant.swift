
     // = = = = = = = = = = = = = = = = = = = = = = = = = = = = = //
    //                                                           //
   //  📍 Created by Vipul Dudhat on 06/10/15. 📌               //
  //  📍 Copyright © 2015 Vipul Dudhat. All rights reserved. 📌//
 //                                                           //
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = //

import UIKit


// FIXME: VHcompany
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

import MBProgressHUD
//import SDWebImage


  // - - - - - - - - - - - - -
 // MARK:- 📍 Default URL. 📌
// - - - - - - - - - - - - -

let API_URL = "https://app.sidewalkiq.com/" //" http://ec2-34-224-218-24.compute-1.amazonaws.com:8000/"

let defaults = UserDefaults.standard
var HotCountDefault = 0
 var dayAry = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]

  // - - - - - - - - - - - - - - - -
 // MARK:- 📍 Constant Varialble 📌
// - - - - - - - - - - - - - - - -


var UUID = "BD8D648A-589C-40EB-A7C9-C625F631E1C7"

var Lat : Double = 0.0
var Long : Double = 0.0
var fontName = "Avenir"


  // - - - - - - - - - - - - - - - -
 // MARK:- 📍 App Database struct 📌
// - - - - - - - - - - - - - - - -


public enum LoginType : Int
{    case Dealer
    case admin
    
    
}
var Login_enum : LoginType!


func convertAryToString(Ary : [String]) -> String {
    
    let stringRepresentation = Ary.joined(separator: ",")
    return stringRepresentation
}

// - - - - - - - - - - - - - -
 // MARK:- 📍 App Main Color 📌
// - - - - - - - - - - - - - -


//let appHeaderColor = UIColor(red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)

 //UIColor(red: 22.0/255.0, green: 171.0/255.0, blue: 204.0/255.0, alpha: 1.0)

//
//let appRedColor = UIColor(red: 228/255.0, green: 94/255.0, blue: 70/255.0, alpha: 1.0)
//let appGreyColor = UIColor(red: 39.0/255.0, green: 45.0/255.0, blue: 51.0/255.0, alpha: 1.0)
//
var animateDistance: CGFloat = 0.0


class MyView : UIView {
    override func draw(_ rect: CGRect) {
        let c = UIGraphicsGetCurrentContext()
        c?.strokePath()
    }
}


func aryToJson(ary:Any) -> String {
    
    var jsonStr = ""
    
    do {
        
        let requestData2 = try JSONSerialization.data(withJSONObject: ary, options: .prettyPrinted)
        
        jsonStr = NSString(data: requestData2, encoding: String.Encoding.utf8.rawValue)! as String
        
    }
    catch{
        
        print("catch")
    }
    
    print(jsonStr)
    
    return jsonStr
}


// - - - - - - - - - - - - -
// MARK:- 📍 Extension - Int
// - - - - - - - - - - - - -

extension Int {

    func get_big_color_CardName()->String{
    
        return "big_color_card_\(self).png"
    }
    func get_small_color_CardName()->String{
        
        return "small_color_card_\(self)"
    }
}

// - - - - - - - - - - - - -
// MARK:- 📍 Extension - Double
// - - - - - - - - - - - - -

extension Double {
    
    // Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    
    var VHcal : String {
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        
        currencyFormatter.locale = Locale.current
        let decimalString = currencyFormatter.string(from: NSNumber(value: self))
        var priceString = decimalString?.dropLast.dropLast.dropLast
        
        if (decimalString!.contains(".")) == true {
            
            let lastvalue = decimalString?.components(separatedBy: ".")
    
                if lastvalue?[1] != "00" {
    
                    if priceString!.characters.first == "-" {
                        
                        priceString = String(priceString!.characters.dropFirst().dropFirst())
                        priceString = "-\(priceString!)"
                        
                    }
                    else {
                        
                        priceString = String(decimalString!.characters.dropFirst())
                    }
                    
                    
                }
                else {
    
                    if priceString!.characters.first == "-" {
                        
                        priceString = String(priceString!.characters.dropFirst().dropFirst())
                        priceString = "-\(priceString!)"
                        
                    }
                    else {
                        
                        priceString = String(priceString!.characters.dropFirst())
                    }
                    
                }
                
            }
            else {
                
                
            }
        
        
        return priceString!
    }
    
    
    var VHmoney : String {
        
        var finalAmount = "\(Int(self.roundTo(places:2)))"
        
        if setting_money_lbl.shorten! {
            
            finalAmount = "\(self.formatUsingAbbrevation())"
            
        }
       if setting_money_lbl.seprator! && !setting_money_lbl.shorten!{
            
            finalAmount = "\(self.VHamount)"
        }
        
        if setting_money_lbl.decimal! && !setting_money_lbl.shorten! {
            
            if setting_money_lbl.seprator! {
                
                finalAmount = "\(self.roundTo(places:2).VHamount)"
            }
            else {
                
                finalAmount = "\(self.roundTo(places:2))"
            }
            
            
        }
        
//        if setting_money_lbl.show_currency! {
//
//            finalAmount = "\(currency_symbol) \(finalAmount)"
//        }
//
//
        
        return  finalAmount
    }
    
    var VHamount : String {
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        
        currencyFormatter.locale = Locale.current
        
        if !setting_money_lbl.localsep {
            
            currencyFormatter.locale = Locale(identifier: "it")
        }
        
        
        let decimalString = currencyFormatter.string(from: NSNumber(value: self))
        var priceString = decimalString?.dropLast.dropLast.dropLast
        
        if setting_money_lbl.decimal! {
            
            priceString = String(decimalString!.characters.dropFirst())
            
            if !setting_money_lbl.localsep {
                
                priceString = String((decimalString!.dropLast))
            }
        }
        
        
        if !setting_money_lbl.localsep && !setting_money_lbl.decimal! {
            
            priceString = priceString!
        }
        else if setting_money_lbl.localsep! && !setting_money_lbl.decimal! {
            
            if priceString!.characters.first == "-" {
                
                priceString = String(priceString!.characters.dropFirst().dropFirst())
                priceString = "-\(priceString!)"
                
            }
            else {
                priceString = String(priceString!.characters.dropFirst())
            }
            
        }
        
        
       return priceString!
        
    }
    
    
    func formatUsingAbbrevation () -> String {
        let numFormatter = NumberFormatter()
        
        typealias Abbrevation = (threshold:Double, divisor:Double, suffix:String)
        let abbreviations:[Abbrevation] = [(0, 1, ""),
                                           (1000.0, 1000.0, "K"),
                                           (100_000.0, 1_000_000.0, "M"),
                                           (100_000_000.0, 1_000_000_000.0, "B")]
        // you can add more !
        let startValue = Double (abs(self))
        let abbreviation:Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if (startValue < tmpAbbreviation.threshold) {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        } ()
        
        let value = Double(self) / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1
        
        return numFormatter.string(from: NSNumber (value:value))!
    }
    
    
}
//func GetHashValueFromAry(Ary: [Int])-> String{
//    
//    let hashids_master = Hashids(salt: "slideit")
//    let hash = hashids_master.encode(Ary)
//    
//    return "\(hash!)"
//    
//}







func convertDateFromTime(timestamp : String) -> Date {
    
    let timestamp = timestamp
    var interval:Double = 0
    
    let parts = timestamp.components(separatedBy: ":")
    for (index, part) in parts.reversed().enumerated() {
        interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
    }
    
    let date = Date(timeIntervalSince1970: interval)
    
    return date
    
}


// - - - - - - - - - - - - -
// MARK:- 📍 Extension - UILabel
// - - - - - - - - - - - - -

extension UILabel {
    
    func copyLBL(_ sp_lbl:UILabel) {
        
        self.frame = sp_lbl.frame
        self.textColor = sp_lbl.textColor
        self.font = sp_lbl.font
        self.textAlignment = sp_lbl.textAlignment
        self.backgroundColor = sp_lbl.backgroundColor
        self.numberOfLines = sp_lbl.numberOfLines
        self.lineBreakMode = sp_lbl.lineBreakMode
        
    }
}


// - - - - - - - - - - - - -
// MARK:- 📍 Extension - Date
// - - - - - - - - - - - - -

extension Date {
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
    
    
    
    func GetWeekRange() -> (Date,Date) {
        let cal = Calendar.current
        
        var comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: self)
        comps.weekday = 2 // Monday
        let mondayInWeek = cal.date(from: comps)!
        
        return (mondayInWeek,mondayInWeek.GetDateFrom(day: 6,datecomponent: .day))
    }
    
    func GetDateFrom(day : Int , datecomponent : Calendar.Component) -> Date {
        
         let newdate = NSCalendar.current.date(byAdding: datecomponent, value: day, to: self)
        
        return newdate!
    }
    
    func getComponent(index : Int) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE d MMMM yyyy Q"
        let datestring = dateFormatter.string(from: self)
        let dateary = datestring.components(separatedBy: " ")
        return dateary[index]
    }
    
    func startOfDayOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func startOfYear() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfYear() -> Date {
        return Calendar.current.date(byAdding: DateComponents(year: 1, day: -1), to: self.startOfYear())!
    }
    
    
    func combineDateWithTime(time: Date) -> Date {
        let calendar = Calendar.current as NSCalendar
        
        let dateComponents = calendar.components([.year, .month, .day], from: self)
        let timeComponents = calendar.components([.hour, .minute, .second], from: time as Date)
        
        var mergedComponments = DateComponents()
        
        mergedComponments.year = dateComponents.year!
        mergedComponments.month = dateComponents.month!
        mergedComponments.day = dateComponents.day!
        mergedComponments.hour = timeComponents.hour!
        mergedComponments.minute = timeComponents.minute!
        mergedComponments.second = timeComponents.second!
        
        return calendar.date(from: mergedComponments)!
    }
    
    var Timestamp: String {
        
        let timesp = self.timeIntervalSince1970
        
        let strNs = NSString(format: "%.f", timesp)
        
        return "\(strNs)"
    }
    
    func dateToString()-> String {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss" 
        let dateString = dateFormatter.string(from: self)
        
        return dateString
    }
    
    func yearsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year!
    }
    func monthsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    func weeksFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    func daysFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    func hoursFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    func minutesFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    func secondsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }
    func offsetFrom(_ date:Date) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date)) year"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date)) month"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date)) week"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date)) day"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date)) hour"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date)) min" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date)) second" }
        if secondsFrom(date) == 0 { return "Just now" }
      
        
        return ""
    }
    
    
    func off_Nub_unit_setFrom(_ date:Date) -> (Int,String) {
        if yearsFrom(date)   > 0 { return (yearsFrom(date), "year")   }
        if monthsFrom(date)  > 0 { return (monthsFrom(date), "month")  }
        if weeksFrom(date)   > 0 { return (weeksFrom(date), "week")   }
        if daysFrom(date)    > 0 { return (daysFrom(date), "day")    }
        if hoursFrom(date)   > 0 { return (hoursFrom(date), "hour")   }
        if minutesFrom(date) > 0 { return (minutesFrom(date), "min") }
        if secondsFrom(date) > 0 { return (secondsFrom(date), "second") }
        
        
        return (0,"")
    }
}





  // - - - - - - - - - - - - - - - - - -
 // MARK:- 📍 Extension - UITextField 📌
// - - - - - - - - - - - - - - - - - -

extension UITextField {
    
    func setPlaceHolderWhite() {
        
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
                                                        attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    
    func setPlaceHolderWithColor(_ color:UIColor) {
        
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
                                                        attributes:[NSAttributedStringKey.foregroundColor: color])
    }
    
    func copyT1T2(T2 : UITextField) {
        
        self.frame = T2.frame
        self.placeholder = T2.placeholder
        self.layer.cornerRadius = T2.layer.cornerRadius
        self.font = T2.font
        self.layer.borderColor = T2.layer.borderColor
        self.layer.borderWidth = T2.layer.borderWidth
        self.textAlignment = T2.textAlignment
        self.textColor = T2.textColor
        self.delegate = T2.delegate
        self.keyboardType = T2.keyboardType
        
        
    }
    
}
extension UITextField : UITextFieldDelegate {
    
    
    func setUnderLineDark(){
    
        let borderUser = CALayer()
        let widthUser = CGFloat(1.0)
        borderUser.borderColor = UIColor.lightGray.cgColor
        borderUser.frame = CGRect(x: 0, y: self.frame.size.height - widthUser, width:  self.frame.size.width, height: self.frame.size.height)
        
        borderUser.borderWidth = widthUser
        self.layer.addSublayer(borderUser)
        
        let lView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        self.leftView = lView
        self.leftViewMode = UITextFieldViewMode.always;
        
        self.autocorrectionType = UITextAutocorrectionType.no
    }
    func setUnderLineBack(){
        
        let borderUser = CALayer()
        let widthUser = CGFloat(0.5)
        borderUser.borderColor = UIColor.black.cgColor
        borderUser.frame = CGRect(x: 0, y: self.frame.size.height - widthUser, width:  self.frame.size.width, height: widthUser)
        
        borderUser.borderWidth = widthUser
        self.layer.addSublayer(borderUser)
        
//        let lView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
//        self.leftView = lView
//        self.leftViewMode = UITextFieldViewMode.always;
    }
    
    func setCorner(_ color:UIColor){
        
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 20.0
        
        let lView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        self.leftView = lView
         self.leftViewMode = UITextFieldViewMode.always;
    }
    
    func setColorBox(_ color:UIColor){
        
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
        
        let lView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        self.leftView = lView
        self.leftViewMode = UITextFieldViewMode.always;
    }
    func setColorWithCorner(_ color:UIColor){
        
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
        
        self.layer.cornerRadius = self.vHeight*0.5
    }
    
    
    func LeftIcon(tf_L_Icon setIName:String){
        
        
        let borderUser = CALayer()
        let widthUser = CGFloat(0.5)
        borderUser.borderColor = Appcolor.current_text_color.cgColor
        borderUser.frame = CGRect(x: 0, y: self.frame.size.height - widthUser, width:  self.frame.size.width, height: self.frame.size.height)
        
        borderUser.borderWidth = widthUser
        self.layer.addSublayer(borderUser)
        
        
        let lView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let setIV = UIImageView(image: UIImage(named: setIName))
        setIV.center = lView.center
        setIV.frame.origin.x = 0.0
        lView.addSubview(setIV)
        self.leftView = lView
        
        self.leftViewMode = UITextFieldViewMode.always;
    }
    func RightIcon(tf_R_Icon rIM:String){
        
        let setIVr = UIImageView()
        setIVr.frame = CGRect(x: self.XW - 30, y: self.YPOINT, width: 18, height: 18)
        setIVr.center.y = self.center.y
        setIVr.image = UIImage(named: rIM)
        setIVr.isUserInteractionEnabled = true
        self.superview?.addSubview(setIVr)
//        self.superview?.addSubview(self)
    }
}

  // - - - - - - - - - - - - - - - - - - - - -
 // MARK:- 📍 Extension - UIViewController 📌
// - - - - - - - - - - - - - - - - - - - -



extension UIViewController: UITextFieldDelegate {
    
    
    
}
extension UIViewController: UITextViewDelegate {
    
   
    
    
}



  // - - - - - - - - - - - - - - - - - - - -
 // MARK:- 📍 Extension - NSMutableData. 📌
// - - - - - - - - - - - - - - - - - - - -

extension NSMutableData {
    
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
    
}

func randomString(length: Int) -> String {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    
    var randomString = ""
    
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    
    return randomString
}

  // - - - - - - - - - - - - - - - - - -
 // MARK:- 📍 Struct - MoveKeyboard. 📌
// - - - - - - - - - - - - - - - - - -
struct MoveKeyboard {
    
    static let KEYBOARD_ANIMATION_DURATION : CGFloat = 0.3
    static let MINIMUM_SCROLL_FRACTION : CGFloat = 0.2;
    static let MAXIMUM_SCROLL_FRACTION : CGFloat = 1.0;
    static let PORTRAIT_KEYBOARD_HEIGHT : CGFloat = 216;
    static let LANDSCAPE_KEYBOARD_HEIGHT : CGFloat = 162;
}


struct Appcolor {
    
    static let green : UIColor = UIColor(red: 65.0/255.0, green: 117.0/255.0, blue: 5.0/255.0, alpha: 1.0)
    static let red : UIColor = UIColor(red: 208.0/255.0, green: 2.0/255.0, blue: 27.0/255.0, alpha: 1.0)
    static let loan_title_grey : UIColor = UIColor(red: 46.0/255.0, green: 47.0/255.0, blue: 48.0/255.0, alpha: 1.0)
    static let loan_date_grey : UIColor = UIColor(red: 106.0/255.0, green: 108.0/255.0, blue: 110.0/255.0, alpha: 1.0)
    static let loan_note_grey : UIColor = UIColor(red: 108.0/255.0, green: 111.0/255.0, blue: 115.0/255.0, alpha: 1.0)
    static let loan_date_install_grey : UIColor = UIColor(red: 82.0/255.0, green: 84.0/255.0, blue: 85.0/255.0, alpha: 1.0)
    static let current_text_color = UIColor(red: 22.0/255.0, green: 171.0/255.0, blue: 204.0/255.0, alpha: 0.7)
    static let cat_title_grey = UIColor(red: 112/255.0, green: 110/255.0, blue: 110/255.0, alpha: 1.0)
    static let overview_color = UIColor(red: 255/255.0, green: 237/255.0, blue: 154/255.0, alpha: 1.0)
    static let app_bg_color = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
}

struct VHkey {
    
    static let login : String = "login"
    static let ID : String = "ID"
    static let token : String = "token"
    static let sensor_id : String = "sensor_id"
    static let userName : String = "userName"
}

struct selectedDates {
    
    var start : Date!
    var end : Date!
    
    init(start : Date! , end: Date!) {
        
        self.start = start
        self.end = end
    }
}

struct filterOverView {
    
    var ie_id : String!
    var amount : Double!
    
    init(ie_id : String! , amount: Double!) {
        
        self.ie_id = ie_id
        self.amount = amount
    }
}

struct amountCal {
    
    var display : String!
    var process : Double!
    var first   : String!
    var second  : String!
    var coperator : String!
    var deciPoint : String!
    
    init(display : String! , process: Double!, first: String!, second: String!, coperator:String!, deciPoint:String!) {
        
        self.display = display
        self.process = process
        self.first = first
        self.second = second
        self.coperator = coperator
        self.deciPoint = deciPoint
    }
}

struct settingMoneyLBL {
    
    var shorten : Bool!
    var show_currency : Bool!
    var decimal : Bool!
    var seprator : Bool!
    var negstyle : Int!
    var localsep : Bool!
    
    
    init(shorten : Bool! , show_currency: Bool!,decimal: Bool!,seprator: Bool!,negstyle: Int!,localsep: Bool!) {
        
        self.shorten = shorten
        self.show_currency = show_currency
        self.decimal = decimal
        self.seprator = seprator
        self.negstyle = negstyle
        self.localsep = localsep
    }
}

var setting_money_lbl : settingMoneyLBL!

public enum VHNotification : String {
    
    case customRange
    case customRange_detail
    case customRange_chart
    case addbudget
    case EditHome
    case Edit3dcat
    case Edit3dacc
    case Del3dcat
    case Del3dacc
    case drpboxLogin
    case restoreData
     case transferMoney
}


  // - - - - - - - - - - - - - - - - -
 // MARK:- 📍 Functions for The App 📌
// - - - - - - - - - - - - - - - - -

func AttribWhiteAndUnderLine(_ lblStrin:String)-> NSAttributedString {
    
    let myMutableString = NSMutableAttributedString(string: lblStrin)
    
    myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange(location:0,length:myMutableString.length))
    
    myMutableString.addAttribute(NSAttributedStringKey.underlineStyle, value: 1, range: NSRange(location:0,length:myMutableString.length))
    
    
    
    return myMutableString
}

// - - - - - - - - - - - - - - -

func AttribWhite(_ lblStrin:String)-> NSAttributedString {
    
    let myMutableString = NSMutableAttributedString(string: lblStrin)
    
    myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange(location:0,length:myMutableString.length))
    
    
    return myMutableString
}

// - - - - - - - - - - - - - - -

// Email Validation Methods
func isValidEmail(_ emailString:String,cc:UIViewController) -> Bool {
    
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    
    let result = emailTest.evaluate(with: emailString)
    if !result {
    
        showAlertWithMsg("Please enter valid Email", cc: cc)
    }
    
    return result
}

// - - - - - - - - - - - - - - -

// Show Alert Message
func showAlertWithMsg(_ msg:String,cc:UIViewController) {
    
    let alert = UIAlertView(title: "", message: msg, delegate: cc, cancelButtonTitle: "ok")
    alert.show()
}

// validation function

func validationTextField(_ textFied:UITextField,msg:String,cc:UIViewController)-> Bool {

    if textFied.text == "" {
    
        showAlertWithMsg(msg, cc: cc)
        
        return false
    }
    return true
}

//text Validation

func isTextSame(text1:String, text2:String,cc:UIViewController)->Bool{

    if text1 != text2 {
    
        showAlertWithMsg("Password not match", cc: cc)
        return false
    }
    return true
}

  // - - - - - - -
 // MARK:- Search
// - - - - - - -
public enum SearchState : Int {
    
    case show
    case typing
    case zero
    case hide
}

public enum ComponentType : Int {

    case day
    case date
    case month
    case year
    case quarter
}






// - - - - - - - - - -
// MARK:- H U D
// - - - - - - - - - -
func hudProggess(_ view:UIView,Show:Bool){

    if Show {

        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.contentColor = UIColor.black
        hud.label.text = "Loading"

    }
    else{

        MBProgressHUD.hide(for: view, animated: true)
    }
}

func hudChecker(_ view:UIView)-> Bool{

    if MBProgressHUD.allHUDs(for: view).count == 0 {

        return false
    }

    return true
}

// - - - - - - - - - - - - - - -



  // - - - - - - - - - - - - - - - - - - - - -
 // MARK:- 📍 Add Other Constant data here 📌
// - - - - - - - - - - - - - - - - - - - - -





func getStartEnddate(date : String) -> (Date,Date) {
    
    let timestamp = date
    var interval:Double = 0
    
    let parts = timestamp.components(separatedBy: ":")
    for (index, part) in parts.reversed().enumerated() {
        interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
    }
    
    let date = Date(timeIntervalSince1970: interval)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
    
    
    let s_day = dateFormatter.string(from: date.startOfDay as Date)
    let e_day = dateFormatter.string(from: date.endOfDay!)
    
    let s_date = dateFormatter.date(from: s_day)
    let e_date = dateFormatter.date(from: e_day)
    
    return(s_date!,e_date!)
}



func getDirectoryPath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}




var Timestamp: String {
    
    let timesp = Date().timeIntervalSince1970 * 1000

    let strNs = NSString(format: "%.f", timesp)
    
    return "\(strNs)"
}

func makeBool(_ Value:Bool)->String{
    
    if Value {
        
        return "true"
    }
    return "false"
}
func stringBool(_ Value:String)->Bool{
    
    if Value == "true" {
        
        return true
    }
    return false
}


var randomNumber : String {

    let random = Int(arc4random_uniform(UInt32(123456789)))
    
    return "\(random)"
}

class VHTextField: UITextField {
//    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        
//        if action == #selector(NSObject.paste(_:)) {
//            return false
//        }
//        if action == #selector(NSObject.select(_:)) {
//            return false
//        }
//        if action == #selector(NSObject.selectAll(_:)) {
//            return false
//        }
//        if action == #selector(NSObject.cut(_:)) {
//            return false
//        }
//        
//        return super.canPerformAction(action, withSender: sender)
//    }
}
extension UITableView {

    func animateTable() {
        self.reloadData()
        
        let cells = self.visibleCells
        let tableHeight: CGFloat = self.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
                }, completion: nil)
            
            index += 1
        }
    }
}



func daysBetweenDates(startDate: Date, endDate: Date) -> Int
{
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day], from: startDate, to: endDate)
    return components.day!
}

func GetDiffForm(_ dateString : String) -> (Int, String)
{
    let dateformate = DateFormatter()
    dateformate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateformate.timeZone = TimeZone.current
    
    let date = Date()
    let sdate = dateformate.string(from: date)
    let todate = dateformate.date(from: sdate)
   
    let finaldate  = dateformate.date(from: dateString)!
    
//    print(finaldate)
//    print(todate!)
    
    let diff = finaldate.off_Nub_unit_setFrom(todate!)
    
    return diff
    
}

func GetDiffForm(_ dateMain : Date) -> (Int, String)
{
    let dateformate = DateFormatter()
    dateformate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateformate.timeZone = TimeZone.current
    
    
    let dateString = dateformate.string(from: dateMain)
    let finaldate  = dateformate.date(from: dateString)!
    
    let date = Date()
    let sdate = dateformate.string(from: date)
    let todate = dateformate.date(from: sdate)
    
    
    let diff = finaldate.off_Nub_unit_setFrom(todate!)
    
    return diff
    
}


func convertDateFormaterS(_ date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    
    guard let date = dateFormatter.date(from: date) else {
        assert(false, "no date from string")
        return ""
    }
    
    dateFormatter.dateFormat = "MMM dd, yyyy HH:mm a"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    let timeStamp = dateFormatter.string(from: date)
    
    return timeStamp
}


func shadoToText(text:String) -> NSAttributedString {
    
    
    let myShadow = NSShadow()
    myShadow.shadowBlurRadius = 2
    myShadow.shadowOffset = CGSize(width: 0, height: 2)
    myShadow.shadowColor = UIColor(red: 193.0/255.0, green: 193.0/255.0, blue: 193.0/255.0, alpha: 1.0)
    
    // Create an attribute from the shadow
    let myAttribute = [ NSAttributedStringKey.shadow: myShadow ]
    
    // Add the attribute to the string
    let myAttrString = NSAttributedString(string: text, attributes: myAttribute)
    
    return myAttrString
}

func convertTimetoDate(date : String) -> Date {
    
    let timestamp = date
    var interval:Double = 0
    
    let parts = timestamp.components(separatedBy: ":")
    for (index, part) in parts.reversed().enumerated() {
        interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
    }
    
    let date = Date(timeIntervalSince1970: interval)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
    let datestring = dateFormatter.string(from: date as Date)
    
    return dateFormatter.date(from: datestring)!
}

extension Sequence {
    public func myFilter( includeElement: (Self.Iterator.Element) throws -> Bool) rethrows -> [Self.Iterator.Element] {
        var array : [Self.Iterator.Element] = []
        for element in self {
            do {
                if try includeElement (element) {
                    array.append(element)
                }
            }
        }
        return array
    }
}
public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}







