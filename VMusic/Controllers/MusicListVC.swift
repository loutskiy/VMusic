//
//  MusicListVC.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 23.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import UIKit
import ICSPullToRefresh
import LNPopupController
import MBProgressHUD

class MusicListVC: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var data = [VMDatmusicModel]()
    var offset = 0
    var currentIndexPathRow = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.tableView.register(UINib(nibName: __kCV__MusicListCell, bundle: Bundle.main), forCellReuseIdentifier: __kCV__MusicListCell)
        self.loadData()
        
        tableView.addInfiniteScrollingWithHandler {
            DispatchQueue.global(qos: .userInitiated).async {
                // do something in the background
                DispatchQueue.main.async { [unowned self] in
                    self.offset += 1
                    self.loadData()
                    print(self.offset)
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .reloadData, object: nil)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        VMCaptcha.shared.openCaptchaView(captchaIndex: 0, captchaId: 0, captchaImg: "")
//    }
//    
    @objc func loadData () {
        if offset == 0 {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        VMusic.shared.getSongs(query: self.searchBar.text ?? "", offset: offset) { (data) in
            if data.count > 0 {
                if self.offset == 0 {
                    self.data = data
                } else {
                    self.data += data
                }
                self.tableView.reloadData()
            } else {
                if self.offset > 0 {
                    self.offset -= 1
                }
            }
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
        let song: VMDatmusicModel = self.data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: __kCV__MusicListCell, for: indexPath) as! MusicListCell
        cell.songTitleLabel.text = song.title
        cell.authorTitleLabel.text = song.artist
        cell.durationLabel.text = song.duration.toAudioString
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentIndexPathRow != indexPath.row {
            currentIndexPathRow = indexPath.row
            let song = self.data[indexPath.row]
            
            updateCurrentTrackInfo()
            let sourceURL = URL(string: song.url)
            DispatchQueue.global(qos: .background).async {
                AudioPlayer.defaultPlayer.playAudio(fromURL: sourceURL)
            }
            
            let player = self.storyboard?.instantiateViewController(withIdentifier: __kCC__MusicPlayerVC) as! MusicPlayerVC
            
            player.albumArt = #imageLiteral(resourceName: "AlbumPlaceholder")
            player.songTitle = song.title
            player.albumTitle = song.artist
            player.popupItem.progress = 0;
            
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

extension MusicListVC: MusicListCellDelegate {
    func didPressDownloadButton(for Index: Int) {
        showAlertMessage(text: "Для загрузки аудиозаписи, необходимо войти в аккаунт ВКонтакте", title: "Требуется авторизация")
    }
}
