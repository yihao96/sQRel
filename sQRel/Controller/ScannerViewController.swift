//
//  ScannerViewController.swift
//  sQRel
//
//  Created by Alex Lim on 27/05/2018.
//  Copyright © 2018 Alex Lim. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class ScannerViewController: UIViewController {

	@IBOutlet var scanButton: UIButton!
	
	var scannedData: String!
	
	var captureSession = AVCaptureSession()
	var videoPreviewLayer: AVCaptureVideoPreviewLayer?
	var qrCodeFrameView: UIView?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		scanButton.isEnabled = false
//		scanButton.backgroundColor = UIColor.gray

        // Get the back-facing camera for capturing videos
		let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
		
		guard let captureDevice = deviceDiscoverySession.devices.first else {
			print("Failed to get the camera device")
			return
		}
		
		do {
			// Get an instance of the AVCaptureDeviceInput class using the previous device object
			let input = try AVCaptureDeviceInput(device: captureDevice)
			
			// Set the input device on the capture session
			captureSession.addInput(input)
			
			// Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session
			let captureMetadataOutput = AVCaptureMetadataOutput()
			captureSession.addOutput(captureMetadataOutput)
			
			// Set delegate and use the default dispatch queue to execute the call back
			captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
			captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
		} catch {
			print(error.localizedDescription)
			return
		}
		
		// Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer
		videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
		videoPreviewLayer?.frame = view.layer.bounds
		view.layer.addSublayer(videoPreviewLayer!)
		
		// Start video capture
		captureSession.startRunning()
		
		// Move the button to the front
		view.bringSubviewToFront(scanButton)
		
		// Initialize QR code frame to highlight the QR code
		qrCodeFrameView = UIView()
		
		if let qrCodeFrameView = qrCodeFrameView {
			qrCodeFrameView.layer.borderColor = UIColor.orange.cgColor
			qrCodeFrameView.layer.borderWidth = 2
			view.addSubview(qrCodeFrameView)
			view.bringSubviewToFront(qrCodeFrameView)
		}
		
    }

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return UIStatusBarStyle.lightContent
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func scanIt(_ sender: UIButton) {
		if presentedViewController != nil {
			return
		}
		
		takeAction(decodedURL: scannedData)
		
		guard let userId = Auth.auth().currentUser?.uid else {
			return
		}
		
		Firestore.firestore().collection("qr").addDocument(data: [
			SCANNED_URL : scannedData,
			TIMESTAMP : FieldValue.serverTimestamp(),
			USERID : userId
		]) { (err) in
			if let err = err {
				print(err.localizedDescription)
			}
		}
	}
	
	func takeAction(decodedURL: String) {
		if presentedViewController != nil {
			return
		}

		let alertController = UIAlertController(title: "Open Link", message: "You're about to open the link:\n \(decodedURL)", preferredStyle: .alert)
		
		let openAction = UIAlertAction(title: "Open", style: .default) { (action) -> Void in
			OpenUrl.shared.takeAction(decodedURL: decodedURL)
		}

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alertController.addAction(openAction)
		alertController.addAction(cancelAction)
		present(alertController, animated: true, completion: nil)
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Extension

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
	
	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		
		// Check if the metadataObjects array is not nil and it contains at least one object
		if metadataObjects.count == 0 {
			qrCodeFrameView?.frame = CGRect.zero
			scanButton.isEnabled = false
			scanButton.titleLabel?.text = "No QR code found..."
//			scanButton.backgroundColor = UIColor.gray
			return
		}
		
		// Get the metadata object
		let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
		
		if metadataObj.type == AVMetadataObject.ObjectType.qr {
			
			// If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
			let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
			qrCodeFrameView?.frame = barCodeObject!.bounds
			
			if metadataObj.stringValue != nil {
				scanButton.isEnabled = true
//				scanButton.titleLabel?.text = "Scan IT"
				scanButton.titleLabel?.text = metadataObj.stringValue
//				scanButton.backgroundColor = UIColor.init(red: 46.0, green: 204.0, blue: 113.0, alpha: 1.0)
				scannedData = metadataObj.stringValue
			}
		}
	}
}
