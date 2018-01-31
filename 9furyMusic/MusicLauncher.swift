//
//  MusicLauncher.swift
//  9furyMusic
//
//  Created by VuHongSon on 1/31/18.
//  Copyright © 2018 VuHongSon. All rights reserved.
//

import UIKit
import AVFoundation

class MusicLauncher: NSObject {
    
    var music : Music? {
        didSet {
            nameLabel.text = music?.name
            artistLabel.text = music?.artist
            setCoverImage()
        }
    }
    
    var player : AVAudioPlayer!
    var isPlaying = false
    var lockShowPauseButton = true
    
    let pausePlayButton : UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "pause"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(handlePause), for: UIControlEvents.touchUpInside)
        button.tintColor = UIColor.white
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let backButton : UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "back"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(handlePause), for: UIControlEvents.touchUpInside)
        button.tintColor = UIColor.white
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let musicLengthLabel : UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    let currentTimeLabel : UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Song Name"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.textAlignment = .right
        return label
    }()
    
    let artistLabel : UILabel = {
        let label = UILabel()
        label.text = "Artist"
        label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.textAlignment = .right
        return label
    }()
    
    let musicSlider : UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.maximumTrackTintColor = UIColor.white
        slider.minimumTrackTintColor = UIColor.red
        slider.setThumbImage(#imageLiteral(resourceName: "thumb"), for: UIControlState.normal)
        slider.addTarget(self, action: #selector(handleSliderChange), for: UIControlEvents.valueChanged)
        return slider
    }()
    
    let coverImage : CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    func handleSliderChange() {
//        let duration = player.duration
//        let totalSeconds = CMTimeGetSeconds(duration)
//        let value = Float64(musicSlider.value) * totalSeconds
//        let seekTime = CMTime(value: Int64(value), timescale: 1)
//            
//            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
//                //perhaps do something later here
//            })
    }
    
    func handlePause() {
        if isPlaying == true {
            pausePlayButton.setImage(#imageLiteral(resourceName: "play"), for: UIControlState.normal)
            pausePlayButton.isHidden = false
            player?.pause()
        }else {
            pausePlayButton.setImage(#imageLiteral(resourceName: "pause"), for: UIControlState.normal)
            pausePlayButton.isHidden = false
            Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (time) in
                self.pausePlayButton.isHidden = true
            }
            player?.play()
        }
        
        isPlaying = !isPlaying
    }
    
    func showMusicPlayer() {
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
//            view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
            view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            view.frame = CGRect(x: 0, y: keyWindow.frame.height - 10, width: keyWindow.frame.width, height: 10)
            
            setupView(view: view)
            
            keyWindow.addSubview(view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: {
                view.frame = keyWindow.frame
            }, completion: { (completedAnimation) in
//                UIApplication.shared.setStatusBarHidden(true, with: .fade)
            })
        }
    }
    
    func setCoverImage() {
        if let coverImageURL = music?.cover {
            let coverImageURLDecode = coverImageURL.replacingOccurrences(of: "\\", with: "")
            coverImage.loadImageFromURL(urlString: coverImageURLDecode)
        }
    }
    
    func setupView(view : UIView) {
        view.addSubview(backButton)
        view.addSubview(nameLabel)
        view.addSubview(artistLabel)
        view.addSubview(coverImage)
        view.addSubview(currentTimeLabel)
        view.addSubview(musicLengthLabel)
        view.addSubview(musicSlider)
        view.addSubview(pausePlayButton)
        
        // horizontal
        view.addContraintsWithFormat(format: "H:|-10-[v0(20)]-20-[v1]-10-|", views: backButton, nameLabel)
        view.addContraintsWithFormat(format: "H:|-50-[v0]-10-|", views: artistLabel)
        view.addContraintsWithFormat(format: "H:|-30-[v0]-30-|", views: coverImage)
        view.addContraintsWithFormat(format: "H:|-5-[v0(30)]-10-[v1]-10-[v2(30)]-5-|", views: currentTimeLabel, musicSlider, musicLengthLabel)
        view.addContraintsWithFormat(format: "H:[v0(40)]", views: pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // vertical
        view.addContraintsWithFormat(format: "V:|-30-[v0(20)]-50-[v1]", views: backButton, coverImage)
        coverImage.heightAnchor.constraint(equalTo: coverImage.widthAnchor).isActive = true
        view.addContraintsWithFormat(format: "V:|-30-[v0(16)]-2-[v1(16)]", views: nameLabel, artistLabel)
        view.addContraintsWithFormat(format: "V:[v0(20)]-20-[v1(40)]-30-|", views: musicSlider, pausePlayButton)
        view.addContraintsWithFormat(format: "V:[v0(16)]-90-|", views: currentTimeLabel)
        view.addContraintsWithFormat(format: "V:[v0(16)]-90-|", views: musicLengthLabel)
        
        
    }
}
