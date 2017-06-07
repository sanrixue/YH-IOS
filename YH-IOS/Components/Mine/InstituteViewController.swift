//
//  InstituteViewController.swift
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/7.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

import UIKit

class InstituteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor.blue
        let imageAvater:UIImageView = UIImageView()
        imageAvater.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let imageUrl:URL = URL(string: "http://upload-images.jianshu.io/upload_images/1567375-1d1283291a093bbc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240")!
        imageAvater.sd_setAnimationImages(with:[imageUrl])
        imageAvater.backgroundColor = UIColor.red
        view.addSubview(imageAvater)
        // Do any additional setup after loading the view.
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
