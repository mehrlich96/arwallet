//
//  InfoDetailViewController.swift
//  ARWallet
//
//  Created by Nicholas Zouras on 6/19/19.
//  Copyright © 2019 Ehrlich, Mark. All rights reserved.
//

import UIKit

class InfoDetailViewController: UIViewController, UITextFieldDelegate {

    var name: String = ""
    
    var dataManager = DataStoreManager.sharedDataStoreManager
    var sharedData = DataStoreManager.sharedDataStoreManager.dataStore
    
    @IBOutlet weak var infoName: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        infoName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = infoName.text {
            name = text
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneSegue" {
            name = infoName.text!
            
                    }
    }
    

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
