//
//  MainViewController.swift
//  sQRel
//
//  Created by Alex Lim on 27/05/2018.
//  Copyright © 2018 Alex Lim. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class MainViewController: UIViewController {

	@IBOutlet var backgroundImageView: UIImageView!
	
	private var blurEffectView: UIVisualEffectView?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
		blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView?.frame = view.bounds
		backgroundImageView.addSubview(blurEffectView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func unwindtoMainView(segue: UIStoryboardSegue) {
		dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Logout Button
	
	@IBAction func logout(_ sender: UIButton) {
		
		do {
			
			if let providerData = Auth.auth().currentUser?.providerData {
				let userInfo = providerData[0]
				
				switch userInfo.providerID {
				case "google.com":
					GIDSignIn.sharedInstance().signOut()
				default:
					break
				}
			}
			
			try Auth.auth().signOut()
		} catch {
			let alertController = UIAlertController(title: "Logout Error",
													message: error.localizedDescription,
													preferredStyle: .alert)
			let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
			alertController.addAction(okayAction)
			present(alertController, animated: true, completion: nil)
			return
		}
		
		// Present the welcome view
		if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeView") {
			UIApplication.shared.keyWindow?.rootViewController = viewController
			self.dismiss(animated: true, completion: nil)
		}
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
