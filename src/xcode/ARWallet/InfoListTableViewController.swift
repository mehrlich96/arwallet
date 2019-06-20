//
//  InfoListTableViewController.swift
//  ARWallet
//
//  Created by Nicholas Zouras on 6/19/19.
//  Copyright © 2019 Ehrlich, Mark. All rights reserved.
//

import UIKit

class InfoListTableViewController: UITableViewController {
    
    var info = [Password]()
    var newInfo: Password?
    
    var currentImage: UIImage!
    
    var dataManager = DataStoreManager.sharedDataStoreManager
    var sharedData = DataStoreManager.sharedDataStoreManager.dataStore

    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    
    var isEditingNew = true
    
    @IBAction func addInfo(_ sender: Any) {
        isEditingNew = true
        self.performSegue(withIdentifier: "segueToAdd", sender: self)
    }
    @IBAction func done(segue:UIStoryboardSegue) {
        
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        info = [Password(password: "888-88-8888", userName: nil, site: "Social Security Number"), Password(password: "55 555 555", userName: nil, site: "Driver's License Number")]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sharedData.userPData.append(ViewData(passwords: info))
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return info.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < info.count {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)

        var pword = info[indexPath.row]
        cell.textLabel?.text = pword.site
        cell.detailTextLabel?.text = pword.password
        // Configure the cell...

        return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
            
            cell.backgroundColor = UIColor.blue
            
            cell.textLabel?.text = "DONE"
            cell.textLabel?.textColor = UIColor.white
            
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < info.count {
        if let data = info[indexPath.row] as? Password {
            passingData = data
            editingIndex = indexPath.row
            self.isEditingNew = false
            self.performSegue(withIdentifier: "segueToAdd", sender: nil)
        }
        } else {
            print("done btn tapped")
            
            let alert = UIAlertController(title: "Name", message: "Please enter a reference image name", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Enter Reference Image Name"
                })
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
                let firstTextField = alert.textFields![0] as UITextField
                self.referenceName = firstTextField.text
                self.createReferenceImage()
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
        }
    }
    
    var referenceName: String?
    
    func createReferenceImage() {
        let viewG = self.tableView
        let renderer = UIGraphicsImageRenderer(size: viewG!.bounds.size)
        let image = renderer.image { ctx in
            viewG!.drawHierarchy(in: viewG!.bounds, afterScreenUpdates: true)
        }
        
        if let name = referenceName {
            sharedData.ReferenceDict[name] = (image, ViewData(passwords: info), currentImage)
            dataManager.saveDataStore()
        } else {
            sharedData.ReferenceDict["Random"] = (image, ViewData(passwords: info), currentImage)
            dataManager.saveDataStore()
        }
        

        self.navigationController?.popViewController(animated: true)
    }
    
    var passingData: Password?
    var editingIndex: Int?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAdd" {
            if let destVC = segue.destination as? InfoDetailViewController {
                if !isEditingNew {
                    destVC.passwordData = passingData
                    destVC.isEditingNew = false
                    destVC.editingIndex = editingIndex
                } else {
                    destVC.passwordData = Password(password: "", userName: "", site: "")
                    destVC.isEditingNew = true
                }
            }
        }
    }
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}