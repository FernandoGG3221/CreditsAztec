//
//  Detail.swift
//  Creditos
//
//  Created by Fernando González González on 28/12/21.
//

import UIKit

class Detail: UIViewController {
    
    //Instancias de UI
    @IBOutlet weak var lblMoney: UILabel!
    @IBOutlet weak var lblNormal: UILabel!
    @IBOutlet weak var lblPuntual: UILabel!
    @IBOutlet weak var lblNameProduct: UILabel!
    
    var arrData:[Any]?
    var dataProduct:[Any]?
    var dataInteres:[Any]?
    
    var nameProduct = ""
    var money = ""
    var interesNormal = ""
    var interesPuntual = ""
    var semanas = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        recoveryData()
    }
    

    func recoveryData(){
        if let arrData = arrData {
            dataProduct = (arrData[0] as! [Any])
            dataInteres = (arrData[1] as! [Any])
            
            
            if let dataProduct = dataProduct {
                nameProduct = "\(dataProduct[1])"
                money = "\(dataProduct[2])"
            }
            
            if let dataInteres = dataInteres {
                semanas = dataInteres[0] as! Int
                interesNormal = "\(dataInteres[1])"
                interesPuntual = "\(dataInteres[2])"
            }
            
            calculate()
            
            lblNameProduct.text = nameProduct
            lblMoney.text = money
            
        }
    }
    
    func calculate(){
        let semanal = ((Double(money)! * Double(interesNormal)!) + Double(money)!) / Double(semanas)
        let puntual = ((Double(money)! * Double(interesPuntual)!) + Double(money)!) / Double(semanas)
        
        lblNormal.text = "$\(semanal)"
        lblPuntual.text = "$\(puntual)"
        
    }
    
    
    @IBAction func btnClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
