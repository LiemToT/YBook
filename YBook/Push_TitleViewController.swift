//
//  Push_TitleViewController.swift
//  YBook
//
//  Created by linyi on 16/5/20.
//  Copyright © 2016年 linyi. All rights reserved.
//

typealias Push_TitleCallBack = (content: String) -> Void

import UIKit

class Push_TitleViewController: UIViewController {

    var textField: UITextField?
    
    var callBack: Push_TitleCallBack?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        self.textField = UITextField(frame: CGRectMake(15, 60, SCREEN_WIDTH - 30, 30))
        self.textField?.placeholder = "书评标题"
        self.textField?.font = UIFont(name: MY_FONT, size: 15)
        self.view.addSubview(self.textField!)
        
        self.textField?.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func confirm() {
        self.callBack!(content: (self.textField?.text)!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
