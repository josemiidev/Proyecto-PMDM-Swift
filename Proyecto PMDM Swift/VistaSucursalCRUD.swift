//
//  VistaSucursalCRUD.swift
//  Proyecto PMDM Swift
//
//  Created by José Miguel Lorenzo Lara on 1/3/23.
//

import UIKit

class VistaSucursalCRUD: UIViewController {

    @IBOutlet weak var btnEliminar: UIButton!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var referencia: UITextField!
    @IBOutlet weak var provincia: UITextField!
    @IBOutlet weak var poblacion: UITextField!
    @IBOutlet weak var titulo: UILabel!
    var id : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        if(id == 0 ){
            titulo.text = "Nueva Sucursal"
            btnEliminar.isHidden = true
        }else{
            titulo.text = "Editar Sucursal"
            btnEliminar.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
