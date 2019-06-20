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
    
    var isEditingNew: Bool!
    
    var editingIndex: Int?
    
    var passwordData: Password!
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var storeField: UITextField!
    
    @IBOutlet weak var userField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        checkPassword()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.addTarget(self, action: #selector(titleFieldDidChange(_:)), for: .editingChanged)
        userField.addTarget(self, action: #selector(userFieldDidChange(_:)), for: .editingChanged)
        storeField.addTarget(self, action: #selector(infoFieldDidChange(_:)), for: .editingChanged)
        
        // Do any additional setup after loading the view.
    }
    
    func checkPassword() {
        if !isEditingNew {
            titleField.text = passwordData.site
            storeField.text = passwordData.password
            if let user = passwordData.userName {
                userField.text = user
            }
        }
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        print("save tapped")
    }
    
    @objc func titleFieldDidChange(_ textField: UITextField) {
        if let text = titleField.text {
            passwordData.site = text
        }
    }
    
    @objc func infoFieldDidChange(_ textField: UITextField) {
        if let text = storeField.text {
            passwordData.password = text
        }
    }

    @objc func userFieldDidChange(_ textField: UITextField) {
        if let text = userField.text {
            passwordData.userName = text
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveSegue" {
            if let destVC = segue.destination as? InfoListTableViewController {
                if isEditingNew {
                    destVC.info.append(passwordData)
                    destVC.tableView.reloadData()
                } else {
                    if let index = editingIndex {
                         destVC.info[index] = passwordData
                        destVC.tableView.reloadData()
                    }
                }
                
            }
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
