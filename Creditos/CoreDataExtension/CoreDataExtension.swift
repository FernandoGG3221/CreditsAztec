//
//  CoreDataExtension.swift
//  Creditos
//
//  Created by Fernando González González on 27/12/21.
//

import Foundation
import CoreData
import UIKit

extension UIViewController{
    
    func getContextCoreData() -> NSManagedObjectContext{
        let ctx = UIApplication.shared.delegate as! AppDelegate
        return ctx.persistentContainer.viewContext
    }
    
}
