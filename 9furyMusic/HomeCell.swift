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
        
        addData()
        
        backgroundColor = UIColor.brown
        addSubview(collectionView)
        addContraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addContraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        collectionView.register(MusicCell.self, forCellWithReuseIdentifier: cellID)
        
    }
    
    func addData() {
        let music1 = Music(dictionary: ["avatarImageURL" : "abcd", "title":"My Love", "artist":"Westlife", "numberView":"111.234", "quality":"Lossless", "rating":"1"])
        let music2 = Music(dictionary: ["avatarImageURL" : "abcd", "title":"I Lay My Love On You", "artist":"Westlife", "numberView":"234.678", "quality":"Lossless", "rating":"2"])
        let music3 = Music(dictionary: ["avatarImageURL" : "abcd", "title":"Season In The Sun", "artist":"Westlife", "numberView":"34.567", "quality":"Lossless", "rating":"3"])
        let music4 = Music(dictionary: ["avatarImageURL" : "abcd", "title":"Haru Haru", "artist":"Big Bang", "numberView":"1.234.345", "quality":"320 Kbps", "rating":"4"])
        let music5 = Music(dictionary: ["avatarImageURL" : "abcd", "title":"Ichinen Nikagetsu Hatsuka", "artist":"Lisa", "numberView":"23.345", "quality":"Lossless", "rating":"5"])
        let music6 = Music(dictionary: ["avatarImageURL" : "abcd", "title":"Nguoi La Oi", "artist":"Karik; Orange; Superbrothers", "numberView":"104.668", "quality":"500 Kbps", "rating":"6"])
        let music7 = Music(dictionary: ["avatarImageURL" : "abcd", "title":"Buon Cua Anh", "artist":"Đạt G; K-ICM; Masew", "numberView":"23.234", "quality":"Lossless", "rating":"7"])
        let music8 = Music(dictionary: ["avatarImageURL" : "abcd", "title":"Da Lo Yeu Em Nhieu", "artist":"JustaTee", "numberView":"121.234", "quality":"Lossless", "rating":"8"])
        let music9 = Music(dictionary: ["avatarImageURL" : "abcd", "title":"Lang Tham", "artist":"Thuy Chi", "numberView":"212.234", "quality":"Lossless", "rating":"9"])
        
        musics = [Music]()
        musics?.append(music1)
        musics?.append(music2)
        musics?.append(music3)
        musics?.append(music4)
        musics?.append(music5)
        musics?.append(music6)
        musics?.append(music7)
        musics?.append(music8)
        musics?.append(music9)
//        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musics?.count ?? 0
//        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MusicCell
        cell.music = musics?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let height = (frame.width - 16 - 16) * 9 / 16
        return CGSize(width: frame.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
