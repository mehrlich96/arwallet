//
//  ViewController.swift
//  ARWallet
//
//  Created by Ehrlich, Mark on 6/18/19.
//  Copyright © 2019 Ehrlich, Mark. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }

    
    var referenceImages: [UIImage] = [UIImage]()
    
    @IBAction func segueToInfoBtn(_ sender: Any) {
        self.showImagePicker()
    }
    var DataManager = DataStoreManager.sharedDataStoreManager
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARImageTrackingConfiguration()
        
        var customReferenceSet = Set<ARReferenceImage>()
        
        
            if let unwrapped = self.DataManager.dataStore.ReferenceDict as?  [String: (UIImage, ViewData, UIImage)] {
                
                if unwrapped.count > 0{
                    
                    for (key, (view,viewData, image)) in unwrapped {
                        guard let cgImage = image.cgImage else { return }
                        
                        //3. Get The Width Of The Image
                        let imageWidth = CGFloat(cgImage.width)
                        
                        //4. Create A Custom AR Reference Image With A Unique Name
                        let customARReferenceImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation.up, physicalWidth: CGFloat(0.1))
                        customARReferenceImage.name = key
                        
                        //4. Insert The Reference Image Into Our Set
                        customReferenceSet.insert(customARReferenceImage)
                        
                        print("ARReference Image == \(customARReferenceImage.name)")
                    }
                    
                    configuration.trackingImages = customReferenceSet
                } else {
                    self.presentRefImageAlert()
                }
                
               
            } else {
                self.presentRefImageAlert()
            }
        
        
        // Run the view's session
        sceneView.session.run(configuration, options: [.resetTracking,.removeExistingAnchors])
    }
    
    var imagePicker: ImagePicker!
    
    func showImagePicker() {
         self.imagePicker.present(from: self.view)
    }
    
    func presentRefImageAlert() {
        if shouldPresentAlert {
            let alert = UIAlertController(title: "Warning", message: "UH-oh looks like you don't have any reference images click ok to add them now", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.showImagePicker()
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor {
            handleFoundImage(imageAnchor, node)
        }
        
        
    }
    
    private func handleFoundImage(_ imageAnchor: ARImageAnchor, _ node: SCNNode) {
        let size = imageAnchor.referenceImage.physicalSize
        
        
        /*
         if let btnNode = makeBtnNode(size: size, anchorImage: node) {
         node.addChildNode(btnNode)
         node.opacity = 1
         }
         */
        
        let picDeats = makePictureNode(size: size, node: node, referenceImage: imageAnchor)
        
        if let picNode = picDeats.0, let adjustedSize = picDeats.1 {
            node.addChildNode(picNode)
            node.opacity = 1
            //displaySideView(on: picNode, size: size)
            
        }
        
        
        
    }
    
    private func makePictureNode(size: CGSize, node: SCNNode, referenceImage: ARImageAnchor) -> (SCNNode?, CGSize?) {
        let planeGeometry = SCNPlane(width: size.width, height: size.height)
        var adjustedSize = size
        let material = SCNMaterial()
        let picNode = SCNNode(geometry: planeGeometry)
        print("\(referenceImage.name)")
        
        material.diffuse.contents = UIImage(named: "over")
        
        
        planeGeometry.materials = [material]
        
        //picNode.position = SCNVector3Make(, , )
        picNode.eulerAngles.x = -.pi/2
        return (picNode, adjustedSize)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueToInfo":
            if let segueDest = segue.destination as? InfoListTableViewController {
                if let image = self.newRefImage {
                    segueDest.currentImage = image
                }
            }
        default:
            print("\(segue.identifier)")
        }
    }
    
    var newRefImage: UIImage?
    var shouldPresentAlert = true
    
}


extension ViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if let unwrappedImage = image {
            self.newRefImage = unwrappedImage
            self.shouldPresentAlert = false
            self.performSegue(withIdentifier: "segueToInfo", sender: self)
            
        }
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexInt: UInt32 = 0
        let scanner = Scanner(string: hexString)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)
        
        let red = CGFloat((hexInt & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexInt & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexInt & 0xff) >> 0) / 255.0
        let alpha = alpha
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
