//
//  ModelsVC.swift
//  QiangGuoPlugs
//
//  Created by 张贺 on 2021/3/10.
//

import UIKit



class ModelsVC: BaseVC {
    @IBOutlet weak var backgroundV: UIView!
    
    var dataAry: [ModelM] = ModelM.queryAll()
    
    @IBOutlet weak var cBtn: UIButton!
    @IBOutlet weak var bBtn: UIButton!
    
    var cIsAdd: Bool = false
    var bIsAdd: Bool = false
    
    var cModel: ModelM?
    var bModel: ModelM?
    
    @IBOutlet weak var cImgV: UIImageView!
    @IBOutlet weak var bImgV: UIImageView!
    
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(setData), name: NSNotification.Name(rawValue: "modelChange"), object: nil)
        super.viewDidLoad()
    }
    
    override func setViews() {
//        baseTV.frame = backgroundV.bounds
//        baseTV.register(UINib(nibName: "ModelTableCell", bundle: nil), forCellReuseIdentifier: "ModelTableCell")
//        backgroundV.addSubview(baseTV)
    }
    
    override func resetViews() {
        cBtn.setTitle(cIsAdd ? "修改" : "添加", for: .normal)
        bBtn.setTitle(bIsAdd ? "修改" : "添加", for: .normal)
        if dataAry.count == 2 {
            cImgV.alpha = UserDefaults.standard.string(forKey: "modelT") == "挑战答题" ? 1 : 0
            bImgV.alpha = UserDefaults.standard.string(forKey: "modelT") == "比赛答题" ? 1 : 0
        } else {
            cImgV.alpha = 0
            bImgV.alpha = 0
        }
    }
    
    @objc override func setData() {
        dataAry = ModelM.queryAll()
        bIsAdd = false
        cIsAdd = false
        if dataAry.count == 2 {
            cIsAdd = true
            bIsAdd = true
            if UserDefaults.standard.string(forKey: "modelT") == nil {
                UserDefaults.standard.setValue("挑战答题", forKey: "modelT")
            }
        } else {
            for tempM in dataAry {
                if tempM.name == "挑战答题" {
                    cIsAdd = true
                    cModel = tempM
                }
                if tempM.name == "比赛答题" {
                    bIsAdd = true
                    bModel = tempM
                }
            }
        }
        resetViews()
    }
    
    @IBAction func modelAct(_ sender: UIButton) {
        let rootVC: ModelAddImgVC = ModelAddImgVC.init(nibName: "ModelAddImgVC", bundle: nil)
        rootVC.model = sender.tag == 30000 ? cIsAdd ? cModel : nil : bIsAdd ? bModel : nil;
        rootVC.name = sender.tag == 30000 ? "挑战答题" : "比赛答题"
        let vc: UINavigationController = UINavigationController(rootViewController: rootVC)
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func selectAct(_ sender: UIButton) {
        if dataAry.count == 2 {
            let type = sender.tag == 30010 ? "挑战答题" : "比赛答题"
            if UserDefaults.standard.string(forKey: "modelT") != type {
                UserDefaults.standard.setValue(type, forKey: "modelT")
                resetViews()
            }
        }
    }
    
    @IBAction func backAct(_ sender: Any) {
        backAct()
    }
    
    override func didReceiveMemoryWarning() {
        NotificationCenter.default.removeObserver(self)
    }
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataAry.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: ModelTableCell = tableView.dequeueReusableCell(withIdentifier: "ModelTableCell", for: indexPath) as! ModelTableCell
//        cell.model = dataAry[indexPath.row]
//        cell.selectionStyle = UITableViewCell.SelectionStyle.none
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let delAct = UIContextualAction(style: .destructive, title: "删除") { action, view, completion in
//            let tempM = self.dataAry[indexPath.row]
//            if UserDefaults.standard.string(forKey: "modelT") == tempM.tid {
//                UserDefaults.standard.setValue(nil, forKey: "modelT")
//            }
//            ModelM.delete(modelM: self.dataAry[indexPath.row])
//            self.setData()
//        }
//        let modAct = UIContextualAction(style: .normal, title: "编辑") { action, view, completion in
//            let vc: ModelAddAreaVC = ModelAddAreaVC.init(nibName: "ModelAddAreaVC", bundle: nil)
//            vc.model = self.dataAry[indexPath.row]
//            self.navigationController?.pushViewController(vc, animated: true)
//            tableView.setEditing(false, animated: true)
//        }
//        let conf = UISwipeActionsConfiguration(actions: [delAct, modAct])
//        return conf
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if UserDefaults.standard.string(forKey: "modelT") != dataAry[indexPath.row].tid {
//            UserDefaults.standard.setValue(dataAry[indexPath.row].tid, forKey: "modelT")
//            UserDefaults.standard.setValue(dataAry[indexPath.row].name, forKey: "modelN")
//            UserDefaults.standard.setValue(String(format: "%@,%@,%@,%@", dataAry[indexPath.row].x, dataAry[indexPath.row].y, dataAry[indexPath.row].wid, dataAry[indexPath.row].hei), forKey: "modelC")
//            resetViews()
//        }
//    }
}
