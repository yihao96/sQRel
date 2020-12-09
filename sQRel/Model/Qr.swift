//
//  Qr.swift
//  sQRel
//
//  Created by Alex Lim on 02/06/2018.
//  Copyright © 2018 Alex Lim. All rights reserved.
//

import Foundation
import Firebase

class Qr {
	private(set) var userId: String
	private(set) var timestamp: Date
	private(set) var scannedUrl: String
	private(set) var documentId: String
	
	init (userId: String, timestamp: Date, scannedUrl: String, documentId: String) {
		self.userId = userId
		self.timestamp = timestamp
		self.scannedUrl = scannedUrl
		self.documentId = documentId
	}
	
	class func parseData(snapshot: QuerySnapshot?) -> [Qr] {
		var qr = [Qr]()
		
		guard let snap = snapshot else {
			return qr
		}
		
		let UId = Auth.auth().currentUser?.uid
		
		for document in snap.documents {
			let data = document.data()
			let userId = data[USERID] as? String ?? UId!
			let timestamp = data[TIMESTAMP] as? Date ?? Date()
			let scannedUrl = data[SCANNED_URL] as? String ?? "some url"
			let documentId = document.documentID
			
			let newQr = Qr(userId: userId, timestamp: timestamp, scannedUrl: scannedUrl, documentId: documentId)
			
			qr.append(newQr)
		}
		
		return qr
	}
}
