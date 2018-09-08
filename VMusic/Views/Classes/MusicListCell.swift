//
//  MusicListCell.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 23.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import UIKit

protocol MusicListCellDelegate {
    func didPressDownloadButton(for Index: Int)
}

extension MusicListCellDelegate {
    func didPressDownloadButton(for Index: Int) { }
}

class MusicListCell: UITableViewCell {
    
    var delegate: MusicListCellDelegate?
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var authorTitleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var widthConstraintDownloadButton: NSLayoutConstraint!
    @IBOutlet weak var progressRing: UIActivityIndicatorView!
    
    var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.iconView.layer.cornerRadius = 3
        self.iconView.clipsToBounds = true
        progressRing.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func downloadButtonAction(_ sender: Any) {
        progressRing.isHidden = false
        downloadButton.isHidden = true
        delegate?.didPressDownloadButton(for: index)
    }
}
