//
//  Music.swift
//  9furyMusic
//
//  Created by VuHongSon on 1/26/18.
//  Copyright © 2018 VuHongSon. All rights reserved.
//

import UIKit

class Music: NSObject {
    var avatarImageURL : String?
    var title : String?
    var artist : String?
    var numberView : String?
    var quality : String?
    var rating : String?
    
    init(dictionary : [String: String]) {
        super.init()
        setValuesForKeys(dictionary)
    }
}
