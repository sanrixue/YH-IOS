//
//  UserViewController.swift
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/7.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    var person:Person? {
        return YHNetworkTool.shareNetWork().loadUserInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow;
       // loadUserDate()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTableView(){
        let tableView:UITableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableHeaderView  = headerView
        headerView.userHead = person
    }
    
    var headerView:MineHeadView = {
        let headerView = MineHeadView()
        headerView.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 300)
        return headerView
    }()
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UserViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        return cell
    }
}
