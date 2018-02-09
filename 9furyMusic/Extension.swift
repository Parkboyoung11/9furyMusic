//
//  Extension.swift
//  9furyMusic
//
//  Created by VuHongSon on 1/25/18.
//  Copyright © 2018 VuHongSon. All rights reserved.
//


import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    func addContraintsWithFormat(format: String , views : UIView...) {
        var viewsDictionary = [String : UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func separatorView() {
        self.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()


class CustomImageView : UIImageView {
    
    var imageUrlString : String?
    
    func loadImageFromURL(urlString : String) {
        
        imageUrlString = urlString
        
        let url = URL(string: urlString)
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, respone, error) in
            if error != nil {
                print(error ?? String())
                return
            }
            DispatchQueue.main.async(execute: {
                let imageToCache = UIImage(data: data!)
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
            })
        }).resume()
    }
}

extension UILabel {
    func myLabel(textColor: UIColor, textAlignment: NSTextAlignment, font: UIFont) {
        self.numberOfLines = 1
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.font = font
    }
    
    func customLabelWithText(textColor: UIColor, textAlignment: NSTextAlignment, font: UIFont, text: String) {
        myLabel(textColor: textColor, textAlignment: textAlignment, font: font)
        self.text = text
    }
    
    
}

extension UICollectionViewController {
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
}

extension UIImageView {
    func myImageSkin() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.brown.cgColor
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
}

extension UIButton {
    func customButton(image: UIImage, target: Any? , selector: Selector, tintColor: UIColor, isHidden: Bool) {
        self.setImage(image, for: UIControlState.normal)
        self.addTarget(target, action: selector, for: UIControlEvents.touchUpInside)
        self.tintColor = tintColor
        self.isHidden = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UISlider {
    func customSlider(thumbImage: UIImage, target: Any?, selector: Selector) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.maximumTrackTintColor = UIColor.white
        self.minimumTrackTintColor = UIColor.orange
        self.setThumbImage(thumbImage, for: UIControlState.normal)
        self.addTarget(target, action: selector, for: UIControlEvents.valueChanged)
        self.isUserInteractionEnabled = false
    }
}









