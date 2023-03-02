//
//  ViewController.swift
//  Proyecto PMDM Swift
//
//  Created by José Miguel Lorenzo Lara on 22/2/23.
//

import UIKit

struct Sucursal :Codable{
    let id : Int?
    let poblacion : String?
    let provincia : String?
    let referencia : String?
    
    func toString() -> String {
        return (poblacion ?? "") + " ("+(provincia ?? "") + ") - " + (referencia ?? "")
        }
}
class VistaSucursal: UIViewController {
    var UrlStr = "http://dam2-15e3b8:8000/"
    
    @IBOutlet weak var tabla: UITableView!
    
    var sucursales : [Sucursal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabla.register(UINib(nibName:  "CeldaSucursalesView", bundle: nil), forCellReuseIdentifier: "celdaSucursal")
        tabla.delegate = self
        tabla.dataSource = self
        
        buscarSucursales()
    }
    
    func buscarSucursales(){
        guard let url = URL(string: UrlStr + "sucursales") else {
        //guard let url = URL(string: "http://dam2-15e3b8:8000/sucursales") else {
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
                self.sucursales = datos
                DispatchQueue.main.async {
                    self.tabla.reloadData()
                }
                
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    @IBAction func btnActualizar(_ sender: Any) {
        buscarSucursales()
    }
}

extension VistaSucursal: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sucursales.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tabla.dequeueReusableCell(withIdentifier: "celdaSucursal", for: indexPath) as! CeldaSucursalesView
        celda.lblPoblacion.text = sucursales[indexPath.row].poblacion
        celda.lblProvincia.text = sucursales[indexPath.row].provincia
        celda.lblReferencia.text = sucursales[indexPath.row].referencia
        celda.id = Int(sucursales[indexPath.row].id ?? 0)
        return celda
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let celda = tabla.cellForRow(at: indexPath) as! CeldaSucursalesView
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "CRUD_Sucursal") as! VistaSucursalCRUD;
        vc.id = celda.id
        self.present(vc,animated: true,completion: nil)
        print("HOLA")
    }
}

