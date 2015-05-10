//
//  VKMessage.swift
//  prochats
//
//  Created by Сергей on 10.05.15.
//  Copyright (c) 2015 Creators. All rights reserved.
//

import UIKit

class VKMessage: JSQMessage {
    var imageUrl: String

    init(imageUrl: String, senderId: String, senderDisplayName: String, date: NSDate, text: String) {
        self.imageUrl = imageUrl
        super.init(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
    }

    required init(coder aDecoder: NSCoder) {
        imageUrl = "http://dummyimage.com/50x50/231/aaf"
        super.init(coder: aDecoder)
    }
}
