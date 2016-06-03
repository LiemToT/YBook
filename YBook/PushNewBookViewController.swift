//
//  PushNewBookViewController.swift
//  YBook
//
//  Created by linyi on 16/5/19.
//  Copyright © 2016年 linyi. All rights reserved.
//

import UIKit

class PushNewBookViewController: UIViewController, BookTitleDelegate, PhotoPickerDelegate, VPImageCropperDelegate, UITableViewDelegate, UITableViewDataSource{

    var bookTitleView: BookTitleView?
    var tableView: UITableView?
    var score: LDXScore?
    
    var titleArray: Array<String> = []
    var bookTitle = ""
    var isScoreShowed = false
    var bookType = "文学"
    var detailType = "小说"
    var bookDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.bookTitleView = BookTitleView(frame: CGRectMake(0, 40, SCREEN_WIDTH, 160))
        self.bookTitleView?.delegate = self
        self.view.addSubview(bookTitleView!)
        
        self.tableView = UITableView(frame: CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT - 200), style: .Grouped)
        self.tableView?.tableFooterView = UIView()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        self.tableView?.backgroundColor = RGB(250, g: 250, b: 250)
        self.view.addSubview(self.tableView!)
        
        self.titleArray = ["标题", "评分", "分类", "书评"]
        
        self.score = LDXScore(frame: CGRectMake(100, 10, 100, 22))
        self.score?.isSelect = true
        self.score?.normalImg = UIImage(named: "btn_star_evaluation_normal")
        self.score?.highlightImg = UIImage(named: "btn_star_evaluation_press")
        self.score?.show_star = 5
        self.score?.max_star = 5
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("pushBookCallBack:"), name: "PushBookCallBack", object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pushBookCallBack(noti: NSNotification) {
        if String(noti.userInfo!["success"]!) == "true" {
            ProgressHUD.showSuccess("上传成功")
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            ProgressHUD.showError("上传失败")
        }
    }
    
    func choiceCover() {
        let vc = PhotoPickerViewController()
        vc.delegate = self
        self.presentViewController(vc, animated: true) { () -> Void in
            
        }
    }
    
    func getImageFromPicker(image: UIImage) {
        let croVC = VPImageCropperViewController(image: image, cropFrame: CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_WIDTH * 1.273), limitScaleRatio: 3)
        croVC.delegate = self
        self.presentViewController(croVC, animated: true, completion: nil)
    }
    
    func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func confirm() {
        let dict: NSDictionary = [
            "BookName" : (self.bookTitleView?.bookName?.text)!,
            "BookEditor" : (self.bookTitleView?.bookEditor?.text)!,
            "BookCover" : (self.bookTitleView?.bookCover?.currentImage)!,
            "BookTitle" : self.bookTitle,
            "Score" : String((self.score?.show_star)!),
            "Type" : self.bookType,
            "DetailType" : self.detailType,
            "Description" : self.bookDescription,
        ]
        PushBook.pushBookInBack(dict)
    }
    
    //MARK: VPImageCropperDelegate Methods
    
    func imageCropperDidCancel(cropperViewController: VPImageCropperViewController!) {
        cropperViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imageCropper(cropperViewController: VPImageCropperViewController!, didFinished editedImage: UIImage!) {
        self.bookTitleView?.bookCover?.setImage(editedImage, forState: .Normal)
        cropperViewController.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    
    //MARK: TableView Delegate && DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        if cell != nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "Cell")
        } else {
            for view in cell!.contentView.subviews {
                view.removeFromSuperview()
            }
        }
        
        if (indexPath.row != 1) {
            cell!.accessoryType = .DisclosureIndicator
        }
        
        cell!.textLabel?.font = UIFont(name: MY_FONT, size: 15)
        cell!.detailTextLabel?.font = UIFont(name: MY_FONT, size: 13)
        cell!.textLabel?.text = titleArray[indexPath.row]
        
        var row = indexPath.row
        
        if self.isScoreShowed && row > 1 {
            row--
        }
        
        switch row {
            case 0:
                cell?.detailTextLabel?.text = self.bookTitle
                break
            case 1:
                break
            case 2:
                cell?.detailTextLabel?.text = self.bookType + "->" + self.detailType
                break
            case 4:
                let textView = UITextView(frame: CGRectMake(4, 4, SCREEN_WIDTH - 8, 80))
                textView.font = UIFont(name: MY_FONT, size: 14)
                textView.text = self.bookDescription
                textView.editable = false
                cell?.accessoryType = .None
                cell?.contentView.addSubview(textView)
                break
            default:
                break
        }
        
        if self.isScoreShowed && indexPath.row == 2 {
            cell?.contentView.addSubview(self.score!)
            cell?.accessoryType = .None
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        var row = indexPath.row
        
        if self.isScoreShowed && row > 1 {
            row -= 1
        }
        
        switch row {
        case 0:
            self.tableViewSelectTitle()
            break
        case 1:
            self.tableViewSelectScore()
            break
        case 2:
            self.tableViewSelectType()
            break
        case 3:
            self.tableViewSelectDescription()
            break
        default:
            break
        }

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.isScoreShowed && indexPath.row > 4 {
            return 88
        } else if !self.isScoreShowed && indexPath.row > 3 {
            return 88
        } else {
            return 44
        }
    }
    
    //MARK: Select Method
    
    /**
    *  选择标题
    */
    func tableViewSelectTitle() {
        let vc = Push_TitleViewController()
        GeneralFactory.addTargetWithTitle(vc, title: "取消", title2: "确定")
        vc.callBack = { (title) -> Void in
            self.bookTitle = title
            self.tableView?.reloadData()
        }
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    /**
     *  选择评分
     */
    func tableViewSelectScore() {
        self.tableView?.beginUpdates()
        
        let indexPaths = [NSIndexPath(forRow: 2, inSection: 0)]
        
        if self.isScoreShowed {
            self.titleArray.removeAtIndex(2)
            self.tableView?.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Right)
        } else{
            self.titleArray.insert("", atIndex: 2)
            self.tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Left)
        }
        
        self.isScoreShowed = !self.isScoreShowed
        
        self.tableView?.endUpdates()
    }
    
    /**
     *  选择分类
     */
    func tableViewSelectType() {
        let vc = Push_TypeViewController()
        GeneralFactory.addTargetWithTitle(vc, title: "取消", title2: "确定")
        
        let btn1 = vc.view.viewWithTag(1234) as? UIButton
        let btn2 = vc.view.viewWithTag(1235) as? UIButton
        
        btn1?.setTitleColor(RGB(38, g: 82, b: 67), forState: .Normal)
        btn2?.setTitleColor(RGB(38, g: 82, b: 67), forState: .Normal)
        
        vc.callBack = { (type, detailType) -> Void in
            self.bookType = type
            self.detailType = detailType
            self.tableView?.reloadData()
        }
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    /**
     *  选择书评
     */
    func tableViewSelectDescription() {
        let vc = Push_DescriptionViewController()
        GeneralFactory.addTargetWithTitle(vc, title: "取消", title2: "确定")
        vc.textView?.text = self.bookDescription
        vc.callBack = { (description: String) -> Void in
            self.bookDescription = description
            
            if self.titleArray.last == "" {
                self.titleArray.removeLast()
            }
            
            if self.bookDescription != "" {
                self.titleArray.append("")
            }
            
            self.tableView?.reloadData()
        }
        self.presentViewController(vc, animated: true, completion: nil)
    }
}





























