//
//  CommentViewController.swift
//  YBook
//
//  Created by linyi on 16/5/25.
//  Copyright © 2016年 linyi. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, InputViewDelegate {

    var tableView: UITableView?
    lazy var dataArray = NSMutableArray()
    var bookObject: AVObject?
    var input: InputView?
    var layView: UIView?
    var keyboardHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        let btn = self.view.viewWithTag(1234)
        btn?.hidden = true
        
        let titleLabel = UILabel(frame: CGRectMake(0, 20, SCREEN_WIDTH, 44))
        titleLabel.text = "讨论区"
        titleLabel.font = UIFont(name: MY_FONT, size: 17)
        titleLabel.textAlignment = .Center
        titleLabel.textColor = MAIN_RED
        self.view.addSubview(titleLabel)
        
        tableView = UITableView(frame: CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44))
        tableView?.registerClass(DiscussCell.self, forCellReuseIdentifier: "Cell")
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.tableFooterView = UIView()
        self.view.addSubview(tableView!)
        
        self.tableView?.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefresh")
        self.tableView?.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: "footerRefresh")
        
        input = NSBundle.mainBundle().loadNibNamed("InputView", owner: self, options: nil).last as? InputView
        input?.frame = CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)
        input?.delegate = self
        view.addSubview(input!)
        
        layView = UIView(frame: view.frame)
        layView?.backgroundColor = UIColor.grayColor()
        layView?.alpha = 0
        layView?.hidden = true
        let tap = UITapGestureRecognizer(target: self, action: Selector("tapLayView"))
        layView?.addGestureRecognizer(tap)
        
        view.insertSubview(layView!, belowSubview: input!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func confirm() {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    func tapLayView() {
       input?.inputTextView?.resignFirstResponder()
    }
    
// MARK: - Refresh Method
    func headerRefresh() {
        let query = AVQuery(className: "Discuss")
        query.orderByDescending("createdAt")
        query.limit = 20
        query.whereKey("BookObject", equalTo: self.bookObject)
        query.includeKey("BookObject")
        query.includeKey("User")
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.tableView?.mj_header.endRefreshing()
            
            if results != nil && results.count != 0 {
                self.dataArray.removeAllObjects()
                self.dataArray.addObjectsFromArray(results)
                self.tableView?.reloadData()
            }
        }
    }
    
    func footerRefresh() {
        let query = AVQuery(className: "Discuss")
        query.orderByDescending("createdAt")
        query.limit = 20
        query.skip = dataArray.count
        query.whereKey("BookObject", equalTo: self.bookObject)
        query.includeKey("BookObject")
        query.includeKey("User")
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.tableView?.mj_footer.endRefreshing()
            
            if results != nil && results.count != 0 {
                self.dataArray.addObjectsFromArray(results)
                self.tableView?.reloadData()
            }
        }
    }
    
// MARK: - InputViewDelegate
    func publishButtonDidClick(button: UIButton!) {
        ProgressHUD.show("")
        
        let object = AVObject(className: "Discuss")
        object.setObject(input?.inputTextView?.text, forKey: "Text")
        object.setObject(bookObject, forKey: "BookObject")
        object.setObject(AVUser.currentUser(), forKey: "User")
        object.saveInBackgroundWithBlock { (success, error) -> Void in
            self.input?.inputTextView?.resignFirstResponder()
            ProgressHUD.showSuccess("评论成功")
        }
    }
    
    func textViewHeightDidChange(height: CGFloat) {
        input?.height = height + 10
        input?.bottom = SCREEN_HEIGHT - keyboardHeight
    }
    
    func keyboardWillHide(inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: NSTimeInterval, animationCurve: UIViewAnimationCurve) {
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.input?.bottom = SCREEN_HEIGHT
            self.layView?.alpha = 0
            }) { (finish) -> Void in
                self.layView?.hidden = true
                self.input?.inputTextView?.text = ""
                self.input?.resetInputView()
                self.input?.bottom = SCREEN_HEIGHT
                self.tableView?.mj_header.beginRefreshing()
        }
    }
    
    func keyboardWillShow(inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: NSTimeInterval, animationCurve: UIViewAnimationCurve) {
        self.keyboardHeight = keyboardHeight
        layView?.hidden = false
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.layView?.alpha = 0.4
            self.input?.bottom = SCREEN_HEIGHT - keyboardHeight
            }) { (finish) -> Void in
                
        }
    }
}

// MARK: - TableView Delegate && DataSource
extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? DiscussCell
        
        cell?.initFrame()
        
        let object = dataArray[indexPath.row] as? AVObject
        let user = object!["User"] as? AVUser
        
        
        cell?.nameLabel?.text = user!.username
        cell?.avatarImage?.image = UIImage(named: "Avatar")
        
        let date = object!["createdAt"] as? NSDate
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        cell?.dateLabel?.text = formatter.stringFromDate(date!)
        
        cell?.detailLabel?.text = object!["Text"] as? String
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let object = dataArray[indexPath.row] as? AVObject
        let text = object!["Text"] as? NSString
        let textSize = text?.boundingRectWithSize(CGSizeMake(SCREEN_WIDTH - 56 - 8, 0), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(15)], context: nil).size
        
        return (textSize?.height)! + 30 + 25
    }
}











