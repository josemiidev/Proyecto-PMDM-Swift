//
//  CeldaClienteView.swift
//  Proyecto PMDM Swift
//
//  Created by José Miguel Lorenzo Lara on 1/3/23.
//

import UIKit

class CeldaClienteView: UITableViewCell {

    
    @IBOutlet weak var lblNombre: UILabel!
    
    @IBOutlet weak var lblDni: UILabel!
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
