//
//  ModelAddAreaVC.swift
//  QiangGuoPlugs
//
//  Created by 张贺 on 2021/3/11.
//

import UIKit

enum ToucheType {
    case none
    case left
    case top
    case right
    case bottom
    case leftTop
    case rightTop
    case leftBottom
    case rightBottom
}

class ModelAddAreaVC: BaseVC, UITextFieldDelegate {
    
    var img: UIImage?
    var name: String?
    var model: ModelM?
    
    var touchType: ToucheType = ToucheType.none
    let miniAreaWid: CGFloat = 150
    let miniAreaHei: CGFloat = 30
    let miniTouchLength: CGFloat = 15
    
    @IBOutlet weak var shadowV: UIView!
    @IBOutlet weak var borderV: UIView!
    
    @IBOutlet weak var nameTF: UITextField!
    
    var borderRect: CGRect = CGRect(x: 30, y: 200, width: UIScreen.main.bounds.size.width - 60, height: 100)
    var tempRect: CGRect = CGRect(x: 30, y: 200, width: UIScreen.main.bounds.size.width - 60, height: 100)
    
    var tempPoint: CGPoint = CGPoint(x: 0, y: 0 )
    
    @IBOutlet weak var borderVHeiCon: NSLayoutConstraint!
    @IBOutlet weak var borderVWidCon: NSLayoutConstraint!
    @IBOutlet weak var borderVYCon: NSLayoutConstraint!
    @IBOutlet weak var borderVXCon: NSLayoutConstraint!
    
    @IBOutlet weak var imgV: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setViews() {
        if model != nil {
            borderRect = CGRect(x: CGFloat(Float(model!.x)!), y: CGFloat(Float(model!.y)!), width: CGFloat(Float(model!.wid)!), height: CGFloat(Float(model!.hei)!))
        }
        nameTF.text = name
        imgV.image = img
        borderV.layer.borderColor = UIColor.white.cgColor
        resetViews()
    }
    
    override func resetViews() {
        let path: UIBezierPath = UIBezierPath.init(rect: shadowV.frame)
        path.append(UIBezierPath.init(roundedRect: borderRect, cornerRadius: 0).reversing())
        let layer: CAShapeLayer = CAShapeLayer()
        layer.path = path.cgPath
        shadowV.layer.mask = layer

        borderVXCon.constant = borderRect.origin.x - 2
        borderVYCon.constant = borderRect.origin.y - 2
        borderVWidCon.constant = borderRect.size.width + 4
        borderVHeiCon.constant = borderRect.size.height + 4;
        view.layoutIfNeeded()
    }
    
    @IBAction func backAct(_ sender: Any) {
        backAct()
    }
    
