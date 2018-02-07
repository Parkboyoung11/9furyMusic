//
//  HomeCell.swift
//  9furyMusic
//
//  Created by VuHongSon on 1/25/18.
//  Copyright © 2018 VuHongSon. All rights reserved.
//

import UIKit

class HomeCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    var musics : [Music]?
    let cellID = "cellID"
    
    override func setupViews() {
        super.setupViews()
        
        fetchMusic()
        
        backgroundColor = UIColor.brown
        addSubview(collectionView)
        addContraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addContraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        collectionView.register(MusicCell.self, forCellWithReuseIdentifier: cellID)
        
    }
    
    func fetchMusic() {
        ApiService.sharedInstance.fetchHome { (musics) in
            self.musics = musics
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MusicCell
        cell.music = musics?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = musics?[indexPath.item]
        if musicForPlayer == nil {
            let musicLauncher = MusicLauncher()
            //musicLauncher.music = data
            musicLauncher.showMusicPlayer(music : data!)
        }else {
            if musicForPlayer == data {
                showMusicPlayer()
            }else {
                if player != nil {
                    player.stop()
                    player = nil
                }
                musicForPlayer = data
                updateMusicPlayer()
                showMusicPlayer()
            }
        }
    }
    
    func showMusicPlayer() {
        if let keyWindow = UIApplication.shared.keyWindow {
            let viewSuper = keyWindow.viewWithTag(111)
            viewSuper?.frame = CGRect(x: 0, y: keyWindow.frame.height - 10, width: keyWindow.frame.width, height: 10)
            viewSuper?.isHidden = false
            viewSuper?.viewWithTag(110)?.isHidden = false
            viewSuper?.viewWithTag(110)?.viewWithTag(109)?.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: {
                viewSuper?.frame = keyWindow.frame
            }, completion: { (completedAnimation) in})
            
        }
    }
    
    func updateMusicPlayer() {
        if let keyWindow = UIApplication.shared.keyWindow {
            let viewSuper2 = keyWindow.viewWithTag(111)?.viewWithTag(110) as! MusicView
            viewSuper2.music = musicForPlayer
//            viewSuper?.viewWithTag(110)?.music = musicForPlayer
            
        }
    }
    
}
