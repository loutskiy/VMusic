//
//  MusicLibraryVC.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 23.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import UIKit
import ICSPullToRefresh
import LNPopupController
import MBProgressHUD
import SDWebImage

class MusicLibraryVC: UITableViewController, UISearchBarDelegate {
    
    var data = [VMSongModel]()
    var offset = 0
    var currentIndexPathRow = -1
    var cache = [IndexPath : Artwork]()

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.searchBar.delegate = self
        VMDownloadManager.shared.delegate = self
        
        self.tableView.register(UINib(nibName: __kCV__MusicListCell, bundle: Bundle.main), forCellReuseIdentifier: __kCV__MusicListCell)
        
        tableView.addInfiniteScrollingWithHandler {
            DispatchQueue.global(qos: .userInitiated).async {
                // do something in the background
                DispatchQueue.main.async { [unowned self] in
                    self.offset += 100
                    self.loadData()
                    print(self.offset)
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .reloadData, object: nil)
        
        print(VMCache.shared.getSongs())
    }
    
    @objc func loadData() {
        if offset == 0 {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        VMusic.shared.getMySongs(offset: offset, query: searchBar.text!, store: segmentControl.selectedSegmentIndex == 0 ? .web : .local) { (data) in
            if data.count > 0 {
                if self.offset == 0 {
                    self.data = data
                } else {
                    self.data += data
                }
            } else {
                if self.offset > 0 {
                    self.offset -= 100
                }
            }
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tableView.infiniteScrollingView?.stopAnimating()
        }
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let song : VMSongModel = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: __kCV__MusicListCell, for: indexPath) as! MusicListCell
        cell.delegate = self
        cell.index = indexPath.row
        cell.songTitleLabel.text = song.title
        cell.authorTitleLabel.text = song.artist
        cell.durationLabel.text = song.duration.toAudioString
        if segmentControl.selectedSegmentIndex == 0 {
            try! realm.write {
                song.localPath = VMCache.shared.getLocalPathForSong(id:song.id)
            }
        }
        if song.localPath == "" {
            cell.downloadButton.setImage(#imageLiteral(resourceName: "download"), for: .normal)
        } else {
            cell.downloadButton.setImage(#imageLiteral(resourceName: "garbage"), for: .normal)
        }
        cell.iconView.image = #imageLiteral(resourceName: "AlbumPlaceholder")
        downloadImageFor(artist: song.artist, track: song.title, indexPath: indexPath)
        if VMDownloadManager.shared.getQueue().contains(song) {
            cell.progressRing.isHidden = false
//            cell.progressRing.startAnimating()
            cell.downloadButton.isHidden = true
        } else {
            cell.progressRing.isHidden = true
            cell.downloadButton.isHidden = false
        }

        return cell
    }
    
    func downloadImageFor(artist: String, track: String, indexPath: IndexPath ) {
        if let value = self.cache[indexPath] {
            print("pathCache")
            print(value.url)
            print(indexPath)
            print(self.tableView.indexPathsForVisibleRows)
            if (self.tableView.indexPathsForVisibleRows?.contains(indexPath))! {
                DispatchQueue.main.async {
                    let cell = self.tableView.cellForRow(at: indexPath) as! MusicListCell
                    cell.iconView.sd_setImage(with: URL(string: value.url), placeholderImage: #imageLiteral(resourceName: "AlbumPlaceholder"), options: [], completed: nil)
                }
            }
        } else {
            print(self.cache)
            VMusic.shared.getTrackArtwork(artist:artist, track: track, success: {
                path in
                print("path")
                print(path)
                print(indexPath)
                self.cache[indexPath] = Artwork(url: path)
                if (self.tableView.indexPathsForVisibleRows?.contains(indexPath))! {
                    let cell = self.tableView.cellForRow(at: indexPath) as! MusicListCell
                    cell.iconView.sd_setImage(with: URL(string: path), placeholderImage: #imageLiteral(resourceName: "AlbumPlaceholder"), options: [], completed: nil)
                }
            })
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentIndexPathRow != indexPath.row {
            currentIndexPathRow = indexPath.row
            let song : VMSongModel = self.data[indexPath.row]
            
            updateCurrentTrackInfo()
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let fileURL = documentsURL.appendingPathComponent("\(song.id)_\(song.ownerId).mp3")
            let sourceURL = URL(string: song.localPath == "" ? song.url : documentsURL.appendingPathComponent(song.localPath).absoluteString)
            print(sourceURL)
            DispatchQueue.global(qos: .background).async {
                AudioPlayer.defaultPlayer.playAudio(fromURL: sourceURL)
            }
            
            let player = self.storyboard?.instantiateViewController(withIdentifier: __kCC__MusicPlayerVC) as! MusicPlayerVC
            
            player.albumArt = #imageLiteral(resourceName: "AlbumPlaceholder")
            player.songTitle = song.title
            player.albumTitle = song.artist
            player.popupItem.progress = 0;
            
            VMusic.shared.getTrackArtwork(artist:song.artist, track: song.title, success: {
                path in
                print("path")
                print(path)
                SDWebImageDownloader.shared().downloadImage(with: URL(string: path), options: [], progress: nil, completed: { (image, data, error, _) in
                    player.albumArt = image!
                })
            })

            tabBarController?.presentPopupBar(withContentViewController: player, animated: true, completion: nil)
            tabBarController?.popupBar.tintColor = .VMusicBlue
            tabBarController?.popupBar.imageView.layer.cornerRadius = 5
            tabBarController?.popupBar.progressViewStyle = .top

        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func updateCurrentTrackInfo() {
        AudioPlayer.defaultPlayer.setPlayList(data)
        AudioPlayer.index = currentIndexPathRow

        NotificationCenter.default.post(name: .playTrackAtIndex, object: nil, userInfo: ["index" : currentIndexPathRow])
    }
    
    @IBAction func segmentControlAction(_ sender: Any) {
        self.data = [VMSongModel]()
        self.offset = 0
        self.loadData()
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.offset = 0
        self.loadData()
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.offset = 0
        self.loadData()
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}

extension MusicLibraryVC: MusicListCellDelegate {
    func didPressDownloadButton(for Index: Int) {
        let song : VMSongModel = data[Index]
        if song.localPath == "" {
            let downloadManager = VMDownloadManager.shared
            downloadManager.downloadSong(song)
        } else {
            VMCache.shared.deleteSong(song)
            self.tableView.reloadData()
        }
//        tableView.reloadData()
    }
}

extension MusicLibraryVC: VMDownloadManagerDelegate {
    
    func didFinishDownloadingSong (_ song : VMSongModel, path : String) {
        print("reloadTableData")
        tableView.reloadData()
    }

}
