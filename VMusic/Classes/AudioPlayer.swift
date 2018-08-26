//
//  AudioPlayer.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 23.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

protocol AudioPlayerDelegate {
    func audioDidChangeTime(_ time: Int64)
    func playerWillPlayNextAudio(_ song: VMSongModel)
    func playerWillPlayPreviousAudio(_ song: VMSongModel)
    func receivedArtworkImage(_ image: UIImage)
}

class AudioPlayer {
    
    static let defaultPlayer = AudioPlayer()
    
    var delegate: AudioPlayerDelegate?
    static var index = 0
    fileprivate var player: AVPlayer!
    var currentAudio: VMSongModel!
    
    fileprivate var currentPlayList = [VMSongModel]()
    fileprivate var timeObserber: AnyObject?
    
    //MARK: - Time Observer
    
    fileprivate func addTimeObeserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: 1)
        timeObserber = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) {
            (time: CMTime) -> Void in
            let currentTime  = Int64(time.value) / Int64(time.timescale)
            if let d = self.delegate {
                d.audioDidChangeTime(currentTime)
            }
            if currentTime == Int64(self.currentAudio.duration) {
                self.next()
            }
        } as AnyObject?
    }
    
    fileprivate func killTimeObserver() {
        if let observer = timeObserber {
            player.removeTimeObserver(observer)
        }
    }
    
    func playAudio(fromURL url: URL!) {
        if currentAudio != nil {
            killTimeObserver()
        }
        
        currentAudio = currentPlayList[AudioPlayer.index]
        let header = ["User-Agent":VMServerManager.userAgentForDatmusic]
        let asset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey":header])
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem:playerItem)
        player.play()
        addTimeObeserver()
        
//        let metadataList = playerItem.asset.metadata
//        var audio_image = currentPlayList[AudioPlayer.index].thumbnail_image
//        if metadataList.count > 0 {
//            for item in metadataList {
//                guard let key = item.commonKey, let value = item.value else { continue }
//                
//                if key.rawValue == "artwork" {
//                    if let audioImage = UIImage(data: value as! Data) {
//                        print("\nimage Found\n")
//                        audio_image = audioImage
//                        self.delegate?.receivedArtworkImage(audioImage)
//                    }
//                }
//            }
//        } else {
//            print("\nMetadataList is empty \n")
//        }
//        
        CommandCenter.defaultCenter.setNowPlayingInfo(artworkImage: #imageLiteral(resourceName: "AlbumPlaceholder"))
    }
    
    func play() {
        if let player = player {
            player.play()
        }
    }
    
    func previous() {
        var nextIndex = AudioPlayer.index - 1
        
        if nextIndex < 0 {
            nextIndex = currentPlayList.count - 1
        }
        
        currentAudio = currentPlayList[nextIndex]
        AudioPlayer.index = nextIndex
        
        NotificationCenter.default.post(name: .previousTrack, object: nil)
        delegate?.playerWillPlayPreviousAudio(currentPlayList[nextIndex])
    }
    
    func next() {
        var nextIndex = AudioPlayer.index + 1
        
        if nextIndex > (currentPlayList.count - 1) {
            nextIndex = 0
        }
        
        currentAudio = currentPlayList[nextIndex]
        AudioPlayer.index = nextIndex

        NotificationCenter.default.post(name: .nextTrack, object: nil)
        delegate?.playerWillPlayNextAudio(currentPlayList[nextIndex])
    }
    
    func pause() {
        if let player = player {
            player.pause()
        }
    }
    
    func getCurrentTime() -> Double {
        return player.currentTime().seconds
    }
    
    func kill() {
        if let player = player {
            killTimeObserver()
            player.replaceCurrentItem(with: nil)
            currentAudio = nil
        }
    }
    
    func setPlayList(_ playList: [VMSongModel]) {
        currentPlayList = playList
    }
    
    func seekToTime(_ time: CMTime) {
        player.seek(to: time)
    }
}
