//
//  QuestionVC.swift
//  QiangGuoPlugs
//
//  Created by 张贺 on 2021/3/15.
//

import UIKit

typealias BackBlock = (_ string: String) ->()

class QuestionVC: BaseVC {
    
    @IBOutlet weak var qTextV: UITextView!
    @IBOutlet weak var aTextV: UITextView!
    var model: QuestionM?
    
    var backBlock: BackBlock!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setViews() {
        qTextV.text = model?.originalQuestion
        aTextV.text = model?.answer
    }
    
    @IBAction func closeAct(_ sender: Any) {
        closeAct()
    }
    
    @IBAction func saveAct(_ sender: Any) {
//        if qTextV.text.count * aTextV.text.count != 0 {
//            model?.originalQuestion = qTextV.text
//            model?.answer = aTextV.text
//            QuestionM.update(questionM: model!)
//            backBlock("1")
//            closeAct()
//        }
    }
}
