//
//  MoreViewController.swift
//  YBook
//
//  Created by linyi on 16/5/19.
//  Copyright © 2016年 linyi. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let btn = UIButton(type: .System)
        btn.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT / 2 - 15, 60, 30)
        btn.setTitle("退出登录", forState: .Normal)
        btn.addTarget(self, action: Selector("logout"), forControlEvents: .TouchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func logout() {
        AVUser.logOut()
        
        let story = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = story.instantiateViewControllerWithIdentifier("Login")
        self.presentViewController(loginVC, animated: true, completion: nil)
    }
}
