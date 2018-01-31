////
////  test.swift
////  9furyMusic
////
////  Created by VuHongSon on 1/31/18.
////  Copyright © 2018 VuHongSon. All rights reserved.
////
//
//class MusicPlayerView: UIView {
//    
//    var player : AVPlayer?
//    var isPlaying = false
//    var lockShowPauseButton = true
//    var music : Music?
//    
//    let activityIndicatorView : UIActivityIndicatorView = {
//        let avt = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
//        avt.translatesAutoresizingMaskIntoConstraints = false
//        avt.startAnimating()
//        return avt
//    }()
//    
//    let controlsContainerView : UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(white: 0, alpha: 1)
//        //        view.isUserInteractionEnabled = true
//        return view
//    }()
//    
//    let pausePlayButton : UIButton = {
//        let button = UIButton(type: UIButtonType.system)
//        button.setImage(#imageLiteral(resourceName: "pause"), for: UIControlState.normal)
//        button.addTarget(self, action: #selector(handlePause), for: UIControlEvents.touchUpInside)
//        button.tintColor = UIColor.white
//        button.isHidden = true
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    let backButton : UIButton = {
//        let button = UIButton(type: UIButtonType.system)
//        button.setImage(#imageLiteral(resourceName: "pause"), for: UIControlState.normal)
//        button.addTarget(self, action: #selector(handlePause), for: UIControlEvents.touchUpInside)
//        button.tintColor = UIColor.white
//        button.isHidden = true
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    
//    let musicLengthLabel : UILabel = {
//        let label = UILabel()
//        label.text = "00:00"
//        label.textColor = UIColor.white
//        label.font = UIFont.boldSystemFont(ofSize: 14)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .right
//        return label
//    }()
//    
//    let currentTimeLabel : UILabel = {
//        let label = UILabel()
//        label.text = "00:00"
//        label.textColor = UIColor.white
//        label.font = UIFont.boldSystemFont(ofSize: 14)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .right
//        return label
//    }()
//    
//    let nameLabel : UILabel = {
//        let label = UILabel()
//        label.text = "Song Name"
//        label.textColor = UIColor.white
//        label.font = UIFont.boldSystemFont(ofSize: 14)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        //        label.textAlignment = .right
//        return label
//    }()
//    
//    let artistLabel : UILabel = {
//        let label = UILabel()
//        label.text = "Artist"
//        label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        //        label.textAlignment = .right
//        return label
//    }()
//    
//    let musicSlider : UISlider = {
//        let slider = UISlider()
//        slider.translatesAutoresizingMaskIntoConstraints = false
//        slider.maximumTrackTintColor = UIColor.white
//        slider.minimumTrackTintColor = UIColor.red
//        slider.setThumbImage(#imageLiteral(resourceName: "thumb"), for: UIControlState.normal)
//        slider.addTarget(self, action: #selector(handleSliderChange), for: UIControlEvents.valueChanged)
//        return slider
//    }()
//    
//    let coverImage : CustomImageView = {
//        let imageView = CustomImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.cornerRadius = 22
//        imageView.layer.masksToBounds = true
//        return imageView
//    }()
//    
//    fileprivate func setupGradientLayer() {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = bounds
//        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
//        gradientLayer.locations = [0.7, 1.2]
//        controlsContainerView.layer.addSublayer(gradientLayer)
//    }
//    
//    func handleSliderChange() {
//        if let duration = player?.currentItem?.duration {
//            let totalSeconds = CMTimeGetSeconds(duration)
//            let value = Float64(musicSlider.value) * totalSeconds
//            let seekTime = CMTime(value: Int64(value), timescale: 1)
//            
//            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
//                //perhaps do something later here
//            })
//        }
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupPlayerView()
//        setupGradientLayer()
//        
//        self.addSubview(controlsContainerView)
//        controlsContainerView.frame = frame
//        controlsContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePause)))
//        
//        controlsContainerView.addSubview(activityIndicatorView)
//        activityIndicatorView.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor).isActive = true
//        activityIndicatorView.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
//        
//        controlsContainerView.addSubview(pausePlayButton)
//        pausePlayButton.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
//        pausePlayButton.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor).isActive = true
//        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        
//        controlsContainerView.addSubview(musicLengthLabel)
//        musicLengthLabel.rightAnchor.constraint(equalTo: controlsContainerView.rightAnchor, constant: -8).isActive = true
//        musicLengthLabel.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor).isActive = true
//        musicLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        musicLengthLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
//        
//        controlsContainerView.addSubview(currentTimeLabel)
//        currentTimeLabel.leftAnchor.constraint(equalTo: controlsContainerView.leftAnchor, constant: -2).isActive = true
//        currentTimeLabel.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor).isActive = true
//        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        currentTimeLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
//        
//        controlsContainerView.addSubview(musicSlider)
//        musicSlider.rightAnchor.constraint(equalTo: musicLengthLabel.leftAnchor).isActive = true
//        musicSlider.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor).isActive = true
//        musicSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor, constant: 4).isActive = true
//        musicSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        
//        
//        backgroundColor = UIColor.black
//    }
//    
//    func handlePause() {
//        if isPlaying == true {
//            pausePlayButton.setImage(#imageLiteral(resourceName: "play"), for: UIControlState.normal)
//            pausePlayButton.isHidden = false
//            player?.pause()
//        }else {
//            pausePlayButton.setImage(#imageLiteral(resourceName: "pause"), for: UIControlState.normal)
//            pausePlayButton.isHidden = false
//            Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (time) in
//                self.pausePlayButton.isHidden = true
//            }
//            player?.play()
//        }
//        
//        isPlaying = !isPlaying
//    }
//    
//    fileprivate func setupPlayerView() {
//        let link = "https://zmp3-mp3-mv1-te-vnno-vn-1.zadn.vn/4efc52c16c8485dadc95/168176087412415806?authen=exp=1511320039~acl=/4efc52c16c8485dadc95/*~hmac=80900fbd5c13bdb1e2de31b5a5ed27e2"
//        
//        if let url = URL(string: link) {
//            player = AVPlayer(url: url)
//            
//            let playerLayer = AVPlayerLayer(player: player)
//            self.layer.addSublayer(playerLayer)
//            playerLayer.frame = self.frame
//            
//            player?.play()
//            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
//            
//            let interval = CMTime(value: 1, timescale: 2)
//            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
//                
//                let seconds = CMTimeGetSeconds(progressTime)
//                let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
//                let minutesString = String(format: "%02d", Int(seconds / 60))
//                
//                self.currentTimeLabel.text = "\(minutesString):\(secondsString)"
//                
//                //lets move the slider thumb
//                if let duration = self.player?.currentItem?.duration {
//                    let durationSeconds = CMTimeGetSeconds(duration)
//                    
//                    self.musicSlider.value = Float(seconds / durationSeconds)
//                    
//                }
//                
//            })
//        }
//    }
//    
//    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "currentItem.loadedTimeRanges" {
//            activityIndicatorView.stopAnimating()
//            controlsContainerView.backgroundColor = .clear
//            
//            if let duration = player?.currentItem?.duration {
//                let seconds = CMTimeGetSeconds(duration)
//                let secondsText = Int(seconds) % 60
//                let minutesText = String(format: "%02d", Int(seconds) / 60)
//                musicLengthLabel.text = "\(minutesText):\(secondsText)"
//            }
//            
//            if lockShowPauseButton == true {
//                isPlaying = true
//                pausePlayButton.isHidden = false
//                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (time) in
//                    self.pausePlayButton.isHidden = true
//                    self.lockShowPauseButton = false
//                }
//            }
//        }
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
