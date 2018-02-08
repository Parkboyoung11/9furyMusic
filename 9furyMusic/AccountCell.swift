//
//  AccountCell.swift
//  9furyMusic
//
//  Created by VuHongSon on 2/8/18.
//  Copyright © 2018 VuHongSon. All rights reserved.
//

import UIKit

class AccountCell: BaseCell {
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Yuuki Asuna"
        label.myLabel(textColor: UIColor.white, textAlignment: .center, font: .boldSystemFont(ofSize: 20))
        return label
    }()
    
    let viewSP : UIView = {
        let viewSP = UIView()
        viewSP.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        viewSP.translatesAutoresizingMaskIntoConstraints = false
        return viewSP
    }()
    
    
    let imgAvatar : UIImageView = {
        let imgView = UIImageView()
        imgView.isUserInteractionEnabled = true
        imgView.image = #imageLiteral(resourceName: "asuna")
        imgView.myImageSkin()
        imgView.contentMode = UIViewContentMode.scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let updateButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.0368008456, green: 0.08081357971, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.05117796371, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    override func setupViews() {
        addSubview(viewSP)
        addContraintsWithFormat(format: "V:|[v0]|", views: viewSP)
        addContraintsWithFormat(format: "H:|[v0]|", views: viewSP)
        
        viewSP.addSubview(nameLabel)
        viewSP.addSubview(imgAvatar)
        viewSP.addSubview(updateButton)
        
        viewSP.addContraintsWithFormat(format: "V:|-50-[v0(35)]-20-[v1(200)]-20-[v2(35)]", views: nameLabel, imgAvatar, updateButton)
        viewSP.addContraintsWithFormat(format: "H:|-50-[v0]-50-|", views: nameLabel)
        
        imgAvatar.centerXAnchor.constraint(equalTo: viewSP.centerXAnchor).isActive = true
        imgAvatar.widthAnchor.constraint(equalTo: imgAvatar.heightAnchor).isActive = true
        updateButton.centerXAnchor.constraint(equalTo: viewSP.centerXAnchor).isActive = true
        updateButton.widthAnchor.constraint(equalTo: nameLabel.widthAnchor, multiplier: 1/3).isActive = true
        
    }
}
