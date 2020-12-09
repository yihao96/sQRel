//
//  UINavigationController+Transparent.swift
//  sQRel
//
//  Created by Alex Lim on 26/05/2018.
//  Copyright © 2018 Alex Lim. All rights reserved.
//

import UIKit

extension UINavigationController {
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		
		// Make the navigation bar transparent
		self.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationBar.shadowImage = UIImage()
		self.navigationBar.isTranslucent = true
		self.navigationBar.tintColor = UIColor.white
		self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Rubik-Medium", size: 20)!,
												  NSAttributedString.Key.foregroundColor: UIColor.white]
	}
}
