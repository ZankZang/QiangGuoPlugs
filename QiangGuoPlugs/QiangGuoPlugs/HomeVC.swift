//
//  HomeVC.swift
//  QiangGuoPlugs
//
//  Created by 张贺 on 2021/2/25.
//

import UIKit
import Photos

class HomeVC: BaseVC, UITextFieldDelegate {
    
    var dataAry:[QuestionM] = QuestionM.queryAll()
    
    var unfindDataAry:[QuestionM] = []
    
    @IBOutlet weak var modelBtn: UIButton!
    
    //取得的资源结果，用来存放的PHAsset
    var  assetsFetchResults: PHFetchResult <PHAsset>!
     
    //带缓存的图片管理对象
    var  imageManager: PHCachingImageManager!
     
    //用于显示缩略图
    var  imageView: UIImageView!
     
    //缩略图大小
    var  assetGridThumbnailSize: CGSize!
    
    
    var tempImgStr: String = ""
    var tempQ: String = ""
    
    @IBOutlet weak var answerV: UIView!
    @IBOutlet weak var answerTextV: UITextView!
    
    @IBOutlet weak var backgroundV: UIView!
    
    var model: ModelM?
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        resetViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func setViews() {
        baseTV.frame = backgroundV.bounds
        baseTV.register(UINib.init(nibName: "AnswerTableCell", bundle: nil), forCellReuseIdentifier: "AnswerTableCell")
        backgroundV.addSubview(baseTV)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyBoardWillShow(notification: Notification) {
        let userInfo = notification.userInfo! as Dictionary
        let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyBoardRect = value.cgRectValue
        let keyBoardHeight = keyBoardRect.size.height
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        UIView.animate(withDuration: TimeInterval(floatLiteral: duration.doubleValue)) {
            self.baseTV.frame = CGRect(x: 0, y: 0, width: self.backgroundV.bounds.size.width, height: self.backgroundV.bounds.height - keyBoardHeight)
        };
    }
    
    @objc func keyBoardWillHide(notification: Notification) {
        let userInfo = notification.userInfo! as Dictionary
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        UIView.animate(withDuration: TimeInterval(floatLiteral: duration.doubleValue)) {
            self.baseTV.frame = self.backgroundV.bounds
        };
    }
    
    override func resetViews() {
        modelBtn.setTitle(ModelM.queryAll().count != 2 ? "创建模式" : UserDefaults.standard.string(forKey: "modelT"), for: .normal)
    }
    
    override func setData() {
        if dataAry.count == 0 {
            let path = Bundle.main.path(forResource: "question 2", ofType: "json")
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path!))
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let tempAry = OCQuestionM.mj_objectArray(withKeyValuesArray: json)! as NSArray as! [OCQuestionM]
                
                for tempM in tempAry {
                    let tempQ = QuestionM()
                    tempQ.originalQuestion = tempM.originalQuestion
                    tempQ.checkQuestion = tempM.checkQuestion
                    tempQ.answer = tempM.answer
                    tempQ.firstImgStr = tempM.firstImgStr
                    tempQ.secondImgStr = tempM.secondImgStr
                    tempQ.thirdImgStr = tempM.thirdImgStr
                    tempQ.itemId = tempM.itemId
                    QuestionM.insert(questionM: tempQ)
                }
                dataAry = QuestionM.queryAll()
            } catch {
            }
        }
//        let path = Bundle.main.path(forResource: "question", ofType: "json")
//        do {
//            let data = try Data(contentsOf: URL(fileURLWithPath: path!))
//            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//            let tempAry: [OCQuestionM] = OCQuestionM.mj_objectArray(withKeyValuesArray: json)! as NSArray as! [OCQuestionM]
//            var ary: [Any] = []
//            let pattern = "[^\\u4E00-\\u9FA5]"
//            var index = 1
//            for tempM in tempAry {
//                ary.insert(["itemId": String(format: "%d", index), "originalQuestion": tempM.question, "checkQuestion": tempM.question.pregReplace(pattern: pattern, with: ""), "answer": tempM.answer, "firstImgStr": "", "secondImgStr": "", "thirdImgStr": ""], at: ary.count)
//                index = index + 1
//            }
//            let filePath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!.appending("/question.json")
//            try! (ary as NSArray).mj_JSONString()?.description.write(toFile: filePath, atomically: true, encoding: .utf8)
////
//        } catch {
//        }
        baseTV.reloadData()
        
        self.imageManager =  PHCachingImageManager()
        let scale = UIScreen.main.scale
        assetGridThumbnailSize = CGSize(width: self.view.frame.size.width * scale, height: self.view.frame.size.height * scale)
        PHPhotoLibrary.requestAuthorization({ (status)  in
            if  status != .authorized {
                return
            }
            let  allPhotosOptions =  PHFetchOptions ()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending:false)]
            allPhotosOptions.predicate =  NSPredicate (format:  "mediaType = %d", PHAssetMediaType.image.rawValue)
            self.assetsFetchResults =  PHAsset.fetchAssets(with:.image, options:allPhotosOptions)
