//
//  InfoListTableViewController.swift
//  ARWallet
//
//  Created by Nicholas Zouras on 6/19/19.
//  Copyright © 2019 Ehrlich, Mark. All rights reserved.
//

import UIKit
import SAPFiori

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
//        if info.count >= 2 {
//            FUIToastMessage.show(message: "Error the recommended limit for this reference image is 2 messages", icon: FUIIconLibrary.system.information, inView: self.view, withDuration: 3, maxNumberOfLines: 5)
//        } else {
            self.performSegue(withIdentifier: "segueToAdd", sender: self)
        //}
    }
    @IBAction func done(segue:UIStoryboardSegue) {
        
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        passwordCells.removeAll()
        navigationController?.navigationBar.barTintColor = UIColor.init(hexString: "#1693c9")
        
        info = [Password(password: "888-88-8888", userName: nil, site: "Social Security Number"), Password(password: "55 555 555", userName: nil, site: "Driver's License Number")]
        
        tableView.register(FUIButtonFormCell.self, forCellReuseIdentifier: FUIButtonFormCell.reuseIdentifier)
        tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: FUIObjectTableViewCell.reuseIdentifier)
        
        tableView.backgroundColor = UIColor.white
        
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
    @IBOutlet weak var placehodlerView: UIView!
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: FUIObjectTableViewCell.reuseIdentifier, for: indexPath) as! FUIObjectTableViewCell

        var pword = info[indexPath.row]
        cell.headlineText = pword.site
        cell.subheadlineText = pword.password
        cell.footnoteText = pword.userName
            
            
        // Configure the cell...

        passwordCells.append(cell)
        
        return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: FUIButtonFormCell.reuseIdentifier, for: indexPath) as! FUIButtonFormCell
            
            doneBtnHeight = cell.frame.height
            
            cell.button.setTitle("Done", for: .normal)
            cell.button.addTarget(self, action: #selector(doneBtnFunc), for: .touchUpInside)
            return cell
        }
    }
    
    
    @objc func doneBtnFunc() {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < info.count {
        if let data = info[indexPath.row] as? Password {
            passingData = data
            editingIndex = indexPath.row
            self.isEditingNew = false
            self.performSegue(withIdentifier: "segueToAdd", sender: nil)
        }
        }
    }
    
    var doneBtnHeight: CGFloat? = 0
    
    var passwordCells: [FUIObjectTableViewCell] = [FUIObjectTableViewCell]()
    
    var referenceName: String?
    
    func createReferenceImage() {
        let viewG = self.tableView
        
        print(self.tableView.contentSize)
        
        let viewHeight = placehodlerView.frame.height
        let offset = viewHeight + doneBtnHeight!
        
        print("\(offset)")
        
        let adjustedSize = CGSize(width: self.tableView.contentSize.width, height: self.tableView.contentSize.height - offset)
        
        let imager = self.tableView.asFullImage()
        let imamage = generateImage(tblview: self.tableView)
        
        let imageWidth = imamage.size.width
        let imageHeight = imamage.size.height
        
       let cropped = imamage.croppedImage(inRect: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight - imageHeight*(offset/imageHeight)))
        
        
        
        
        
        if let name = referenceName {
            sharedData.ReferenceDict[name] = (cropped, ViewData(passwords: info), currentImage)
            dataManager.saveDataStore()
        } else {
            sharedData.ReferenceDict["Random"] = (cropped, ViewData(passwords: info), currentImage)
            dataManager.saveDataStore()
        }
        

        self.navigationController?.popViewController(animated: true)
    }
    
    func generateImage(tblview:UITableView) ->UIImage{
        UIGraphicsBeginImageContext(tblview.contentSize);
        tblview.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        tblview.layer.render(in: UIGraphicsGetCurrentContext()!)
        let row = tblview.numberOfRows(inSection: 0)
        let numberofRowthatShowinscreen = 4
        var scrollCount = row / numberofRowthatShowinscreen
        var i = 0
        while i < scrollCount {
            tblview.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            tblview.layer.render(in: UIGraphicsGetCurrentContext()!)
            i += 1
        }
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return image;
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

extension UITableView {
    
    func asFullImage() -> UIImage? {
        
        guard self.numberOfSections > 0, self.numberOfRows(inSection: 0) > 0 else {
            return nil
        }
        
        self.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        
        var height: CGFloat = 0.0
        for section in 0..<self.numberOfSections {
            var cellHeight: CGFloat = 0.0
            for row in 0..<self.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                guard let cell = self.cellForRow(at: indexPath) else { continue }
                cellHeight = cell.frame.size.height
            }
            height += cellHeight * CGFloat(self.numberOfRows(inSection: section))
        }
        
        
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.contentSize.width, height: height), true, UIScreen.main.scale)
        
        for section in 0..<self.numberOfSections {
            for row in 0..<self.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                guard let cell = self.cellForRow(at: indexPath) else { continue }
                cell.backgroundColor = UIColor.white
                cell.contentView.drawHierarchy(in: cell.frame, afterScreenUpdates: true)
                
                if row < self.numberOfRows(inSection: section) - 1 {
                    self.scrollToRow(at: IndexPath(row: row+1, section: section), at: .bottom, animated: false)
                }
            }
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
