//
//  GameViewController.swift
//  PCRenderer
//
//  Created by Evgeniy on 24.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, OpenFileDelegate {
    
    let scene = SCNScene()
    let cameraNode = SCNNode()
    let lightNode = SCNNode()
    let ambientLightNode = SCNNode()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.delegate = self
        
        // add a tap gesture recognizer
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        //scnView.addGestureRecognizer(tapGesture)
    }
    
    func configureUI() {
        // create and add a camera to the scene
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.automaticallyAdjustsZRange = false
        cameraNode.camera?.zNear  = 0.001
        cameraNode.camera?.zFar = 100
        
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 1)
        
        // create and add a light to the scene
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 3, z: 3)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.lightGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // animate the 3d object
        //        pcNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        // retrieve demo node
        openFile(url: "dragon_hidden.ply")
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.darkGray
    }
   
    func openFile(url: String) {
        // remove previous nodes
        scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
        // render new node
        if !url.isEmpty {
            // retrieve the node
            let pc = PointCloud(url: url)
            let pcNode = pc.getNode()
            pcNode.position = SCNVector3(x: 0, y: 0, z: 0)
            pcNode.renderingOrder = 100_000
            scene.rootNode.addChildNode(pcNode)
        }
    }
    
    //    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
    //        // retrieve the SCNView
    //        let scnView = self.view as! SCNView
    //
    //        // check what nodes are tapped
    //        let p = gestureRecognize.location(in: scnView)
    //        let hitResults = scnView.hitTest(p, options: [:])
    //        // check that we clicked on at least one object
    //        if hitResults.count > 0 {
    //            // retrieved the first clicked object
    //            let result: AnyObject = hitResults[0]
    //
    //            // get its material
    //            let material = result.node!.geometry!.firstMaterial!
    //
    //            // highlight it
    //            SCNTransaction.begin()
    //            SCNTransaction.animationDuration = 0.5
    //
    //            // on completion - unhighlight
    //            SCNTransaction.completionBlock = {
    //                SCNTransaction.begin()
    //                SCNTransaction.animationDuration = 0.5
    //
    //                material.emission.contents = UIColor.black
    //
    //                SCNTransaction.commit()
    //            }
    //
    //            material.emission.contents = UIColor.red
    //
    //            SCNTransaction.commit()
    //        }
    //    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
