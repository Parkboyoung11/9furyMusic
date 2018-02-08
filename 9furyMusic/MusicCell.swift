//
//  MusicCell.swift
//  9furyMusic
//
//  Created by VuHongSon on 1/25/18.
//  Copyright © 2018 VuHongSon. All rights reserved.
//

import UIKit
class MusicCell: BaseCell {
    var music : Music? {
        didSet {
            titleLabel.text = music?.name
            ratingLabel.text = music?.rank
            artistLabel.text = music?.artist
            viewLabel.text = music?.view
            if music?.quality == "Lossless" {
                qualityLabel.textColor = UIColor.red
            }
            if music?.quality == "320kbps" {
                qualityLabel.textColor = UIColor.blue
            }
            if music?.quality == "128kbps" {
                qualityLabel.textColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
            }
            if music?.quality == "64kbps" {
                qualityLabel.textColor = UIColor.black
            }
            qualityLabel.text = music?.quality
            setAvatarImage()
        }
    }
    
    let avatarImageView : CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let titleLabel = UILabel()
    let artistLabel = UILabel()
    let viewLabel = UILabel()
    let qualityLabel = UILabel()
    let ratingLabel = UILabel()
    
    let separatorHorizontalView = UIView()
    let separatorVerticalViewBonus = UIView()
    let separatorVerticalView = UIView()
    
    var titleLabelHeightContraint : NSLayoutConstraint?
    
    func setAvatarImage() {
        if let profileImageURL = music?.avatar {
            let profileImageURLDecode = profileImageURL.replacingOccurrences(of: "\\", with: "")
            avatarImageView.loadImageFromURL(urlString: profileImageURLDecode)
        }
    }
    
    override func setupViews() {
        titleLabel.myLabel(textColor: #colorLiteral(red: 0.1725987196, green: 0.4564271569, blue: 0.548560977, alpha: 1), textAlignment: NSTextAlignment.left, font: UIFont.boldSystemFont(ofSize: 17))
        artistLabel.myLabel(textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textAlignment: NSTextAlignment.left, font: UIFont.systemFont(ofSize: 13))
        viewLabel.myLabel(textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textAlignment: NSTextAlignment.right, font: UIFont.systemFont(ofSize: 12))
        qualityLabel.myLabel(textColor: UIColor.red, textAlignment: NSTextAlignment.right, font: UIFont.systemFont(ofSize: 12))
        ratingLabel.myLabel(textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textAlignment: NSTextAlignment.center, font: UIFont.boldSystemFont(ofSize: 14))
        
        
        separatorHorizontalView.separatorView()
        separatorVerticalView.separatorView()
        separatorVerticalViewBonus.separatorView()
        
        addSubview(ratingLabel)
        addSubview(avatarImageView)
        addSubview(titleLabel)
        addSubview(artistLabel)
        addSubview(viewLabel)
        addSubview(qualityLabel)
        addSubview(separatorHorizontalView)
        addSubview(separatorVerticalView)
        addSubview(separatorVerticalViewBonus)
        
        // Vertical
        addContraintsWithFormat(format: "V:|-5-[v0]-6-|", views: avatarImageView)
        addContraintsWithFormat(format: "V:|-18-[v0]-19-|", views: ratingLabel)
        
        addContraintsWithFormat(format: "V:|-8-[v0]-12-[v1(1)]|", views: separatorVerticalView, separatorHorizontalView)
        addContraintsWithFormat(format: "V:|-13-[v0]-13-|", views: separatorVerticalViewBonus)
        
        addContraintsWithFormat(format: "V:|-8-[v0(22)]-2-[v1]-9-|", views: titleLabel, artistLabel)
        addContraintsWithFormat(format: "V:|-8-[v0(17)][v1]-13-|", views: viewLabel, qualityLabel)
        
        // Horizontal
        addContraintsWithFormat(format: "H:|-5-[v0(18)]-5-[v1(1)]-5-[v2(44)]-15-[v3(201)]-5-[v4(1)]-5-[v5]-10-|", views: ratingLabel, separatorVerticalViewBonus, avatarImageView, titleLabel, separatorVerticalView, viewLabel)
        addContraintsWithFormat(format: "H:|-93-[v0(201)]-11-[v1]-10-|", views: artistLabel, qualityLabel)
        addContraintsWithFormat(format: "H:|-2-[v0]-2-|", views: separatorHorizontalView)

    }
}











