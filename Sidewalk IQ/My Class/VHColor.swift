          // = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = //
         //                                                               //
        //  📍 Created by Vipul Dudhat on 06/10/17. 📌                   //
       //  📍 Copyright © 2017 SCC INFOTECH LLP. All rights reserved. 📌//
      //                                                               //
     // = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = //


import UIKit


extension UIColor {
    
     // USE OF COLOR 
    // ---------------------------------------
   // view.backroundColor = UIColor.themeColor
  // ----------------------------------------
    
    static var themeColor : UIColor {
        get{
            return UIColor(red: 168/255.0, green: 215/255.0, blue: 111/255.0, alpha: 1.0)
        }
    }
    
    static var appColor : UIColor {
        get{
            return UIColor(red: 109/255.0, green: 183/255.0, blue: 215/255.0, alpha: 1.0)
        }
    }
    
    static var appAlphaColor : UIColor {
        get{
            return UIColor(red: 237/255.0, green: 255/255.0, blue: 246/255.0, alpha: 1.0)
        }
    }
}
