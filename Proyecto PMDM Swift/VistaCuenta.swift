//
//  VistaCuenta.swift
//  Proyecto PMDM Swift
//
//  Created by José Miguel Lorenzo Lara on 27/2/23.
//

import UIKit

class VistaCuenta: UIViewController {

    @IBOutlet weak var tabla: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
    }

}
extension VistaCuenta: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tabla.dequeueReusableCell(withIdentifier: "celdaCuenta", for: indexPath)
        
        celda.textLabel?.text = "Cuenta"
        return celda
    }
}
