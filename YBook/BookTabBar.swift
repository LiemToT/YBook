//
//  BookTabBar.swift
//  YBook
//
//  Created by linyi on 16/5/23.
//  Copyright © 2016年 linyi. All rights reserved.
//

import UIKit

protocol BookTabBarDelegate:class {
    func comment()
    func commentController()
    func likeBook(btn: UIButton)
    func shareAction()
}

class BookTabBar: UIView {

    weak var delegate: BookTabBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = UIColor.whiteColor()
        
        let imageName = ["Pen 4", "chat 3", "heart", "box outgoing"]
        for var i = 0; i < 4; i++ {
            let btn = UIButton(frame: CGRectMake(CGFloat(i) * frame.size.width / 4.0, 0, frame.size.width / 4, frame.size.height))
            btn.setImage(UIImage(named: imageName[i]), forState: .Normal)
            self.addSubview(btn)
            btn.tag = i
            btn.addTarget(self, action: Selector("bookTabBarAction:"), forControlEvents: .TouchUpInside)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 0.5)
        
        for var i = 1; i < 4; i++ {
            CGContextMoveToPoint(context, CGFloat(i) * rect.size.width / 4, rect.size.height * 0.1)
            CGContextAddLineToPoint(context, CGFloat(i) * rect.size.width / 4, rect.size.height * 0.9)
        }
        
        CGContextSetRGBStrokeColor(context, 231/255, 231/255, 231/255, 1.0)
        CGContextMoveToPoint(context, 8, 0)
        CGContextAddLineToPoint(context, rect.size.width - 8, 0)
        CGContextStrokePath(context)
    }

    func bookTabBarAction(btn: UIButton) {
        
        switch btn.tag {
        case 0:
            self.delegate!.comment()
        case 1:
            self.delegate!.commentController()
        case 2:
            self.delegate!.likeBook(btn)
        case 3:
            self.delegate!.shareAction()
        default:
            break
        }
    }
}
