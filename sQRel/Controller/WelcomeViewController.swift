//
//  WelcomeViewController.swift
//  sQRel
//
//  Created by Alex Lim on 26/05/2018.
//  Copyright © 2018 Alex Lim. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class WelcomeViewController: UIViewController {

	@IBOutlet var backgroundImageView: UIImageView!
	
	private var blurEffectView: UIVisualEffectView?
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
		blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView?.frame = view.bounds
		backgroundImageView.addSubview(blurEffectView!)
		
		GIDSignIn.sharedInstance().delegate = self
		GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func unwindtoWelcomeView(segue: UIStoryboardSegue) {
		dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Facebook Login Button
	
	@IBAction func facebookLogin(sender: UIButton) {
		let fbLoginManager = FBSDKLoginManager()
		
		fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
			if let err = error {
				print("Failed to login: \(err.localizedDescription)")
				return
			}
			
			guard let accessToken = FBSDKAccessToken.current() else {
				print("Failed to get access token")
				return
			}
			
			let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
			
			// Perform login by calling Firebase APIs
			Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
				if let err = error {
					print("Login error: \(err.localizedDescription)")
					let alertController = UIAlertController(title: "Login Error", message: err.localizedDescription, preferredStyle: .alert)
					let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
					alertController.addAction(okayAction)
					self.present(alertController, animated: true, completion: nil)
					return
				}
				
				// Present the main view
				if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
					UIApplication.shared.keyWindow?.rootViewController = viewController
					self.dismiss(animated: true, completion: nil)
				}
			})
		}
	}
	
	// MARK: - Google Sign In
	
	@IBAction func googleLogin(sender: UIButton) {
		GIDSignIn.sharedInstance().signIn()
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

// MARK: - Google Sign In extension & delegate

extension WelcomeViewController: GIDSignInDelegate, GIDSignInUIDelegate {
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		if error != nil {
			return
		}
		
		guard let authentication = user.authentication else {
			return
		}
		
		let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
		
        Auth.auth().signInAndRetrieveData(with: credential) { (iser, error) in
//        Auth.auth().signIn(with: credential) { (user, error) in
			if let err = error {
				print("Login error: \(err.localizedDescription)")
				let alertController = UIAlertController(title: "Login Error", message: err.localizedDescription, preferredStyle: .alert)
				let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
				alertController.addAction(okayAction)
				self.present(alertController, animated: true, completion: nil)
				return
			}
			
			// Present the main view
			if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
				UIApplication.shared.keyWindow?.rootViewController = viewController
				self.dismiss(animated: true, completion: nil)
			}
		}
	}
	
	func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
		
	}
}
