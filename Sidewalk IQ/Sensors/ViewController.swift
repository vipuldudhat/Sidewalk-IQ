//
//  ViewController.swift
//  Sidewalk IQ
//
//  Created by Himani Patel on 12/3/17.
//  Copyright © 2017 SCC INFOTECH LLP. All rights reserved.
//

import UIKit
import KYDrawerController
import SwiftyJSON

var sensorname = ""

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,VIPNetworkDelegate {

    @IBOutlet weak var tbl_sensor: UITableView!
  
    @IBOutlet weak var lbl_sensorName: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var bgAlertView: UIView!
   
    @IBOutlet weak var txt_deviceId: UITextField!
    
    @IBOutlet weak var txt_devicename: UITextField!
    
    @IBOutlet weak var txt_zip: UITextField!
    @IBOutlet weak var txt_address: UITextField!
   
    
    var arySensor : [JSON] = [JSON]()
     let vipClass = VIPNetwork()
    var cellHeight : CGFloat = 0
    var selectSensorid = 0
    var isEdit = false
    var sensorId = 0
     var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         vipClass.delegate = self
        tbl_sensor.tableFooterView = UIView()
        
        if defaults.value(forKey: VHkey.sensor_id) != nil {
            
            selectSensorid = defaults.value(forKey: VHkey.sensor_id) as! Int
        }
        setpadding(txt: txt_deviceId)
        setpadding(txt: txt_devicename)
        setpadding(txt: txt_zip)
        setpadding(txt: txt_address)
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        tbl_sensor.addSubview(refreshControl)
        
        getSensorList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        lbl_sensorName.text = sensorname
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }

    func setpadding(txt:UITextField) {
        
        txt.setPlaceHolderWhite()
        txt.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txt.vHeight))
        txt.leftViewMode = .always
    }
    
    
    func getSensorList() {
        
        hudProggess(self.view, Show: true)
        
        let param = [
            
            "offset": 0,
            "user_id": defaults.value(forKey: VHkey.ID) as! Int
            
            ] as [String : Any]
        
        let header = [
            
            "Authorization": "Token \(defaults.value(forKey: VHkey.token) as! String)"
            
            ] as [String : String]
        
        vipClass.Tag = 1
        vipClass.apiPOST(ApiLink: "core/getdeviceslist/", ApiParam: param as [String : AnyObject]?, headers: header)
    }
    
    
    // MARK: - Refresh table
    
    @objc func refresh(sender:AnyObject) {
        
        getSensorList()
            
        self.refreshControl.endRefreshing()
        
        
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
            arySensor = sJson["data"].arrayValue
            tbl_sensor.reloadData()
            break
        case 2:
            txt_address.text = ""
            txt_zip.text = ""
            txt_devicename.text = ""
            txt_deviceId.text = ""
            bgAlertView.hideV()
           hudProggess(self.view, Show: true)
            
            let when = DispatchTime.now() + 3.0
            
            DispatchQueue.main.asyncAfter(deadline: when) {
                hudProggess(self.view, Show: false)
                self.getSensorList()
            }
           
            
           
            break
            
        default:
            getSensorList()
            break
        }
        
       
        
    }
    
    func failResponseWithError(error: NSError) {
        
        hudProggess(self.view, Show: false)
        print(error)
        
    }
    
    // - - - - - - - - - - - - - - - - - - - - - -
    // MARK: - UITableViewDataSource protocol
    // - - - - - - - - - - - - - - - - - - - - - -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arySensor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "sensorcell", for: indexPath)
        _ = cell.subviews.map({$0.removeFromSuperview()})
        cell.selectionStyle = .none
    
        
        let liveData = arySensor[indexPath.row]
     
        let bgview = UIView(frame: CGRect(x: 5, y: 5, width: tbl_sensor.vWidth - 10, height: 50))
        bgview.backgroundColor = UIColor.white
        bgview.layer.cornerRadius = 5.0
