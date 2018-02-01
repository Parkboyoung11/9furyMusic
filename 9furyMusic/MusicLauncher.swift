//
//  MusicLauncher.swift
//  9furyMusic
//
//  Created by VuHongSon on 1/31/18.
//  Copyright © 2018 VuHongSon. All rights reserved.
//

import UIKit
import AVFoundation

class MusicView: UIView {
    var music : Music? {
        didSet {
            nameLabel.text = music?.name
            artistLabel.text = music?.artist
            setCoverImage()
            MusicController(link: (music?.link)!)
        }
    }
    
    var player : AVAudioPlayer!
    var isPlaying = false
    var lockShowPauseButton = true
    var timer : Timer!
    var angle : Float = 0
    
    let controlsContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return view
    }()
    
    let pausePlayButton : UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "pause"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(handlePause), for: UIControlEvents.touchUpInside)
        button.tintColor = UIColor.white
        button.isHidden = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nextButton : UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "next3"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(handleNext), for: UIControlEvents.touchUpInside)
        button.tintColor = UIColor.white
        button.isHidden = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let previousButton : UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "previous3"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(handlePrevious), for: UIControlEvents.touchUpInside)
        button.tintColor = UIColor.white
        button.isHidden = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let backButton : UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "back2"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(handleBack), for: UIControlEvents.touchUpInside)
        button.tintColor = UIColor.white
        button.isHidden = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let musicLengthLabel : UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    let currentTimeLabel : UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Song Name"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let artistLabel : UILabel = {
        let label = UILabel()
        label.text = "Artist"
        label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let musicSlider : UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.maximumTrackTintColor = UIColor.white
        slider.minimumTrackTintColor = UIColor.orange
        slider.setThumbImage(#imageLiteral(resourceName: "thumbs"), for: UIControlState.normal)
//        slider.setMinimumTrackImage(#imageLiteral(resourceName: "thumbs"), for: UIControlState.normal)
//        slider.setMaximumTrackImage(#imageLiteral(resourceName: "thumbs"), for: UIControlState.normal)
//        slider.minimumValue = 0.05
//        slider.maximumValue = 0.95
        
//        slider.addTarget(self, action: #selector(handleSliderChange), for: UIControlEvents.valueChanged)
        
        slider.isUserInteractionEnabled = false
        return slider
    }()
    
    let coverImage : CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = (UIScreen.main.bounds.width - 15 * 2) / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    func MusicController(link : String) {
        if let url = URL(string: link) {
            let queue = DispatchQueue(label: "queueLoadData")
            queue.async {
                do{
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        do {
                            self.player = try AVAudioPlayer(data: data)
                            self.player.play()
                            self.player.numberOfLoops = -1
                            self.isPlaying = true
                            self.coverRotation()
                            self.updateMusic()
                        }catch {}
                    }
                }catch {}
            }
        }
    }
    
    func updateMusic() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (time) in
            UIView.animate(withDuration: 0.5, animations: {
                self.musicSlider.setValue(Float(self.player.currentTime / self.player.duration), animated: false)
                let duration = self.convertSecToMin(secs: Int(self.player.duration))
                let current = self.convertSecToMin(secs: Int(self.player.currentTime))
                self.musicLengthLabel.text = duration
                self.currentTimeLabel.text = current
            })
        }
    }
    
    func convertSecToMin(secs: Int) -> String {
        let min = Int(secs / 60)
        let sec = Int(secs % 60)
        let minStr : String = String(format: "%02d:%02d", min, sec)
        return minStr
    }
    
    func coverRotation(){
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (timer) in
            self.angle += 0.5
            self.coverImage.transform = CGAffineTransform(rotationAngle: CGFloat(self.angle) * CGFloat(Double.pi) / 180)
        }
    }
    
    func handlePause() {
        if isPlaying == true {
            pausePlayButton.setImage(#imageLiteral(resourceName: "play"), for: UIControlState.normal)
            player?.pause()
            if (timer) != nil {
                timer.invalidate()
                timer = nil
            }
            isPlaying = false
        }else {
            if (player != nil) {
                pausePlayButton.setImage(#imageLiteral(resourceName: "pause"), for: UIControlState.normal)
                player?.play()
                coverRotation()
                isPlaying = true
            }
        }
    }
    
    func handleBack(){
        
    }
    
    func handleNext(){
        print("Next")
    }
    
    func handlePrevious(){
        print("Previous")
    }
    
//    func handleSliderChange() {
//        let duration = player.duration
//        let value = Float64(musicSlider.value) * duration
//        player.pause()
//        player.play(atTime: value)
//    }
    
    func setCoverImage() {
        if let coverImageURL = music?.cover {
            let coverImageURLDecode = coverImageURL.replacingOccurrences(of: "\\", with: "")
            coverImage.loadImageFromURL(urlString: coverImageURLDecode)
        }
    }
    
    
    
    fileprivate func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.2]
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
        
        self.addSubview(controlsContainerView)
        controlsContainerView.frame = frame
//        controlsContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBack)))
        
        controlsContainerView.addSubview(backButton)
        controlsContainerView.addSubview(nextButton)
        controlsContainerView.addSubview(previousButton)
        controlsContainerView.addSubview(nameLabel)
        controlsContainerView.addSubview(artistLabel)
        controlsContainerView.addSubview(coverImage)
        controlsContainerView.addSubview(currentTimeLabel)
        controlsContainerView.addSubview(musicLengthLabel)
        controlsContainerView.addSubview(musicSlider)
        controlsContainerView.addSubview(pausePlayButton)
        
        // horizontal
        controlsContainerView.addContraintsWithFormat(format: "H:|-10-[v0(20)]-20-[v1]-10-|", views: backButton, nameLabel)
        controlsContainerView.addContraintsWithFormat(format: "H:|-50-[v0]-10-|", views: artistLabel)
        controlsContainerView.addContraintsWithFormat(format: "H:|-15-[v0]-15-|", views: coverImage)
        controlsContainerView.addContraintsWithFormat(format: "H:|-5-[v0(40)]-5-[v1]-5-[v2(40)]-5-|", views: currentTimeLabel, musicSlider, musicLengthLabel)
        controlsContainerView.addContraintsWithFormat(format: "H:[v0(40)]-50-[v1(40)]-50-[v2(40)]", views: previousButton, pausePlayButton, nextButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        
        // vertical
        controlsContainerView.addContraintsWithFormat(format: "V:|-30-[v0(20)]-50-[v1]", views: backButton, coverImage)
        coverImage.heightAnchor.constraint(equalTo: coverImage.widthAnchor).isActive = true
        controlsContainerView.addContraintsWithFormat(format: "V:|-30-[v0(16)]-2-[v1(16)]", views: nameLabel, artistLabel)
        controlsContainerView.addContraintsWithFormat(format: "V:[v0(16)]-20-[v1(40)]-30-|", views: musicSlider, pausePlayButton)
        controlsContainerView.addContraintsWithFormat(format: "V:[v0(16)]-90-|", views: currentTimeLabel)
        controlsContainerView.addContraintsWithFormat(format: "V:[v0(16)]-90-|", views: musicLengthLabel)
        controlsContainerView.addContraintsWithFormat(format: "V:[v0(40)]-30-|", views: previousButton)
        controlsContainerView.addContraintsWithFormat(format: "V:[v0(40)]-30-|", views: nextButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

let viewUnderPlayer : UIView = {
    let viewss = UIView()
    return viewss
}()

class MusicLauncher: NSObject {
    func showMusicPlayer(music : Music) {
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView()
            view.frame = CGRect(x: 0, y: keyWindow.frame.height - 10, width: keyWindow.frame.width, height: 10)
            
            let musicView = MusicView(frame: keyWindow.frame)
            musicView.music = music
            view.addSubview(musicView)
            
            keyWindow.addSubview(view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: {
                view.frame = keyWindow.frame
            }, completion: { (completedAnimation) in
                //UIApplication.shared.setStatusBarHidden(true, with: .fade)
            })
        }
    }
    
    
}
