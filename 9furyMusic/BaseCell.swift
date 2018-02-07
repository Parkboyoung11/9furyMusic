//
//  BaseCell.swift
//  9furyMusic
//
//  Created by VuHongSon on 2/7/18.
//  Copyright © 2018 VuHongSon. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
}
