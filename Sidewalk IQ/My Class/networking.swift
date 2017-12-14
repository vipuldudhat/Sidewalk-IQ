 //
//  networking.swift
//  
//
//  Created by Optimumbrew Technology (www.optimumbrew.com) on 25/06/16.
//
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

//=================---> MARK:- 📍 Protocol 📍

protocol VIPNetworkDelegate : NSObjectProtocol {
    
   
    func internetConnectionOffline();
    func successResponseWithData(sJson:JSON);
//    func failResponseWithData(DataAsDictionary:NSMutableDictionary);
    func failResponseWithError(error:NSError);
    
}
    //UITextFieldDelegate
//UITextViewDelegate

//===============------===================-------


class VIPNetwork : UIViewController {

    weak internal var delegate: VIPNetworkDelegate? // default is nil. weak reference
    var Tag : Int = 0
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
    }
    
      // - - - - - - - - - - -
     // MARK:- 📍 GET API 📍
    // - - - - - - - - - - -
    func apiGET(ApiLink strurl:String, headers:[String:String]?){
    
    /*
        Alamofire.request(.GET, "\(API_URL)\(strurl)")
            .validate()
            .responseJSON { response in
                debugPrint(response)
        }
    */
        
        let status = Reach().connectionStatus()
        
        switch status {
            
        case .unknown, .offline:
            print("Network issue")
            
            if self.delegate != nil{
                
                self.delegate!.internetConnectionOffline()
                return
            }
            
            
        default:
            
            print("\(API_URL)\(strurl)")
            Alamofire.request("\(API_URL)\(strurl)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        
                        print("Responce success 1")
                        if self.delegate != nil{
                            
                            let sJson = JSON(response.result.value as Any)
                            self.delegate!.successResponseWithData(sJson: sJson)
                        }
                        
                    case .failure:
                        
                        if self.delegate != nil {
                            
                            self.delegate?.failResponseWithError(error: response.result.error! as NSError)
                        }

                    }
            }
        }

        
        
        
    /*
         Alamofire.request(.GET, "\(API_URL)\(strurl)", parameters: nil)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
   */
    }
    
      // - - - - - - - - - - - -
     // MARK:- 📍 POST API 📍
    // - - - - - - - - - - -
    
    func apiPOST(ApiLink strurl:String, ApiParam:[String:AnyObject]?, headers:[String:String]?){
    
        let status = Reach().connectionStatus()
        
        switch status {
            
        case .unknown, .offline:
            print("Network issue")
            
            if self.delegate != nil{
                
                self.delegate!.internetConnectionOffline()
                return
            }
            
            
        default:
            
            print("\(API_URL)\(strurl)")
            print(ApiParam as Any)
//            
            
            Alamofire.request("\(API_URL)\(strurl)", method: .post, parameters: ApiParam, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        
                        print("Responce success 1")
                        if self.delegate != nil{
                            
                            let sJson = JSON(response.result.value as Any)
                            
                            self.delegate!.successResponseWithData(sJson: sJson)
                        }
                        
                    case .failure:
                        
                        if self.delegate != nil {
                            
                            self.delegate?.failResponseWithError(error: response.result.error! as NSError)
                        }
                        
                    }
            }
        }

        
    }
    
      // - - - - - - - - - - - -
     // MARK:- 📍 PUT API 📍
    // - - - - - - - - - - -
    
    func apiPUT(ApiLink strurl:String, ApiParam:[String:AnyObject], headers:[String:String]?){
        
        let status = Reach().connectionStatus()
        
        switch status {
            
        case .unknown, .offline:
            print("Network issue")
            
            if self.delegate != nil{
                
                self.delegate!.internetConnectionOffline()
                return
            }
            
            
        default:
            
            print("\(API_URL)\(strurl)")
            print(ApiParam)
            
            
           Alamofire.request("\(API_URL)\(strurl)", method: .put, parameters: ApiParam, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        
                        print("Responce success 1")
                        if self.delegate != nil{
                            
                             let sJson = JSON(response.result.value as Any)
                            
                            self.delegate!.successResponseWithData(sJson: sJson)
                        }
                        
                    case .failure:
                        
                        if self.delegate != nil {
                            
                            self.delegate?.failResponseWithError(error: response.result.error! as NSError)
                        }
                        
                    }
            }
        }
        
        
    }
    
      // - - - - - - - - - - - -
     // MARK:- 📍 DELETE API 📍
    // - - - - - - - - - - -
    
    func apiDELETE(ApiLink strurl:String,headers:[String:String]?){
        
        let status = Reach().connectionStatus()
        
        switch status {
            
        case .unknown, .offline:
            print("Network issue")
            
            if self.delegate != nil{
                
                self.delegate!.internetConnectionOffline()
                return
            }
            
            
        default:
            
            print("\(API_URL)\(strurl)")
            
           Alamofire.request("\(API_URL)\(strurl)", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        
                        print("Responce success 1")
                        if self.delegate != nil{
                            
                            let sJson = JSON(response.result.value as Any)
                            self.delegate!.successResponseWithData(sJson: sJson)
                        }
                        
                    case .failure:
                        
                        if self.delegate != nil {
                            
                            self.delegate?.failResponseWithError(error: response.result.error! as NSError)
                        }
                        
                    }
            }
        }
        
    }
    
    func apiDELETE_Body(ApiLink strurl:String,ApiParam:[String:AnyObject]?,headers:[String:String]?){
        
        let status = Reach().connectionStatus()
        
        switch status {
            
        case .unknown, .offline:
            print("Network issue")
            
            if self.delegate != nil{
                
                self.delegate!.internetConnectionOffline()
                return
            }
            
            
        default:
            
            print("\(API_URL)\(strurl)")
            
            Alamofire.request("\(API_URL)\(strurl)", method: .delete, parameters: ApiParam, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        
                        print("Responce success 1")
                        if self.delegate != nil{
                            
                            let sJson = JSON(response.result.value as Any)
                            
                            self.delegate!.successResponseWithData(sJson: sJson)
                        }
                        
                    case .failure:
                        
                        if self.delegate != nil {
                            
                            self.delegate?.failResponseWithError(error: response.result.error! as NSError)
                        }
                        
                    }
            }
        }
        
    }
    
    func createBodyWithParameters(parameters: [String: Any]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        let fromatter = DateFormatter()
        fromatter.dateFormat = "ddMMyyyyHHmmss"
        let filename = fromatter.string(from: Date()) + ".jpg"
        
        
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString("\r\n")
        
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

    func ImageUpload(ApiLink strurl:String,image : UIImage,ApiParam:[String:AnyObject]?,headers:[String:String]?) {
        
        let status = Reach().connectionStatus()
        
        switch status {
            
        case .unknown, .offline:
            print("Network issue")
            
            if self.delegate != nil{
                
                self.delegate!.internetConnectionOffline()
                return
            }
            
            
        default:
        
        let strurl  = "\(API_URL)\(strurl)"
        print(strurl)
        
        let request = NSMutableURLRequest(url: URL(string:strurl as String)!)
        
        request.httpMethod = "POST"

        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        for (key,value) in headers! {
            
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let imageData = image.lowQualityJPEGNSData
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: ApiParam, filePathKey: "file", imageDataKey: imageData, boundary: boundary) as Data
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main, completionHandler: { response, Data, error in
            
            print("Error K : \(String(describing: error))")
            
            
            if((error) == nil){


                do {
                    let Dict : NSMutableDictionary = try JSONSerialization.jsonObject(with: Data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                    let sJson = JSON(Dict as Any)
                    print(sJson)
                    if self.delegate != nil{
                        
                        self.delegate!.successResponseWithData(sJson: sJson)
                    }
                    
                }
                catch {
                    
                    print("fail")
                    if self.delegate != nil {
                        
                        self.delegate?.failResponseWithError(error: error as NSError)
                    }
                }
               
            }
            else {
                
                if self.delegate != nil {
                    
                    self.delegate?.failResponseWithError(error: error! as NSError)
                }
            }
        })
     }
    }
    
    
    func apiImageupload(ApiLink strurl:String,image : UIImage,headers:[String:String]?,ApiParam:[String:String]?){
        
        let status = Reach().connectionStatus()
        
        switch status {
            
        case .unknown, .offline:
            print("Network issue")
            
            if self.delegate != nil{
                
                self.delegate!.internetConnectionOffline()
                return
            }
            
            
        default:
            
            print("\(API_URL)\(strurl)")
            Alamofire.upload(multipartFormData: { multipartFormData in
                
                if let imageData = UIImagePNGRepresentation(image) {
                    
                   multipartFormData.append(imageData, withName: "file", fileName: "file.png", mimeType: "image/png")

                }
                for (key, value) in ApiParam! {
                    
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                    
                }
                
            }, usingThreshold: UInt64.init(), to: "\(API_URL)\(strurl)", method: .post, headers: headers, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        
                        let sJson = JSON(response.result.value as Any)
                        
                        self.delegate!.successResponseWithData(sJson: sJson)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    if self.delegate != nil {
                        
                        self.delegate?.failResponseWithError(error: encodingError as NSError)
                    }
                }
            })
        }
    }

    
   
}
