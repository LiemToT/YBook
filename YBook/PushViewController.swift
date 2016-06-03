//
//  PushViewController.swift
//  YBook
//
//  Created by linyi on 16/5/19.
//  Copyright © 2016年 linyi. All rights reserved.
//

import UIKit

class PushViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var dataArray = NSMutableArray()
    var tableView: UITableView?
    var navigationView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        self.setNavigationBar()
        
        tableView = UITableView(frame: self.view.frame)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.tableFooterView = UIView()
        tableView?.registerClass(PushBookTableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView!)
        
        tableView?.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("headerRefresh"))
        tableView?.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: Selector("footerRefresh"))
        
        tableView?.mj_header.beginRefreshing()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationView?.hidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationView?.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigationBar() {
        navigationView = UIView(frame: CGRectMake(0, -20, SCREEN_WIDTH, 65))
        navigationView!.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.addSubview(navigationView!)
        
        let addBookBtn = UIButton(frame: CGRectMake(20, 20, SCREEN_WIDTH, 45))
        
        addBookBtn.setImage(UIImage(named: "plus circle"), forState: .Normal)
        addBookBtn.setTitle("       新建书评", forState: .Normal)
        addBookBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        addBookBtn.titleLabel?.font = UIFont(name: MY_FONT, size: 18.0)
        addBookBtn.contentHorizontalAlignment = .Left
        addBookBtn.addTarget(self, action: Selector("pushNewBook"), forControlEvents: .TouchUpInside)
        
        navigationView!.addSubview(addBookBtn)
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "删除") { (action, indexPath) -> Void in
            let object = self.dataArray[indexPath.row] as? AVObject
            
        }
        deleteAction.backgroundColor = UIColor.greenColor()
        
        let editAction = UITableViewRowAction(style: .Default, title: "编辑") { (action, indexPath) -> Void in
            print("Edit")
        }
        
        editAction.backgroundColor = UIColor.orangeColor()
        
        return [deleteAction, editAction]
    }
    
    func pushNewBook() {
        let vc = PushNewBookViewController()
        GeneralFactory.addTargetWithTitle(vc, title: "取消", title2: "发布")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? PushBookTableViewCell
        let dict = self.dataArray[indexPath.row] as? AVObject
        
        cell?.bookName?.text = "《" + (dict!["BookName"] as! String) + "》:" + (dict!["BookTitle"] as! String)
        cell?.editor?.text = "作者:" + (dict!["BookEditor"] as! String)
        
        let date = dict!["createdAt"] as? NSDate
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        cell?.more?.text = formatter.stringFromDate(date!)
        
        let coverFile = dict!["Cover"] as? AVFile
        cell?.cover?.sd_setImageWithURL(NSURL(string: (coverFile?.url)!), placeholderImage: UIImage(named: "Cover"))
        
        
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let vc = BookDetailViewController()
        vc.bookObject = self.dataArray[indexPath.row] as? AVObject
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
    *  上拉加载 下拉刷新
    */
    func headerRefresh() {
        let query = AVQuery(className: "Book")
        query.orderByDescending("createdAt")
        query.limit = 20
        query.whereKey("User", equalTo: AVUser.currentUser())
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.tableView?.mj_header.endRefreshing()
            
            if error == nil {
                self.dataArray.removeAllObjects()
                self.dataArray.addObjectsFromArray(results)
                self.tableView?.reloadData()
            }
        }
    }
    
    func footerRefresh() {
        let query = AVQuery(className: "Book")
        query.orderByDescending("createdAt")
        query.limit = 20
        query.skip = self.dataArray.count
        query.whereKey("User", equalTo: AVUser.currentUser())
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.tableView?.mj_footer.endRefreshing()
            if error == nil {
                self.dataArray.addObjectsFromArray(results)
                self.tableView?.reloadData()
            }
        }
    }
}
