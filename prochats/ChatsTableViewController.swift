//
//  ChatsTableViewController.swift
//  prochats
//
//  Created by Сергей on 09.05.15.
//  Copyright (c) 2015 Creators. All rights reserved.
//

import UIKit

class ChatsTableViewController: UITableViewController, VKConnnectorProtocol {
    
    var Connector: VKConnector = VKConnector()
    var chats: [Chat] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        Connector.loadChats()
        chats = Connector.chats.allValues as! [Chat]
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = "Сообщения"
        self.tableView.reloadData()
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
//        return self.mockData.count
        return self.chats.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatCell", forIndexPath: indexPath) as! ChatTableViewCell

        cell.setDetails(chats[indexPath.row])

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let chatViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ChatViewController") as! ChatViewController
        chatViewController.setCurrentChat(chats[indexPath.row])
        self.navigationController?.showViewController(chatViewController, sender: self)
    }
}