//            PHPhotoLibrary.shared().register(self)
        })
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let inputText = textField.text ?? ""
        let updatedStr: String = (inputText as NSString).replacingCharacters(in: range, with: string)
        let pattern = "[^\\u4E00-\\u9FA5]"
        let str = updatedStr.pregReplace(pattern: pattern, with: "")
        print(str)
        dataAry = QuestionM.query(question: str)
        baseTV.reloadData()
        return true
    }
    
    @IBAction func selectAreaAct(_ sender: Any) {
        let vc: ModelsVC = ModelsVC.init(nibName: "ModelsVC", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addAct(_ sender: Any) {
//        answerV.alpha = 1;
//        var questions: String = ""
//        for tempM in unfindDataAry {
//            questions.append(String(format: "%@/", tempM.question))
//        }
//        if questions.count > 0 {
//            questions = String(questions.prefix(questions.count - 1))
//        }
//        answerTextV.text = questions
    }
    
    @IBAction func cancelAct(_ sender: Any) {
        answerTextV.resignFirstResponder()
        answerV.alpha = 0;
    }
    
    @IBAction func saveAct(_ sender: Any) {
//        let content: String = answerTextV.text
//        if content.count > 0 {
//            let tempAry: [Substring] = content.split(separator: "/")
//            if tempAry.count > 0 {
//                var index = dataAry.count + 1
//                for tempStr in tempAry {
//                    let qAry: [Substring] = String(tempStr).split(separator: "&")
//                    if qAry.count == 2 {
//                        let tempQ: QuestionM = QuestionM()
//                        tempQ.question = String(qAry[0])
//                        tempQ.answer = String(qAry[1])
//                        QuestionM.insert(questionM: tempQ)
//                        index = index + 1
//                    }
//                }
//                unfindDataAry.removeAll()
//                answerTextV.text = ""
//                answerV.alpha = 0
//                QuestionM.setInd()
//                dataAry = QuestionM.queryAll()
//            }
//        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAry.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AnswerTableCell = tableView.dequeueReusableCell(withIdentifier: "AnswerTableCell", for: indexPath) as! AnswerTableCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.questionLab.text = dataAry[indexPath.row].originalQuestion
        cell.answerLab.text = dataAry[indexPath.row].answer
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = QuestionVC.init(nibName: "QuestionVC", bundle: nil)
        vc.model = dataAry[indexPath.row]
        vc.backBlock = { (sender) -> Void in
            self.baseTV.reloadData()
        }
        present(vc, animated: true, completion: nil)
    }
    
    func getGrayImage(sourceImage: UIImage) -> UIImage {
        let imageRef: CGImage = sourceImage.cgImage!
        let width: Int = imageRef.width
        let height: Int = imageRef.height

        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let context: CGContext = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        let rect: CGRect = CGRect.init(x: 0, y: 0, width: width, height: height)
        context.draw(imageRef, in: rect)

        let outPutImage: CGImage = context.makeImage()!

        let newImage: UIImage = UIImage.init(cgImage: outPutImage)

        return newImage
    }
    
    func pHashValueWithImage(image: UIImage) -> NSString {
        let pHashString = NSMutableString()
        let imageRef = image.cgImage!
        let width = imageRef.width
        let height = imageRef.height
        let pixelData = imageRef.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        var sum: Int = 0
        for i in 0..<width * height {
            if data[i] != 0 {
                sum = sum + Int(data[i])
            }
        }
        let avr = sum / (width * height)
        for i in 0..<width * height {
            if Int(data[i]) >= avr {
                pHashString.append("1")
            } else {
                pHashString.append("0")
            }
        }
        return pHashString
    }
    
    func getDifferentValueCountWithString(str1: NSString, str2: NSString) -> NSInteger {
        var diff: NSInteger = 0
        let s1 = str1.utf8String!
        let s2 = str2.utf8String!
        for i in 0..<str1.length {
            if s1[i] != s2[i] {
                diff += 1
            }
        }
        return diff
    }
    
    func isEqualImage(imageOne: UIImage, imageTwo: UIImage) -> Bool {
        var equalResult = false
        let mImageOne = self.getGrayImage(sourceImage: imageOne)
        let mImageTwo = self.getGrayImage(sourceImage: imageTwo)
        let diff = self.getDifferentValueCountWithString(str1: self.pHashValueWithImage(image: mImageOne), str2: self.pHashValueWithImage(image: mImageTwo))
        print(diff)
        if diff > 10 {
            equalResult = false
        } else {
            equalResult = true
        }
        return equalResult
    }
    
    func tipResult(questions: [QuestionM]) {
        print(questions)
        var temtQ = ""
        var temtA = ""
        for tempM in questions {
            temtQ.append(tempM.originalQuestion.appending(";\n"))
            temtA.append(tempM.answer.appending(";\n"))
        }
        if temtQ.count > 0 {
            temtQ = String(temtQ.prefix(temtQ.count - 1))
        }
        if temtA.count > 1 {
            temtA = String(temtA.prefix(temtA.count - 1))
            let content = UNMutableNotificationContent()
            content.title = temtQ
            content.body = temtA
            content.sound = UNNotificationSound.init(named: UNNotificationSoundName.init(rawValue: "none"))
            UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: String(format: "%d", Date().timeIntervalSince1970), content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 0.0001, repeats: false)), withCompletionHandler: nil)
        }
    }
    
    func scaleImg(img: UIImage, scale: Float) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: img.size.width * CGFloat(scale), height: img.size.height * CGFloat(scale)))
        img.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: img.size.width * CGFloat(scale), height: img.size.height * CGFloat(scale))))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}

