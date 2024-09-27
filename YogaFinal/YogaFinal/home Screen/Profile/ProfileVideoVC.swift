//
//  ProfileVideoVC.swift
//  YogaFinal
//
//  Created by student on 16/04/24.
//

import UIKit
import youtube_ios_player_helper
import CoreData
import SDWebImage

class ProfileVideoVC: UIViewController, YTPlayerViewDelegate {
    @IBOutlet weak var videoPlayer: YTPlayerView!
    var video : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hiihgvhgjhfhvhgcg-------------------------\(String(describing: video))https://youtu.be/2nENgcT9z3g")
        videoPlayer.delegate = self
        
        videoPlayer.load(withVideoId: video ?? "")
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        videoPlayer.playVideo()
    }
   

}
