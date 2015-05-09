//
//  ChatsTableViewController.swift
//  prochats
//
//  Created by Сергей on 09.05.15.
//  Copyright (c) 2015 Creators. All rights reserved.
//

import UIKit

class ChatsTableViewController: UITableViewController {
    let mockData = [
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
            "title": "Чат ТОПОВЫЙ",
            "last_message": "!!!!! >:3",
            "temp_icon": "",
            "last_time": "4:02"
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.navigationItem.title = "Сообщения"
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = "Сообщения"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showMenu(sender: AnyObject) {
        self.revealViewController().revealToggleAnimated(true)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.mockData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatCell", forIndexPath: indexPath) as! ChatTableViewCell

        cell.setDetails(self.mockData[indexPath.row])

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let chatViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ChatViewController") as! ChatViewController
        self.navigationController?.showViewController(chatViewController, sender: self)
    }
}
