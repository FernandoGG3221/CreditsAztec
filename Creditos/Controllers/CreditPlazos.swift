//
//  CreditPlazos.swift
//  Creditos
//
//  Created by Fernando González González on 28/12/21.
//

import UIKit
import CoreData

protocol dataCotizacion{
    func dataCotizame(arrayProduct:[Any]?, arrayInteres:[Any]?)
}

class CreditPlazos: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Instancias de UI
    @IBOutlet weak var tablePlazos: UITableView!
    
    var arrData = [Any]()
    var arrCotizacion = [[Any]]()
    weak var context:NSManagedObjectContext?
    let adapterModal = ModalAdapter()
    var arrDataPlazos: [Any]?
    var arrDataProduct: [Any]?
    var delegate:dataCotizacion?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureTable()
        recoveryData()
    }
    
    
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCotizacionCell.idCell1, for: indexPath) as! ListCotizacionCell
        
        let array = arrCotizacion[index]
        cell.configureCell([array])
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Abrir modal")
        let index = indexPath.row
        let array = arrCotizacion[index]
        
        if let arrDataProduct = arrDataProduct {
            let arr = [arrDataProduct, array]
            self.performSegue(withIdentifier: "transDetail", sender: arr)
        }
        
        let modal = adapterModal.modalFunc()
        
        
        present(modal, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let send = sender as! [Any]
        let screen:Detail = segue.destination as! Detail
        screen.arrData = send
    }
    
    func configureTable(){
        tablePlazos.delegate = self
        tablePlazos.dataSource = self
        tablePlazos.register(ListCotizacionCell.nib(), forCellReuseIdentifier: ListCotizacionCell.idCell1)
    }
    
    func recoveryData(){
        context = getContextCoreData()
        
        let requestSearch = NSFetchRequest<NSFetchRequestResult>(entityName: "ModelPlazos")
        
        do{
            arrData = try context!.fetch(requestSearch)
            
            for i in arrData{
                let temp = i as! NSManagedObject
                
                let week = temp.value(forKey: "semanas")
                let normal = temp.value(forKey: "interesNormal")
                let puntual = temp.value(forKey: "interesPuntual")
                
                arrCotizacion.append([week!, normal!, puntual!])
                
            }
            
        }catch let err{
            print(err.localizedDescription)
        }
    }
    
}
