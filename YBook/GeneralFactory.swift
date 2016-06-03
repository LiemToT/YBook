//
//  GeneralFactory.swift
//  YBook
//
//  Created by linyi on 16/5/19.
//  Copyright © 2016年 linyi. All rights reserved.
//

import UIKit

class GeneralFactory: NSObject {
    
    static func addTargetWithTitle(target: UIViewController, title: String = "关闭", title2: String = "确认") {
        let btn1 = UIButton(frame: CGRectMake(10, 20, 40, 20))
        btn1.titleLabel?.font = UIFont(name: MY_FONT, size: 15)
        btn1.setTitle(title, forState: .Normal)
        btn1.contentHorizontalAlignment = .Center
        btn1.setTitleColor(MAIN_RED, forState: .Normal)
        btn1.tag = 1234
        target.view.addSubview(btn1)
        
        let btn2 = UIButton(frame: CGRectMake(SCREEN_WIDTH - 50, 20, 40, 20))
        btn2.titleLabel?.font = UIFont(name: MY_FONT, size: 16)
        btn2.setTitle(title2, forState: .Normal)
        btn2.contentHorizontalAlignment = .Center
        btn2.setTitleColor(MAIN_RED, forState: .Normal)
        btn2.tag = 1235
        target.view.addSubview(btn2)
        
        btn1.addTarget(target, action: Selector("close"), forControlEvents: .TouchUpInside)
        btn2.addTarget(target, action: Selector("confirm"), forControlEvents: .TouchUpInside)
    }
}
