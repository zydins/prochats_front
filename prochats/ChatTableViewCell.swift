//
//  ChatTableViewCell.swift
//  prochats
//
//  Created by Balaban Alexander on 09/05/15.
//  Copyright (c) 2015 Creators. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    @IBOutlet var chatImageView: UIImageView!
    @IBOutlet var chatTitleLabel: UILabel!
    @IBOutlet var lastMessageLabel: UILabel!
    @IBOutlet var favoriteIcon: UIImageView!
    @IBOutlet var lastMessageTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.chatImageView.layer.cornerRadius = self.chatImageView.frame.size.width / 2
        self.chatImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setDetails(chat: Chat) {
//        self.chatImageView.image = chat.imageUrl
        
        let color = UIColor.barColor()
        let nameLength = count(chat.name)
        let initials : String? = chat.name.substringToIndex(advance(chat.name.startIndex, min(1, nameLength)))
        let userImage = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(initials, backgroundColor: color, textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(CGFloat(53)), diameter: UInt(144))
        
        if (chat.imageUrl != nil) {
            self.chatImageView.sd_setImageWithURL(NSURL(string: chat.imageUrl))
        } else {
            let color = UIColor.barColor()
            let nameLength = count(chat.name)
            let initials : String? = chat.name.substringToIndex(advance(chat.name.startIndex, min(1, nameLength)))
            let userImage = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(initials, backgroundColor: color, textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(CGFloat(53)), diameter: UInt(144))
            self.chatImageView.image = userImage.avatarImage
        }
        
        self.chatTitleLabel.text = chat.name
        var message: Message = chat.messages.allValues[0] as! Message
        self.lastMessageLabel.text = message.body
        self.favoriteIcon.sd_setImageWithURL(NSURL(string: "http://dummyimage.com/30x30/000/fff"))
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm" //format style. Browse online to get a format that fits your needs.
        var dateString = dateFormatter.stringFromDate(message.date)
        self.lastMessageTimeLabel.text = dateString
    }
}
