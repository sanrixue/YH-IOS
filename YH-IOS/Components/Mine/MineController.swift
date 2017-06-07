//
//  MineController.swift
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/7.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

import UIKit

class MineController: MainBaseViewController {
    
    
    weak var titlesView =  UIView()
    weak var indicatorview = UIView()
    // 当前选中的按钮
    
    weak var selectedButton = UIButton()
    weak var contentView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.navigationController!.navigationBar.isTranslucent = false;
        
        self.addViewWithName()

        self.setupTitlesView()
        self.setupContentView()
    }
    
    // 初始化自控制器
    
    
    func addViewWithName() {
        let noticeView = NoticeTableViewController()
        noticeView.title = "公告预警"
        self.addChildViewController(noticeView)
        
        let instituteView  = InstituteViewController()
        instituteView.title = "数据学院"
         self.addChildViewController(instituteView)
        
        let userView = UserViewController()
        userView.title = "个人信息"
        self.addChildViewController(userView)
    }
    
    // 顶部标签栏
    func setupTitlesView() {
        //顶部背景
        let bgView:UIView = UIView()
        bgView.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height:KtitlesViewH)
        view.addSubview(bgView)
        
        // 标签
        let titlesView = UIView()
       // titlesView.backgroundColor = OMGlobalColor()
        titlesView.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: KtitlesViewH)
        bgView.addSubview(titlesView)
        self.titlesView = titlesView
        
        // 底部红色指示器
        let indicatorView = UIView()
        indicatorView.backgroundColor = UIColor.red
        indicatorView.height = kIndicatorViewH
        indicatorView.y = KtitlesViewH  - 2;
        indicatorView.tag = -1;
        self.indicatorview  = indicatorView
        
        let count = childViewControllers.count
        let width = titlesView.width / CGFloat(count)
        let height = titlesView.height - 2
        
        for index in 0..<count {
            let button = UIButton()
            button.y = 0;
            button.height = height
            button.width = width
            button.x = CGFloat(index) * width
            button.tag = index
            //button.layer.borderColor = UIColor.
            let vc =  childViewControllers[index]
            button.titleLabel!.font = UIFont.systemFont(ofSize: 14)
            button.setTitle(vc.title, for: .normal)
            button.setTitleColor(UIColor.gray, for: .normal)
            button.setTitleColor(UIColor.red, for: .selected)
            button.addTarget(self, action: #selector(titlesClick(button:)), for: .touchUpInside)
            titlesView.addSubview(button)
            
            // 默认点击了第一个按钮
            if index == 0 {
                button.isEnabled = false
                selectedButton = button
                button.titleLabel!.sizeToFit()
                indicatorView.width = button.titleLabel!.width
                indicatorView.centerX = button.centerX
            }
        }
        titlesView.addSubview(self.indicatorview!);
    }
    
    // 选择按钮点击事件
    func arrowButtonClick(button:UIButton)
    {
        print("okokok")
    }
    
    
    func titlesClick(button:UIButton)
    {
        selectedButton!.isEnabled = true
        button.isEnabled = false
        selectedButton = button
        
        UIView.animate(withDuration: 0.25, animations: {
            self.indicatorview!.width = self.selectedButton!.titleLabel!.width
            self.indicatorview!.centerX = self.selectedButton!.centerX
        })
        var offset = contentView!.contentOffset
        offset.x = CGFloat(button.tag) * contentView!.width
        contentView!.setContentOffset(offset, animated: true)
    }
    
    func setupContentView() {
        automaticallyAdjustsScrollViewInsets = false
        
        let contentView = UIScrollView()
        contentView.frame = view.bounds
        contentView.delegate = self
        contentView.contentSize = CGSize(width: contentView.width * 3, height: 0)
        contentView.isPagingEnabled = true
        view.insertSubview(contentView, at: 0)
        self.contentView = contentView
        scrollViewDidEndScrollingAnimation(contentView)
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        let vc = childViewControllers[index]
        //vc.view.x = scrollView.contentOffset.x
        if vc.isViewLoaded {
            return
        }
        vc.view.frame = scrollView.bounds
        scrollView.addSubview(vc.view)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        let button  = titlesView!.subviews[index] as! UIButton
        titlesClick(button: button)
}
}
