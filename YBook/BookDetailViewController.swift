//
//  BookDetailViewController.swift
//  YBook
//
//  Created by linyi on 16/5/23.
//  Copyright © 2016年 linyi. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController, BookTabBarDelegate, InputViewDelegate {

    var bookObject: AVObject?
    var bookTitleView: BookDetailView?
    var bookTabBar: BookTabBar?
    var bookTextView: UITextView?
    var keyboardHeight: CGFloat = 0.0
    
    lazy var input: InputView = {
        var inputTemp = NSBundle.mainBundle().loadNibNamed("InputView", owner: self, options: nil).last as! InputView
        inputTemp.frame = CGRectMake(0, SCREEN_WIDTH - 44, SCREEN_WIDTH, 44)
        inputTemp.delegate = self
        self.view.addSubview(inputTemp)
        return inputTemp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.tintColor = UIColor.grayColor()
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Default)
        
        self.initBookDetailView()
        
        self.bookTabBar = BookTabBar(frame: CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40))
        self.view.addSubview(self.bookTabBar!)
        self.view.subviews
        self.bookTabBar?.delegate = self
        
        self.bookTextView = UITextView(frame: CGRectMake(0, 64 + SCREEN_HEIGHT / 4, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - SCREEN_HEIGHT / 4 - 40))
        self.bookTextView?.editable = false
        self.bookTextView?.text = self.bookObject!["Description"] as? String
        self.view.addSubview(self.bookTextView!)
        
        isLove()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     是否点赞初始化
     
     */
    func isLove() {
        let query = AVQuery(className: "Love")
        query.whereKey("User", equalTo: AVUser.currentUser())
        query.whereKey("BookObject", equalTo: bookObject)
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if results != nil && results.count != 0 {
                let btn = self.bookTabBar?.viewWithTag(2) as? UIButton
                btn?.setImage(UIImage(named: "solidheart"), forState: .Normal)
            }
        }
    }
    
    func initBookDetailView() {
        bookTitleView = BookDetailView(frame: CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT / 4))
        view.addSubview(self.bookTitleView!)
        
        let coverFile = self.bookObject!["Cover"] as? AVFile
        bookTitleView?.cover?.sd_setImageWithURL(NSURL(string: (coverFile?.url)!), placeholderImage: UIImage(named: "Cover"))
        
        bookTitleView?.bookName?.text = "《" + (self.bookObject!["BookName"] as! String) + "》"
        bookTitleView?.editor?.text = "作者: " + (self.bookObject!["BookEditor"] as! String)
        
        let user = self.bookObject!["User"] as? AVUser
        user?.fetchInBackgroundWithBlock({ (returnUser, error) -> Void in
            self.bookTitleView?.userName?.text = "编者: " + (returnUser as? AVUser)!.username
        })
        
        let date = self.bookObject!["createdAt"] as? NSDate
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        self.bookTitleView?.date?.text = format.stringFromDate(date!)
        
        let scoreString = self.bookObject!["Score"] as? String
        self.bookTitleView?.score?.show_star = Int(scoreString!)!
        
        self.bookTitleView?.more?.text = "65个喜欢,5此评论,12000次浏览"
    }
    
    /**
     Comment Input View Delegate
     */
    func publishButtonDidClick(button: UIButton!) {
        ProgressHUD.show("")
        
        let object = AVObject(className: "Discuss")
        object.setObject(self.bookObject, forKey: "BookObject")
        object.setObject(AVUser.currentUser(), forKey: "User")
        object.setObject(input.inputTextView?.text, forKey: "Text")
        object.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                self.input.inputTextView?.resignFirstResponder()
                ProgressHUD.showSuccess("评论成功")
            }
        }
    }
    
    func textViewHeightDidChange(height: CGFloat) {
        self.input.height = height + 10
        self.input.bottom = SCREEN_HEIGHT - self.keyboardHeight
    }
    
    func keyboardWillShow(inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: NSTimeInterval, animationCurve: UIViewAnimationCurve) {
        self.keyboardHeight = keyboardHeight
        UIView.animateWithDuration(duration, delay: 0, options: .BeginFromCurrentState, animations: { () -> Void in
            inputView.bottom = SCREEN_HEIGHT - keyboardHeight
            }, completion: nil)
    }
    
    func keyboardWillHide(inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: NSTimeInterval, animationCurve: UIViewAnimationCurve) {
        UIView.animateWithDuration(duration, delay: 0, options: .BeginFromCurrentState, animations: { () -> Void in
            inputView.bottom = SCREEN_HEIGHT + inputView.height
            }, completion: nil)
    }
    
    /**
    *  BookTabBar Delegate
    */
    func comment() {
        input.inputTextView?.becomeFirstResponder()
    }
    
    func commentController() {
        let vc = CommentViewController()
        GeneralFactory.addTargetWithTitle(vc, title: "", title2: "关闭")
        vc.bookObject = bookObject
        vc.tableView?.mj_header.beginRefreshing()
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func likeBook(btn: UIButton) {
        btn.enabled = false
        btn.setImage(UIImage(named: "redheart"), forState: .Normal)
        
        let query = AVQuery(className: "Love")
        query.whereKey("User", equalTo: AVUser.currentUser())
        query.whereKey("BookObject", equalTo: bookObject)
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if results != nil && results.count != 0 {
                let object = results[0] as? AVObject
                object?.deleteEventually()
                btn.setImage(UIImage(named: "heart"), forState: .Normal)
            } else {
                let object = AVObject(className: "Love")
                object.setObject(AVUser.currentUser(), forKey: "User")
                object.setObject(self.bookObject, forKey: "BookObject")
                object.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if success {
                        btn.setImage(UIImage(named: "solidheart"), forState: .Normal)
                    } else {
                        ProgressHUD.showError("操作失败")
                    }
                })
            }
            btn.enabled = true
        }
    }
    
    func shareAction() {
        let shareParams = NSMutableDictionary()
        shareParams.SSDKSetupShareParamsByText("分享内容", images: self.bookTitleView?.cover?.image, url: NSURL(string: "http://www.baidu.com"), title: "标题", type: SSDKContentType.Image)
        //        ShareSDK.share(.TypeWechat, parameters: shareParams) { (state, userData, contentEntity, error) -> Void in
        //            switch state{
        //            case SSDKResponseState.Success:
        //                ProgressHUD.showSuccess("分享成功")
        //                break
        //            case SSDKResponseState.Fail:
        //                ProgressHUD.showError("分享失败")
        //                break
        //            case SSDKResponseState.Cancel:
        //                ProgressHUD.showError("已取消分享")
        //                break
        //            default:
        //                break
        //            }
        //        }
        
        ShareSDK.showShareActionSheet(self.view, items: nil, shareParams: shareParams) { (state, platForm, userdata, contentEntity, error, success) -> Void in
            
            switch state{
            case SSDKResponseState.Success:
                ProgressHUD.showSuccess("分享成功")
                break
            case SSDKResponseState.Fail:
                ProgressHUD.showError("分享失败")
                break
            case SSDKResponseState.Cancel:
                ProgressHUD.showError("已取消分享")
                break
            default:
                break
            }
            
        }

    }
}
