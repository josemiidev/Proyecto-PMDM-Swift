//
//  VistaCliente.swift
//  Proyecto PMDM Swift
//
//  Created by José Miguel Lorenzo Lara on 27/2/23.
//

import UIKit
struct Cliente :Codable{
    let id : Int?
    let dni : String?
    let nombre : String?
    let apellidos : String?
    let fechaNacimiento: String?
    let sucursalByIdSucursal: Sucursal?
    
    func toString() -> String {
        return (dni ?? "") + " - "+(nombre ?? "") + " " + (apellidos ?? "")
    }
}
class VistaCliente: UIViewController {
    var UrlStr = "http://dam2-15e3b8:8000/"
    
    @IBOutlet weak var tabla: UITableView!
    var clientes : [Cliente] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.register(UINib(nibName:  "CeldaClienteView", bundle: nil), forCellReuseIdentifier: "celdaCliente")
        tabla.delegate = self
        tabla.dataSource = self
        
        buscarClientes()
    }
    
    func buscarClientes(){
        guard let url = URL(string: UrlStr + "clientes") else {
        //guard let url = URL(string: "http://dam2-15e3b8:8000/clientes") else {
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
                    self.tabla.reloadData()
                }
                
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
}
extension VistaCliente: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tabla.dequeueReusableCell(withIdentifier: "celdaCliente", for: indexPath) as! CeldaClienteView
        celda.lblNombre.text = (clientes[indexPath.row].nombre ?? "") + " " + (clientes[indexPath.row].apellidos ?? "")
        celda.lblDni.text = clientes[indexPath.row].dni
        celda.id = Int(clientes[indexPath.row].id ?? 0)
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let celda = tabla.cellForRow(at: indexPath) as! CeldaClienteView
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "CRUD_Cliente") as! VistaClienteCRUD;
        vc.id = celda.id
        self.present(vc,animated: true,completion: nil)
    }
}
