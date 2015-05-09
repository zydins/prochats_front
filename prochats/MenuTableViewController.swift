//
//  MenuTableViewController.swift
//  prochats
//
//  Created by Balaban Alexander on 09/05/15.
//  Copyright (c) 2015 Creators. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    typealias cellData = (title: String, function: String)
    let cells: [cellData] = [
        ("Настройки", "Settings"),
        ("Не беспокоить", "Mute All"),
        ("Выход", "Logout")
    ]
    
    @IBOutlet var userPhotoProfile: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var headerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.headerView.backgroundColor = UIColor.menuColor()
        self.view.backgroundColor = UIColor.menuColor()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.userPhotoProfile.sd_setImageWithURL(NSURL(string: "https://pp.vk.me/c618319/v618319951/188e9/ZWuMEntaV7w.jpg"))
        self.userPhotoProfile.clipsToBounds = true
        self.userPhotoProfile.layer.cornerRadius = self.userPhotoProfile.frame.size.width / 2
        self.nameLabel.text = "Балабан Александр"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRectMake(0, 0, 320, 1.0 / UIScreen.mainScreen().scale))
        header.backgroundColor = UIColor.clearColor()
        let tempView = UIView(frame: CGRectMake(17, 0, 260, 1.0 / UIScreen.mainScreen().scale))
        tempView.backgroundColor = UIColor(white: 1.0, alpha: 0.6)
        header.addSubview(tempView)
        return header
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.text = cells[indexPath.row].title
        return cell
    }

    // MARK: - Auxiliary methods
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
