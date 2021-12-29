//
//  ModalListController.swift
//  Creditos
//
//  Created by Fernando González González on 28/12/21.
//

import UIKit
import CoreData

class ModalListController: UIViewController, dataCotizacion {
    
    func dataCotizame(arrayProduct: [Any]?, arrayInteres: [Any]?) {
        print("Funciona")
        print(arrayInteres!)
        print(arrayProduct!)
    }
    
    
    //INSTACIAS DE UI
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblNameProduct: UILabel!
    @IBOutlet weak var lblMoneyProduct: UILabel!
    @IBOutlet weak var lblInteresNormal: UILabel!
    @IBOutlet weak var lblInteresPuntual: UILabel!
    
    let adapter = ModalAdapter()
    
    var arrPro:[Any]?
    var arrInt:[Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(arrPro!)
    }
    
    
    func sendDataProduct(arrDataProduct: [Any]) {
        print(arrDataProduct)
    }
    

    @IBAction func btnClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
