//
//  ListTableCell.swift
//  Creditos
//
//  Created by Fernando González González on 27/12/21.
//

import UIKit

class ListTableCell: UITableViewCell {
    
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblSKU: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    
    static let idCell = "idCell"
    
    static func nib()->UINib{
        return UINib(nibName: "ListTableCell", bundle: nil)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ data:[[Any]]?){
        
        if let dat = data{
            
            for i in dat{
                lblSKU.text = "SKU: \(i[0])"
                lblNombre.text = "Nombre: \(i[1])"
                lblPrecio.text = "$\(i[2])"
            }
            
        }
    }
    
}
