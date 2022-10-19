//
//  SongListViewController.swift
//  AppMusicPlayer
//
//  Created by Quang Khánh on 19/10/2022.
//

import UIKit

final class SongListViewController: UIViewController {
    
    @IBOutlet private weak var songListTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }
    
    private func configTableView() {
        songListTable.dataSource = self
        songListTable.delegate = self
        songListTable.backgroundColor = .white
    }
}

extension SongListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListMusic.listSong.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as? ItemSongTableViewCell else {
            return UITableViewCell()
        }

        cell.setDataCell(index: indexPath.row)
        cell.backgroundColor = .white
        return cell
    }
}

extension SongListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        songListTable.deselectRow(at: indexPath, animated: false)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let playMediaViewController = sb.instantiateViewController(identifier: "PlayMedia") as? PlayMediaViewController else {
            return 
        }
        playMediaViewController.setDataPage(index: indexPath.row)
        self.navigationController?.pushViewController(playMediaViewController, animated: true)
    }
}
