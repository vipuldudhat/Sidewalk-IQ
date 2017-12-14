//
//  LoginVC.swift
//  Sidewalk IQ
//
//  Created by Himani Patel on 12/3/17.
//  Copyright © 2017 SCC INFOTECH LLP. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginVC: UIViewController,VIPNetworkDelegate {

    @IBOutlet weak var txt_email: UITextField!
 
    @IBOutlet weak var txt_password: UITextField!
    
    let vipClass = VIPNetwork()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vipClass.delegate = self
        
        txt_email.setPlaceHolderWhite()
        txt_password.setPlaceHolderWhite()
        
        setpadding(txt: txt_email)
        setpadding(txt: txt_password)
    }
    
    func setpadding(txt:UITextField) {
        
        txt.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txt.vHeight))
        txt.leftViewMode = .always
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        let nextTag: Int = textField.tag + 1
        
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        if (nextResponder != nil)  {
            nextResponder?.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
        
    }
    
    @IBAction func Click_SignIn(_ sender: UIButton) {
        
        if isValidEmail(txt_email.text!, cc: self) {
            
            if validationTextField(txt_password, msg: "Sorry,Invalid Password!! No 'space' or '&' allowed", cc: self) {
                
                hudProggess(self.view, Show: true)
                
                let param = [
                   
                    "email": "\(txt_email.text!)",
                    "password": "\(txt_password.text!)"
                   
                    ] as [String : Any]
                vipClass.Tag = 1
                vipClass.apiPOST(ApiLink: "account/login/", ApiParam: param as [String : AnyObject]?, headers: nil)
            }
        }
        else {
            
            showAlertWithMsg("Sorry,Invalid Email!!", cc: self)
        }
    }
    
    // - - - - - - - - - - - - - - - - - - - - - -
    // MARK: - Vipnetwork Delegate
    // - - - - - - - - - - - - - - - - - - - - - -
    
    func internetConnectionOffline() {
        
        hudProggess(self.view, Show: false)
        print("fail net")
    }
    
    
    func successResponseWithData(sJson: JSON) {
        
        hudProggess(self.view, Show: false)
        print(sJson)
        
        switch vipClass.Tag {
        case 1:
            let token = sJson["token"].stringValue
            let id = sJson["data"]["user"]["id"].intValue
            let fname = sJson["data"]["user"]["first_name"].stringValue
            let lname = sJson["data"]["user"]["last_name"].stringValue
            
            defaults.set(token, forKey: VHkey.token)
            defaults.set(1, forKey: VHkey.login)
            defaults.set(id, forKey: VHkey.ID)
            defaults.set("\(fname) \(lname)", forKey: VHkey.userName)
            
            let param = [
                
                "offset": 0,
                "user_id": id
                
                ] as [String : Any]
            let header = [
                
                "Authorization": "Token \(defaults.value(forKey: VHkey.token) as! String)"
                
                ] as [String : String]
            vipClass.Tag = 2
            vipClass.apiPOST(ApiLink: "core/getdeviceslist/", ApiParam: param as [String : AnyObject]?, headers: header)
            break
        case 2:
            (UIApplication.shared.delegate as! AppDelegate).loadStartupScreen()
            break
            
        default:
            
            break
        }
        
       
    
        
        
    }
    
    func failResponseWithError(error: NSError) {
        
        hudProggess(self.view, Show: false)
        print(error)
        showAlertWithMsg("Sorry! Username and Password didn't match, Please try again!", cc: self)
    }

   
}
