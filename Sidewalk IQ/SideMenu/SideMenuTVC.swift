//
//  SideMenuTVC.swift
//  Buzzed
//
//  Created by vipul dudhat on 10/2/17.
//  Copyright © 2017 SCC INFOTECH LLP. All rights reserved.
//

import UIKit
import KYDrawerController

class SideMenuTVC: UITableViewController {

    //MARK: - IBOutlet. . .
    @IBOutlet var tblSideMenu: UITableView!
    
//    var SideBarAryAdmin = ["Home","My Profile","Bar Calender","About us","Share","Logout"]
    
    var SideBarAry = ["Dashboard","Calendar","Report","Site Score","Sensors","Settings","Export","Logout"]
    
    var SideBarImgAry = [#imageLiteral(resourceName: "dashboard"),#imageLiteral(resourceName: "calendar"),#imageLiteral(resourceName: "report_option_1"),#imageLiteral(resourceName: "report_option_2"),#imageLiteral(resourceName: "sensors"),#imageLiteral(resourceName: "sensors"),#imageLiteral(resourceName: "export"),#imageLiteral(resourceName: "logout")]
    
     let cellIdentifier="Cell"
    
    var selectIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier:self.cellIdentifier)
         self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        tblSideMenu.tableFooterView = UIView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        tblSideMenu.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return  SideBarAry.count + 1
      
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath as IndexPath)
        
        _ = cell.subviews.map({$0.removeFromSuperview()})
        
        let startingX : CGFloat = 10.0
        
        if indexPath.row == 0 {
            
            let BGimgview = UIImageView(frame: CGRect(x: 0, y: -20, width: tblSideMenu.vWidth, height: 170))
            BGimgview.image = #imageLiteral(resourceName: "sidewalk_iq_background4")
            BGimgview.contentMode = .scaleToFill
            cell.addSubview(BGimgview)
            
            
            let editIM = UIImageView(frame: CGRect(x: 235, y: 10, width: 32.0, height: 32.0))
            editIM.image = #imageLiteral(resourceName: "edit_profile")
            editIM.contentMode = .scaleToFill
            cell.addSubview(editIM)
            
            let AppNAme = UIImageView(frame: CGRect(x: startingX, y: editIM.YH, width: 126.0, height: 26.0))
            AppNAme.image = #imageLiteral(resourceName: "sidewalk_iq_icon_white_small")
            AppNAme.contentMode = .scaleAspectFit
            cell.addSubview(AppNAme)
            
            let lblTitle = UILabel(frame: CGRect(x: startingX, y: AppNAme.YH + 8.0, width: tblSideMenu.vWidth - 50, height: 21))
            lblTitle.textColor = UIColor.white
            lblTitle.font = UIFont.systemFont(ofSize: 15.0)
            lblTitle.text = defaults.value(forKey: VHkey.userName) as! String
            lblTitle.textAlignment = .left
            lblTitle.tag = 200
            cell.addSubview(lblTitle)
            
            let lblDetail = UILabel(frame: CGRect(x: startingX, y: lblTitle.YH + 4.0, width: tblSideMenu.vWidth - 50, height: 21))
            lblDetail.textColor = UIColor.lightGray
            lblDetail.font = UIFont.systemFont(ofSize: 15.0)
            lblDetail.text = sensorname
            lblDetail.textAlignment = .left
            lblDetail.sizeToFit()
            lblDetail.tag = 200
            cell.addSubview(lblDetail)
            
            
            let selectionIM = UIImageView(frame: CGRect(x: lblDetail.XW + 2.0, y: lblDetail.YPOINT, width: 21.0, height: 21.0))
            selectionIM.image = #imageLiteral(resourceName: "circle_check_green")
            selectionIM.contentMode = .scaleAspectFit
            if sensorname != "" {
                
                cell.addSubview(selectionIM)
            }
            
            
            
            
            
        }
        else if indexPath.row == 6 {
            
            cell.selectionStyle = .none
            let img = UIImageView(frame: CGRect(x: 0, y: 0, width: tblSideMenu.vWidth, height: 0.5))
            img.backgroundColor = UIColor.lightGray
            img.tag = 300
            cell.addSubview(img)
            
            
            let lbl = UILabel(frame: CGRect(x: startingX, y: 17.5, width: tblSideMenu.vWidth - 50, height: 25))
            lbl.textColor = UIColor.darkGray
            lbl.font = UIFont.systemFont(ofSize: 15.0)
            lbl.text = SideBarAry[indexPath.row - 1]
            lbl.textAlignment = .left
            lbl.tag = 200
            cell.addSubview(lbl)
            
        }
        else {
            
            let img = UIImageView(frame: CGRect(x: startingX, y: 17.5, width: 25, height: 25))
            img.image = SideBarImgAry[indexPath.row - 1]
            img.contentMode = .scaleAspectFit
            img.tag = 300
            cell.addSubview(img)
            
            let lbl = UILabel(frame: CGRect(x: img.XW + 20, y: 0, width: tblSideMenu.vWidth - 50, height: 60))
            lbl.textColor = UIColor.black
           
            lbl.font = UIFont.systemFont(ofSize: 14.0)
            lbl.text = SideBarAry[indexPath.row - 1]
            lbl.textAlignment = .left
            lbl.font = UIFont.systemFont(ofSize: 17)
            lbl.tag = 200
            cell.addSubview(lbl)
           
            cell.backgroundColor = UIColor.white
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var vc = UIViewController()
        
        if indexPath.row == 0 {
            
          vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
            
        }
        
        selectIndex = indexPath.row

        switch indexPath.row {
            
        case 1:
            vc = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
            break
        case 2:
            //calendar
            vc = self.storyboard?.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
            break
        case 3:
            //report
             vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportVC") as! ReportVC
            break
            
        case 4:
           //sitescore
             vc = self.storyboard?.instantiateViewController(withIdentifier: "SiteScoreVC") as! SiteScoreVC
            break
        case 5:
            //sensor
            vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            break
        case 6:
            return
        case 7:
            //export
            vc = self.storyboard?.instantiateViewController(withIdentifier: "ExportVC") as! ExportVC
            break
        case 8:
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
            vc1.isLogout = true
            vc = vc1
            break
        default:
            
            break
            
        }
        
        if let eldrawer = self.navigationController?.parent as? KYDrawerController {
            
            let navcontroller = UINavigationController(rootViewController: vc)
            navcontroller.setNavigationBarHidden(true, animated: false)
            eldrawer.mainViewController = navcontroller
            eldrawer.setDrawerState(.closed, animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if indexPath.row == 0 {
            
             return 150
        }
        else {
            
             return 60.0
            
        }
        
       
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if indexPath.row != 0 {
            
            let cell : UITableViewCell = tableView.cellForRow(at: indexPath)!
            if let lbl = cell.viewWithTag(200) as? UILabel {
                
                lbl.textColor = UIColor.black
            }
            cell.imageView?.image = SideBarImgAry[indexPath.row - 1]
        }
        
      
        
    }
            
    

}
