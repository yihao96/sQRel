//
//  QrCell.swift
//  sQRel
//
//  Created by Alex Lim on 02/06/2018.
//  Copyright © 2018 Alex Lim. All rights reserved.
//

import UIKit

class QrCell: UITableViewCell {

	@IBOutlet var scannedQr: UILabel!
	@IBOutlet var timestampLbl: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func configureCell(qr: Qr) {
		scannedQr.text = qr.scannedUrl
		
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM d, hh:mm a"
		formatter.amSymbol = "AM"
		formatter.pmSymbol = "PM"
		let timestamp = formatter.string(from: qr.timestamp)
		timestampLbl.text = "Scanned on: \(timestamp)"
	}

	func openLink(decodedUrl: String) {
		
	}
}
