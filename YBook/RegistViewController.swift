//
//  RegistViewController.swift
//  YBook
//
//  Created by linyi on 16/5/22.
//  Copyright © 2016年 linyi. All rights reserved.
//

import UIKit

class RegistViewController: UIViewController {

    @IBOutlet weak var topLayout: NSLayoutConstraint!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
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
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func regist(sender: AnyObject) {
        let user = AVUser()
        user.username = self.userName.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        user.password = self.password.text
        user.email = self.email.text
        
        user.signUpInBackgroundWithBlock { (success, error) -> Void in
            if success {
                ProgressHUD.showSuccess("注册成功,请验证邮箱")
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                var msgError = ""
                
                //String(error.code)
                print("errorCode:\(error.code)")
                
                switch error.code {
                    
                    case 124:
                        msgError = "网络超时"
                        break
                    case 125:
                        msgError = "电子邮箱地址无效"
                        break
                    case 126:
                        msgError = "无效的用户Id，可能用户不存在"
                        break
                    case 139:
                        msgError = "用户名非法"
                        break
                    case 217:
                        msgError = "用户名不能为空"
                        break
                    case 218:
                        msgError = "密码不能为空"
                        break
                    case 202:
                        msgError = "用户名已经被占用"
                        break
                    case 203:
                        msgError = "电子邮箱地址已经被占用"
                        break
                    case 203:
                        msgError = "没有提供电子邮箱地址"
                        break
                    default:
                        msgError = "注册失败"
                        break
                }
                
                ProgressHUD.showError(msgError)
            }
        }
    }
}
