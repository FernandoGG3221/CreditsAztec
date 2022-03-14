//
//  Credits.swift
//  Creditos
//
//  Created by Fernando González González on 27/12/21.
//

import UIKit
import CoreData


class Credits: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var tableProducts: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Variables
    var arrData = [Any]()
    var arrProducts = [[Any]]()
    var arrFilter = [[Any]]()
    weak var context:NSManagedObjectContext?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTable()
        recoveryData()
        arrFilter = arrProducts
    }
    
    func configureTable(){
        tableProducts.delegate = self
        tableProducts.dataSource = self
        tableProducts.register(ListTableCell.nib(), forCellReuseIdentifier: ListTableCell.idCell)
        searchBar.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableCell.idCell, for: indexPath) as! ListTableCell
        
        let array = arrFilter[index]
        
        cell.configureCell([array])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let array = arrFilter[index]
        
        self.performSegue(withIdentifier: "transCotizacion", sender: array)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let send = sender as! [Any]
        let screen:CreditPlazos = segue.destination as! CreditPlazos
        screen.arrDataProduct = send
    }

    func recoveryData(){
        
        context = getContextCoreData()
        
        arrProducts = []
        
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
            
            arrFilter = arrProducts
            
        }catch let err{
            print(err.localizedDescription)
        }
        
    }
    
    //MARK: - SearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        arrFilter = []
        
        if searchText == ""{
            arrFilter = arrProducts
            tableProducts.reloadData()
        }else{
            print("Arreglo de productos",arrFilter)
            
            for i in arrProducts{
                print(i)
                let sku = i[0] as! String
                let product = i[1] as! String
                   
                if  sku.lowercased().contains(searchText.lowercased())
                    ||
                    product.lowercased().contains(searchText.lowercased())
                {
                    print("\nProductos en existencia")
                    print("sku",sku)
                    print("product", product)
                    arrFilter.append(i)
                    tableProducts.reloadData()
                    print(i)
                }else{
                    print("No se encuentran en existencia")
                }
            }
        }
        
    }
    
}
