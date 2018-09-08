//
//  SettingsVC.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 25.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import UIKit
import SDWebImage

class SettingsVC: UITableViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    func loadData () {
        VMusic.shared.getUserInfo { (user) in
            self.userImageView.sd_setImage(with: URL(string: user.photoBig), placeholderImage: nil, options: [], completed: nil)
            self.userNameLabel.text = "\(user.firstName) \(user.secondName)"
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                VMCache.shared.clearAll()
                break
            case 1:
                break
            case 2:
                UIApplication.shared.open(URL(string: "https://lwts.ru")!, options: [:], completionHandler: nil)
            case 3:
                UIApplication.shared.open(URL(string: "https://vk.com/privacy")!, options: [:], completionHandler: nil)
            default:
                break
            }
            break
        case 2:
            switch indexPath.row {
            case 0:
                VMusic.shared.deauth()
                break
            default:
                break
            }
            break
        default:
            break
        }
    }
    
}
