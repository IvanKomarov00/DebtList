//
//  HomeScreenTableViewCell.swift
//  DebtList
//
//  Created by Ivan Komarov on 21.04.2023.
//

import UIKit

class HomeScreenTableViewCell: UITableViewCell {

    @IBOutlet weak var debtLable: UILabel!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var durationLable: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func update(with debtor: Debtor){
        debtLable.text = "\(debtor.total) $"
        nameLable.text = debtor.name
        durationLable.text = debtor.duration
        photoImageView.image = debtor.image
    }

}
