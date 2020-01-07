//  RWVideoNinja
//
//  Created by Aleksey Shapoval on 1/6/20.
//  Copyright © 2020 VoVa LLC. All rights reserved.

import UIKit
import AVKit
import MobileCoreServices

class RecordVideoViewController: UIViewController {
  
  @IBAction func record(_ sender: AnyObject) {
    VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)
  }
  
  @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
    let title = (error == nil) ? "Success" : "Error"
    let message = (error == nil) ? "Video was saved" : "Video failed to save"
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  
}

extension RecordVideoViewController: UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

    dismiss(animated: true, completion: nil)
    
    guard
      let mediaType = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as? String,
      mediaType == (kUTTypeMovie as? String),
      let url = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as? URL,
      UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
      else {
        print("Failed to identify image mediaType & url")
        return
    }
    
    //Handle a movie capture
    UISaveVideoAtPathToSavedPhotosAlbum(url.path,
                                        self,
                                        #selector(video(_:didFinishSavingWithError:contextInfo:)),
                                        nil)
    
  }
  
}

extension RecordVideoViewController: UINavigationControllerDelegate {
  
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
