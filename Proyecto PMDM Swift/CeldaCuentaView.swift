//
//  CeldaCuentaView.swift
//  Proyecto PMDM Swift
//
//  Created by José Miguel Lorenzo Lara on 1/3/23.
//

import UIKit

class CeldaCuentaView: UITableViewCell {

    @IBOutlet weak var saldo: UILabel!
    @IBOutlet weak var ccc: UILabel!
    var id : Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
