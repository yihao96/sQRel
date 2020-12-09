//
//  RecordsTableViewController.swift
//  sQRel
//
//  Created by Alex Lim on 28/05/2018.
//  Copyright © 2018 Alex Lim. All rights reserved.
//

import UIKit
import Firebase

class RecordsTableViewController: UITableViewController {

	@IBOutlet var navBar: UINavigationItem!
	
	private var qrs = [Qr]()
	private var qrCollectionRef: CollectionReference!
	private var qrListener: ListenerRegistration!
	
	private var userId = Auth.auth().currentUser?.uid
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
		self.navigationController?.navigationBar.titleTextAttributes = textAttributes
		
		qrCollectionRef = Firestore.firestore().collection(QR_REF)
		
		tableView.estimatedRowHeight = 70
    }

	override func viewWillAppear(_ animated: Bool) {
		setListener()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		qrListener.remove()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return qrs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? QrCell {
			cell.configureCell(qr: qrs[indexPath.row])
			return cell
		} else {
			return UITableViewCell()
		}
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! QrCell
		let decodedURL = cell.scannedQr.text!
		
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
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return "End of record"
	}
    
    func setListener() {
        
        qrListener = qrCollectionRef.whereField(USERID, isEqualTo: userId!).order(by: TIMESTAMP, descending: true).addSnapshotListener({ (snapshot, error) in
            
            if let err = error {
                print(err.localizedDescription)
            } else {
                self.qrs.removeAll()
                self.qrs = Qr.parseData(snapshot: snapshot)
                self.tableView.reloadData()
            }
        })
    }
	
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
