//
//  Products.swift
//  Creditos
//
//  Created by Fernando González González on 27/12/21.
//

import UIKit
import CoreData

class Products: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //  INSTANCIAS DE UI
    
    //Segmented Control
    @IBOutlet weak var optionsProducts: UISegmentedControl!
    //Btns
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    //EditText
    @IBOutlet weak var edtSKU: UITextField!
    @IBOutlet weak var edtName: UITextField!
    @IBOutlet weak var edtMoney: UITextField!
    //TableView
    @IBOutlet weak var tableViewProducts: UITableView!
    //Views
    @IBOutlet weak var viewShowProducts: UIView!
    @IBOutlet weak var viewTableProducts: UIView!
    
    //Variables
    var posIniViewP:Double?
    var posIniViewT:Double?
    var heigtView:Double?
    weak var context:NSManagedObjectContext?
    
    var arrData = [Any]()
    var arrProducts = [[Any]]()
    var indexList = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        //Configuración de las posiciones de las vistas
        posIniView()
        configureBtns()
        configureTable()
        recoveryData()
        setUpTarget()
    }

    @IBAction func changeOptionProduct(_ sender: Any) {
        segmentedOptions()
        tableViewProducts.reloadData()
        recoveryData()
    }
    
    
    func setUpTarget(){
        edtSKU.addTarget(self, action: #selector(self.validateFields), for: .editingChanged)
        edtName.addTarget(self, action: #selector(self.validateFields), for: .editingChanged)
        edtMoney.addTarget(self, action: #selector(self.validateFields), for: .editingChanged)
    }
    
    
    @objc func validateFields(){
        btnAdd.isEnabled = edtSKU.text != "" && edtName.text != "" && edtMoney.text != ""
    }
    
    //Reglas de negocio
    
    @IBAction func btnAddProduct(_ sender: UIButton) {
        
        let sku = edtSKU.text
        let name = edtName.text
        let money = edtMoney.text
        
        if sku!.isEmpty && name!.isEmpty && money!.isEmpty{
            print("LLena los datos")
        }else{
            do{
                context = getContextCoreData()
                
                if let ctx = context{
                    let newObj = NSEntityDescription.insertNewObject(forEntityName: "ModelProducts", into: ctx)
                    newObj.setValue(sku, forKey: "sku")
                    newObj.setValue(name, forKey: "nombre")
                    newObj.setValue(Double(money!), forKey: "precio")
                    try context?.save()
                    edtClears()
                    
                    print("Añadiendo producto a la bd")
                    btnAdd.isEnabled = false
                    recoveryData()
                    
                }
                
            }catch let err{
                print("\nError al guardar los datos")
                print(err.localizedDescription)
            }
            
            
            
        }
        
        
        
    }
    
    @IBAction func btnEdit(_ sender: UIButton) {
        
        
        let entity = arrData[indexList] as! NSManagedObject
        
        
        let sku = edtSKU.text
        let name = edtName.text
        let money = edtMoney.text
        entity.setValue(sku, forKey: "sku")
        entity.setValue(name, forKey: "nombre")
        entity.setValue(Double(money!), forKey: "precio")
        
        do{
            try context?.save()
            print("Actualizando datos")
            edtClears()
            recoveryData()
        }catch let err{
            print(err.localizedDescription)
        }
        configureBtns()
        //recoveryData()
        
    }
    
    func edtClears(){
        edtSKU.text = ""
        edtName.text = ""
        edtMoney.text = ""
    }
    
    func configureTable(){
        tableViewProducts.delegate = self
        tableViewProducts.dataSource = self
        tableViewProducts.register(ListTableCell.nib(), forCellReuseIdentifier: ListTableCell.idCell)
    }
    
    
    func configureBtns(){
        btnEdit.isHidden = true
        btnAdd.isEnabled = false
    }
    
        
    func segmentedOptions(){
        if optionsProducts.selectedSegmentIndex == 0{
            print("Opcinones de añadir y editar productos")
            viewAddProducts(hide: false)
            if let heigth = heigtView{
                viewTableProducts.frame.size.height = heigth
            }
            
        }else if optionsProducts.selectedSegmentIndex == 1{
            print("Opcinones de eliminar productos")
            viewAddProducts(hide: true)
            //Aumentar de tamaño la tabla para ver las elementos
            viewTableProducts.frame.size.height = viewTableProducts.frame.height + viewShowProducts.frame.height
        }
        
        
        recoveryData()
        
    }
    
    //Funcion para ver los productos
    func viewAddProducts(hide:Bool){
        
        if hide == true{
            viewShowProducts.isHidden = hide
            if let pos = posIniViewP{
                viewTableProducts.frame.origin.y = pos
                
            }else{
                print("Error 1")
            }
            
        }else if hide == false{
            btnEdit.isHidden = true
            viewShowProducts.isHidden = hide
            edtClears()
            if let pos = posIniViewT{
                viewTableProducts.frame.origin.y = pos
            }else{
                print("Error 2")
            }
            
        }
        
    }
    
    func posIniView(){
        posIniViewP = viewShowProducts.frame.origin.y
        posIniViewT = viewTableProducts.frame.origin.y
        heigtView = viewTableProducts.frame.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableCell.idCell, for: indexPath) as! ListTableCell
        
        let _array = arrProducts[index]
        
        cell.configureCell([_array])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btnAdd.isEnabled = false
        //Solo permite editar en la lista
        if optionsProducts.selectedSegmentIndex == 0{
            print("Editando opciones")
            btnEdit.isHidden = false
            
            let arr = arrProducts[indexPath.row]
            indexList = indexPath.row
            
            edtSKU.text = "\(arr[0])"
            edtName.text = "\(arr[1])"
            edtMoney.text = "\(arr[2])"
            
            
        }
        //  Se encuentra en el menu de eliminar
        else if optionsProducts.selectedSegmentIndex == 1{
            print("Eliminando elemento")
            
            var indexfound = -1
            let arr = arrProducts[indexPath.row]
            var count = 0
            
            for i in arrData{
                let data = i as! NSManagedObject
                let sku = data.value(forKey: "sku") as! String
                
                if sku == "\(arr[0])"{
                    indexfound = count
                }
                
                count += 1
            }
            
            let alert = UIAlertController(title: "Atención", message: "¿Deseas eliminar el registro?", preferredStyle: .alert)
            let btnOk = UIAlertAction(title: "Si, eliminar", style: .default, handler: { [self]_ in
                
                do{
                    self.context?.delete(self.arrData[indexfound] as! NSManagedObject)
                    //Actualizar el arreglo que se envia a las listas para actualizar los datos
                    try self.context?.save()
                    print("Eliminación correcta")
                    recoveryData()
                }catch let err{
                    print(err.localizedDescription)
                }
                
            })
            
            let btnCancel = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alert.addAction(btnOk)
            alert.addAction(btnCancel)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        recoveryData()
        
    }
    
    
    
    func recoveryData(){
        
        context = getContextCoreData()
        
        let requestSerarch = NSFetchRequest<NSFetchRequestResult>(entityName: "ModelProducts")
        
        arrProducts = []
        
        do{
            
            arrData = try context!.fetch(requestSerarch)
            
            for index in arrData{
                let temp = index as! NSManagedObject
                
                let sku = temp.value(forKey: "sku") as! String
                let name = temp.value(forKey: "nombre") as! String
                let money = "\(temp.value(forKey: "precio")!)"
                
                
                arrProducts.append([sku, name, money])
                
                
            }
            
            tableViewProducts.reloadData()

        }catch let err{
            print("Error al cargar los datos en el array")
            print(err.localizedDescription)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
