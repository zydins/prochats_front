//
//  ChatSettingsViewController.swift
//  prochats
//
//  Created by Сергей on 09.05.15.
//  Copyright (c) 2015 Creators. All rights reserved.
//

import UIKit

class ChatSettingsViewController: UITableViewController, VKConnnectorProtocol {
    
    var Connector: VKConnector = VKConnector()
    var chat: Chat?
    var currentType = 0
    
    var types = [
        "На lock-экране",
        "В приложении",
        "Никогда"
    ]
    
    var users =  [
        [
            "URL": "http://dummyimage.com/144x144/000/fff",
            "title": "Вася Петров",
            "last_message": "не ожидал от тебя такого...",
            "temp_icon": "",
            "last_time": "12:32"
        ],
        [
            "URL": "http://dummyimage.com/144x144/647/faf",
            "title": "Дима Иванов",
            "last_message": "класс",
            "temp_icon": "",
            "last_time": "21:31"
        ],
        [
            "URL": "http://dummyimage.com/144x144/231/aaf",
            "title": "Семен Семеныч",
            "last_message": "!!!!! >:3",
            "temp_icon": "",
            "last_time": "4:02"
        ]
    ]
    
    
    
    func setCurrentChat(chat: Chat) {
        self.chat = chat
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.topItem!.title = "";
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 20))
        view.backgroundColor = UIColor.whiteColor()
        return view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        switch section {
            case 0: return 1
            case 1: return 1
            case 2: return users.count
            default: return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        switch indexPath.section {
            case 0:
                var tempCell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as! ChatOptionTableViewCell
                if (chat!.imageUrl != nil) {
                    tempCell.setAvatarByUrl(chat!.imageUrl)
                } else {
                    let color = UIColor.barColor()
                    let nameLength = count(chat!.name)
                    let initials : String? = chat!.name.substringToIndex(advance(chat!.name.startIndex, min(1, nameLength)))
                    let userImage = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(initials, backgroundColor: color, textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(CGFloat(53)), diameter: UInt(120))
                     tempCell.imageView!.image = userImage.avatarImage
                }
                tempCell.label.text = chat!.name
            cell = tempCell
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("notificationCell", forIndexPath: indexPath) as! UITableViewCell
            cell.detailTextLabel?.text = types[currentType]
            case 2:
//                if (indexPath.row == 0) {
//                    cell = tableView.dequeueReusableCellWithIdentifier("addUserCell", forIndexPath: indexPath) as! UITableViewCell
//                } else {
                    cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath) as! UITableViewCell
                    cell.textLabel?.text = users[indexPath.row]["title"]
//                }
            default: cell = UITableViewCell()
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1) {
            currentType = currentType == 2 ? 0 : currentType + 1
            var cell = tableView.cellForRowAtIndexPath(indexPath)!
            cell.detailTextLabel?.text = types[currentType]
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 140.0
        } else {
            return 44.0
        }
    }
    


}
