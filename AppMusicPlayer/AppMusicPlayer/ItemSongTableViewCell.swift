//
//  ItemSongTableViewCell.swift
//  AppMusicPlayer
//
//  Created by Quang Khánh on 19/10/2022.
//

import UIKit

final class ItemSongTableViewCell: UITableViewCell {

    @IBOutlet private weak var txtAuthorMusic: UILabel!
    @IBOutlet private weak var txtNameMusic: UILabel!
    @IBOutlet private weak var imgBannerMusic: UIImageView!
    
    func setDataCell(index: Int) {
        imgBannerMusic?.image = UIImage(named: ListMusic.listSong[index].imageMusic ?? "")
        txtNameMusic?.text = ListMusic.listSong[index].name ?? ""
        txtAuthorMusic?.text = ListMusic.listSong[index].author ?? ""
    }
}
