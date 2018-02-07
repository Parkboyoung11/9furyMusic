//
//  SearchController.swift
//  9furyMusic
//
//  Created by VuHongSon on 2/7/18.
//  Copyright © 2018 VuHongSon. All rights reserved.
//

import UIKit

class SearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellID = "cellID"
    var musics : [Music]?
//    var isSearching = false
    
    let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.keyboardType = UIKeyboardType.default
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Find Music"
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search"
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        tabBarController?.tabBar.isHidden = true
//        self.automaticallyAdjustsScrollViewInsets = false
        setupSearchBar()
        setupCollectionView()
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musics?.count ?? 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SearchCell
        cell.music = musics?[indexPath.item]
        cell.ratingLabel.text = String(indexPath.item + 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
    
    
    func fetchMusic(keyWord: String) {
        ApiService.sharedInstance.fetchSearch(keyWord: keyWord, { (musics) in
            self.musics = musics
            self.collectionView?.reloadData()
        })
    }
    
    
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 0
        }
        collectionView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        collectionView?.register(SearchCell.self, forCellWithReuseIdentifier: cellID)
        
        collectionView?.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
//        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
//        collectionView?.isPagingEnabled = true
    }
    
    func setupSearchBar() {
        view.addSubview(searchBar)
        view.addContraintsWithFormat(format: "V:|[v0(44)]", views: searchBar)
        view.addContraintsWithFormat(format: "H:|[v0]|", views: searchBar)
        searchBar.delegate = self
        
    }
    
    func hideKeyboardss() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardss))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardss() {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    

}

extension SearchController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        if searchBar.text != nil {
            let keyWord = searchBar.text?.replacingOccurrences(of: " ", with: "+")
            fetchMusic(keyWord: keyWord!)
            collectionView?.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        hideKeyboardss()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}

