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

    func setDetails(details: [String: String]) {
        self.chatImageView.image = nil
        self.chatImageView.sd_setImageWithURL(NSURL(string: details["URL"]!))
        self.chatTitleLabel.text = details["title"]!
        self.lastMessageLabel.text = details["last_message"]!
        self.favoriteIcon.sd_setImageWithURL(NSURL(string: details["temp_icon"]!))
        self.lastMessageTimeLabel.text = details["last_time"]!
    }
}
