//
//  MusicLauncher.swift
//  9furyMusic
//
//  Created by VuHongSon on 1/31/18.
//  Copyright © 2018 VuHongSon. All rights reserved.
//

import UIKit
import AVFoundation

var musicForPlayer : Music?
var player : AVAudioPlayer!
var repeatMode : Int = 1      //0: no repeat, 1 : one song, 2: all


class MusicView: UIView, AVAudioPlayerDelegate {
    var music : Music? {
        didSet {
            nameLabel.text = music?.name
            artistLabel.text = music?.artist
            setCoverImage()
            setToDefault()
            MusicController(link: (music?.link)!)
        }
    }
    
    var isPlaying = false
    
    var lockShowPauseButton = true
    var timerRotation : Timer!
    var timerUpdate : Timer!
    var angle : Float = 0
    
    let controlsContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return view
    }()
    
    let coverImage : CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = (UIScreen.main.bounds.width - 15 * 2) / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let musicLengthLabel = UILabel()
    let currentTimeLabel = UILabel()
    let nameLabel = UILabel()
    let artistLabel = UILabel()
    
    let pausePlayButton = UIButton(type: UIButtonType.system)
    let nextButton = UIButton(type: UIButtonType.system)
    let previousButton = UIButton(type: UIButtonType.system)
    let backButton = UIButton(type: UIButtonType.system)
    let repeatButton = UIButton(type: UIButtonType.system)
    let shuffleButton = UIButton(type: UIButtonType.system)
    let downloadButton = UIButton(type: UIButtonType.system)
    
    
    let musicSlider = UISlider()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
        setupPlayerView()
        
        
        controlsContainerView.tag = 109
        self.addSubview(controlsContainerView)
        controlsContainerView.frame = frame
        
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
        controlsContainerView.addSubview(repeatButton)
        controlsContainerView.addSubview(shuffleButton)
        controlsContainerView.addSubview(downloadButton)
        
        //Add TapGesture for UISlider
        musicSlider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:))))
        
        // horizontal
        controlsContainerView.addContraintsWithFormat(format: "H:|-10-[v0(20)]-20-[v1]-10-|", views: backButton, nameLabel)
        controlsContainerView.addContraintsWithFormat(format: "H:|-50-[v0]-10-|", views: artistLabel)
        controlsContainerView.addContraintsWithFormat(format: "H:|-15-[v0]-15-|", views: coverImage)
        controlsContainerView.addContraintsWithFormat(format: "H:|-5-[v0(40)]-5-[v1]-5-[v2(40)]-5-|", views: currentTimeLabel, musicSlider, musicLengthLabel)
        controlsContainerView.addContraintsWithFormat(format: "H:[v0(40)]-50-[v1(40)]-50-[v2(40)]", views: previousButton, pausePlayButton, nextButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        controlsContainerView.addContraintsWithFormat(format: "H:[v0(30)]-60-[v1(20)]-60-[v2(28)]", views: shuffleButton, downloadButton, repeatButton)
        downloadButton.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        
        
        // vertical
        controlsContainerView.addContraintsWithFormat(format: "V:|-30-[v0(20)]-50-[v1]", views: backButton, coverImage)
        coverImage.heightAnchor.constraint(equalTo: coverImage.widthAnchor).isActive = true
        controlsContainerView.addContraintsWithFormat(format: "V:|-30-[v0(16)]-2-[v1(16)]", views: nameLabel, artistLabel)
        controlsContainerView.addContraintsWithFormat(format: "V:[v0(16)]-20-[v1(40)]-30-|", views: musicSlider, pausePlayButton)
        controlsContainerView.addContraintsWithFormat(format: "V:[v0(16)]-90-|", views: currentTimeLabel)
        controlsContainerView.addContraintsWithFormat(format: "V:[v0(16)]-90-|", views: musicLengthLabel)
        controlsContainerView.addContraintsWithFormat(format: "V:[v0(40)]-30-|", views: previousButton)
        controlsContainerView.addContraintsWithFormat(format: "V:[v0(40)]-30-|", views: nextButton)
        controlsContainerView.addContraintsWithFormat(format: "V:[v0(20)]-130-|", views: repeatButton)
        controlsContainerView.addContraintsWithFormat(format: "V:[v0(20)]-130-|", views: shuffleButton)
        controlsContainerView.addContraintsWithFormat(format: "V:[v0(19)]-131-|", views: downloadButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag == true {
            handlePause()
        }
    }
    
    func playMusicBackground() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
//            print("Playback OK")
//            try AVAudioSession.sharedInstance().setActive(true)
//            print("Session is Active")
        } catch {
            print(error)
        }
    }
    
    func setupPlayerView() {
        musicLengthLabel.customLabelWithText(textColor: UIColor.white, textAlignment: NSTextAlignment.right, font: UIFont.boldSystemFont(ofSize: 12), text: "00:00")
        currentTimeLabel.customLabelWithText(textColor: UIColor.white, textAlignment: NSTextAlignment.left, font: UIFont.boldSystemFont(ofSize: 12), text: "00:00")
        nameLabel.customLabelWithText(textColor: UIColor.white, textAlignment: NSTextAlignment.left, font: UIFont.boldSystemFont(ofSize: 14), text: "Song Name")
        artistLabel.customLabelWithText(textColor: UIColor.white, textAlignment: NSTextAlignment.left, font: UIFont.systemFont(ofSize: 14), text: "Artist")
        pausePlayButton.customButton(image: #imageLiteral(resourceName: "pause"), target: self, selector: #selector(handlePause), tintColor: UIColor.white, isHidden: false)
        nextButton.customButton(image: #imageLiteral(resourceName: "next3"), target: self, selector: #selector(handleNext), tintColor: UIColor.white, isHidden: false)
        previousButton.customButton(image: #imageLiteral(resourceName: "previous3"), target: self, selector: #selector(handlePrevious), tintColor: UIColor.white, isHidden: false)
        
        
        repeatButton.customButton(image: #imageLiteral(resourceName: "repeat"), target: self, selector: #selector(handleRepeat), tintColor: UIColor.white, isHidden: false)
        handleRepeatImage()
        shuffleButton.customButton(image: #imageLiteral(resourceName: "shuffle"), target: self, selector: #selector(handleShuffle), tintColor: UIColor.white, isHidden: false)
        downloadButton.customButton(image: #imageLiteral(resourceName: "download"), target: self, selector: #selector(handleDownload), tintColor: UIColor.white, isHidden: false)
        backButton.customButton(image: #imageLiteral(resourceName: "back2"), target: self, selector: #selector(handleBack), tintColor: UIColor.white, isHidden: false)
        musicSlider.customSlider(thumbImage: #imageLiteral(resourceName: "thumbRemake"), target: self, selector: #selector(handleSliderChange))
    }
    
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
    
    func MusicController(link : String) {
        if let url = URL(string: link) {
            let queue = DispatchQueue(label: "queueLoadData")
            queue.async {
                do{
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        do {
                            if player == nil {
                                player = try AVAudioPlayer(data: data)
                                player.prepareToPlay()
                                self.playMusicBackground()
                                player.play()
                                player.delegate = self
                                self.handleRepeatLoop()
                                self.isPlaying = true
                                self.musicSlider.isUserInteractionEnabled = true
                                self.coverRotation()
                                self.updateMusic()
                            }
                        }catch {print("Data is not Audio!")}
                    }
                }catch {print("Cant Load Data from Server!")}
            }
        }
    }
    
    
    
    func setToDefault(){
        isPlaying = false
        if timerUpdate != nil {
            timerUpdate.invalidate()
            timerUpdate = nil
        }
        
        if (timerRotation) != nil {
            timerRotation.invalidate()
            timerRotation = nil
        }
        pausePlayButton.setImage(#imageLiteral(resourceName: "pause"), for: UIControlState.normal)
        coverImage.transform = CGAffineTransform(rotationAngle: 0)
        angle = 0
        musicSlider.setValue(0, animated: false)
        musicSlider.isUserInteractionEnabled = false
        currentTimeLabel.text = "00:00"
        musicLengthLabel.text = "00:00"
    }
    
    func updateMusic() {
        timerUpdate = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (time) in
            UIView.animate(withDuration: 0.5, animations: {
                self.musicSlider.setValue(Float(player.currentTime / player.duration), animated: false)
                let duration = self.convertSecToMin(secs: Int(player.duration))
                let current = self.convertSecToMin(secs: Int(player.currentTime))
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
        timerRotation = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (timer) in
            self.angle += 0.5
            self.coverImage.transform = CGAffineTransform(rotationAngle: CGFloat(self.angle) * CGFloat(Double.pi) / 180)
        }
    }
    
    func handlePause() {
        if isPlaying == true {
            pausePlayButton.setImage(#imageLiteral(resourceName: "play"), for: UIControlState.normal)
            player?.pause()
            if (timerRotation) != nil {
                timerRotation.invalidate()
                timerRotation = nil
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
        if let keyWindow = UIApplication.shared.keyWindow {
            let viewSuper = self.superview
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: {
                viewSuper?.frame = CGRect(x: 0, y: keyWindow.frame.height - 0, width: keyWindow.frame.width, height: 0)
            }, completion: { (completedAnimation) in
                self.controlsContainerView.isHidden = true
                self.isHidden = true
                viewSuper?.isHidden = true
            })
        }else {
            controlsContainerView.isHidden = true
            self.isHidden = true
            self.superview?.isHidden = true
        }
        
        
    }
    
    func handleNext(){
//        print("Next Function. Coming Soon")
    }
    func handlePrevious(){
//        print("Previous Function. Coming Soon")
    }
    func handleRepeat() {
        if player != nil {
            handleRepeatValue()
            handleRepeatLoop()
            handleRepeatImage()
        }
        
    }
    func handleShuffle() {
//        print("Shuffle Function. Coming Soon")
    }
    func handleDownload() {
//        print("Download Function. Coming Soon")
    }
    
    func handleRepeatValue() {
        if repeatMode == 0 {
            repeatMode = 2
        }else if repeatMode == 1 {
            repeatMode = 0
        }else if repeatMode == 2 {
            repeatMode = 1
        }
    }
    
    func handleRepeatLoop() {
        if repeatMode == 0 {
            player.numberOfLoops = 0
        }else if repeatMode == 1 {
            player.numberOfLoops = -1
        }else {
            player.numberOfLoops = 0
        }
    }
    
    func handleRepeatImage() {
        if repeatMode == 0 {
            repeatButton.setImage(#imageLiteral(resourceName: "repeat"), for: UIControlState.normal)
            repeatButton.tintColor = UIColor(white: 0.5, alpha: 0.5)
        }else if repeatMode == 1 {
            repeatButton.setImage(#imageLiteral(resourceName: "repeat_one"), for: UIControlState.normal)
            repeatButton.tintColor = UIColor.white
        }else {
            repeatButton.setImage(#imageLiteral(resourceName: "repeat"), for: UIControlState.normal)
            repeatButton.tintColor = UIColor.white
        }
    }
    
    func handleSliderChange() {
        let duration = player.duration
        let currentTime = musicSlider.value * Float(duration)
        player.stop()
        player.currentTime = TimeInterval(currentTime)
        player.prepareToPlay()
        player.play()
    }

    func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        let pointTapped: CGPoint = gestureRecognizer.location(in: self.controlsContainerView)
        let positionSlider: CGPoint = musicSlider.frame.origin
        let widthSlider: CGFloat = musicSlider.frame.size.width
        
        let newValue = ((pointTapped.x - positionSlider.x) * CGFloat(musicSlider.maximumValue) / widthSlider)
        musicSlider.setValue(Float(newValue), animated: true)
        handleSliderChange()
    }
 
}

class MusicLauncher: NSObject {
    func showMusicPlayer(music : Music) {
        if let keyWindow = UIApplication.shared.keyWindow {
            musicForPlayer = music
            let view = UIView()
            view.frame = CGRect(x: 0, y: keyWindow.frame.height - 10, width: keyWindow.frame.width, height: 10)
            view.backgroundColor = UIColor.clear
            
            let musicView = MusicView(frame: keyWindow.frame)
            musicView.music = music
            musicView.tag = 110
            
            view.addSubview(musicView)
            view.tag = 111
            musicView.backgroundColor = UIColor.clear
            
            keyWindow.addSubview(view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: {
                view.frame = keyWindow.frame
            }, completion: { (completedAnimation) in
                //UIApplication.shared.setStatusBarHidden(true, with: .fade)
            })
        }
    }
    
    
}
