//
//  VistaCuenta.swift
//  Proyecto PMDM Swift
//
//  Created by José Miguel Lorenzo Lara on 27/2/23.
//

import UIKit
struct Cuenta :Codable{
    let id : Int?
    let ccc : String?
    let saldo : Float?
    let enAlta : Bool?
    let clienteByIdCliente: Cliente?
}
class VistaCuenta: UIViewController {
    var UrlStr = "http://dam2-15e3b8:8000/"

    @IBOutlet weak var tabla: UITableView!
    
    var cuentas : [Cuenta] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.register(UINib(nibName:  "CeldaCuentaView", bundle: nil), forCellReuseIdentifier: "celdaCuenta")
        tabla.delegate = self
        tabla.dataSource = self
        
        buscarCuentas()
    }
    func buscarCuentas(){
        guard let url = URL(string: UrlStr + "cuentas") else {
        //guard let url = URL(string: "http://dam2-15e3b8:8000/cuentas") else {
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
                let datos = try decoder.decode([Cuenta].self, from: data)
                self.cuentas.append(contentsOf: datos)
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
extension VistaCuenta: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cuentas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tabla.dequeueReusableCell(withIdentifier: "celdaCuenta", for: indexPath) as! CeldaCuentaView
        celda.lblCuenta.text = cuentas[indexPath.row].ccc
        celda.lblSaldo.text = NSString(format: "%.2f", cuentas[indexPath.row].saldo ?? 0.0) as String?
        celda.id = Int(cuentas[indexPath.row].id ?? 0)
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let celda = tabla.cellForRow(at: indexPath) as! CeldaCuentaView
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "CRUD_Cuenta") as! VistaCuentaCRUD;
        vc.id = celda.id
        self.present(vc,animated: true,completion: nil)
    }
}
