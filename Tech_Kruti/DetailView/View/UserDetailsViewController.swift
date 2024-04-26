//
//  UserDetailsViewController.swift
//  Tech_Kruti
//
//  Created by Kruti on 26/04/24.
//

import UIKit

class UserDetailsViewController: UIViewController {

    @IBOutlet weak var lblUserID: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    var userDetailListModel: UserDetailListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let userDetailListModel = self.userDetailListModel {
            self.lblUserID.text = "User: \(userDetailListModel.id ?? 0)"
            self.lblTitle.text = userDetailListModel.title ?? "Title"
            self.lblDetails.text = "Details:\n\(userDetailListModel.body ?? "Data not available")"
        }
    }
    

    @IBAction func btnBackAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
