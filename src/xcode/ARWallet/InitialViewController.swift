//
//  InitialViewController.swift
//  ARWallet
//
//  Created by Ehrlich, Mark on 6/19/19.
//  Copyright © 2019 Ehrlich, Mark. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        userTextField.delegate = self
        passwordField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        DispatchQueue.main.async {
           
            let viewHeight = self.view.frame.height
            let viewWidth = self.view.frame.width
            self.userTextField.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: viewHeight*316/667).isActive = true
            
            self.passwordField.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: viewHeight*384/667).isActive = true
            
            self.signInBtn.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: viewHeight*499/667).isActive = true
            
            
            
        }
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func signInSegue(_ sender: Any) {
        
        if let user = userTextField.text {
            self.performSegue(withIdentifier: "SegueToAR", sender: self)
        } else {
            
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

extension UIView {
    func applyGradient(colours: [CGColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [CGColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        print(self.bounds)
        gradient.frame = self.bounds
        //        gradient.frame = CGRect(x: 0, y: 0, width: gradient.frame.width + 20, height: gradient.frame.height)
        print(gradient.frame.width)
        
        gradient.colors = colours
        gradient.cornerRadius = 5
        //gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
}