//PHPhotoLibraryChangeObserver代理实现，图片新增、删除、修改开始后会触发
extension  HomeVC : PHPhotoLibraryChangeObserver {
    //当照片库发生变化的时候会触发
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        //获取assetsFetchResults的所有变化情况，以及assetsFetchResults的成员变化前后的数据
        guard let collectionChanges = changeInstance.changeDetails(for: self .assetsFetchResults as! PHFetchResult < PHObject >)  else  {  return  }
        DispatchQueue .main.async {
            let modelAry: [ModelM] = ModelM.queryAll()
            if modelAry.count != 2 {
                return
            } else {
                if self.model == nil {
                    self.model = ModelM()
                }
                if self.model?.name != UserDefaults.standard.string(forKey: "modelT") {
                    for tempM in modelAry {
                        if tempM.name == UserDefaults.standard.string(forKey: "modelT") {
                            self.model = tempM
                            break
                        }
                    }
                }
            }
            //获取最新的完整数据
            if let allResult = collectionChanges.fetchResultAfterChanges as? PHFetchResult<PHAsset> {
                self.assetsFetchResults = allResult
            }

            if !collectionChanges.hasIncrementalChanges || collectionChanges.hasMoves {
                return
            } else {
                //照片新增情况
                if let insertedIndexes = collectionChanges.insertedIndexes,
                    insertedIndexes.count > 0 {
                    print ( "新增了\(insertedIndexes.count)张照片" )
                    //获取最后添加的图片资源
                    let asset = self.assetsFetchResults[insertedIndexes.first!]
                    //获取缩略图
                    self.imageManager.requestImage(for: asset, targetSize: self.assetGridThumbnailSize, contentMode:.aspectFit, options:nil) { (image, nfo) in
                        let scale = UIScreen.main.scale
                        if (image?.size.width)! > 200 {
                            let img: UIImage = UIImage.init(cgImage: (image?.cgImage?.cropping(to: CGRect(x:CGFloat(Float(self.model!.x)!) * scale, y: CGFloat(Float(self.model!.y)!) * scale, width: CGFloat(Float(self.model!.wid)!) * scale, height: CGFloat(Float(self.model!.hei)!) * scale)))!)
//                            self.imageView.image = img
                            let imgStr = self.pHashValueWithImage(image: self.getGrayImage(sourceImage: self.scaleImg(img: img, scale: 0.2))) as String
                            let tempAry: [QuestionM] = QuestionM.query(imgStr: imgStr, name: (self.model?.name)!)
                            if tempAry.count > 0 {
                                self.tipResult(questions: tempAry)
                            } else {
                                AipOcrService.shard()?.detectText(from: img, withOptions: ["language_type":"CHN_ENG", "detect_direction":"true"], successHandler: { (success) in
                                    let searchResultM: OCSearchResultM = OCSearchResultM.mj_object(withKeyValues: success!)!
                                    if searchResultM.words_result.count > 0 {
                                        var tempQ = ""
                                        for tempSubM in searchResultM.words_result {
                                            tempQ.append((tempSubM as! OCSearchResultWordsM).words)
                                        }
                                        let pattern = "[^\\u4E00-\\u9FA5]"
                                        var str = tempQ.pregReplace(pattern: pattern, with: "")
                                        if str.contains("选择正确的读音") {
                                            str = "选择正确的读音"
                                        }
                                        if str.contains("选择词语的正确词形") {
                                            str = "选择词语的正确词形"
                                        }
                                        let tempAry = QuestionM.query(question: str)
                                        if tempAry.count != 0 {
                                            self.tipResult(questions: tempAry)
                                            if tempAry.count == 1 {
                                                let corrM = tempAry[0]
                                                if self.model?.name == "挑战答题" {
                                                    corrM.firstImgStr = imgStr
                                                } else {
                                                    corrM.secondImgStr = imgStr
                                                }
                                                QuestionM.update(questionM: corrM)
                                            }
                                        } else {
                                            let unfindM = QuestionM()
                                            unfindM.originalQuestion = str
                                            self.unfindDataAry.insert(unfindM, at: self.unfindDataAry.count)
                                        }
                                    }
                                }, failHandler: { (error) in
                                })
                            }
                        }
                    }
                }
            }
        }
     }
}

extension String {
    func pregReplace(pattern: String, with: String,
                     options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.count),
                                              withTemplate: with)
    }
}
