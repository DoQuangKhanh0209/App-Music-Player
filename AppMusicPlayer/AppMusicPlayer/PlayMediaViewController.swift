//
//  PlayMediaViewController.swift
//  AppMusicPlayer
//
//  Created by Quang Khánh on 17/10/2022.
//
import UIKit
import AVFoundation
import MediaPlayer

final class PlayMediaViewController: UIViewController {
    
    private var index: Int?
    private var player: AVAudioPlayer?
    private var fileMusic: String?
    
    @IBOutlet private weak var sliderMusicTime: UISlider!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var txtAuthorMusic: UILabel!
    @IBOutlet private weak var txtNameMusic: UILabel!
    @IBOutlet private weak var imgMusic: UIImageView!
    
    override func viewDidLoad() {
        playButton.layer.cornerRadius = playButton.frame.width/2
        setupDataUIMusic()
        playSongMusic()
    }
    
    private func setupDataUIMusic() {
        imgMusic?.image = UIImage(named: ListMusic.listSong[index ?? 0].imageMusic ?? "")
        txtNameMusic?.text = ListMusic.listSong[index ?? 0].name ?? ""
        txtAuthorMusic?.text = ListMusic.listSong[index ?? 0].author ?? ""
        fileMusic = ListMusic.listSong[index ?? 0].fileMusic
    }
    
    private func playSongMusic() {
        guard let url = Bundle.main.url(forResource: fileMusic ?? "", withExtension: "mp3") else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else {
                return
            }
            player.play()
            sliderMusicTime.maximumValue = Float(player.duration)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.updateSlider()
            }
            
            //into music in lokscreen
            guard let image = UIImage(named: ListMusic.listSong[index ?? 0].imageMusic!) else {
                        return
                    }
            let artWork = MPMediaItemArtwork(boundsSize: image.size, requestHandler: {
                (size) -> UIImage in return image
            })
            
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                MPMediaItemPropertyTitle: ListMusic.listSong[index ?? 0].name ?? 0,
                MPMediaItemPropertyArtist: ListMusic.listSong[index ?? 0].author ?? 0,
                MPMediaItemPropertyPlaybackDuration: player.duration,
                MPMediaItemPropertyArtwork: artWork
            ]
            
            UIApplication.shared.beginReceivingRemoteControlEvents()
            becomeFirstResponder()
        } catch _ {
            print("something went wrong")
        }
    }
    
    //music playback control function
    override func remoteControlReceived(with event: UIEvent?) {
        if let event = event {
            if event.type == .remoteControl {
                switch event.subtype {
                case.remoteControlPlay:
                    player?.play()
                case.remoteControlStop:
                    player?.stop()
                case.remoteControlPause:
                    player?.pause()
                case.remoteControlNextTrack:
                    index = ((index ?? 0) + 1 + 3) % 3
                    setupDataUIMusic()
                    playSongMusic()
                case.remoteControlPreviousTrack:
                    index = ((index ?? 0) - 1 + 3) % 3
                    setupDataUIMusic()
                    playSongMusic()
                default: break
                }
            }
        }
    }
    
    private func updateSlider() {
        sliderMusicTime.value = Float(player?.currentTime ?? 0.0)

        if (Int(player?.currentTime ?? 0) == Int(player?.duration ?? 0)) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.endMusic()
            }
        }
    }
    
    private func endMusic() {
        index = ((index ?? 0) + 1 + 3) % 3
        setupDataUIMusic()
        playSongMusic()
    }
    
    func setDataPage(index: Int) {
     self.index = index
 }
    
    @IBAction private func playButton(_ sender: UIButton) {
        if let player = player {
            if (player.isPlaying) {
                player.pause()
                playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            } else {
                player.play()
                playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
        }
    }
    
    @IBAction private func prevMusic(_ sender: UIButton) {
        index = ((index ?? 0) - 1 + 3) % 3
        setupDataUIMusic()
        playSongMusic()
    }
    
    @IBAction private func nextMusic(_ sender: UIButton) {
        index = ((index ?? 0) + 1 + 3) % 3
        setupDataUIMusic()
        playSongMusic()
    }
    
    @IBAction private func changeTimeSlide(_ sender: UISlider) {
        player?.pause()
        player?.currentTime = TimeInterval(sliderMusicTime.value)
        player?.play()
    }
}
