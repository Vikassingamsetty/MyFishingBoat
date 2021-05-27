//
//  ProductDetailsViewController.swift
//  MyFishingBoat
//
//  Created by Appcare on 26/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit
import CoreData
import iOSDropDown

class ProductDetailsViewController: BaseViewController,UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var ReviewTextVw: UITextView!
    @IBOutlet weak var checkOutBtnOutlet: UIButton!
    @IBOutlet weak var decrementBtn: UIButton!
    @IBOutlet weak var incrementBtn: UIButton!
    @IBOutlet weak var valueBtn: UIButton!
    @IBOutlet weak var addBtnOutlet: CustomButton!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var segmentLabel4: UITextView!
    
    @IBOutlet weak var SubmitRatingView: UIView!
    @IBOutlet weak var ListOfCuttingsTF: DropDown!
    @IBOutlet weak var priceDescpLbl: UILabel!
    
    //Static value
    var cid = String()
    var pid = String()
    
    var Count = Int()
    
    var ProductId : String?
    var FromVc : String!
    var ratingValue:String = "\(0.0)"
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var outOfStockLbl: UILabel!
    
    @IBOutlet weak var SingleProductNamelbl: UILabel!
    @IBOutlet weak var SingleproductPricelbl: UILabel!
    @IBOutlet weak var ProductImageVw: UIImageView!
    @IBOutlet weak var shortDescriptionLbl: UILabel!
    @IBOutlet weak var quantityDescriptionLbl: UILabel!
    @IBOutlet weak var Gramslbl: UILabel!
    @IBOutlet weak var segmentLblHeight: NSLayoutConstraint!
    @IBOutlet weak var ratingViewHeight: NSLayoutConstraint!
    
    //submit recipe
    var placeHolderText = "  your recipe here..."
    
    var value = [0, 1, 2]
    var optionArray1 = [String]()
    
    var nameTF: String?
    
    //Models
    var singleProductModel:SingleProductModel?
    var submitRecipieModel:SubmitRecipieModel?
    var addToCartBtnModel:AddToCartBtnModel?
    var cuttingPreferencesModel: CuttingPreferencesModel?
    
    //min and max quantity change
    var quantity = Int()
    var price = String()
    
    //Coredata Array
    var indexList:[NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addBtnOutlet.isHidden = false
        
        let imageTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapImageView(gesture:)))
        ProductImageVw.isUserInteractionEnabled = true
        ProductImageVw.addGestureRecognizer(imageTap)
        ProductImageVw.contentMode = .scaleToFill
        
        //font for segment controller
        guard let font = UIFont.init(name: "FedraSansStd-Normal", size: 13) else {return}
        segmentController.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        segmentController.selectedSegmentIndex = 0
        
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
        
        self.SubmitRatingView.isHidden = true
        
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentController.setTitleTextAttributes(titleTextAttributes1, for:.selected)
        
        ReviewTextVw.delegate = self
        ReviewTextVw.layer.cornerRadius = 15.0
        ReviewTextVw.layer.borderWidth = 1.0
        ReviewTextVw.layer.borderColor = appColor.appGary?.cgColor
        ListOfCuttingsTF.layer.cornerRadius = 15.0
        ListOfCuttingsTF.layer.borderWidth = 1.0
        ListOfCuttingsTF.layer.borderColor = appColor.appGary?.cgColor
        ListOfCuttingsTF.selectedRowColor = #colorLiteral(red: 0.4274509804, green: 0.4352941176, blue: 0.4470588235, alpha: 0.5)
        
        //Segment controller
        segmentController.backgroundColor = .white
        fontstyle(segment: segmentController, state: .normal, fontName: "MyriadPro-Regular", fontSize: 12, foregroundColor: UIColor.colorFromHex("#717376"))
        fontstyle(segment: segmentController, state: .selected, fontName: "MyriadPro-Semibold", fontSize: 12, foregroundColor: UIColor.colorFromHex("#545557"))
        segmentController.addUnderlineForSelectedSegment()
        
    }
    
    @IBAction func onTapAddBtn(_ sender: Any) {
        addBtnOutlet.isHidden = true
        quantity = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Reachability.isConnectedToNetwork() {
            cuttingPref()
            if UserDefaults.standard.string(forKey: "userid") != nil {
                self.singleProductDetails(cat_id: self.cid, pro_id: self.pid, uid: UserDefaults.standard.string(forKey: "userid")!)
            }else{
                //product Details
                self.singleProductDetails(cat_id: self.cid, pro_id: self.pid, uid: "")
                //DB fetch
                self.fetchRequestProductResult(prdtId: self.pid, cateId: self.cid)
            }
            
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if ReviewTextVw.text != nil || ReviewTextVw.text != placeHolderText {
            ReviewTextVw.text = placeHolderText
        }
    }
    
    
    @objc func tapImageView(gesture: UITapGestureRecognizer){
        print("image tapped")
        imageExpand()
    }
    
    func imageExpand(){
        let photoItem = self.ProductImageVw.image
        let newImageView = UIImageView(image: photoItem)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        sender.view?.removeFromSuperview() // This will remove image from full screen
    }
    
    @IBAction func SubmitRatingsAction(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            if UserDefaults.standard.string(forKey: "userid") != nil {
                if ReviewTextVw.text.isEmpty || ReviewTextVw.text == placeHolderText {
                    showAlertMessage(vc: self, titleStr: "", messageStr: "Enter recipe")
                }else{
                    addRecipie(uid: UserDefaults.standard.string(forKey: "userid")!, cat_id: singleProductModel!.data?[0].catID ?? "", pro_id: singleProductModel!.data?[0].id ?? "", description: ReviewTextVw.text)
                }
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: "Login/signup to proceed")
            }
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        segmentController.changeUnderlinePosition()
        
        if segmentController.selectedSegmentIndex == 3 {
            
            self.SubmitRatingView.isHidden = false
            
            if UserDefaults.standard.string(forKey: "userid") != nil {
                segmentLabel4.isHidden = true
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: "Login/Signup to submit recipe")
            }
            
        }else  if segmentController.selectedSegmentIndex == 2{
            segmentLabel4.text = singleProductModel?.data?[0].recipes ?? ""
            segmentLabel4.isHidden = false
            self.SubmitRatingView.isHidden = true
            
        }else  if segmentController.selectedSegmentIndex == 1{
            segmentLabel4.text = singleProductModel?.data?[0].healthBenefits ?? ""
            segmentLabel4.isHidden = false
            self.SubmitRatingView.isHidden = true
            
        }else if segmentController.selectedSegmentIndex == 0{
            segmentLabel4.text = singleProductModel?.data?[0].facts ?? ""
            segmentLabel4.isHidden = false
            self.SubmitRatingView.isHidden = true
        }
    }
    
    @IBAction func DecreamentAction(_ sender: Any) {
        
        if quantity > 1 {
            quantity -= 1
            valueBtn.setTitle("\(quantity) kg", for: .normal)
            price = "\(quantity * Int(SingleproductPricelbl.text!)!)"
            print(quantity, price)
            
            if UserDefaults.standard.string(forKey: "userid") != nil {
                if ListOfCuttingsTF.text == "" {
                    self.valueBtn.setTitle("\(quantity)", for: .normal)
                }else{
                    addToCart(cuttingid: self.singleProductModel!.data?[0].cuttingPreferencesID ?? "", pid: pid, price: price, quantity: "\(quantity)")
                }
            }else{
                //update quantity to DB
                //updateDB(prdtId: pid, cateId: cid, qty: "\(quantity)")
                if ListOfCuttingsTF.text == "" {
                    showAlertMessage(vc: self, titleStr: "", messageStr: "Select cutting type")
                }
//                    else{
//                    if indexList.count > 0 {
//                        updateDB(prdtId: pid, cateId: cid, qty: "\(quantity)")
//                    }else{
//                        //MARK:- Done
//                        for value in 0..<(self.cuttingPreferencesModel?.data?[0].cuttingPreferencesData!.count)! {
//                            save(pname: singleProductModel!.data?[0].productName ?? "", prdtId: pid, cids: cid, qty: "\(quantity)", image: singleProductModel!.data?[0].productPhotos ?? "", prefe: self.cuttingPreferencesModel?.data?[0].cuttingPreferencesData?[value].cuttingPreferencesID ?? "0", prefName: self.cuttingPreferencesModel?.data?[0].cuttingPreferencesData?[value].type ?? "0", price: price)
//                        }
//                    }
//                }
            }
        } else if quantity == 1 {
            
            if UserDefaults.standard.string(forKey: "userid") != nil {
                if ListOfCuttingsTF.text == "" {
                    self.quantity = 0
                    self.addBtnOutlet.isHidden = false
                }else{
                    ListOfCuttingsTF.text = ""
                    removeItemFromCart(uid: UserDefaults.standard.string(forKey: "userid")!, pid: pid)
                }
            }else{
                //remove item from DB
                self.addBtnOutlet.isHidden = false

                if indexList.count > 0 {
                    deleteItem(prdtId: pid)
                }
            }
        }
    }
    
    @IBAction func IncrementActiion(_ sender: Any) {
        if quantity > 0 {
            quantity += 1
            self.valueBtn.setTitle("\(quantity)", for: .normal)
            price = "\(quantity * Int(SingleproductPricelbl.text!)!)"
            print(quantity, price)
            
            if UserDefaults.standard.string(forKey: "userid") != nil {
                if ListOfCuttingsTF.text == "" {
                    self.valueBtn.setTitle("\(quantity)", for: .normal)
                }else{
                    addToCartIncDec(cuttingid: self.singleProductModel!.data?[0].cuttingPreferencesID ?? "", pid: pid, price: price, quantity: "\(quantity)")
                }
            }else{
                //updateDB(prdtId: pid, cateId: cid, qty: "\(quantity)")
                if ListOfCuttingsTF.text == "" {
                    self.valueBtn.setTitle("\(quantity)", for: .normal)
//                }else{
//                    if indexList.count > 0 {
//                        updateDB(prdtId: pid, cateId: cid, qty: "\(quantity)")
//                    }else{
//                        //MARK:- Done
//                        for value in 0..<(self.cuttingPreferencesModel?.data?[0].cuttingPreferencesData!.count)! {
//                            save(pname: singleProductModel!.data?[0].productName ?? "", prdtId: pid, cids: cid, qty: "\(quantity)", image: singleProductModel!.data?[0].productPhotos ?? "", prefe: self.cuttingPreferencesModel?.data?[0].cuttingPreferencesData?[value].cuttingPreferencesID ?? "0", prefName: self.cuttingPreferencesModel?.data?[0].cuttingPreferencesData?[value].type ?? "0", price: price)
//                        }
//                    }
                }
            }
        }
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func checkoutBtnTapped(_ sender: Any) {
        UserDefaults.standard.setValue("No", forKey: "FromTab")
        
        print(quantity, price, ListOfCuttingsTF.text!)
        
        if (quantity == 0 && ListOfCuttingsTF.text!.isEmpty) {
            showAlertMessage(vc: self, titleStr: "", messageStr: "Cutting type or quantity is empty")
        }else{
            if Reachability.isConnectedToNetwork() {
                if quantity == 0 {
                    showAlertMessage(vc: self, titleStr: "", messageStr: "Quantity is empty")
                }else{
                    if ListOfCuttingsTF.text!.isEmpty {
                        showAlertMessage(vc: self, titleStr: "", messageStr: "Select cutting type")
                    }else{
                        if UserDefaults.standard.string(forKey: "userid") != nil {
                            print(ListOfCuttingsTF.text!)
                            
                            //MARK:- Done
                            for value in 0..<(self.cuttingPreferencesModel?.data?[0].cuttingPreferencesData!.count)! {
                                if self.ListOfCuttingsTF.text == self.cuttingPreferencesModel?.data?[0].cuttingPreferencesData?[value].type {
                                    addToCart(cuttingid: self.cuttingPreferencesModel?.data?[0].cuttingPreferencesData?[value].cuttingPreferencesID ?? "0", pid: pid, price: price, quantity: "\(quantity)")
                                }
                            }
                            
                        }else{
                            
                            //MARK:- Done
                            //fetch one record with product id and category if
                            for value in 0..<(self.cuttingPreferencesModel?.data?[0].cuttingPreferencesData!.count)! {
                                if self.ListOfCuttingsTF.text == self.cuttingPreferencesModel?.data?[0].cuttingPreferencesData?[value].type {
                                    if indexList.count > 0 {
                                        updsteDB(prdtId: pid, cateId: cid, qty: "\(quantity)", priceQty: price, preference: self.cuttingPreferencesModel?.data?[0].cuttingPreferencesData?[value].cuttingPreferencesID ?? "0", prefName: self.cuttingPreferencesModel?.data?[0].cuttingPreferencesData?[value].type ?? "0")
                                    }else{
                                        save(pname: singleProductModel!.data?[0].productName ?? "", prdtId: pid, cids: cid, qty: "\(quantity)", image: singleProductModel!.data?[0].productPhotos ?? "", prefe: self.cuttingPreferencesModel?.data?[0].cuttingPreferencesData?[value].cuttingPreferencesID ?? "0", prefName: self.cuttingPreferencesModel?.data?[0].cuttingPreferencesData?[value].type ?? "0", price: price)
                                    }
                                }
                            }
                        }
                    }
                }
            }else {
                showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
            }
        }
        
    }
    
    //MARK:- CoreData
    //FetchRequest if product is there with pid and cid and adding it to indexlist
    func fetchRequestProductResult(prdtId :String,cateId :String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
        if !prdtId.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "productId = %@ && categoryId = %@", prdtId ,cateId )
        }
        do {
            indexList = try managedContext.fetch(fetchRequest)
            print(indexList, "list")
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    //UpdatedDB
    func updsteDB(prdtId :String,cateId :String,qty:String, priceQty:String, preference:String, prefName: String)  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        
        fetchRequest.predicate = NSPredicate(format: "productId = %@ && categoryId = %@", prdtId ,cateId )
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                results![0].setValue(qty, forKeyPath: "qty")
                results![0].setValue(priceQty, forKeyPath: "price")
                results![0].setValue(preference, forKey: "preferences")
                results![0].setValue(prefName, forKey: "preferenceName")
                //move to cart list
                
                self.dismiss(animated: false, completion: nil)
                
                //                let vc = storyboard?.instantiateViewController(identifier: "CartViewController") as! CartViewController
                //                vc.modalPresentationStyle = .fullScreen
                //                present(vc, animated: false, completion: nil)
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
            print("Saving Core Data Failed: \(error)")
        }
    }
    
    //update DB for only quantity
    func updateDB(prdtId :String,cateId :String,qty:String)  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        
        fetchRequest.predicate = NSPredicate(format: "productId = %@ && categoryId = %@", prdtId ,cateId )
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                results![0].setValue(qty, forKeyPath: "qty")
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
            print("Saving Core Data Failed: \(error)")
        }
    }
    
    //Save entire product
    func save(pname: String,prdtId:String,cids:String,qty:String,image:String,prefe:String, prefName:String,price:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Product", in: managedContext)!
        let userName = NSManagedObject(entity: entity, insertInto: managedContext)
        userName.setValue(pname, forKeyPath: "prdtname")
        userName.setValue(prdtId, forKeyPath: "productId")
        userName.setValue(cids, forKeyPath: "categoryId")
        userName.setValue(qty, forKeyPath: "qty")
        userName.setValue(image, forKeyPath: "image")
        userName.setValue(prefe, forKeyPath: "preferences")
        userName.setValue(prefName, forKeyPath: "preferenceName")
        userName.setValue(price, forKeyPath: "price")
        var userArray: [NSManagedObject] = []
        
        do {
            try managedContext.save()
            
            self.dismiss(animated: false, completion: nil)
            
            //            let vc = storyboard?.instantiateViewController(identifier: "CartViewController") as! CartViewController
            //            vc.modalPresentationStyle = .fullScreen
            //            present(vc, animated: false, completion: nil)
            
            userArray.append(userName)
            print(userArray)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //coredata delete item
    func deleteItem(prdtId: String)  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        if !prdtId.isEmpty {
            request.predicate = NSPredicate(format: "productId = %@", prdtId)
        }
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                context.delete(data)
                print("DELETED COREDATA DATA------->>>\(data)")
                // print(fetchRequestResult(itemId: ""))
                fetchRequestProductResult(prdtId: pid, cateId: cid)
                try context.save()
                self.addBtnOutlet.isHidden = false
            }
        } catch {
            print(" deleteItem Failed")
        }
    }
    
    
    //MARK:- API's
    //Cutting preferences
    func cuttingPref() {
        
        let params = [
            "pid": self.pid,
            "cid": self.cid
        ]
        
        print("vikas", params)
        
        RestService.serviceCall(url: cuttingPreference_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(CuttingPreferencesModel.self, from: response) else{return}
            
            if responseJson.status == 200 {
                self.cuttingPreferencesModel = responseJson
                
               let value = responseJson.data?[0].cuttingPreferencesData?.count ?? 0
                for i in 0..<value {
                    self.optionArray1.append(responseJson.data?[0].cuttingPreferencesData?[i].type ?? "")
                }
                
                
                //drop down
                self.ListOfCuttingsTF.delegate = self
                self.ListOfCuttingsTF.optionArray = self.optionArray1
                self.ListOfCuttingsTF.listDidDisappear {
                    print(self.ListOfCuttingsTF.text!)
                    self.nameTF = self.ListOfCuttingsTF.text
                    self.ListOfCuttingsTF.layer.borderColor = appColor.appGary?.cgColor
                }
                
                print(self.optionArray1, "Cutting type")
                
                if UserDefaults.standard.string(forKey: "userid") != nil {
                    self.singleProductDetails(cat_id: self.cid, pro_id: self.pid, uid: UserDefaults.standard.string(forKey: "userid")!)
                }else{
                    //product Details
                    self.singleProductDetails(cat_id: self.cid, pro_id: self.pid, uid: "")
                    //DB fetch
                    self.fetchRequestProductResult(prdtId: self.pid, cateId: self.cid)
                    
                    if self.indexList.count > 0 {
                        self.addBtnOutlet.isHidden = true
                        self.quantity = (self.indexList[0].value(forKey: "qty") as! NSString).integerValue
                        self.valueBtn.setTitle("\(String(describing: self.indexList[0].value(forKey: "qty")!)) kg", for: .normal)
                        print(self.optionArray1,"array print")
                        for val in 0..<self.optionArray1.count {
                            
                            //MARK:- Done
                            if self.indexList[0].value(forKey: "preferences") as? String == self.cuttingPreferencesModel?.data?[0].cuttingPreferencesData?[val].cuttingPreferencesID ?? "" {
                                print("vikas", self.optionArray1[val])
                                self.ListOfCuttingsTF.text = self.optionArray1[val]
                                self.view.bringSubviewToFront(self.ListOfCuttingsTF)
                            }
                        }
                    }else{
                        self.addBtnOutlet.isHidden = false
                    }
                }
               
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
    }
    
    //single product details
    func singleProductDetails(cat_id:String, pro_id:String, uid:String) {
        
        let params = [
            "cid": cat_id,
            "id": pro_id,
            "uid": uid
        ]
        
        RestService.serviceCall(url: singleProductDetails_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(SingleProductModel.self, from: response) else {return}
            
            if responseJson.status == 200 {
                self.singleProductModel = responseJson
                
                self.fetchRequestProductResult(prdtId: responseJson.data?[0].id ?? "0", cateId: responseJson.data?[0].catID ?? "0")
                
                //UI details
                self.ProductImageVw.sd_setImage(with: URL(string: (self.singleProductModel!.data?[0].imageIos?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!),
                                                placeholderImage: UIImage(named: ""))
                self.SingleProductNamelbl.text = self.singleProductModel?.data?[0].productName ?? ""
                self.shortDescriptionLbl.text = self.singleProductModel?.data?[0].productDiscription ?? ""
                self.quantityDescriptionLbl.text = self.singleProductModel?.data?[0].quantityDescription ?? ""
                self.SingleproductPricelbl.text = self.singleProductModel?.data?[0].productPrice ?? ""
                self.segmentLabel4.text = self.singleProductModel?.data?[0].facts ?? ""
                self.priceDescpLbl.text = self.singleProductModel?.data?[0].priceDescription ?? ""
                self.Gramslbl.text = self.singleProductModel?.data?[0].productWeight ?? ""
                
                if UserDefaults.standard.string(forKey: "userid") != nil {
                    self.ListOfCuttingsTF.text = self.singleProductModel?.data?[0].type ?? ""
                }
                
                if self.singleProductModel?.data?[0].cart ?? "" == "Yes" {
                    self.addBtnOutlet.isHidden = true
                    self.quantity = Int(self.singleProductModel?.data?[0].quantity ?? "0")!
                    self.valueBtn.setTitle("\(self.singleProductModel?.data?[0].quantity ?? "") kg", for: .normal)
                }
                
                if self.singleProductModel?.data?[0].stockStatus ?? "" == "0" {
                    self.outOfStockLbl.isHidden = false
                    self.checkOutBtnOutlet.isUserInteractionEnabled = false
                }else{
                    self.outOfStockLbl.isHidden = true
                    self.checkOutBtnOutlet.isUserInteractionEnabled = true
                }
                
                self.price = self.singleProductModel?.data?[0].productPrice ?? ""
                
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    func addToCartIncDec(cuttingid:String, pid:String, price:String, quantity:String) {
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        let params = [
            "uid": uid,
            "pid": pid,
            "cid": cuttingid,
            "price": price,
            "quantity": quantity
        ]
        
        print(params)
        
        RestService.serviceCall(url: addToCartSingle_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(AddToCartBtnModel.self, from: response) else {return}
            self.addToCartBtnModel = responseJson
            
            if responseJson.status == 200 {
                //inc dec quantity
                
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.addToCartBtnModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //adding whole qunatity
    func addToCart(cuttingid:String, pid:String, price:String, quantity:String) {
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        let params = [
            "uid": uid,
            "pid": pid,
            "cid": cuttingid,
            "price": price,
            "quantity": quantity
        ]
        
        print(params)
        
        RestService.serviceCall(url: addToCartSingle_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(AddToCartBtnModel.self, from: response) else {return}
            self.addToCartBtnModel = responseJson
            
            if responseJson.status == 200 {
                self.dismiss(animated: false, completion: nil)
                //                let vc = self.storyboard?.instantiateViewController(identifier: "CartViewController") as! CartViewController
                //                vc.modalPresentationStyle = .fullScreen
                //                self.present(vc, animated: false, completion: nil)
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.addToCartBtnModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //submit recepie
    func addRecipie(uid:String, cat_id:String, pro_id:String, description:String) {
        let params = [
            "uid": uid,
            "cid": cat_id,
            "pid": pro_id,
            "discription": description
        ]
        
        RestService.serviceCall(url: addRecipie_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            guard let responseJson = try? JSONDecoder().decode(SubmitRecipieModel.self, from: response) else{return}
            self.submitRecipieModel = responseJson
            if responseJson.status == true {
                showAlertMessage(vc: self, titleStr: "", messageStr: self.submitRecipieModel!.message)
                DispatchQueue.main.asyncAfter(deadline: .now()+2.1) {
                    self.ReviewTextVw.text = self.placeHolderText
                    self.segmentController.selectedSegmentIndex = 0
                    self.segmentController.changeUnderlinePosition()
                    self.segmentLabel4.text = self.singleProductModel?.data?[0].facts ?? ""
                    self.segmentLabel4.isHidden = false
                    self.SubmitRatingView.isHidden = true
                    self.ReviewTextVw.resignFirstResponder()
                }
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.submitRecipieModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "", messageStr: error.localizedDescription)
        }
        
    }
    
    //Delete item from cart
    func removeItemFromCart(uid:String, pid:String) {
        let params = [
            "uid": uid,
            "pid":pid
        ]
        
        RestService.serviceCall(url: deleteCart_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else {return}
            
            do{
                let responseJson = try JSONDecoder().decode(RemoveCartModel.self, from: response)
                //self.removeCartModel = responseJson
                if responseJson.status == 200 {
                    self.addBtnOutlet.isHidden = false
                    self.quantity = 0
                }else{
                    showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
                }
            }catch{
                showAlertMessage(vc: self, titleStr: "", messageStr: error.localizedDescription)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
}


extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}
extension ProductDetailsViewController: FloatRatingViewDelegate {
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        
        //        ratingValue = String(format: "%.1f", self.ratinglbl.rating)
        //        print(value, "values feedback")
    }
    
}

extension ProductDetailsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if ReviewTextVw.text == placeHolderText {
            ReviewTextVw.text = ""
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if ReviewTextVw.text.isEmpty {
            ReviewTextVw.text = placeHolderText
        }
        ReviewTextVw.resignFirstResponder()
    }
    
}
