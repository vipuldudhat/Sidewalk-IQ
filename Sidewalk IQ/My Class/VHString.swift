//
//  VHString.swift
//  Buzzed
//
//  Created by vipul dudhat on 10/1/17.
//  Copyright © 2017 SCC INFOTECH LLP. All rights reserved.
//

import UIKit


  // - - - - - - - - - - - - -
 // MARK:- 📍 Extension - String
// - - - - - - - - - - - - -

extension String {
    
    
    var abrevationFormat : String {
        
        let numFormatter = NumberFormatter()
        
        typealias Abbrevation = (threshold:Double, divisor:Double, suffix:String)
        
        let abbreviations:[Abbrevation] = [(0, 1, ""),
                                           (1000.0, 1000.0, "K"),
                                           (100_000.0, 1_000_000.0, "M"),
                                           (100_000_000.0, 1_000_000_000.0, "B")]
        // you can add more !
        
        var result = self
        
        if self.contains("K") {
            
            result = self.replacingOccurrences(of: "K", with: "000")
            print(result)
        }
        else if self.contains("M") {
            
            result = self.replacingOccurrences(of: "M", with: "000000")
            print(result)
        }
        else if self.contains("B") {
            
            result = self.replacingOccurrences(of: "B", with: "000000000")
            print(result)
        }
        
        let numb = Double(result)
        let startValue = Double (abs(numb!))
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
        
        
        
        let value = Double(numb!) / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1
        
        return numFormatter.string(from: NSNumber (value:value))!
    }
    
    
    var dropLast : String {
        
        return String(self.characters.dropLast())
    }
    
    //white space remove
    
    func removeSpecialCharsFromString() -> String {
        
        let okayChars : Set<Character> = Set("0123456789.-".characters)
        
        return String(self.characters.filter {okayChars.contains($0) })
    }
   
    
    //white space remove
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    
    // get word array from text-line
    var words: [String] {
        var result:[String] = []
        enumerateSubstrings(in: startIndex..<endIndex, options: .byWords) {
            (substring, substringRange, enclosingRange, stop) -> () in
            result.append(substring!)
        }
        return result
    }
    
    // find word length
    var length: Int {
        return characters.count
    }
    
    
    
    var strikethroughStyle : NSMutableAttributedString {
        
        let myMutableString = NSMutableAttributedString(string: self)
        
        myMutableString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location:0,length:self.length))
        
        return myMutableString
    }
    
    
    
   
    var isAlphanumeric: Bool {
       
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var isPasswordAllow: Bool {
        
        if self == "" {
            
            return false
        }
        else if self.characters.contains(" ") {
            
            return false
        }
        else if self.characters.contains("&") {
            
            return false
        }
        else {
            
            return true
        }
    }
   
    
    
    //MARK: Helper method to convert the NSDate to NSDateComponents
    func dateComponentFromNSDate()-> DateComponents{
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let date = dateFormatter.date(from: self)
        
        let calendarUnit: NSCalendar.Unit = [.hour, .day, .month, .year]
        let dateComponents = (Calendar.current as NSCalendar).components(calendarUnit, from: date!)
        return dateComponents
    }
    
    
    func StringToDate(formate : String)-> Date {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = formate
        let date = dateFormatter.date(from: self)
        
        return date!
    }
    
    var timeToDate : Date {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: self)
        
       
        
        return date!
    }
    
    var filePath : String {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = URL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent(self).path
        
        return filePath
    }
    
    var PhonenumberValidation : Bool {
        
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    
    
    
    
    
}
