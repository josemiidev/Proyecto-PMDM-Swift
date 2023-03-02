//
//  VistaCuentaCRUD.swift
//  Proyecto PMDM Swift
//
//  Created by José Miguel Lorenzo Lara on 1/3/23.
//

import UIKit

class VistaCuentaCRUD: UIViewController {
    var UrlStr = "http://dam2-15e3b8:8000/"
    @IBOutlet weak var titulo: UILabel!
    
    @IBOutlet weak var btnEliminar: UIButton!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var spinner: UIPickerView!
    @IBOutlet weak var enAlta: UISwitch!
    @IBOutlet weak var saldo: UITextField!
    @IBOutlet weak var ccc: UITextField!
    var id:Int = 0

    var clientes : [Cliente] = []
    var item :Cuenta = Cuenta(id: 0, ccc: "", saldo: 0.0, enAlta: false, clienteByIdCliente: nil)
    var indexOfPicker = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.delegate = self
        spinner.dataSource = self
        
        if(id == 0 ){
            titulo.text = "Nueva Cuenta"
            btnEliminar.isHidden = true
        }else{
            titulo.text = "Editar Cuenta"
            btnEliminar.isHidden = false
            buscarCuenta(id:id)
        }
        
        buscarClientes()
        // Do any additional setup after loading the view.
    }
    
    func buscarClientes(){
        //guard let url = URL(string: "http://JOSEMIGUEL:8000/sucursales") else {
        guard let url = URL(string: UrlStr + "clientes") else {
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
                let datos = try decoder.decode([Cliente].self, from: data)
                //print("tabla: \(datos.count)")
                self.clientes.append(contentsOf: datos)
                DispatchQueue.main.async {
                    self.spinner.reloadAllComponents()
                    var cont = 0
                    for cliente in self.clientes{
                        if(cliente.id == self.item.clienteByIdCliente?.id){
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
    
    func buscarCuenta(id:Int){
        //guard let url = URL(string: "http://JOSEMIGUEL:8000/clientes/" + String(id)) else {
        guard let url = URL(string: UrlStr + "cuentas/" + String(id)) else {
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
                let datos = try decoder.decode(Cuenta.self, from: data)
                //print("tabla: \(datos.count)")
                self.item = datos
                DispatchQueue.main.async {
                    //self.tabla.reloadData()
                    self.ccc.text = self.item.ccc
                    self.saldo.text = String(self.item.saldo ?? 0.0)
                    self.enAlta.isOn = self.item.enAlta ?? false
                }
                
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    func guardarCuenta(){
        //guard let url = URL(string: "http://JOSEMIGUEL:8000/clientes") else {
        guard let url = URL(string: UrlStr + "cuentas") else {
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
                let datos = try decoder.decode(Cuenta.self, from: data)
                self.item = datos
                DispatchQueue.main.async {
                    
                    // Create new Alert
                     var dialogMessage = UIAlertController(title: "Correcto", message: "Nueva Cuenta añadida correctamente", preferredStyle: .alert)
                     
                     // Create OK button with action handler
                     let ok = UIAlertAction(title: "Aceptar", style: .default, handler: { (action) -> Void in
                         
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
    
    func eliminarCuenta(id:Int){
        //guard let url = URL(string: "http://JOSEMIGUEL:8000/clientes/" + String(id)) else {
        guard let url = URL(string: UrlStr + "cuentas/" + String(id)) else {
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
                         var dialogMessage = UIAlertController(title: "Correcto", message: "Cuenta eliminada correctamente", preferredStyle: .alert)
                         
                         // Create OK button with action handler
                         let ok = UIAlertAction(title: "Aceptar", style: .default, handler: { (action) -> Void in
                             
                          })
                         
                         //Add OK button to a dialog message
                         dialogMessage.addAction(ok)
                         // Present Alert to
                         self.present(dialogMessage, animated: true, completion: nil)
                }
            }
        }.resume()
    }
    
    func modificarCuenta(id:Int){
        //guard let url = URL(string: "http://JOSEMIGUEL:8000/clientes/" + String(id)) else {
        guard let url = URL(string: UrlStr + "cuentas/" + String(id)) else {
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
                let datos = try decoder.decode(Cuenta.self, from: data)
                self.item = datos
                DispatchQueue.main.async {
                    
                    // Create new Alert
                     var dialogMessage = UIAlertController(title: "Correcto", message: "Cuenta modificada correctamente", preferredStyle: .alert)
                     
                     // Create OK button with action handler
                     let ok = UIAlertAction(title: "Aceptar", style: .default, handler: { (action) -> Void in
                         
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
        if(!(ccc.text?.isEmpty ?? true) && !(saldo.text?.isEmpty ?? true)){
            print(id)
            if(id == 0){
                let cli = clientes[spinner.selectedRow(inComponent: 0)]
                
                item = Cuenta(id: 0, ccc: ccc.text, saldo: Float(saldo.text ?? "0.0"), enAlta: enAlta.isOn, clienteByIdCliente: cli)
                
                guardarCuenta()
            }else{
                let cli = clientes[spinner.selectedRow(inComponent: 0)]
                
                item = Cuenta(id: id, ccc: ccc.text, saldo: Float(saldo.text ?? "0.0"), enAlta: enAlta.isOn, clienteByIdCliente: cli)
                modificarCuenta(id: id)
            }
        }
    }
    
    @IBAction func btnEliminar(_ sender: Any) {
        eliminarCuenta(id: id)
    }
}

extension VistaCuentaCRUD: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return clientes.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return clientes[row].toString()
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.indexOfPicker = row
    }
}

