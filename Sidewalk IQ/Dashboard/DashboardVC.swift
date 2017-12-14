//
//  DashboardVC.swift
//  Sidewalk IQ
//
//  Created by Himani Patel on 12/4/17.
//  Copyright © 2017 SCC INFOTECH LLP. All rights reserved.
//

import UIKit
import KYDrawerController
import SwiftyJSON
import Charts
import AEAccordion

var flagChart : Bool = true

class DashboardVC: UIViewController,VIPNetworkDelegate,UITableViewDelegate,UITableViewDataSource,ChartViewDelegate {

    @IBOutlet weak var tbl_dashboard: UITableView!
   
    @IBOutlet weak var linechartView: LineChartView!
    @IBOutlet weak var lbl_sensorName: UILabel!
  
    let vipClass = VIPNetwork()
    var arytrafficList = [JSON]()
    var aryweatherList = [JSON]()
    var cellHeight : CGFloat = 0
    var imgDic = [String:UIImage]()
    var aryhideShow = [Int]()
    var aryHour = [Int:String]()
    var bgColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
    var calendarData : JSON!
    var openDate = ""
    var timer : Timer!
    var refreshControl: UIRefreshControl!
    var counter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgDic = ["Partly Cloudy" :#imageLiteral(resourceName: "partlycloudy"),"Chance of Storms":#imageLiteral(resourceName: "chancetstorms"),"Clear":#imageLiteral(resourceName: "clear"),"Cloudy":#imageLiteral(resourceName: "cloudy"),"Hazy":#imageLiteral(resourceName: "hazy"),"Mostly Cloudy":#imageLiteral(resourceName: "mostlycloudy"),"Mostly Sunny":#imageLiteral(resourceName: "mostlysunny"),"Night Chancet Storms":#imageLiteral(resourceName: "nt_chancetstorms"),"Night Clear":#imageLiteral(resourceName: "nt_clear"),"Night Mostly Cloudy":#imageLiteral(resourceName: "nt_mostlycloudy"),"Night Partly Cloudy":#imageLiteral(resourceName: "nt_partlycloudy"),"Chance of Rain":#imageLiteral(resourceName: "rain"),"Chance of Snow":#imageLiteral(resourceName: "snow"),"Snow":#imageLiteral(resourceName: "snow"),"Thunder Storms":#imageLiteral(resourceName: "tstorms"),"Weather Partly Cloudy":#imageLiteral(resourceName: "weather_partly_cloudy"),"Overcast":#imageLiteral(resourceName: "hazy"),"Rain":#imageLiteral(resourceName: "rain"),"Snow Showers":#imageLiteral(resourceName: "snow")]
        
//        aryHour = [23:"10-11 PM",22:"9-10 PM",21:"8-9 PM",20:"7-8 PM",19:"6-7 PM",18:"5-6 PM",17:"4-5 PM",16:"3-4 PM",15:"2-3 PM",14:"1-2 PM",13:"12-1 PM",12:"11-12 PM",11:"10-11 AM",10:"9-10 AM",9:"8-9 AM",8:"7-8 AM",7:"6-7 AM",6:"5-6 AM",5:"4-5 AM",4:"3-4 AM",3:"2-3 AM",2:"1-2 AM",1:"12-1 AM",0:"11-12 PM"]
        
        aryHour = [23:"11-12 PM",22:"10-11 PM",21:"9-10 PM",20:"8-9 PM",19:"7-8 PM",18:"6-7 PM",17:"5-6 PM",16:"4-5 PM",15:"3-4 PM",14:"2-3 PM",13:"1-2 PM",12:"12-1 PM",11:"11-12 PM",10:"10-11 AM",9:"9-10 AM",8:"8-9 AM",7:"7-8 AM",6:"6-7 AM",5:"5-6 AM",4:"4-5 AM",3:"3-4 AM",2:"2-3 AM",1:"1-2 AM",0:"12-1 AM"]
        
        vipClass.delegate = self
        tbl_dashboard.tableFooterView = UIView()
        lbl_sensorName.text = sensorname
        
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        tbl_dashboard.addSubview(refreshControl)
        
        setChartUI()
        
        if calendarData != nil {
            
            aryhideShow.removeAll()
            
            arytrafficList = calendarData["data"]["foottraffic_data"].arrayValue
            aryweatherList = calendarData["data"]["weather_data"].arrayValue
            
             var index = 0
            
            for (i,obj) in arytrafficList.enumerated() {
                
                if obj["day_date"].stringValue == openDate {
                    
                     index = i
                    aryhideShow.append(1)
                }
                else {
                    
                    aryhideShow.append(0)
                }
            }
            
            tbl_dashboard.reloadData()
            
            
            setDataCount()
            
            let when = DispatchTime.now() + 0.3
            
            DispatchQueue.main.asyncAfter(deadline: when) {
                
                if self.arytrafficList.count > 0 {
                    
                    let indexpath = IndexPath(row: 0, section: index)
                    self.tbl_dashboard.scrollToRow(at: indexpath, at: .top, animated: false)
                }
                
            }
           
        }
        else {
            
             getFootprintList()
        }
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if !flagChart {
            
            flagChart = true
            updatechart()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       
        if timer != nil {
            
             timer.invalidate()
        }
        
       flagChart = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
//    func expandFirstCell() {
//        let firstCellIndexPath = IndexPath(row: 0, section: 0)
//        expandedIndexPaths.append(firstCellIndexPath)
//    }
    
    // MARK: - Refresh table
    
    @objc func refresh(sender:AnyObject) {
        
        if calendarData == nil {
         
            getFootprintList()
        }
        
        self.refreshControl.endRefreshing()
        
        
    }
    
    func setChartUI() {
        
//        linechartView.delegate = self
        linechartView.chartDescription?.enabled = false
        
        linechartView.dragEnabled = false
        linechartView.setScaleEnabled(false)
        linechartView.pinchZoomEnabled = false
        linechartView.drawGridBackgroundEnabled = false
        linechartView.backgroundColor = UIColor(red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1.0)
        
        let xAxis = linechartView.xAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = true
        xAxis.axisLineColor = UIColor.white
        xAxis.granularity = 1.0
        xAxis.labelPosition = .bottom
        xAxis.enabled = false
        
        
        
        
        let leftAxis = linechartView.rightAxis
        leftAxis.enabled = false
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawGridLinesEnabled = false
       
        
        let rightAxis = linechartView.leftAxis
        rightAxis.enabled = false
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawGridLinesEnabled = false
        
        linechartView.legend.enabled = false
        linechartView.legend.direction = .rightToLeft
        if #available(iOS 9.0, *) {
            LineChartView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            // Fallback on earlier versions
        }
//        linechartView.xAxis.labelPosition = .bottom
        
        
       
        
    }
    
     func setDataCount() {
     
        var values = [ChartDataEntry]()
        
        let mul = 63 / 2.0
        let val = arc4random_uniform(UInt32(mul)) + 50
        values.append(ChartDataEntry(x: Double(0), y: Double(val)))
        
        let dataset : LineChartDataSet = LineChartDataSet(values: values, label: "")
        dataset.axisDependency = .right
        dataset.colors = [UIColor(red: 64/255.0, green: 138/255.0, blue: 230/255.0, alpha: 1.0)]
        dataset.circleColors = [UIColor(red: 129/255.0, green: 229/255.0, blue: 253/255.0, alpha: 1.0)]
        dataset.lineWidth = 2.0
        dataset.circleRadius = 6.0
        dataset.circleHoleRadius = 3.0
        dataset.circleHoleColor = UIColor.white
        
        dataset.drawCircleHoleEnabled = true
        dataset.drawValuesEnabled = false
        
        linechartView.xAxis.granularityEnabled = true
        linechartView.xAxis.granularity = 1.0
        
        let data = LineChartData(dataSet: dataset)
        data.setValueTextColor(NSUIColor.white)
        
        linechartView.data = data
        
        self.linechartView.setNeedsDisplay()
        flagChart = true
        updatechart()
//         timer = Timer.scheduledTimer(timeInterval: 0.2, target: self,selector: (#selector(DashboardVC.updatechart)), userInfo: nil, repeats: true)
    }
    
    func getFootprintList() {
        
        hudProggess(self.view, Show: true)
        
        let param = [
            
            "sensor_id": defaults.value(forKey: VHkey.sensor_id) as! Int,
            "start_timestamp": Date().dateToString()
            
            ] as [String : Any]
        
        let header = [
            
            "Authorization": "Token \(defaults.value(forKey: VHkey.token) as! String)"
            
            ] as [String : String]
        
        vipClass.Tag = 1
        vipClass.apiPOST(ApiLink: "core/getfoottraffic/", ApiParam: param as [String : AnyObject]?, headers: header)
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        openDate = dateFormatter.string(from: Date())
        
         aryhideShow.removeAll()
        
        arytrafficList = sJson["data"]["foottraffic_data"].arrayValue
        aryweatherList = sJson["data"]["weather_data"].arrayValue
        
        var index = 0
        
        for (i,obj) in arytrafficList.enumerated() {
            
            if obj["day_date"].stringValue == openDate {
                
                aryhideShow.append(1)
                index = i
            }
            else {
                
                aryhideShow.append(0)
            }
            
            
        }
        
        tbl_dashboard.reloadData()
        let when = DispatchTime.now() + 0.3
        
        DispatchQueue.main.asyncAfter(deadline: when) {
        
            if self.arytrafficList.count > 0 {
             
                let indexpath = IndexPath(row: 0, section: index)
                self.tbl_dashboard.scrollToRow(at: indexpath, at: .top, animated: false)
            }
            
            
            
        }
        setDataCount()
       
        
    }
    
    
    func updatechart(){
    
        let mul = 63 / 2.0
        let val = arc4random_uniform(UInt32(mul)) + 50
        
        linechartView.data?.addEntry(ChartDataEntry(x: Double(counter), y: Double(val)), dataSetIndex: 0)
        linechartView.setVisibleXRange(minXRange: 1.0, maxXRange: 34)
        linechartView.notifyDataSetChanged()
        linechartView.moveViewToX(Double(counter))
        counter = counter + 1
        
        
        if flagChart {
            
            let when = DispatchTime.now() + 0.3
            
            DispatchQueue.main.asyncAfter(deadline: when) {
                
                self.updatechart()
                
            }
        }
        
       
        
        
    }
    
    func failResponseWithError(error: NSError) {
        
        hudProggess(self.view, Show: false)
        print(error)
        
        
        
    }
    
   
    
    // - - - - - - - - - - - - - - - - - - - - - -
    // MARK: - UITableViewDataSource protocol
    // - - - - - - - - - - - - - - - - - - - - - -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return arytrafficList.count
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return sections[section].collapsed ? 0 : sections[section].items.count
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let trafficData = arytrafficList[section]
        let weatherData = aryweatherList[section]
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tbl_dashboard.vWidth, height: 60))
        headerView.backgroundColor = UIColor.white
        headerView.isUserInteractionEnabled = true
        headerView.tag = section + 200
       
        
        let tapgest = UITapGestureRecognizer()
        tapgest.addTarget(self, action: #selector(DashboardVC.showHiddenItems(sender:)))
        headerView.addGestureRecognizer(tapgest)
        
        let dropImg = UIImageView(frame: CGRect(x: 5, y: (60 - 12)/2, width: 12, height: 12))
        dropImg.image = #imageLiteral(resourceName: "down-arrow")
        dropImg.contentMode = .scaleAspectFit
        headerView.addSubview(dropImg)
        
        let weatherImg = UIImageView(frame: CGRect(x: dropImg.XW + 5, y: (60 - 35)/2, width: 35, height: 35))
        weatherImg.image = imgDic[weatherData["day_condition"].stringValue]
        headerView.addSubview(weatherImg)
        
        let tempLBL = UILabel(frame: CGRect(x: weatherImg.XW + 8, y: 5, width: 50, height: 40))
        tempLBL.font = UIFont.systemFont(ofSize: 14.0)
        tempLBL.numberOfLines = 0
        tempLBL.text = weatherData["day_high"].stringValue
        tempLBL.sizeToFit()
        tempLBL.YPOINT = (headerView.vHeight - tempLBL.vHeight)/2
        headerView.addSubview(tempLBL)
        
        let footImg = UIImageView(frame: CGRect(x: headerView.vWidth - 35, y: (60 - 30)/2, width: 30, height: 30))
        footImg.image = #imageLiteral(resourceName: "foottraffic")
        footImg.alpha = 0.5
        if trafficData["value"].intValue > 0 {
            
            footImg.alpha = 1.0
        }
        headerView.addSubview(footImg)
        
        let valueLBL = UILabel(frame: CGRect(x: headerView.vWidth - 93, y: 5, width: 50, height: 40))
        valueLBL.font = UIFont.systemFont(ofSize: 14.0)
        valueLBL.textAlignment = .right
        valueLBL.numberOfLines = 0
        valueLBL.text = "\(trafficData["value"].intValue)"
        valueLBL.sizeToFit()
        
        
        valueLBL.XPOINT = (headerView.vWidth - (footImg.vWidth + valueLBL.vWidth + 10))
        valueLBL.YPOINT = (headerView.vHeight - valueLBL.vHeight) / 2
        headerView.addSubview(valueLBL)
        
        
        let date = trafficData["day_date"].stringValue.StringToDate(formate: "yyyy-MM-dd")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd"
        let dayValue = dateFormatter.string(from: date)
        
        //
        let remainwidth = headerView.vWidth - (tempLBL.XW + 10 + ((footImg.vWidth + valueLBL.vWidth + 10)))
        
        let dayLBL = UILabel(frame: CGRect(x: tempLBL.XW + (remainwidth - 100)/2, y: 10, width: 100, height: 21))
        dayLBL.font = UIFont.boldSystemFont(ofSize: 15.0)
        dayLBL.center.x = headerView.center.x + 10
        dayLBL.text = dayValue.components(separatedBy: ",")[0]
        dayLBL.textAlignment = .center
        //        dayLBL.backgroundColor = UIColor.yellow
        headerView.addSubview(dayLBL)
        
        
        let dateLBL = UILabel(frame: CGRect(x: dayLBL.XPOINT, y: dayLBL.YH, width: dayLBL.vWidth, height: 21))
        dateLBL.font = UIFont.systemFont(ofSize: 14.0)
        dateLBL.text = dayValue.components(separatedBy: ",")[1]
        dateLBL.textAlignment = .center
        dateLBL.textColor = UIColor.lightGray
        headerView.addSubview(dateLBL)
        
        let lineView = UIView(frame: CGRect(x: 0, y: 59, width: headerView.vWidth, height: 1.0))
        lineView.backgroundColor = UIColor.lightGray
        headerView.addSubview(lineView)
       
         if aryhideShow[section] == 1 {
            
            headerView.backgroundColor = bgColor
            lineView.backgroundColor = UIColor.white
            weatherImg.hideV()
            tempLBL.hideV()
            valueLBL.hideV()
            footImg.hideV()
            dropImg.image = #imageLiteral(resourceName: "Up")
        }
         else {
         
            dropImg.image = #imageLiteral(resourceName: "down-arrow")
            
            headerView.backgroundColor = UIColor.white
            lineView.backgroundColor = UIColor.lightGray
            weatherImg.showV()
            tempLBL.showV()
            valueLBL.showV()
            footImg.showV()
        }
        
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return aryhideShow[section] == 1 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "dashboardcell", for: indexPath)
        _ = cell.subviews.map({$0.removeFromSuperview()})
        cell.selectionStyle = .none
        
        let trafficData = arytrafficList[indexPath.section]
        let weatherData = aryweatherList[indexPath.section]
        

        var bgHeight : CGFloat = 0
        
      //  headerView.YH
        let bgview = UIView(frame: CGRect(x: 0, y: 0, width: tbl_dashboard.vWidth, height: bgHeight))
        bgview.backgroundColor = bgColor
        cell.addSubview(bgview)
        
        let firstView = UIView(frame: CGRect(x: 0, y: 5, width: tbl_dashboard.vWidth, height: 30))
        firstView.backgroundColor = UIColor.clear
        bgview.addSubview(firstView)
        
        let footInImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        footInImg.image = #imageLiteral(resourceName: "foottraffic")
        footInImg.alpha = 0.5
        if trafficData["value"].intValue > 0 {
            
            footInImg.alpha = 1.0
        }
        firstView.addSubview(footInImg)
        
        let valueInLBL = UILabel(frame: CGRect(x: footInImg.XW + 3, y: 0, width: 50, height: 30))
        valueInLBL.font = UIFont.systemFont(ofSize: 14.0)
        valueInLBL.numberOfLines = 0
        valueInLBL.text = "\(trafficData["value"].intValue)"
        valueInLBL.sizeToFit()
        valueInLBL.YPOINT = (30-valueInLBL.vHeight)/2
         firstView.addSubview(valueInLBL)
        
        firstView.vWidth = valueInLBL.XW
        firstView.center.x = bgview.center.x
        
        let secondView = UIView(frame: CGRect(x: 0, y: firstView.YH + 5, width: tbl_dashboard.vWidth, height: 25))
        secondView.backgroundColor = UIColor.clear
        bgview.addSubview(secondView)
        
        let weatherInImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        weatherInImg.image = imgDic[weatherData["day_condition"].stringValue]
        secondView.addSubview(weatherInImg)
        
        let tempInLBL = UILabel(frame: CGRect(x: weatherInImg.XW + 3, y: 0, width: tbl_dashboard.vWidth, height: 30))
        tempInLBL.font = UIFont.systemFont(ofSize: 12.0)
        tempInLBL.numberOfLines = 0
        tempInLBL.text = "\(weatherData["day_high"].stringValue) | \(weatherData["day_low"].stringValue),\(weatherData["day_condition"].stringValue)"
        tempInLBL.sizeToFit()
        tempInLBL.YPOINT = (25-tempInLBL.vHeight)/2
        
        secondView.addSubview(tempInLBL)
        
        secondView.vWidth = tempInLBL.XW
        secondView.center.x = bgview.center.x
        
        let lastView = UIView(frame: CGRect(x: 0, y: secondView.YH + 5, width: tbl_dashboard.vWidth, height: 25))
        lastView.backgroundColor = UIColor.clear
        bgview.addSubview(lastView)
        
         let hourData = trafficData["hourly_foottraffic"].arrayValue
        var valueAry = [Int]()
        for hourvalue in hourData {
            
            valueAry.append(hourvalue["value"].intValue)
        }
        
        var y1 : CGFloat = 5
        let maxValue = valueAry.max()
        
        for (i,_) in hourData.enumerated() {
            
            
            let hourLBL = UILabel(frame: CGRect(x: 5, y: y1, width: 58, height: 21))
            hourLBL.font = UIFont.systemFont(ofSize: 12.0)
            hourLBL.text = aryHour[(hourData.count - 1) - i]
            hourLBL.textAlignment = .right
            lastView.addSubview(hourLBL)
            
            let value = hourData[(hourData.count - 1) - i]["value"].intValue
            
            let footValueLBL = UILabel(frame: CGRect(x: hourLBL.XW + 5, y: y1, width: 45, height: 21))
            footValueLBL.font = UIFont.systemFont(ofSize: 10.0)
            footValueLBL.text = "\(value)"
            
            if value > 0 {
                
                let finalwidth = lastView.vWidth - (hourLBL.XW + 50)
                
                let perc : Float = Float(value)/Float(maxValue!)
                
                let refView = UIView(frame: CGRect(x: hourLBL.XW + 5, y: y1 + 2, width: finalwidth * CGFloat(perc), height: 17))
                refView.backgroundColor = UIColor(red: 60/255.0, green: 151/255.0, blue: 253/255.0, alpha: 1.0)
                lastView.addSubview(refView)
                
                footValueLBL.XPOINT = refView.XW + 3
            }
            
            lastView.addSubview(footValueLBL)
            
            y1 = y1 + 21
            
        }
        
        lastView.vHeight = y1
        
        
        let lineInView = UIView(frame: CGRect(x: 0, y: lastView.YH + 14, width: tbl_dashboard.vWidth, height: 1.0))
        lineInView.backgroundColor = UIColor.white
        bgview.addSubview(lineInView)
        
        bgview.vHeight = lastView.YH + 15
        
        if aryhideShow[indexPath.section] == 1 {
            
            bgview.showV()
            bgHeight = bgview.vHeight
            
        }
        else {
             bgview.hideV()
            bgHeight = 0
        }
        
        cellHeight = (bgview.YPOINT + bgHeight)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return cellHeight
    }
    

    @objc func showHiddenItems(sender: UITapGestureRecognizer) {
        
        let index = (sender.view?.tag)! - 200
        
        if aryhideShow[index] == 0 {
            
            
            aryhideShow[index] = 1
            let indexpath = IndexPath(row: 0, section: index)
//            tbl_dashboard.reloadData()
            
//            if aryhideShow[section] == 1 {
//
//                headerView.backgroundColor = bgColor
//                lineView.backgroundColor = UIColor.white
//                weatherImg.hideV()
//                tempLBL.hideV()
//                valueLBL.hideV()
//                footImg.hideV()
//                dropImg.image = #imageLiteral(resourceName: "Up")
//            }
//            else {
//
//                dropImg.image = #imageLiteral(resourceName: "down-arrow")
//
//                headerView.backgroundColor = UIColor.white
//                lineView.backgroundColor = UIColor.lightGray
//                weatherImg.showV()
//                tempLBL.showV()
//                valueLBL.showV()
//                footImg.showV()
//            }
//            let indextSet11 = IndexSet(index: index)
            tbl_dashboard.reloadSections(NSIndexSet(index: index) as IndexSet, with: .automatic)
//            tbl_dashboard.reloadRows(at: [indexpath], with: .none)
            
//            UIView.animate(withDuration: 0.5, animations: {
//
//                self.tbl_dashboard.scrollToRow(at: indexpath, at: .top, animated: false)
//            })
            
            let when = DispatchTime.now() + 0.2

            DispatchQueue.main.asyncAfter(deadline: when) {

                self.tbl_dashboard.scrollToRow(at: indexpath, at: .top, animated: true)


            }
        }
        else {
            
            aryhideShow[index] = 0
            tbl_dashboard.reloadData()
           
        }
        
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
