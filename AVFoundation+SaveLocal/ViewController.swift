//
//  ViewController.swift
//  AVFoundation+SaveLocal
//
//  Created by Glenn Posadas on 11/1/20.
//

import AVFoundation
import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var containerView: UIView!
    private var player: AVPlayer!
    
    // MARK: - Overrides
    // MARK: Functions
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadSavedVideo()
    }
    
    private func loadSavedVideo() {
        let videoURL = URL(string: "video url here...")
        
        if self.player == nil {
            self.player = AVPlayer(url: videoURL!)
            let playerLayer = AVPlayerLayer(player: self.player)
            playerLayer.frame = self.containerView.frame
            self.containerView.layer.addSublayer(playerLayer)
        }
        
        self.player.play()
    }
    
    @IBAction func loadSavedVideo(_ sender: UIBarButtonItem) {
        self.loadSavedVideo()
    }
    
    @IBAction func selectVideo(_ sender: UIBarButtonItem) {
        let picker = ImagePicker(
            presentationController: self,
            delegate: self
        )
        
        picker.present(from: nil,
                       barButtonItemSource: sender)
    }
}

// MARK: - ImagePickerDelegate

extension ViewController: ImagePickerDelegate {
    func didSelect(videoData: Data, videoURL: URL) {
        
    }
}

