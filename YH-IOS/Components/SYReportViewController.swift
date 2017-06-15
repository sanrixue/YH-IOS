//
//  SYReportViewController.swift
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/15.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

import UIKit

class SYReportViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initCategory()
        // Do any additional setup after loading the view.
    }
    
    
    func initCategory() {
        let reportView = SYReportView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 49));
        view.addSubview(reportView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
