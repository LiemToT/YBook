//
//  Push_TypeViewController.swift
//  YBook
//
//  Created by linyi on 16/5/20.
//  Copyright © 2016年 linyi. All rights reserved.
//

import UIKit

typealias Push_TypeViewControllerCallBack = (type: String, detailType: String) -> Void

class Push_TypeViewController: UIViewController, IGLDropDownMenuDelegate {

    var callBack: Push_TypeViewControllerCallBack?
    
    var segmentControl1: AKSegmentedControl?
    var segmentControl2: AKSegmentedControl?
    
    var literatureArray1:Array<NSDictionary> = []
    var literatureArray2:Array<NSDictionary> = []
    
    
    var humanitiesArray1:Array<NSDictionary> = []
    var humanitiesArray2:Array<NSDictionary> = []
    
    
    var livelihoodArray1:Array<NSDictionary> = []
    var livelihoodArray2:Array<NSDictionary> = []
    
    
    var economiesArray1:Array<NSDictionary> = []
    var economiesArray2:Array<NSDictionary> = []
    
    
    var technologyArray1:Array<NSDictionary> = []
    var technologyArray2:Array<NSDictionary> = []
    
    var NetworkArray1:Array<NSDictionary> = []
    var NetworkArray2:Array<NSDictionary> = []
    
    var dropDownMenu1:IGLDropDownMenu?
    var dropDownMenu2:IGLDropDownMenu?

    var type = ""
    var detailType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = RGB(231, g: 231, b: 231)
        
        let segmentLabel = UILabel(frame: CGRectMake((SCREEN_WIDTH - 300) / 2, 20, 300, 20))
        segmentLabel.textAlignment = .Center
        segmentLabel.textColor = RGB(82, g: 113, b: 131)
        segmentLabel.shadowColor = UIColor.whiteColor()
        segmentLabel.shadowOffset = CGSizeMake(0, 1)
        segmentLabel.font = UIFont(name: MY_FONT, size: 17)
        segmentLabel.text = "请选择分类"
        self.view.addSubview(segmentLabel)
        
