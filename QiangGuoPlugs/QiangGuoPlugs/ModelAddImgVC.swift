//
//  ModelAddImgVC.swift
//  QiangGuoPlugs
//
//  Created by 张贺 on 2021/3/11.
//

import UIKit

class ModelAddImgVC: BaseVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var model: ModelM?
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func selectAct(_ sender: Any) {
        let vc: UIImagePickerController = UIImagePickerController()
        vc.sourceType = UIImagePickerController.SourceType.photoLibrary
        vc.delegate = self
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [self] in
            let img: UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let vc: ModelAddAreaVC = ModelAddAreaVC.init(nibName: "ModelAddAreaVC", bundle: nil)
            vc.img = img
            vc.name = self.name
            vc.model = self.model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func closeAct(_ sender: Any) {
        closeAct()
    }
    
}
