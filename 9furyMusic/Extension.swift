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
}










