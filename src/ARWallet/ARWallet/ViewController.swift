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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    var referenceImages: [UIImage] = [UIImage]()
    
    var DataManager = DataStoreManager.sharedDataStoreManager
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARImageTrackingConfiguration()
        
        var customReferenceSet = Set<ARReferenceImage>()
        
        if let unwrapped = DataManager.dataStore.userReferenceImages as? [UIImage] {
            
            let image = unwrapped[0]
            
            guard let cgImage = image.cgImage else { return }
            
            //3. Get The Width Of The Image
            let imageWidth = CGFloat(cgImage.width)
            
            //4. Create A Custom AR Reference Image With A Unique Name
            let customARReferenceImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.1)
            customARReferenceImage.name = "Custom reference image"
            
            //4. Insert The Reference Image Into Our Set
            customReferenceSet.insert(customARReferenceImage)
            
            print("ARReference Image == \(customARReferenceImage)")
            configuration.trackingImages = customReferenceSet
        } else {
            guard let unwrappedBundle = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
                fatalError("Missing expected asset catalog resources.")
            }
            configuration.trackingImages = unwrappedBundle
        }
        
        
        
        // Create a session configuration
       
        
        // Add previously loaded images to ARScene configuration as detectionImages
        
        
        
        // Create a session configuration
        

        
        
        
        // Run the view's session
        sceneView.session.run(configuration)
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
}
