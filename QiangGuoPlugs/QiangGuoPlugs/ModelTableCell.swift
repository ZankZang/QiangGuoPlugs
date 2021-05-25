//
//  ModelTableCell.swift
//  QiangGuoPlugs
//
//  Created by 张贺 on 2021/3/12.
//

import UIKit

class ModelTableCell: UITableViewCell {
    
    @IBOutlet weak var lab: UILabel!
    
    @IBOutlet weak var imgV: UIImageView!
    
    private var _model: ModelM?
    var model: ModelM? {
        set {
            _model = newValue
            lab.text = _model?.name
            imgV.alpha = UserDefaults.standard.string(forKey: "modelT") == _model?.tid ? 1 : 0
        }
        get {
            return _model
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
