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
        searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Find Music"
        return searchBar
    }()
    
    let searchTutorial = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search"
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        tabBarController?.tabBar.isHidden = true
//        self.automaticallyAdjustsScrollViewInsets = false
        
        
        
        setupSearchTutorial()
        setupRightNavigationButton()
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
    
    func updateMusicPlayer() {
        if let keyWindow = UIApplication.shared.keyWindow {
            let viewSuper2 = keyWindow.viewWithTag(111)?.viewWithTag(110) as! MusicView
            viewSuper2.music = musicForPlayer
            //            viewSuper?.viewWithTag(110)?.music = musicForPlayer
            
        }
    }
    
    
    func fetchMusic(keyWord: String) {
        let backgroundLoadingView = UIView()
        let activityIndicator = UIActivityIndicatorView()
        if let keyWindow = UIApplication.shared.keyWindow {
            backgroundLoadingView.frame = keyWindow.frame
            backgroundLoadingView.backgroundColor = UIColor(white: 0, alpha: 0.4)
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
        
            keyWindow.addSubview(backgroundLoadingView)
            backgroundLoadingView.tag = 199
            backgroundLoadingView.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
        
        ApiService.sharedInstance.fetchSearch(keyWord: keyWord, { (musics) in
            self.musics = musics
            if let keyWindow = UIApplication.shared.keyWindow {
                if let viewWithTag = keyWindow.viewWithTag(199) {
                    activityIndicator.stopAnimating()
                    viewWithTag.removeFromSuperview()
                }
            }
            self.collectionView?.reloadData()
        })
    }
    
    
    func setupRightNavigationButton(){
        let playingButtonItem = UIBarButtonItem(image: UIImage(named: "playing")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handlePlaying))
        navigationItem.rightBarButtonItems = [playingButtonItem]
    }
    
    func handlePlaying() {
        if musicForPlayer != nil {
            showMusicPlayer()
        }
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
    
    func setupSearchTutorial() {
        let tutorialString = "type Song Name, Artist in search bar to\nfind your music =))))\n@9fury"
        let tutorialMutableString = NSMutableAttributedString(string: tutorialString, attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 18)])
        tutorialMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: NSRange(location:5,length:17))
        tutorialMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.orange, range: NSRange(location:26,length:10))
        tutorialMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:62,length:6))
        searchTutorial.textAlignment = .center
        searchTutorial.attributedText = tutorialMutableString
        searchTutorial.numberOfLines = 0
        searchTutorial.sizeToFit()
        searchTutorial.isHidden = false
        view.addSubview(searchTutorial)
        view.addContraintsWithFormat(format: "V:|-70-[v0]", views: searchTutorial)
        view.addContraintsWithFormat(format: "H:|[v0]|", views: searchTutorial)
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
            searchTutorial.isHidden = true
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

