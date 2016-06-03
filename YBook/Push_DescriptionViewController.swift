//
//  Push_DescriptionViewController.swift
//  YBook
//
//  Created by linyi on 16/5/20.
//  Copyright © 2016年 linyi. All rights reserved.
//

import UIKit

typealias Push_DescriptionViewControllerBlock = (desription: String) -> Void

class Push_DescriptionViewController: UIViewController {

    var textView: JVFloatLabeledTextView?
    var callBack: Push_DescriptionViewControllerBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        self.view.tintColor = UIColor.grayColor()
        
        self.textView = JVFloatLabeledTextView(frame: CGRectMake(8, 58, SCREEN_WIDTH - 16, SCREEN_HEIGHT - 58 - 8))
        self.view.addSubview(self.textView!)
        self.textView?.placeholder = "       你可以在这里撰写详细的评价、吐槽、介绍～～"
        self.textView?.font = UIFont(name: MY_FONT, size: 17)
        self.textView?.becomeFirstResponder()
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(UIKeyboardWillShowNotification, object: nil).subscribeNext { (object) -> Void in
            let keyboardFrame = object.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
            self.textView?.contentInset = UIEdgeInsetsMake(0, 0, (keyboardFrame?.size.height)!, 0)
        }
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(UIKeyboardWillHideNotification, object: nil).subscribeNext { (object) -> Void in
            self.textView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func confirm() {
        self.callBack!(desription: (self.textView?.text)!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}