        self.initSegmentControl()
        self.initDropArray()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func confirm() {
        self.callBack!(type: self.type, detailType: self.detailType)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     init Array
     */
    func initDropArray(){
        
        self.literatureArray1 = [
            ["title":"小说"],
            ["title":"漫画"],
            ["title":"青春文学"],
            ["title":"随笔"],
            ["title":"现当代诗"],
            ["title":"戏剧"],
        ];
        self.literatureArray2 = [
            ["title":"传记"],
            ["title":"古诗词"],
            ["title":"外国诗歌"],
            ["title":"艺术"],
            ["title":"摄影"],
        ];
        self.humanitiesArray1 = [
            ["title":"历史"],
            ["title":"文化"],
            ["title":"古籍"],
            ["title":"心理学"],
            ["title":"哲学/宗教"],
            ["title":"政治/军事"],
        ];
        self.humanitiesArray2 = [
            ["title":"社会科学"],
            ["title":"法律"],
        ];
        self.livelihoodArray1 = [
            ["title":"休闲/爱好"],
            ["title":"孕产/胎教"],
            ["title":"烹饪/美食"],
            ["title":"时尚/美妆"],
            ["title":"旅游/地图"],
            ["title":"家庭/家居"],
        ];
        self.livelihoodArray2 = [
            ["title":"亲子/家教"],
            ["title":"两性关系"],
            ["title":"育儿/早教"],
            ["title":"保健/养生"],
            ["title":"体育/运动"],
            ["title":"手工/DIY"],
        ];
        self.economiesArray1  = [
            ["title":"管理"],
            ["title":"投资"],
            ["title":"理财"],
            ["title":"经济"],
        ];
        self.economiesArray2  = [
            ["title":"没有更多了"],
        ];
        self.technologyArray1 =  [
            ["title":"科普读物"],
            ["title":"建筑"],
            ["title":"医学"],
            ["title":"计算机/网络"],
        ];
        self.technologyArray2 = [
            ["title":"农业/林业"],
            ["title":"自然科学"],
            ["title":"工业技术"],
        ];
        self.NetworkArray1 =    [
            ["title":"玄幻/奇幻"],
            ["title":"武侠/仙侠"],
            ["title":"都市/职业"],
            ["title":"历史/军事"],
        ];
        self.NetworkArray2 =    [
            ["title":"游戏/竞技"],
            ["title":"科幻/灵异"],
            ["title":"言情"],
        ];
    }

    
    func initSegmentControl() {
        let buttonArray1 = [
            ["image":"ledger","title":"文学","font":MY_FONT],
            ["image":"drama masks","title":"人文社科","font":MY_FONT],
            ["image":"aperture","title":"生活","font":MY_FONT],
        ]
        
        segmentControl1 = AKSegmentedControl(frame: CGRectMake(10,60,SCREEN_WIDTH-20,37))
        segmentControl1?.initButtonWithTitleandImage(buttonArray1)
        self.view.addSubview(segmentControl1!)
        
        let buttonArray2 = [
            ["image":"atom","title":"经管","font":MY_FONT],
            ["image":"alien","title":"科技","font":MY_FONT],
            ["image":"fire element","title":"网络流行","font":MY_FONT],
        ]
        segmentControl2 = AKSegmentedControl(frame: CGRectMake(10,110,SCREEN_WIDTH-20,37))
        segmentControl2?.initButtonWithTitleandImage(buttonArray2)
        self.view.addSubview(segmentControl2!)

        segmentControl1?.addTarget(self, action: Selector("segmentControlAction:"), forControlEvents: .ValueChanged)
        segmentControl2?.addTarget(self, action: Selector("segmentControlAction:"), forControlEvents: .ValueChanged)
    }
    
    func segmentControlAction(segmentControl: AKSegmentedControl) {
        var index = segmentControl.selectedIndexes.firstIndex
        
        self.type = ((segmentControl.buttonsArray[index] as? UIButton)?.currentTitle)!
        
        if segmentControl == segmentControl1 {
            segmentControl2?.setSelectedIndex(3)
        } else {
            segmentControl1?.setSelectedIndex(3)
            index += 3
        }
        
        if dropDownMenu1 != nil {
            dropDownMenu1?.resetParams()
        }
        
        if dropDownMenu2 != nil {
            dropDownMenu2?.resetParams()
        }
        
        switch index {
            case 0:
                self.createDropMenu(literatureArray1, array2: literatureArray2)
                break
            case 1:
                self.createDropMenu(humanitiesArray1, array2: humanitiesArray2)
                break
            case 2:
                self.createDropMenu(livelihoodArray1, array2: livelihoodArray2)
                break
            case 3:
                self.createDropMenu(economiesArray1, array2: economiesArray2)
                break
            case 4:
                self.createDropMenu(technologyArray1, array2: technologyArray2)
                break
            case 5:
                self.createDropMenu(NetworkArray1, array2: NetworkArray2)
                break
            default:
                break
        }
    }
    
    func createDropMenu(array1: Array<NSDictionary>, array2: Array<NSDictionary>) {
        let dropItems1 = NSMutableArray()
        
        for dict in array1 {
            let item = IGLDropDownItem()
            item.text = dict["title"] as? String
            dropItems1.addObject(item)
        }
        
        let dropItems2 = NSMutableArray()
        
        for dict in array2 {
            let item = IGLDropDownItem()
            item.text = dict["title"] as? String
            dropItems2.addObject(item)
        }
        
        dropDownMenu1?.removeFromSuperview()
        dropDownMenu1 = IGLDropDownMenu()
        
        dropDownMenu2?.removeFromSuperview()
        dropDownMenu2 = IGLDropDownMenu()
        
        initDropDownMenuWithFrameWithItems(dropDownMenu1!, frame: CGRectMake(20, 150, SCREEN_WIDTH / 2 - 30, (SCREEN_HEIGHT - 200) / 7), items: dropItems1)
        initDropDownMenuWithFrameWithItems(dropDownMenu2!, frame: CGRectMake(SCREEN_WIDTH / 2 + 10, 150, SCREEN_WIDTH / 2 - 30, (SCREEN_HEIGHT - 200) / 7), items: dropItems2)
    }
    
    func initDropDownMenuWithFrameWithItems(dropDownMenu: IGLDropDownMenu, frame:CGRect, items: NSArray) {
        dropDownMenu.menuText = "点我,展开详细列表"
        dropDownMenu.menuButton.textLabel.adjustsFontSizeToFitWidth = true
        dropDownMenu.menuButton.textLabel.textColor = RGB(38, g: 82, b: 67)
        dropDownMenu.paddingLeft = 15
        dropDownMenu.delegate = self
        dropDownMenu.type = .Stack
        dropDownMenu.gutterY = 5
        dropDownMenu.dropDownItems = items as [AnyObject]
        dropDownMenu.frame = frame
        self.view.addSubview(dropDownMenu)
        dropDownMenu.reloadView()
    }
    
    func dropDownMenu(dropDownMenu: IGLDropDownMenu!, selectedItemAtIndex index: Int) {
        let item = dropDownMenu?.dropDownItems[index] as? IGLDropDownItem
        self.detailType = (item?.text)!
        
        if dropDownMenu == dropDownMenu1 {
            dropDownMenu2?.menuButton.text = self.detailType
        } else {
            dropDownMenu1?.menuButton.text = self.detailType
        }
    }
}
















