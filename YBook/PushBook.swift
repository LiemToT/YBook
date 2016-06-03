//
//  PushBook.swift
//  YBook
//
//  Created by linyi on 16/5/22.
//  Copyright © 2016年 linyi. All rights reserved.
//

import UIKit

class PushBook: NSObject {
    static func pushBookInBack(dict: NSDictionary) {
        let object = AVObject(className: "Book")
        object.setObject(dict["BookName"], forKey: "BookName")
        object.setObject(dict["BookEditor"], forKey: "BookEditor")
        object.setObject(dict["BookTitle"], forKey: "BookTitle")
        object.setObject(dict["Score"], forKey: "Score")
        object.setObject(dict["Type"], forKey: "Type")
        object.setObject(dict["DetailType"], forKey: "DetailType")
        object.setObject(dict["Description"], forKey: "Description")
        object.setObject(AVUser.currentUser(), forKey: "User")
        
        let cover = dict["BookCover"] as? UIImage
        let coverFile = AVFile.fileWithData(UIImageJPEGRepresentation(cover!, 0.8))
        coverFile.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                object.setObject(coverFile, forKey: "Cover")
                object.saveEventually({ (success, error) -> Void in
                    if success {
                       NSNotificationCenter.defaultCenter().postNotificationName("PushBookCallBack", object: nil, userInfo: ["success" : "true"])
                    } else {
                        NSNotificationCenter.defaultCenter().postNotificationName("PushBookCallBack", object: nil, userInfo: ["success" : "false"])
                    }
                })
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName("PushBookCallBack", object: nil, userInfo: ["success" : "false"])
            }
        }
    }
}
