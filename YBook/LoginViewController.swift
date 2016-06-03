//
//  LoginViewController.swift
//  YBook
//
//  Created by linyi on 16/5/22.
//  Copyright © 2016年 linyi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var topLayout: NSLayoutConstraint!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func login(sender: AnyObject) {
        let userName = self.userName.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        AVUser.logInWithUsernameInBackground(userName, password: self.password.text) { (user, error) -> Void in
            if error == nil {
                ProgressHUD.showSuccess("登录成功")
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                var errorMsg = ""
                
                switch error.code {
                    case 205:
                        errorMsg = "找不到电子邮箱地址对应的用户"
                        break
                    case 210:
                        errorMsg = "用户名密码不匹配"
                        break
                    case 211:
                        errorMsg = "找不到用户"
                        break
                    case 216:
                        AVUser.logOut()
                        errorMsg = "邮箱未验证"
                        break
                    case 217:
                        errorMsg = "无效的用户名"
                        break
                    case 218:
                        errorMsg = "无效的密码"
                        break
                    case 124:
                        errorMsg = "网络超时"
                        break
                    default:
                        errorMsg = "登录失败"
                        break
                }
                
                ProgressHUD.showError(errorMsg)
            }
        }
    }

}
