//
//  DiscussCell.swift
//  YBook
//
//  Created by linyi on 16/5/25.
//  Copyright © 2016年 linyi. All rights reserved.
//

import UIKit

class DiscussCell: UITableViewCell {

    var avatarImage: UIImageView?
    var nameLabel: UILabel?
    var detailLabel: UILabel?
    var dateLabel: UILabel?
    
    func initFrame() {
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        avatarImage = UIImageView(frame: CGRectMake(8, 8, 40, 40))
        avatarImage?.layer.cornerRadius = 20
        avatarImage?.layer.masksToBounds = true
        contentView.addSubview(avatarImage!)
        
        nameLabel = UILabel(frame: CGRectMake(56, 8, SCREEN_WIDTH - 56 - 8, 15))
        nameLabel?.font = UIFont(name: MY_FONT, size: 13)
        contentView.addSubview(nameLabel!)
        
        dateLabel = UILabel(frame: CGRectMake(56, frame.size.height - 8 - 10, SCREEN_WIDTH - 56 - 8, 10))
        dateLabel?.font = UIFont(name: MY_FONT, size: 13)
        dateLabel?.textColor = UIColor.grayColor()
        contentView.addSubview(dateLabel!)
        
        detailLabel = UILabel(frame: CGRectMake(56, 30, SCREEN_WIDTH - 56 - 8, frame.size.height - 30 - 25))
        detailLabel?.font = UIFont(name: MY_FONT, size: 15)
        detailLabel?.numberOfLines = 0
        contentView.addSubview(detailLabel!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
