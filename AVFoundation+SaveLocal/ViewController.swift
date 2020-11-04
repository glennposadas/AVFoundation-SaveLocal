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
        if self.savedURL == nil {
            // Get the fileName from the userDefaults or from your db.
            let fileName = UserDefaults.standard.string(forKey: "fileName") ?? ""
            let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                .first!
                .appendingPathComponent(fileName)
            self.savedURL = fileUrl
        }
        
        if self.player == nil {
            self.player = AVPlayer(url: self.savedURL!)
            let playerLayer = AVPlayerLayer(player: self.player)
            playerLayer.frame = self.containerView.frame
            self.containerView.layer.addSublayer(playerLayer)
        }
        
        self.player.play()
    }
    
    /// The method from the SO question (but a bit modified):
    /// https://stackoverflow.com/questions/64630868/swift-error-while-saving-video-data-from-url
    private func saveVideo(_ url: URL) -> Void {
        let fileName = "\(UUID.init().uuidString).mp4"
        let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent(fileName)
        
        UserDefaults.standard.set(fileName, forKey: "fileName")
        
        self.savedURL = fileUrl
        print("SAVED URL: \(String(describing: self.savedURL))")
        
        DispatchQueue.global(qos: .background).async {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let session = URLSession.shared
            
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
                    print("response: \(String(describing: response)) | error: \(String(describing: error)) | data is nil? \(data == nil)")
                    print("Save to: \(fileUrl.path)")
                    if let data = data {
                        do {
                            try data.write(to: fileUrl, options: Data.WritingOptions.atomic)
                            print("✅✅✅✅")
                        } catch {
                            print("error saving video: \(error.localizedDescription)")
                        }
                    }
                }
            }).resume()
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
        print("didSelect Video")
        self.saveVideo(videoURL)
    }
}

