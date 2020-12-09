//
//  LoginViewController.swift
//  sQRel
//
//  Created by Alex Lim on 26/05/2018.
//  Copyright © 2018 Alex Lim. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

	@IBOutlet var emailTextField: UITextField!
	@IBOutlet var passwordTextField: UITextField!
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.title = "Log In"
		
		// Set emailTextField as focus and pops keyboard for user input
		emailTextField.becomeFirstResponder()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.title = ""
	}
	
	// MARK: - Login button function
	
	@IBAction func login(sender: UIButton) {
		
		// Validate the input
		guard let emailAddress = emailTextField.text, emailAddress != "", let password = passwordTextField.text, password != "" else {
			let alertController = UIAlertController(title: "Login Error",
													message: "Both fields must not be blank.",
													preferredStyle: .alert)
			let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
			alertController.addAction(okayAction)
			present(alertController, animated: true, completion: nil)
			return
		}
		
		// Perform login by calling Firebase APIs
		Auth.auth().signIn(withEmail: emailAddress, password: password, completion: { (user, error) in
			
			if let error = error {
				let alertController = UIAlertController(title: "Login Error",
														message: error.localizedDescription,
														preferredStyle: .alert)
				let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
				alertController.addAction(okayAction)
				self.present(alertController, animated: true, completion: nil)
				return
			}
			
			// Email verification
			guard let currentUser = user, currentUser.user.isEmailVerified else {
				let alertController = UIAlertController(title: "Login Error",
														message: "You haven't confirmed your email address yet. We sent you a confirmation email when you sign up. Please click the verification link in that email. If you need us to send the confirmation email again, please tap Resend Email.",
														preferredStyle: .alert)
				
				let okayAction = UIAlertAction(title: "Resend email", style: .default, handler: { (action) in
					user?.user.sendEmailVerification(completion: nil)
				})
				
				let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
				alertController.addAction(okayAction)
				alertController.addAction(cancelAction)
				self.present(alertController, animated: true, completion: nil)
				return
			}
			
			// Dismiss keyboard
			self.view.endEditing(true)
            
			// Present the main view
			if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
				UIApplication.shared.keyWindow?.rootViewController = viewController
				self.dismiss(animated: true, completion: nil)
			}
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
