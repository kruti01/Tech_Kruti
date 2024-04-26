//
//  UserDetailsTableViewCell.swift
//  Tech_Kruti
//
//  Created by Kruti on 26/04/24.
//

import UIKit

class UserDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
      
       override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
       }

       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

           // Configure the view for the selected state
       }
       
       func configure(id: String, title: String) {
           self.lblID.text = "ID: \(id)"
           self.lblTitle.text = "Title: \(title)"
       }

    
}
