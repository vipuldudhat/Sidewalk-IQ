//
//  RegisterVC.swift
//  Sidewalk IQ
//
//  Created by Himani Patel on 12/3/17.
//  Copyright © 2017 SCC INFOTECH LLP. All rights reserved.
//

import UIKit
import SwiftyJSON

class RegisterVC: UIViewController,VIPNetworkDelegate {

    @IBOutlet weak var txt_fname: UITextField!
   
    @IBOutlet weak var txt_lname: UITextField!
    
    @IBOutlet weak var txt_email: UITextField!
    
    @IBOutlet weak var txt_password: UITextField!
   
    @IBOutlet weak var txt_confirmPassword: UITextField!
    
    @IBOutlet weak var btn_signin: UIButton!
    
    @IBOutlet weak var scroll_content: UIScrollView!
  
     let vipClass = VIPNetwork()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vipClass.delegate = self
        
        scroll_content.contentSize.height = btn_signin.YH + 10
    
        setpadding(txt: txt_fname)
        setpadding(txt: txt_lname)
        setpadding(txt: txt_email)
        setpadding(txt: txt_password)
        setpadding(txt: txt_confirmPassword)
    }
    
    func setpadding(txt:UITextField) {
        
        txt.setPlaceHolderWhite()
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
    
    @IBAction func Click_Register(_ sender: UIButton) {
        
        if isValidEmail(txt_email.text!, cc: self) {
            
            if txt_fname.text!.isAlphanumeric {
                
                if txt_lname.text!.isAlphanumeric {
                    
                    if (txt_password.text!.isPasswordAllow)  {
                        
                        if txt_confirmPassword.text == txt_password.text {
                            
                            hudProggess(self.view, Show: true)
                            
                            let param = [
                                
                                "email": "\(txt_email.text!)",
                                "password": "\(txt_password.text!)",
                                "username": "\(txt_email.text!)",
                                "first_name": "\(txt_fname.text!)",
                                "last_name": "\(txt_lname.text!)"
                                
                                ] as [String : Any]
                            vipClass.Tag = 1
                            vipClass.apiPOST(ApiLink: "account/register/", ApiParam: param as [String : AnyObject]?, headers: nil)
                            
                        }
                        else {
                            
                            showAlertWithMsg("Password don't match", cc: self)
                        }
                    }
                    else {
                        
                        showAlertWithMsg("Sorry!!,invalid Password. 'spaces' or '&' not allowed!!", cc: self)
                    }
                }
                else {
                    
                    showAlertWithMsg("Invalid Last Name. Characters allowed:[a-zA-Z0-9]", cc: self)
                }
            }
            else {
                
                showAlertWithMsg("Invalid First Name. Characters allowed:[a-zA-Z0-9]", cc: self)
                
            }
        }
        else {
            
            showAlertWithMsg("Sorry,Invalid Email!!", cc: self)
        }
        
    }
    
    @IBAction func Click_Back(_ sender: UIButton) {
        
        self.goBack()
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
            
            defaults.set(token, forKey: VHkey.token)
            defaults.set(1, forKey: VHkey.login)
            defaults.set(id, forKey: VHkey.ID)
            defaults.set("\(txt_fname.text!) \(txt_lname.text!)", forKey: VHkey.userName)
           
            let param = [
                
                "offset": 0,
                "user_id": id
                
                ] as [String : Any]
            vipClass.Tag = 2
            vipClass.apiPOST(ApiLink: "core/getdeviceslist/", ApiParam: param as [String : AnyObject]?, headers: nil)
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
        
    }
    

}
