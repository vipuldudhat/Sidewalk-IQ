//
//  CalendarVC.swift
//  Sidewalk IQ
//
//  Created by Himani Patel on 12/4/17.
//  Copyright © 2017 SCC INFOTECH LLP. All rights reserved.
//

import UIKit
import KYDrawerController
import JTCalendar
import SwiftyJSON

class CalendarVC: UIViewController,JTCalendarDelegate,VIPNetworkDelegate {

    @IBOutlet var SensorName: [UILabel]!
   
    @IBOutlet weak var lbl_address: UILabel!
    
    @IBOutlet weak var calendarContentView: JTHorizontalCalendarView!

    @IBOutlet weak var calenderMenuView: JTCalendarMenuView!
    
    var calendarManager: JTCalendarManager = JTCalendarManager()
    var selectedDate : [Date] = [Date]()
    let vipClass = VIPNetwork()
    var selectDate : Date!
    var aryValue : [Int] = [Int]()
    var currentData : JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vipClass.delegate = self
        
        self.calendarManager = JTCalendarManager()
        self.calendarManager.delegate = self
        
        calendarManager.menuView = calenderMenuView
        calenderMenuView.tintColor = UIColor.black
        calendarManager.contentView = calendarContentView
        self.calendarManager.setDate(Date())
    }

    override func viewWillAppear(_ animated: Bool) {
        
        getCalendarData(date: Date().dateToString())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCalendarData(date:String) {
        
        hudProggess(self.view, Show: true)
        
        let param = [
            
            "sensor_id": defaults.value(forKey: VHkey.sensor_id) as! Int,
            "start_timestamp":date
            
            ] as [String : Any]
        
        let header = [
            
            "Authorization": "Token \(defaults.value(forKey: VHkey.token) as! String)"
            
            ] as [String : String]
        
        vipClass.Tag = 1
        vipClass.apiPOST(ApiLink: "core/getmonthlydata/", ApiParam: param as [String : AnyObject]?, headers: header)
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
        
        currentData = sJson
        
        selectedDate.removeAll()
        aryValue.removeAll()
        
        for lbl in SensorName {
            
            lbl.text = sJson["data"]["sensor_data"]["device_name"].stringValue
        }
        lbl_address.text = sJson["data"]["sensor_data"]["device_street"].stringValue
        
        let aryData = sJson["data"]["foottraffic_data"].arrayValue
        
        for datevalue in aryData {
            
            let datestr =  datevalue["day_date"].stringValue
             let value =  datevalue["value"].intValue
            let date = datestr.StringToDate(formate: "yyyy-MM-dd")
            selectedDate.append(date)
            aryValue.append(value)
        }
        self.calendarManager.reload()
    }
    func failResponseWithError(error: NSError) {
        
        hudProggess(self.view, Show: false)
        print(error)
        
    }
    
    //MARK: - CalendarManager delegate
    
    func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: (UIView & JTCalendarDay)!) {
        
        dayView.isHidden = false
        
        if let MyView = dayView as? JTCalendarDayView
        {
            
            MyView.textLabel.textColor = UIColor.black
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: MyView.date)
            
//           print(dateString)
            
            let matchdate = dateString.StringToDate(formate: "yyyy-MM-dd")
            
            for (i,daydate) in selectedDate.enumerated() {
                
                if  calendarManager.dateHelper.date(daydate, isTheSameDayThan: matchdate) {
                    
                    if aryValue[i] > 0 {
                        
                        MyView.dotView.isHidden = false
                        MyView.dotView.backgroundColor = UIColor(red: 60/255.0, green: 151/255.0, blue: 253/255.0, alpha: 1.0)
                        
                        if aryValue[i] <= 500 {
                           
                            MyView.dotSize = CGSize(width: 6, height: 6)
//                             MyView.dotView.backgroundColor = UIColor.red
                            
                        }
                        else if aryValue[i] <= 1000 {
                           
                            MyView.dotSize = CGSize(width: 8, height: 8)
//                             MyView.dotView.backgroundColor = UIColor.yellow
//                            MyView.dotRatio = 1.0 / 5.0
                        }
                        else {
                            
                            MyView.dotSize = CGSize(width: 12, height: 12)
//                             MyView.dotView.backgroundColor = UIColor.blue
//                            MyView.dotRatio = 1.0 / 2.0
                        }
                    }
                    
                    MyView.circleView.isHidden = true
                    MyView.textLabel.textColor = UIColor.black
                    break
                }
                else {
                    
                    MyView.circleView.isHidden = true
                    MyView.textLabel.textColor = UIColor.lightGray
                    MyView.dotView.isHidden = true
                }
            }
            if selectedDate.count == 0 {
                
                MyView.circleView.isHidden = true
                MyView.textLabel.textColor = UIColor.lightGray
                MyView.dotView.isHidden = true
            }
            
            if !calendarManager.dateHelper.date(calendarContentView.date, isTheSameMonthThan: MyView.date) {

                MyView.circleView.isHidden = true
                MyView.textLabel.textColor = UIColor.lightGray
                MyView.dotView.isHidden = true
            }
            if (selectDate != nil) && calendarManager.dateHelper.date(selectDate, isTheSameDayThan: MyView.date) {
                
                MyView.circleView.isHidden = false
                MyView.circleView.backgroundColor = UIColor.lightGray
                MyView.textLabel.textColor = UIColor.white
            }
            if calendarManager.dateHelper.date(Date(), isTheSameDayThan: MyView.date) {
                
                MyView.circleView.isHidden = false
                MyView.circleView.backgroundColor = UIColor.lightGray
                MyView.textLabel.textColor = UIColor.white
            }
            
        }
        
        
    }
    
    func calendarDidLoadPreviousPage(_ calendar: JTCalendarManager!) {
        
        print("prev")
        let nextdate = calendar.date().dateToString().components(separatedBy: "-")
        let date = "\(nextdate[0])-\(nextdate[1])-01 00:00:01"
        print(date)
        
        getCalendarData(date: date)
    }
    func calendarDidLoadNextPage(_ calendar: JTCalendarManager!) {
        
        print("Next")
        let prevdate = calendar.date().dateToString().components(separatedBy: "-")
        let date = "\(prevdate[0])-\(prevdate[1])-01 00:00:01"
        print(date)
        
        getCalendarData(date: date)
    }
    
    func calendar(_ calendar: JTCalendarManager!, didTouchDayView dayView: (UIView & JTCalendarDay)!) {
        
        if let MyView = dayView as? JTCalendarDayView
        {
            
//            MyView.textLabel.textColor = UIColor.black
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: MyView.date)
            
//            print(dateString)
            
            let matchdate = dateString.StringToDate(formate: "yyyy-MM-dd")
        
            for daydate in selectedDate {
            
                if  calendarManager.dateHelper.date(daydate, isTheSameDayThan: matchdate) {
                
                    selectDate = MyView.date
//                    MyView.textLabel.textColor = UIColor.white
//                    MyView.circleView.backgroundColor = UIColor.lightGray
                    // Animation for the circleView
                    MyView.circleView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                    UIView.transition(with: MyView, duration: 0.3, options: [], animations: {() -> Void in
                        MyView.circleView.transform = CGAffineTransform.identity
                        self.calendarManager.reload()
                        
                    }, completion: { _ in
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeZone = TimeZone.current
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let selDate = dateFormatter.string(from: self.selectDate)
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                        vc.calendarData = self.currentData
                        vc.openDate = selDate
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    })
                    
                }
           
            }
        }
    }
    
    
    @IBAction func Click_Prev(_ sender: UIButton) {
        
        calenderMenuView.moveLeft()
    }
    
    
    @IBAction func Click_Next(_ sender: UIButton) {
        
        calenderMenuView.moveRight()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
