//
//  Plazos.swift
//  Creditos
//
//  Created by Fernando González González on 27/12/21.
//

import UIKit
import CoreData

class Plazos: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // INSTANCIAS DE UI
    @IBOutlet weak var edtWeek: UITextField!
    @IBOutlet weak var edtNormal: UITextField!
    @IBOutlet weak var edtPuntual: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    
    
    var selectWeek = UIPickerView()
    var arrData = [Int]()
    weak var context: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        btnAdd.isEnabled = false
        configurePickerView()
        setUpTarget()
    }
    
    func configurePickerView(){
        selectWeek.delegate = self
        selectWeek.dataSource = self
        
        for i in 1...24{
            arrData.append(i)
        }
        
        pickerWeek()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(arrData[row])"
    }

    
    
    func pickerWeek(){
        let btn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(valuePicker))
        let tool = UIToolbar()
        tool.sizeToFit()
        tool.setItems([btn], animated: true)
        
        edtWeek.inputAccessoryView = tool
        edtWeek.inputView = selectWeek
    }
    
    @objc func valuePicker(){
        
        let i = arrData[selectWeek.selectedRow(inComponent: 0)]
        
        edtWeek.text = "\(i)"
        
        self.view.endEditing(true)
        
        calculateInteres(week: i)
    }
    
    
    func calculateInteres(week:Int){
        
        let normal = 1.0366 / 12
        let puntual = 0.8963 / 12
        
        edtNormal.text = "\(Double(week) * normal)"
        edtPuntual.text = "\(Double(week) * puntual)"
        
        validateFields()
    }
    
    func setUpTarget(){
        edtWeek.addTarget(self, action: #selector(self.validateFields), for: .editingChanged)
        edtNormal.addTarget(self, action: #selector(self.validateFields), for: .editingChanged)
        edtPuntual.addTarget(self, action: #selector(self.validateFields), for: .editingChanged)
    }
    
    
    @objc func validateFields(){
        btnAdd.isEnabled = edtWeek.text != "" && edtNormal.text != "" && edtPuntual.text != ""
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        addWeekInteres()
    }
    
    func addWeekInteres(){
     
        let week = edtWeek.text
        let normal = edtNormal.text
        let puntual = edtPuntual.text
        
        if week!.isEmpty && normal!.isEmpty && puntual!.isEmpty{
            print("Porfavor de llenar los datos")
        }else{
            do{
                context = getContextCoreData()
                
                if let ctx = context{
                    let newObj = NSEntityDescription.insertNewObject(forEntityName: "ModelPlazos", into: ctx)
                    newObj.setValue(Int(week!), forKey: "semanas")
                    newObj.setValue(Double(normal!), forKey: "interesNormal")
                    newObj.setValue(Double(puntual!), forKey: "interesPuntual")
                    
                    try context?.save()
                    clearText()
                    
                    print("Añadiendo productos a la bd")
                    validateFields()
                    
                }
                
            }catch let err{
                print("Error al guardar los plazos")
                print(err.localizedDescription)
            }
        }
        
    }
    
    
    
    func clearText(){
        edtWeek.text = ""
        edtNormal.text = ""
        edtPuntual.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
