//
//  ViewController.swift
//  AVFoundation+SaveLocal
//
//  Created by Glenn Posadas on 11/1/20.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - Overrides
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

