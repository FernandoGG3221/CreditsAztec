//
//  ListCotizacionCell.swift
//  Creditos
//
//  Created by Fernando González González on 28/12/21.
//

import UIKit

class ListCotizacionCell: UITableViewCell {

    //INSTANCIAS DE UI
    @IBOutlet weak var lblNoWeek: UILabel!
    
    static let idCell1 = "idCell1"
    
    static func nib()->UINib{
        return UINib(nibName: "ListCotizacionCell", bundle: nil)
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
        
        if let data = data {
            
            for i in data{
                lblNoWeek.text = "\(i[0])"
            }
            
        }
        
    }
    
}
