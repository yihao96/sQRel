//
//  UITextField+Placeholder.swift
//  sQRel
//
//  Created by Alex Lim on 26/05/2018.
//  Copyright © 2018 Alex Lim. All rights reserved.
//

import UIKit

extension UITextField {
	@IBInspectable var placeHolderColor: UIColor? {
		get {
			return self.placeHolderColor
		}
		
		set {
			if let placeholder = self.placeholder {
				self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: newValue!])
			}
		}
	}
}
