//
//  ViewController.swift
//  uottahack-2019
//
//  Created by Volodymyr Klymenko on 2019-02-09.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
		guard let arImage = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else{
			return
		}

		configuration.trackingImages = arImage

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		guard anchor is ARImageAnchor else { return }
		guard let container = sceneView.scene.rootNode.childNode(withName: "container", recursively: false) else { return }
		container.removeFromParentNode()
		node.addChildNode(container)
		container.isHidden = false

		let videoURL = Bundle.main.url(forResource: "slack-vid", withExtension: "mp4")!
		let videoPlayer = AVPlayer(url: videoURL)

		let videoScene = SKScene(size: CGSize(width: 1280.0, height: 536.0))
		let videoNode = SKVideoNode(avPlayer: videoPlayer)


		videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
		videoNode.size = videoScene.size
		videoNode.yScale = -1
		videoNode.play()

		videoScene.addChild(videoNode)


		guard let video = container.childNode(withName: "video", recursively: true) else { return }
		print("SLACK!")
		video.geometry?.firstMaterial?.diffuse.contents = videoScene
		container.addChildNode(video)



		
	}

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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
