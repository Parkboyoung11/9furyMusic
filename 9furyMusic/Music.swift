//
//  Music.swift
//  9furyMusic
//
//  Created by VuHongSon on 1/26/18.
//  Copyright © 2018 VuHongSon. All rights reserved.
//

import UIKit

class Music: NSObject {
    var rank : String?
    var avatar : String?
    var link : String?
    var name : String?
    var artist : String?
    var view : String?
    var quality : String?
    var cover : String?
    var duration : String?
    var genre : String?
    var album : String?
    
    init(dictionary : [String: String]) {
        super.init()
        setValuesForKeys(dictionary)
    }
}
