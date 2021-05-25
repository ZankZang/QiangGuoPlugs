//
//  AnswerTableCell.swift
//  QiangGuoPlugs
//
//  Created by 张贺 on 2021/2/25.
//

import UIKit

class AnswerTableCell: UITableViewCell {

    @IBOutlet open weak var questionLab: UILabel!
    @IBOutlet open weak var answerLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
