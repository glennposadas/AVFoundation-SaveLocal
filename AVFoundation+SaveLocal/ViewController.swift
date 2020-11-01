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
    private var savedURL: URL?
    private lazy var picker: ImagePicker = {
        return ImagePicker(
            presentationController: self,
            delegate: self
        )
    }()
    
    // MARK: - Overrides
    // MARK: Functions
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadSavedVideo()
    }
    
    private func loadSavedVideo() {
        guard let videoURL = self.savedURL else { return }
        
        if self.player == nil {
            self.player = AVPlayer(url: videoURL)
            let playerLayer = AVPlayerLayer(player: self.player)
            playerLayer.frame = self.containerView.frame
            self.containerView.layer.addSublayer(playerLayer)
        }
        
        self.player.play()
    }
    
    /// The method from the SO question (but a bit modified):
    /// https://stackoverflow.com/questions/64630868/swift-error-while-saving-video-data-from-url
    private func saveVideo(_ url: URL) -> Void {
        let homeDirectory = URL.init(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
        let fileUrl = homeDirectory.appendingPathComponent("someAdId")
            .appendingPathComponent("video-clip")
            .appendingPathComponent(UUID.init().uuidString, isDirectory: false)
            .appendingPathExtension("mov")
        
        self.savedURL = fileUrl
        print("SAVED URL: \(String(describing: self.savedURL))")
        
        do {
            let data = try Data(contentsOf: url)
            try data.write(to: fileUrl, options: .atomicWrite)
            print("✅✅✅✅")
        } catch {
            print("error saving video: \(error.localizedDescription)")
        }
        
    }
    
    @IBAction func loadSavedVideo(_ sender: UIBarButtonItem) {
        self.loadSavedVideo()
    }
    
    @IBAction func selectVideo(_ sender: UIBarButtonItem) {
        self.picker.present(from: nil,
                            barButtonItemSource: sender)
    }
}

// MARK: - ImagePickerDelegate

extension ViewController: ImagePickerDelegate {
    func didSelect(videoData: Data, videoURL: URL) {
        self.saveVideo(videoURL)
    }
}

