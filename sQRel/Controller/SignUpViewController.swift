//
//  SignUpViewController.swift
//  sQRel
//
//  Created by Alex Lim on 26/05/2018.
//  Copyright © 2018 Alex Lim. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
	
	@IBOutlet var nameTextField: UITextField!
	@IBOutlet var emailTextField: UITextField!
	@IBOutlet var passwordTextField: UITextField!
	@IBOutlet var backgroundImageView: UIImageView!
	
	private var blurEffectView: UIVisualEffectView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Sign Up"
		let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
		blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView?.frame = view.bounds
		backgroundImageView.addSubview(blurEffectView!)
		nameTextField.becomeFirstResponder()
	}
	
	@IBAction func registerAccount(sender: UIButton) {
		// Validate the input
		guard let name = nameTextField.text, name != "", let emailAddress = emailTextField.text, emailAddress != "", let password = passwordTextField.text, password != "" else {
			let alertController = UIAlertController(title: "Registration Error",
													message: "Please make sure you provide your name, email and password to complete the registration.",
													preferredStyle: .alert)
			let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
			alertController.addAction(okayAction)
			present(alertController, animated: true, completion: nil)
			return
		}
		
		// Register the user account on Firebase
		Auth.auth().createUser(withEmail: emailAddress, password: password, completion: { (user, error) in
			if let error = error {
				let alertController = UIAlertController(title: "Registration Error", message: error.localizedDescription, preferredStyle: .alert)
				let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
				alertController.addAction(okayAction)
				self.present(alertController, animated: true, completion: nil)
				print(error)
				return
			}
			
			// Save the name of the user
			if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
				changeRequest.displayName = name
				
				changeRequest.commitChanges(completion: { (error) in
					if let error = error {
						print("Failed to change the display name: \(error.localizedDescription)")
					}
				})
			}
			
			// Dismiss keyboard
			self.view.endEditing(true)
			
			// Send verification email
			user?.user.sendEmailVerification(completion: nil)
			
			let alertController = UIAlertController(title: "Email Verification",
													message: "We've just send a confirmation email to your email address. Please check your inbox and click the verification link in that email to complete the sign up.",
													preferredStyle: .alert)
			
			let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
				// Dismiss the current view controller
				self.dismiss(animated: true, completion: nil)
			})
			
			alertController.addAction(okayAction)
			self.present(alertController, animated: true, completion: nil)
		})
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
