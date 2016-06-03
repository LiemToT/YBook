//
//  BookTitleView.swift
//  YBook
//
//  Created by linyi on 16/5/19.
//  Copyright © 2016年 linyi. All rights reserved.
//

import UIKit

@objc protocol BookTitleDelegate {
    optional func choiceCover()
}

class BookTitleView: UIView {

    var bookCover: UIButton?
    var bookName: JVFloatLabeledTextField?
    var bookEditor: JVFloatLabeledTextField?
    weak var delegate: BookTitleDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        self.bookCover = UIButton(frame:  CGRectMake(10, 8, 110, 141))
        self.bookCover?.setImage(UIImage(named: "Cover"), forState: .Normal)
        self.addSubview(bookCover!)
        self.bookCover?.addTarget(self, action: Selector("choiceCover"), forControlEvents: .TouchUpInside)
        
        self.bookName = JVFloatLabeledTextField(frame: CGRectMake(128, 8 + 40, SCREEN_WIDTH - 128 - 15, 30))
        self.bookEditor = JVFloatLabeledTextField(frame: CGRectMake(128, 8 + 40 + 70, SCREEN_WIDTH - 128 - 15, 30))
        
        self.bookName?.placeholder = "书名"
        self.bookEditor?.placeholder = "作者"
        
        self.bookName?.floatingLabelFont = UIFont(name: MY_FONT, size: 14)
        self.bookEditor?.floatingLabelFont = UIFont(name: MY_FONT, size: 14)
        
        self.bookName?.font = UIFont(name: MY_FONT, size: 14)
        self.bookEditor?.font = UIFont(name: MY_FONT, size: 14)
        
        self.addSubview(self.bookName!)
        self.addSubview(self.bookEditor!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func choiceCover() {
        self.delegate?.choiceCover!()
    }
}
