//
//  MineHeadView.swift
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/7.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

import UIKit

class MineHeadView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var userHead:Person?{
        didSet {
            avaterImageView.sd_setImage(with: userHead?.icon)
        }
    }
    
    func setupUI() {
        addSubview(avaterImageView)
        addSubview(userNameLabel)
        addSubview(loginStateLable)
        self.backgroundColor = UIColor.red;
        avaterImageView.frame = CGRect(x: SCREENWIDTH/2-44, y:20 , width: 88, height: 88)
        userNameLabel.frame = CGRect(x: 0, y: 123, width: SCREENWIDTH, height: 33)
    }
    
    //用户图像
    lazy var avaterImageView:UIImageView = {
        let avaImageView = UIImageView()
        avaImageView.contentMode = .scaleAspectFill
        return avaImageView
    }()
    
    // 用户名
    lazy var userNameLabel:UILabel = {
       
        let userNameLabel = UILabel()
        userNameLabel.textAlignment = .center
        userNameLabel.text = "张雪迎"
        userNameLabel.font = UIFont.systemFont(ofSize: 16)
        userNameLabel.textColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1)
        return userNameLabel
    }()
    
    // 最近一次登录
    
    lazy var loginStateLable:UILabel = {
        
        let loginStatelable = UILabel()
        loginStatelable.font = UIFont.systemFont(ofSize: 18)
        loginStatelable.textColor = UIColor(colorLiteralRed: 110, green: 110, blue: 110, alpha: 1)
        return loginStatelable
    }()
    
    // 累计登录
}
