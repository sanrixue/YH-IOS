//
//  UIView + Extension.swift
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/7.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

import UIKit

extension UIView {
    
    // 视图宽
    var width:CGFloat {
        get{
            return frame.size.width
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    
    // 视图高
    var height:CGFloat {
        get {
            return frame.size.height
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.size.height = newValue
            frame = tempFrame
        }
    }
    
    // 视图起始坐标
    var x:CGFloat {
        get {
            return frame.origin.x
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.origin.x = newValue
            frame = tempFrame
        }
    }
    
    // 视图起始坐标
    var y:CGFloat {
        get {
            return frame.origin.y
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.origin.y = newValue
            frame = tempFrame
        }
    }
    
    // 视图中心点
    var centerX:CGFloat {
        get{
            return center.x
        }
        set(newValue){
            var tempCenter:CGPoint = center
            tempCenter.x = newValue
            center = tempCenter
        }
    }
}
