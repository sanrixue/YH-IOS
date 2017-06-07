//
//  NoticeTableViewCell.swift
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/7.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {

    @IBOutlet weak var noticeContentLabel: UILabel!
    @IBOutlet weak var noticeTime: UILabel!
    @IBOutlet weak var noticeNameLable: UILabel!
    @IBOutlet weak var noticeImage: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        //timeLable.text = "最美的晴天"
        // Initialization code
    }
    
    var notice:String?{
       didSet{
           noticeNameLable.text = notice!
        noticeContentLabel.text = "很好很好"
        noticeTime.text = "12121212"
        
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