    @IBAction func saveAct(_ sender: Any) {
        if model == nil {
            model = ModelM()
            model!.name = name!
            model!.x = String(format: "%f", borderRect.origin.x)
            model!.y = String(format: "%f", borderRect.origin.y)
            model!.wid = String(format: "%f", borderRect.size.width)
            model!.hei = String(format: "%f", borderRect.size.height)
            ModelM.insert(modelM: model!)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modelChange"), object: nil)
            closeAct()
        } else {
            model!.x = String(format: "%f", borderRect.origin.x)
            model!.y = String(format: "%f", borderRect.origin.y)
            model!.wid = String(format: "%f", borderRect.size.width)
            model!.hei = String(format: "%f", borderRect.size.height)
            ModelM.update(modelM: model!)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modelChange"), object: nil)
            backAct()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tempPoint = (touches.first?.location(in: shadowV))!
        tempRect = CGRect(x: borderV.frame.origin.x + 2, y: borderV.frame.origin.y + 2, width: borderV.frame.size.width - 4, height: borderV.frame.size.height - 4)
        let point: CGPoint = (touches.first?.location(in: borderV))!
//        if CGRect(x: -(miniTouchLength), y: -(miniTouchLength), width: miniTouchLength * 2, height: miniTouchLength * 2).contains(point) {
//            touchType = .leftTop
//            return
//        }
//        if CGRect(x: miniTouchLength, y: -(miniTouchLength), width: tempRect.size.width - miniTouchLength * 2, height: miniTouchLength * 2).contains(point) {
//            touchType = .top
//            return
//        }
//        if CGRect(x: tempRect.size.width - miniTouchLength, y: -(miniTouchLength), width: miniTouchLength * 2, height: miniTouchLength * 2).contains(point) {
//            touchType = .rightTop
//            return
//        }
        if CGRect(x: tempRect.size.width - miniTouchLength, y: -miniTouchLength, width: miniTouchLength * 2, height: tempRect.size.height).contains(point) {
            touchType = .right
            return
        }
        if CGRect(x: tempRect.size.width - miniTouchLength, y: tempRect.size.height - miniTouchLength, width: miniTouchLength * 2, height: miniTouchLength * 2).contains(point) {
            touchType = .rightBottom
            return
        }
        if CGRect(x: -miniTouchLength, y: tempRect.size.height - miniTouchLength, width: tempRect.size.width, height: miniTouchLength * 2).contains(point) {
            touchType = .bottom
            return
        }
//        if CGRect(x: -(miniTouchLength), y: tempRect.size.height - miniTouchLength, width: miniTouchLength * 2, height: miniTouchLength * 2).contains(point) {
//            touchType = .leftBottom
//            return
//        }
//        if CGRect(x: -(miniTouchLength), y: miniTouchLength, width: miniTouchLength * 2, height: tempRect.size.height - miniTouchLength * 2).contains(point) {
//            touchType = .left
//            return
//        }
        touchType = .none
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point: CGPoint = (touches.first?.location(in: shadowV))!
        let X: CGFloat = point.x - tempPoint.x
        let Y: CGFloat = point.y - tempPoint.y
        var rect: CGRect = CGRect()
        let wid: CGFloat = tempRect.size.width
        let hei: CGFloat = tempRect.size.height
        switch touchType {
//        case .left:
//            rect = CGRect(x: wid - X >= miniAreaWid ? tempRect.origin.x + X : tempRect.origin.x + wid - miniAreaWid, y: tempRect.origin.y, width: wid - X >= miniAreaWid ? wid - X : miniAreaWid, height: hei)
//        case .leftTop:
//            rect = CGRect(x: wid - X >= miniAreaWid ? tempRect.origin.x + X : tempRect.origin.x + wid - miniAreaWid, y: hei - Y >= miniAreaHei ? tempRect.origin.y + Y : tempRect.origin.y + hei - miniAreaHei, width: wid - X >= miniAreaWid ? wid - X : miniAreaWid, height: hei - Y >= miniAreaHei ? hei - Y : miniAreaHei)
//        case .top:
//            rect = CGRect(x: tempRect.origin.x, y: hei - Y >= miniAreaHei ? tempRect.origin.y + Y : tempRect.origin.y + hei - miniAreaHei, width: wid, height: hei - Y >= miniAreaHei ? hei - Y : miniAreaHei)
        case .right:
            rect = CGRect(x: tempRect.origin.x, y: tempRect.origin.y, width: wid + X >= miniAreaWid ? wid + X : miniAreaWid, height: hei)
        case .rightBottom:
            rect = CGRect(x: tempRect.origin.x, y: tempRect.origin.y, width: wid + X >= miniAreaWid ? wid + X : miniAreaWid, height: hei + Y >= miniAreaHei ? hei + Y : miniAreaHei)
        case .bottom:
            rect = CGRect(x: tempRect.origin.x, y: tempRect.origin.y, width: wid, height: hei + Y >= miniAreaHei ? hei + Y : miniAreaHei)
        default:
            rect = CGRect(x: tempRect.origin.x + X, y: tempRect.origin.y + Y, width: wid, height: hei)
        }
        borderRect = rect
        resetViews()
    }
}
