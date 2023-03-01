//
//  VistaClienteCRUD.swift
//  Proyecto PMDM Swift
//
//  Created by José Miguel Lorenzo Lara on 1/3/23.
//

import UIKit

class VistaClienteCRUD: UIViewController {

    @IBOutlet weak var btnEliminar: UIButton!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var spinner: UIPickerView!
    @IBOutlet weak var fecha_nacimiento: UIDatePicker!
    @IBOutlet weak var apellidos: UITextField!
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var dni: UITextField!
    @IBOutlet weak var titulo: UILabel!
    
    var id:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(id == 0 ){
            titulo.text = "Nuevo Cliente"
            btnEliminar.isHidden = true
        }else{
            titulo.text = "Editar Cliente"
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
