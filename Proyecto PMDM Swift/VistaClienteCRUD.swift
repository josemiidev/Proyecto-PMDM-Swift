//
//  VistaClienteCRUD.swift
//  Proyecto PMDM Swift
//
//  Created by José Miguel Lorenzo Lara on 1/3/23.
//

import UIKit

class VistaClienteCRUD: UIViewController {
    var UrlStr = "http://dam2-15e3b8:8000/"
    @IBOutlet weak var btnEliminar: UIButton!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var spinner: UIPickerView!
    @IBOutlet weak var fecha_nacimiento: UIDatePicker!
    @IBOutlet weak var apellidos: UITextField!
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var dni: UITextField!
    @IBOutlet weak var titulo: UILabel!
    
    var id:Int = 0
    var sucursales : [Sucursal] = []
    var item :Cliente = Cliente(id: 0, dni: "", nombre: "", apellidos: "", fechaNacimiento: "", sucursalByIdSucursal: nil)
    var indexOfPicker = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.delegate = self
        spinner.dataSource = self
        
        if(id == 0 ){
            titulo.text = "Nuevo Cliente"
            btnEliminar.isHidden = true
        }else{
            titulo.text = "Editar Cliente"
            btnEliminar.isHidden = false
            buscarCliente(id:id)
        }
        
        buscarSucursales()
        
        // Do any additional setup after loading the view.
    }
    func buscarSucursales(){
        //guard let url = URL(string: "http://JOSEMIGUEL:8000/sucursales") else {
        guard let url = URL(string: UrlStr + "sucursales") else {
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
                let datos = try decoder.decode([Sucursal].self, from: data)
                //print("tabla: \(datos.count)")
                self.sucursales.append(contentsOf: datos)
                DispatchQueue.main.async {
                    self.spinner.reloadAllComponents()
                    var cont = 0
                    for sucursal in self.sucursales{
                        if(sucursal.id == self.item.sucursalByIdSucursal?.id){
                            break
                        }else{
                            cont = cont + 1
                        }
                    }
                    self.spinner.selectRow(cont, inComponent: 0, animated: true)
                }
                
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    func buscarCliente(id:Int){
        //guard let url = URL(string: "http://JOSEMIGUEL:8000/clientes/" + String(id)) else {
        guard let url = URL(string: UrlStr + "clientes/" + String(id)) else {
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
                let datos = try decoder.decode(Cliente.self, from: data)
                //print("tabla: \(datos.count)")
                self.item = datos
                DispatchQueue.main.async {
                    //self.tabla.reloadData()
                    self.dni.text = self.item.dni
                    self.nombre.text = self.item.nombre
                    self.apellidos.text = self.item.apellidos
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
                    let date = dateFormatter.date(from: self.item.fechaNacimiento ?? "2023-03-01")
                    
                    self.fecha_nacimiento.setDate(date ?? Date.now, animated: true)
                }
                
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    func guardarCliente(){
        //guard let url = URL(string: "http://JOSEMIGUEL:8000/clientes") else {
        guard let url = URL(string: UrlStr + "clientes") else {
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
                let datos = try decoder.decode(Cliente.self, from: data)
                self.item = datos
                DispatchQueue.main.async {
                    
                    // Create new Alert
                     let dialogMessage = UIAlertController(title: "Correcto", message: "Nuevo Cliente añadido correctamente", preferredStyle: .alert)
                     
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
    
    func eliminarCliente(id:Int){
        //guard let url = URL(string: "http://JOSEMIGUEL:8000/clientes/" + String(id)) else {
        guard let url = URL(string: UrlStr + "clientes/" + String(id)) else {
            print("ERROR AL CREAR LA URL")
            return
        }
        
        var request = URLRequest(url:url)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) {data,response,error in
            guard error == nil else {
                print("ERROR AL HACER LA LLAMADA DELETE")
                print(error!)
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                DispatchQueue.main.async {
                        // Create new Alert
                         let dialogMessage = UIAlertController(title: "Correcto", message: "Cliente eliminado correctamente", preferredStyle: .alert)
                         
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
    
    func modificarCliente(id:Int){
        //guard let url = URL(string: "http://JOSEMIGUEL:8000/clientes/" + String(id)) else {
        guard let url = URL(string: UrlStr + "clientes/" + String(id)) else {
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
                let datos = try decoder.decode(Cliente.self, from: data)
                self.item = datos
                DispatchQueue.main.async {
                    
                    // Create new Alert
                     let dialogMessage = UIAlertController(title: "Correcto", message: "Cliente modificado correctamente", preferredStyle: .alert)
                     
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
        if(!(dni.text?.isEmpty ?? true) && !(nombre.text?.isEmpty ?? true) && !(apellidos.text?.isEmpty ?? true)){
            print(id)
            if(id == 0){
                let date = fecha_nacimiento.date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let fecha = dateFormatter.string(from: date)
                
                let suc = sucursales[spinner.selectedRow(inComponent: 0)]
                
                item = Cliente(id: 0, dni: dni.text, nombre: nombre.text, apellidos: apellidos.text, fechaNacimiento: fecha,sucursalByIdSucursal: suc)
                
                guardarCliente()
            }else{
                let date = fecha_nacimiento.date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let fecha = dateFormatter.string(from: date)
                
                let suc = sucursales[spinner.selectedRow(inComponent: 0)]
                
                item = Cliente(id: id, dni: dni.text, nombre: nombre.text, apellidos: apellidos.text, fechaNacimiento: fecha,sucursalByIdSucursal: suc)
                modificarCliente(id: id)
            }
        }
    }
    
    @IBAction func btnEliminar(_ sender: Any) {
        eliminarCliente(id: id)
    }
}

extension VistaClienteCRUD: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sucursales.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sucursales[row].toString()
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.indexOfPicker = row
    }
}
