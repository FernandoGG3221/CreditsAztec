//
//  Credits.swift
//  Creditos
//
//  Created by Fernando González González on 27/12/21.
//

import UIKit
import CoreData


class Credits: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Instancias de UI
    @IBOutlet weak var tableProducts: UITableView!
    
    //Variables
    var arrData = [Any]()
    var arrProducts = [[Any]]()
    weak var context:NSManagedObjectContext?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTable()
        recoveryData()
        
    }
    
    func configureTable(){
        tableProducts.delegate = self
        tableProducts.dataSource = self
        tableProducts.register(ListTableCell.nib(), forCellReuseIdentifier: ListTableCell.idCell)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableCell.idCell, for: indexPath) as! ListTableCell
        
        let array = arrProducts[index]
        
        cell.configureCell([array])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let array = arrProducts[index]
        
        self.performSegue(withIdentifier: "transCotizacion", sender: array)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let send = sender as! [Any]
        let screen:CreditPlazos = segue.destination as! CreditPlazos
        screen.arrDataProduct = send
    }

    func recoveryData(){
        context = getContextCoreData()
        
        let requestSearch = NSFetchRequest<NSFetchRequestResult>(entityName: "ModelProducts")
        
        do{
            arrData = try context!.fetch(requestSearch)
            
            for index in arrData{
                let temp = index as! NSManagedObject
                
                let sku = temp.value(forKey: "sku") as! String
                let name = temp.value(forKey: "nombre") as! String
                let money = "\(temp.value(forKey: "precio")!)"
                
                arrProducts.append([sku, name, money])
                
            }
            
            
        }catch let err{
            print(err.localizedDescription)
        }
    }
    
}
