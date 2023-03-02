//
//  VistaSucursalCRUD.swift
//  Proyecto PMDM Swift
//
//  Created by José Miguel Lorenzo Lara on 1/3/23.
//

import UIKit

class VistaSucursalCRUD: UIViewController {
    var UrlStr = "http://dam2-15e3b8:8000/"
    @IBOutlet weak var btnEliminar: UIButton!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var referencia: UITextField!
    @IBOutlet weak var provincia: UITextField!
    @IBOutlet weak var poblacion: UITextField!
    @IBOutlet weak var titulo: UILabel!
    
    var item : Sucursal = Sucursal(id: 0, poblacion: "", provincia: "", referencia: "")
    var id : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(id == 0 ){
            titulo.text = "Nueva Sucursal"
            btnEliminar.isHidden = true
        }else{
            titulo.text = "Editar Sucursal"
            btnEliminar.isHidden = false
            
            buscarSucursal(id: id)
        }
        
        // Do any additional setup after loading the view.
    }
    
    func buscarSucursal(id:Int){
        //guard let url = URL(string: "http://JOSEMIGUEL:8000/sucursales/" + String(id)) else {
        guard let url = URL(string: UrlStr + "sucursales/" + String(id)) else {
            print("ERROR AL CREAR LA URL")
            return
        }
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) {data,response,error in
            guard error == nil else {
                print("ERROR AL HACER LA LLAMADA GET")
                print(error!)
                return
            }
            guard let data = data else{
                print("ERROR DATOS NO RECIBIDOS")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                let decoder = JSONDecoder()
                let datos = try decoder.decode(Sucursal.self, from: data)
                //print("tabla: \(datos.count)")
                self.item = datos
                DispatchQueue.main.async {
                    //self.tabla.reloadData()
                    self.poblacion.text = self.item.poblacion
                    self.provincia.text = self.item.provincia
                    self.referencia.text = self.item.referencia
                }
                
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    func guardarSucursal(){
        guard let url = URL(string: UrlStr + "sucursales") else {
            print("ERROR AL CREAR LA URL")
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(item) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) {data,response,error in
            guard error == nil else {
                print("ERROR AL HACER LA LLAMADA POST")
                print(error!)
                return
            }
            guard let data = data else{
                print("ERROR DATOS NO RECIBIDOS")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                let decoder = JSONDecoder()
                let datos = try decoder.decode(Sucursal.self, from: data)
                self.item = datos
                DispatchQueue.main.async {
                    
                    // Create new Alert
                    let dialogMessage = UIAlertController(title: "Correcto", message: "Nueva Sucursal añadida correctamente", preferredStyle: .alert)
                     
                     // Create OK button with action handler
                     let ok = UIAlertAction(title: "Aceptar", style: .default, handler: { (action) -> Void in
                         self.dismiss(animated: true, completion: nil)
                      })
                     
                     //Add OK button to a dialog message
                     dialogMessage.addAction(ok)
                     // Present Alert to
                     self.present(dialogMessage, animated: true, completion: nil)
                }
                
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    func eliminarSucursal(id:Int){
        guard let url = URL(string: UrlStr + "sucursales/" + String(id)) else {
            print("ERROR AL CREAR LA URL")
            return
        }
        
        var request = URLRequest(url:url)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) {data,response,error in
            guard error == nil else {
                print("ERROR AL HACER LA LLAMADA POST")
                print(error!)
                return
            }
            guard data != nil else{
                print("ERROR DATOS NO RECIBIDOS")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                DispatchQueue.main.async {
                        // Create new Alert
                    let dialogMessage = UIAlertController(title: "Correcto", message: "Sucursal eliminada correctamente", preferredStyle: .alert)
                         
                         // Create OK button with action handler
                         let ok = UIAlertAction(title: "Aceptar", style: .default, handler: { (action) -> Void in
                             self.dismiss(animated: true, completion: nil)
                          })
                         
                         //Add OK button to a dialog message
                         dialogMessage.addAction(ok)
                         // Present Alert to
                         self.present(dialogMessage, animated: true, completion: nil)
                    
                }
                
            }
        }.resume()
    }
    
    func modificarSucursal(id:Int){
        guard let url = URL(string: UrlStr + "sucursales/" + String(id)) else {
        //guard let url = URL(string: "http://dam2-15e3b8:8000/cuentas/" + String(id)) else {
            print("ERROR AL CREAR LA URL")
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(item) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        var request = URLRequest(url:url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) {data,response,error in
            guard error == nil else {
                print("ERROR AL HACER LA LLAMADA POST")
                print(error!)
                return
            }
            guard let data = data else{
                print("ERROR DATOS NO RECIBIDOS")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                let decoder = JSONDecoder()
                let datos = try decoder.decode(Sucursal.self, from: data)
                self.item = datos
                DispatchQueue.main.async {
                    
                    // Create new Alert
                    let dialogMessage = UIAlertController(title: "Correcto", message: "Sucursal modificada correctamente", preferredStyle: .alert)
                     
                     // Create OK button with action handler
                     let ok = UIAlertAction(title: "Aceptar", style: .default, handler: { (action) -> Void in
                         self.dismiss(animated: true, completion: nil)
                      })
                     
                     //Add OK button to a dialog message
                     dialogMessage.addAction(ok)
                     // Present Alert to
                     self.present(dialogMessage, animated: true, completion: nil)
                }
                
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }

    @IBAction func btnGuardar(_ sender: Any) {
        if(!(poblacion.text?.isEmpty ?? true) && !(provincia.text?.isEmpty ?? true) && !(referencia.text?.isEmpty ?? true)){
            
            if(id == 0){
                item = Sucursal(id: 0, poblacion: poblacion.text, provincia: provincia.text, referencia: referencia.text)
                guardarSucursal()
            }else{
                item = Sucursal(id: id, poblacion: poblacion.text, provincia: provincia.text, referencia: referencia.text)
                modificarSucursal(id: id)
            }
            
        }
    }
    @IBAction func btnEliminar(_ sender: Any) {
        eliminarSucursal(id: id)
    }
}
