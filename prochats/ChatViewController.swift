//
//  ChatViewController.swift
//  prochats
//
//  Created by Сергей on 09.05.15.
//  Copyright (c) 2015 Creators. All rights reserved.
//

import UIKit

class ChatViewController: JSQMessagesViewController, VKConnnectorProtocol {
    
    var Connector: VKConnector = VKConnector()
    var chat: Chat?
    
    var messages = [VKMessage]()
    var avatars = Dictionary<String, JSQMessagesAvatarImage>()
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.menuColor())
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.barColor())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.topItem!.title = "";
        self.inputToolbar.contentView.leftBarButtonItem = nil
        automaticallyScrollsToMostRecentMessage = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Поиск", style: UIBarButtonItemStyle.Plain, target: self, action: "search")
        self.showLoadEarlierMessagesHeader = true
        
        var titleLabelButton = UIButton()
        titleLabelButton.setTitle("Чат", forState:UIControlState.Normal)
        titleLabelButton.frame = CGRectMake(0, 0, 70, 44)
        titleLabelButton.addTarget(self, action:"openSettings", forControlEvents:UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleLabelButton;

        
        var me: VKUser = Connector.users.allValues[0] as! VKUser
        senderId = NSNumber(int: me.userId).stringValue
        senderDisplayName = me.name
        
        chat?.loadMessages(50)
        var myMessages: [Message] = chat?.getSortedMessages() as! [Message]
        for message in myMessages {
            var chatMessage = VKMessage(imageUrl: message.sender.imageUrl, senderId: NSNumber(int: message.sender.userId).stringValue,
                senderDisplayName: message.sender.name,
                date: message.date,
                text: message.body)
            messages.append(chatMessage)
        }
    }
    
    func setCurrentChat(chat: Chat) {
        self.chat = chat
    }
    
    func openSettings() {
        let chatViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ChatSettingsViewController") as! ChatSettingsViewController
        chatViewController.setCurrentChat(chat!)
        self.navigationController?.showViewController(chatViewController, sender: self)
    }
    
    func search() {
        let hashtagsTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HashtagsTableViewController") as! HashtagsTableViewController
        self.navigationController?.showViewController(hashtagsTableViewController, sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToChat(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId sender: String!, senderDisplayName displayName: String!, date: NSDate!) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        var message = VKMessage(imageUrl: Connector.getMe().imageUrl, senderId: senderId,
            senderDisplayName:senderDisplayName,
            date:date,
            text:text)
        
        messages.append(message)
        
        chat?.sendMessage(text)
        
        finishSendingMessageAnimated(true)
        
    }
    
    func setupAvatarImage(name: String, imageUrl: String?, incoming: Bool) {
        if let stringUrl = imageUrl {
            if let url = NSURL(string: stringUrl) {
                if let data = NSData(contentsOfURL: url) {
                    let image = UIImage(data: data)
                    let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
                    let avatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(image, diameter: diameter)
                    avatars[name] = avatarImage
                    return
                }
            }
        }
        
        // At some point, we failed at getting the image (probably broken URL), so default to avatarColor
        setupAvatarColor(name, incoming: incoming)
    }
    
    func setupAvatarColor(name: String, incoming: Bool) {
        let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
        
        let color = UIColor.barColor()
        
        let nameLength = count(name)
        let initials : String? = name.substringToIndex(advance(senderDisplayName.startIndex, min(1, nameLength)))
        let userImage = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(initials, backgroundColor: color, textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(CGFloat(13)), diameter: diameter)
        
        avatars[name] = userImage
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        var data = self.messages[indexPath.row]
        if (data.senderId == self.senderId) {
            return self.outgoingBubble
        } else {
            return self.incomingBubble
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item]
        setupAvatarImage(message.senderDisplayName, imageUrl: message.imageUrl, incoming: true)
        return avatars[message.senderDisplayName]
        //return nil
    }
    
    // View  usernames above bubbles
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message: JSQMessage = messages[indexPath.item];
        
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm" //format style. Browse online to get a format that fits your needs.
        var dateString = dateFormatter.stringFromDate(message.date)

        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderDisplayName == message.senderDisplayName {
                return nil;
            }
        }
        
        // Sent by me, skip
        if message.senderDisplayName == senderDisplayName {
            return NSAttributedString(string:senderDisplayName + " " + dateString)
        }
        
        
        return NSAttributedString(string:message.senderDisplayName + " " + dateString)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderDisplayName == message.senderDisplayName {
                return CGFloat(0.0)
            }
        }
        
        // Sent by me, skip
        if message.senderDisplayName == senderDisplayName {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        NSLog("oooooooo")
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {
        NSLog("jjjjjjj")
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if (self.showLoadEarlierMessagesHeader && kind == UICollectionElementKindSectionHeader) {
            var view: JSQMessagesCollectionView = collectionView as! JSQMessagesCollectionView
            var header: JSQMessagesLoadEarlierHeaderView = view.dequeueLoadEarlierMessagesViewHeaderForIndexPath(indexPath)
            
            header.loadButton.titleLabel?.text = "Еще сообщения..."
            header.loadButton.setTitleColor(UIColor.barColor(), forState: UIControlState.Normal)
            header.loadButton.titleLabel?.font = UIFont(name: "Helvetica", size: 16)
           
            return header;
        }
        return super.collectionView(view as! UICollectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: JSQMessagesCollectionViewCell = super.collectionView(collectionView, cellForItemAtIndexPath:indexPath) as! JSQMessagesCollectionViewCell
        cell.textView.textColor = UIColor.whiteColor()
        
        return cell
    }
}
