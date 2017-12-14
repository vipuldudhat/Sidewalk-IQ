
     // = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = //
    //                                                               //
   //  📍 Created by Vipul Dudhat on 06/10/17. 📌                   //
  //  📍 Copyright © 2017 SCC INFOTECH LLP. All rights reserved. 📌//
 //                                                               //
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = //


import UIKit

  // - - - - - - - - - - - - - - - -
 // MARK:- 📍 Extension - UIView 📌
// - - - - - - - - - - - - - - - -

extension UIView {
    
    var vHeight : CGFloat {
        
        get { return self.frame.size.height }
        set { self.frame.size.height = newValue }
    }
    
    var vWidth : CGFloat {
        
        get { return self.frame.size.width }
        set { self.frame.size.width = newValue }
    }
    
    var XPOINT : CGFloat {
        
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    
    var YPOINT : CGFloat {
        
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    
   //view end point
    var YH : CGFloat {
        
        return self.frame.origin.y + self.frame.size.height
    }
    
    var XW : CGFloat {
        
        return self.frame.origin.x + self.frame.size.width
    }
    
    // hide & show
    func hideV(){
        
        self.isHidden = true
    }
    
    func showV(){
        
        self.isHidden = false
    }
    
    var cornerRadius : CGFloat {
        
        get { return  self.layer.cornerRadius }
        set {  self.layer.cornerRadius = newValue }
    }
    
    
    
    func setBorder(_ BW:CGFloat,color:UIColor) {

        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = BW
        self.clipsToBounds = true
    }
    
    func CircleWith(Color BGcolor:UIColor) {
        
        self.layer.cornerRadius = self.vWidth/2
        self.clipsToBounds = true
        self.backgroundColor = BGcolor
    }
    // screenshot of view
    var VHSnapshot : UIImage {
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func moveSlider(At NewP:CGFloat){
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut, animations: {
            self.frame.origin.x = NewP
            
        }, completion: nil)
        
    }
    
    func pastViewFrom(View V2:UIView){
        
        self.frame = V2.frame
        self.backgroundColor = V2.backgroundColor
        self.layer.cornerRadius = V2.layer.cornerRadius
        self.clipsToBounds = V2.clipsToBounds
        self.contentMode = V2.contentMode
        
    }
    
    func setShado() {
        
        let layer = self.layer
//      let shadowPath: UIBezierPath = UIBezierPath(rect: self.bounds)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5.0
     // layer.cornerRadius = 10.0
     // layer.shadowPath = shadowPath.CGPath
        
        layer.masksToBounds = false
    }
    
    func setShadoWith(color:UIColor) {
        
        let layer = self.layer
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 10.0
        
        layer.masksToBounds = false
    }
    
    
}
