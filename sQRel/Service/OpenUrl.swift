//
//  OpenUrl.swift
//  sQRel
//
//  Created by Alex Lim on 03/06/2018.
//  Copyright © 2018 Alex Lim. All rights reserved.
//

//import Foundation
import UIKit

final class OpenUrl {
	// MARK: - Properties
	static let shared: OpenUrl = OpenUrl()
	
	private init() {
		
	}
	
	func takeAction(decodedURL: String) {
		if let url = URL(string: decodedURL) {
			if UIApplication.shared.canOpenURL(url) {
				UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
			}
		}
	}
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
