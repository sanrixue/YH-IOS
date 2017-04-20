//
//  YHMarkerV.swift
//  SwiftCharts
//
//  Created by CJG on 17/3/31.
//  Copyright © 2017年 shinow. All rights reserved.
//

import UIKit
import Charts;

public class YHMarkerV:MarkerView  {
    
    @IBOutlet weak var backImageV: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var todayLab: UILabel!
    @IBOutlet weak var lastLab: UILabel!
    @IBOutlet weak var compareLab: UILabel!

    
    override public func awakeFromNib() {
        
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        
        todayLab?.text = "本周: 666"//String.init(format: "本周: %%", Int(round(entry.y)))
        layoutIfNeeded()
    }
    
    
}

public func globalLog() {
    print("这是Swift全局的log方法")
}
