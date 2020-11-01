//
//  ImagePicker.swift
//  AVFoundation+SaveLocal
//
//  Created by Glenn Posadas on 11/1/20.
//

import AVFoundation
import UIKit

typealias ImagePickerCallBack = ((_ selectedImageData: Data?) -> Void)

public protocol ImagePickerDelegate: class {
    func didSelect(imageData: Data)
    func didSelect(videoData: Data, videoURL: URL)
    func didCancel()
}

public extension ImagePickerDelegate {
    func didSelect(imageData: Data) { }
    func didSelect(videoData: Data, videoURL: URL) { }
    func didCancel() { }
}

open class ImagePicker: NSObject {
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    public func present(from sourceView: UIView?, barButtonItemSource: UIBarButtonItem? = nil) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Camera") {
            alertController.addAction(action)
        }
        
        if let action = self.action(for: .photoLibrary, title: "Select from Camera Roll") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if barButtonItemSource != nil {
                alertController.popoverPresentationController?.barButtonItem = barButtonItemSource
            } else {
                alertController.popoverPresentationController?.sourceView = sourceView
                alertController.popoverPresentationController?.sourceRect = sourceView?.bounds ?? .zero
            }
            
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.delegate?.didCancel()
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true) {
            if let image = info[.originalImage] as? UIImage,
                let data = image.jpegData(compressionQuality: 0.8) {
                self.delegate?.didSelect(imageData: data)
            }
        }
        
        if let videoURL = info[.mediaURL] as? URL {
            do {
                let videoData = try Data(contentsOf: videoURL, options: .mappedIfSafe)
                self.delegate?.didSelect(videoData: videoData, videoURL: videoURL)
            } catch {
                print("Error: \(error.localizedDescription)")
                UIViewController.current()?.alert(error.localizedDescription)
            }
        }
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}
