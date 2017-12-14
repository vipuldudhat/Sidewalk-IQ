//
//  EditProfileVC.swift
//  Sidewalk IQ
//
//  Created by Himani Patel on 12/4/17.
//  Copyright © 2017 SCC INFOTECH LLP. All rights reserved.
//

import UIKit
import SwiftyJSON
import KYDrawerController

class EditProfileVC: UIViewController,VIPNetworkDelegate {

    @IBOutlet weak var lbl_sensorName: UILabel!
 
    @IBOutlet weak var lbl_DpName: UILabel!
    
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var lbl_userName: UILabel!
 
    @IBOutlet weak var txt_fname: UITextField!
    
    @IBOutlet weak var txt_lname: UITextField!
 
    @IBOutlet weak var txt_email: UITextField!
    
    @IBOutlet weak var scroll_content: UIScrollView!
    
     let vipClass = VIPNetwork()
    var isLogout = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

         txt_fname.setUnderLineBack()
        txt_lname.setUnderLineBack()
        txt_email.setUnderLineBack()
        
        lbl_sensorName.text = sensorname
        
        lbl_DpName.cornerRadius = lbl_DpName.vWidth/2
        lbl_DpName.layer.borderWidth = 2.0
        lbl_DpName.layer.borderColor = UIColor.white.cgColor
     
        
        
        vipClass.delegate = self
        
        hudProggess(self.view, Show: true)
        
        let param = [
            
            "user_id": defaults.value(forKey: VHkey.ID) as! Int
            
            
            ] as [String : Any]
        
        let header = [
            
            "Authorization": "Token \(defaults.value(forKey: VHkey.token) as! String)"
            
            ] as [String : String]
        
        vipClass.Tag = 1
        vipClass.apiPOST(ApiLink: "account/login/update/", ApiParam: param as [String : AnyObject]?, headers: header)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isLogout {
            
            let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "No", style: .destructive, handler: { (action) in
                
                
            })
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                
               defaults.removeObject(forKey: VHkey.login)
                defaults.removeObject(forKey: VHkey.ID)
                defaults.removeObject(forKey: VHkey.sensor_id)
                
                self.performSegue(withIdentifier: "Logout", sender: nil)
                
            })
            
            alertController.addAction(deleteAction)
            
            self.present(alertController, animated: true, completion: {})
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
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
        
        txt_fname.text = sJson["data"]["user"]["first_name"].stringValue
        txt_lname.text = sJson["data"]["user"]["last_name"].stringValue
        txt_email.text = sJson["data"]["user"]["email"].stringValue
        
        lbl_DpName.text = "\(txt_fname.text!.characters.first!) \(txt_lname.text!.characters.first!)"
        
        lbl_userName.text = "\(txt_fname.text!) \( txt_lname.text!)"
        
        lbl_email.text = sJson["data"]["user"]["username"].stringValue
    }
    
    func failResponseWithError(error: NSError) {
        
        hudProggess(self.view, Show: false)
        print(error)
       
    }
    
    @IBAction func Click_Menu(_ sender: UIButton) {
        
        if let menu = self.navigationController?.parent as? KYDrawerController {
            
            menu.setDrawerState(.opened, animated: true)
        }
        
    }
    @IBAction func Click_Sensor(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
   
    @IBAction func Click_Update(_ sender: UIButton) {
        
        if isValidEmail(txt_email.text!, cc: self) {
            
            if txt_fname.text!.isAlphanumeric {
                
                if txt_lname.text!.isAlphanumeric {
                    
                    hudProggess(self.view, Show: true)
                    
                    let param = [
                        
                        "email": "\(txt_email.text!)",
                        "update": "T",
                        "user_id": defaults.value(forKey: VHkey.ID) as! Int,
                        "first_name": "\(txt_fname.text!)",
                        "last_name": "\(txt_lname.text!)"
                        
                        ] as [String : Any]
                    let header = [
                        
                        "Authorization": "Token \(defaults.value(forKey: VHkey.token) as! String)"
                        
                        ] as [String : String]
                    
                    vipClass.Tag = 2
                    vipClass.apiPOST(ApiLink: "account/login/update/", ApiParam: param as [String : AnyObject]?, headers: header)
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
    
}