//        bgview.layer.borderWidth = 0.5
//        bgview.layer.borderColor = UIColor.lightGray.cgColor
        bgview.setShado()
        cell.addSubview(bgview)
        
        let nameLBL : UILabel = UILabel()
        nameLBL.frame = CGRect(x: 8, y: 8, width: bgview.vWidth - 72, height: 25)
        nameLBL.font = UIFont.boldSystemFont(ofSize: 15.0)
        nameLBL.numberOfLines = 0
        nameLBL.text = liveData["device_name"].stringValue
        nameLBL.sizeToFit()
        bgview.addSubview(nameLBL)
        
        let streetLBL : UILabel = UILabel()
        streetLBL.frame = CGRect(x: 8, y: nameLBL.YH + 8, width: bgview.vWidth - 72, height: 25)
        streetLBL.font = UIFont.systemFont(ofSize: 14.0)
        streetLBL.textColor = UIColor.lightGray
        streetLBL.numberOfLines = 0
        streetLBL.text = liveData["device_street"].stringValue
        streetLBL.sizeToFit()
        bgview.addSubview(streetLBL)
        
        let zipLBL : UILabel = UILabel()
        zipLBL.frame = CGRect(x: 8, y: streetLBL.YH + 8, width: bgview.vWidth - 72, height: 25)
        zipLBL.font = UIFont.systemFont(ofSize: 14.0)
        zipLBL.textColor = UIColor.lightGray
        zipLBL.numberOfLines = 0
        zipLBL.text = liveData["zip"].stringValue
        zipLBL.sizeToFit()
        bgview.addSubview(zipLBL)
        
        bgview.vHeight = zipLBL.YH + 5
        
        let moreBtn : UIButton = UIButton()
        moreBtn.frame = CGRect(x: bgview.vWidth - 35, y: (bgview.vHeight - 30)/2, width: 30, height: 30)
        moreBtn.setImage(#imageLiteral(resourceName: "more"), for: .normal)
        moreBtn.tintColor = UIColor.black
        moreBtn.tag = indexPath.row + 100
        moreBtn.addTarget(self, action: #selector(touchSensor(sender:)), for: .touchUpInside)
        bgview.addSubview(moreBtn)
        
        
        let checkImg : UIImageView = UIImageView()
        checkImg.frame = CGRect(x: bgview.vWidth - 70, y: (bgview.vHeight - 30)/2, width: 30, height: 30)
        checkImg.image = #imageLiteral(resourceName: "circle_check_green")
        
        
        if selectSensorid == 0 {
            
            if indexPath.row == 0 {
                sensorname = liveData["device_name"].stringValue
                defaults.set(liveData["id"].intValue, forKey: VHkey.sensor_id)
                 bgview.addSubview(checkImg)
                lbl_sensorName.text = sensorname
            }
        }
        else {
            
            if selectSensorid == liveData["id"].intValue {
                sensorname = liveData["device_name"].stringValue
                 bgview.addSubview(checkImg)
                lbl_sensorName.text = sensorname
            }
        }
        
        cellHeight = bgview.vHeight + 15
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let livedata = arySensor[indexPath.row]
        defaults.set(livedata["id"].intValue, forKey: VHkey.sensor_id)
        sensorname = livedata["device_name"].stringValue
        lbl_sensorName.text = sensorname
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return cellHeight
    }
    
    
    @objc func touchSensor(sender:UIButton) {
        
        let index = sender.tag - 100
        
        let data = arySensor[index]
         self.sensorId = data["id"].intValue
        
        let actionSheetController = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let attributedString = NSAttributedString(string: "Option", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17.0)])
        
        actionSheetController.setValue(attributedString, forKey: "attributedTitle")
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let editActionButton = UIAlertAction(title: "Edit", style: .default) { action -> Void in
            
            self.isEdit = true
            
            self.lbl_title.text = "Edit Sensor"
            self.txt_address.text = data["device_street"].stringValue
            self.txt_zip.text = data["zip"].stringValue
            self.txt_devicename.text = data["device_name"].stringValue
            self.txt_deviceId.text = data["device_id"].stringValue
           
            
           self.bgAlertView.showV()
            
        }
        
        actionSheetController.addAction(editActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Delete", style: .default) { action -> Void in
            
            let alertController = UIAlertController(title: "Delete Sensor", message: "Are you sure you want to delete this sensor? All the sensor data will be lost!?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "No", style: .destructive, handler: { (action) in
                
               
            })
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                
                hudProggess(self.view, Show: true)
                
                let param = [
                    
                    "sensor_id": self.sensorId
                    
                    ] as [String : Any]
                
                let header = [
                    
                    "Authorization": "Token \(defaults.value(forKey: VHkey.token) as! String)"
                    
                    ] as [String : String]
                
                self.vipClass.Tag = 3
                self.vipClass.apiPOST(ApiLink: "core/delete_device/", ApiParam: param as [String : AnyObject]?, headers: header)
                
            })
            
            alertController.addAction(deleteAction)
            
            self.present(alertController, animated: true, completion: {})
        }
        
        actionSheetController.addAction(deleteActionButton)
        
         self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    @IBAction func Click_AddSensor(_ sender: UIButton) {
        
        bgAlertView.showV()
    }
    
    @IBAction func Click_Save(_ sender: UIButton) {
        
        if validationTextField(txt_deviceId, msg: "Sorry!!,Invalid Id", cc: self) {
            
            hudProggess(self.view, Show: true)
            
            var api = "core/add_device/"
        
            
            var param = [
                
                "device_street": txt_address.text!,
                "device_name": txt_devicename.text!,
                "device_id": txt_deviceId.text!,
                "zip": txt_zip.text!,
                "user_id": defaults.value(forKey: VHkey.ID) as! Int
                
                ] as [String : Any]
            
            if isEdit {
                
                api = "core/update_device/"
                isEdit = false
                
                param = [
                    
                    "device_street": txt_address.text!,
                    "device_name": txt_devicename.text!,
                    "device_id": txt_deviceId.text!,
                    "zip": txt_zip.text!,
                    "user_id": defaults.value(forKey: VHkey.ID) as! Int,
                    "sensor_id": sensorId
                    
                    ] as [String : Any]
            }
            
            let header = [
                
                "Authorization": "Token \(defaults.value(forKey: VHkey.token) as! String)"
                
                ] as [String : String]
            
            vipClass.Tag = 2
            vipClass.apiPOST(ApiLink: api, ApiParam: param as [String : AnyObject]?, headers: header)
        }
        
    }
    
    @IBAction func Tap_close(_ sender: UITapGestureRecognizer) {
        
        bgAlertView.hideV()
    }
    @IBAction func Click_Refresh(_ sender: UIButton) {
        
         getSensorList()
    }
    
    @IBAction func Click_Menu(_ sender: UIButton) {
        
        if let menu = self.navigationController?.parent as? KYDrawerController {
            
            menu.setDrawerState(.opened, animated: true)
        }
    }
    
}

