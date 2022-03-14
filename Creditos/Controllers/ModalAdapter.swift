//
//  ModalAdapter.swift
//  Creditos
//
//  Created by Fernando González González on 28/12/21.
//

import UIKit

class ModalAdapter{
    
    func modalFunc()->ModalListController{
        let storyboard = UIStoryboard(name: "ModalList", bundle: .main)
        let modal = storyboard.instantiateViewController(withIdentifier: "idStoryModal") as! ModalListController
        
        return modal
    }

        
    
}

