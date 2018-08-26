//
//  VMDownloadManager.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 24.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
import Alamofire

protocol VMDownloadManagerDelegate {
    func didFinishDownloadingSong (_ song : VMSongModel, path : String)
    func didGetDownloadProgressForSong (_ song : VMSongModel, progress : Float)
}

extension VMDownloadManagerDelegate {
    func didFinishDownloadingSong (_ song : VMSongModel, path : String) { }
    func didGetDownloadProgressForSong (_ song : VMSongModel, progress : Float) { }
}

class VMDownloadManager {
    
    static let shared = VMDownloadManager()
    
    var delegate : VMDownloadManagerDelegate?
    
    fileprivate var queue = [VMSongModel]()
    
    fileprivate var proccessQueue = [VMSongModel]()
    
    fileprivate var isWorking = false
    
    fileprivate init() {
        DispatchQueue.global().async {
            while true {
                if self.queue.count > 0 && self.isWorking {
                    self.isWorking = false
                    self.downloadingSongs()
                    // Вызов метода загрузки файлов
                }
            }
        }
    }
    
    func downloadSong (_ song : VMSongModel ) {
        if !queue.contains(song) {
            queue.append(song)
            self.isWorking = true
        }
    }
    
    fileprivate func downloadingSongs () {
        for song in queue {
            if !proccessQueue.contains(song) {
                proccessQueue.append(song)
                
                let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let fileURL = documentsURL.appendingPathComponent("\(song.id)_\(song.ownerId).mp3")
                    
                    return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                }

                Alamofire.download(URL(string: song.url)!, to: destination).downloadProgress { (progress) in
                    print(progress.fractionCompleted * 100.0)
                    DispatchQueue.main.async {
                        self.delegate?.didGetDownloadProgressForSong(song, progress: Float(progress.fractionCompleted * 100.0))
                    }
                    } .responseData { response in
                        switch response.result {
                        case .success:
                            self.queue = self.queue.filter {$0 !== song}
                            self.proccessQueue = self.proccessQueue.filter {$0 !== song}
                            DispatchQueue.main.async {
                                song.localPath = "\(song.id)_\(song.ownerId).mp3"
                                VMCache.shared.insertSong(song)
                                self.delegate?.didFinishDownloadingSong(song, path: response.destinationURL?.path ?? "")
                            }
                        case .failure(let error):
                            print(error)
                        }
                }
            }
        }
    }
}
