//
//  ImagePickingViewController.swift
//  ARWallet
//
//  Created by Ehrlich, Mark on 6/18/19.
//  Copyright © 2019 Ehrlich, Mark. All rights reserved.
//

import UIKit

class ImagePickingViewController: UIViewController {
    

    
    var imagePicker: ImagePicker!
    
    var DataManager = DataStoreManager.sharedDataStoreManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    @IBAction func showImagePicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
}

extension ImagePickingViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if let unwrappedImage = image {
            self.DataManager.dataStore.userReferenceImages.append(unwrappedImage)
            self.performSegue(withIdentifier: "showTable", sender: nil)
        }
    }
}
