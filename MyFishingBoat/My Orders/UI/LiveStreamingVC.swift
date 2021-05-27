//
//  LiveStreamingVC.swift
//  MyFishingBoat
//
//  Created by vikas on 05/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit
import AVKit

class LiveStreamingVC: UIViewController {

    @IBOutlet var videoView: UIView!
    
    var player = AVPlayer()
    var avpController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        liveStream()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    func liveStream() {
        
        let myURL = "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4"
        
        let url = URL(string:myURL)

        player = AVPlayer(url: url!)

        avpController.player = player
        
        avpController.showsPlaybackControls = false
        
        avpController.view.frame.size.height = videoView.frame.size.height

        avpController.view.frame.size.width = videoView.frame.size.width

        self.videoView.addSubview(avpController.view)
        
        avpController.player?.play()
        
    }
    
}
