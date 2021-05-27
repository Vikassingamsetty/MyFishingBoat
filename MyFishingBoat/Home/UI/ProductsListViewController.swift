//
//  ProductsListViewController.swift
//  MyFishingBoat
//
//  Created by Appcare on 26/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher

class ProductsListViewController: BaseViewController {
    
    @IBOutlet weak var checkOutBtnOutlet: UIButton!
    @IBOutlet weak var productCollectionview: UICollectionView!
    @IBOutlet weak var scrollItemsCollectionView: UICollectionView!
    @IBOutlet weak var searchNotifyBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    
    //Bottom Checkout outlets
    @IBOutlet weak var cartHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ChechOutView: UIView!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var totalItemslbl: UILabel!
    @IBOutlet weak var cartQntyBtn: UIButton!
    
    var productCatgryList:ProductListByCategory?
    var cartListModel:CartListModel?
    var categoryStaticList:CategoryStaticList?
    var addToCartBtnModel:AddToCartBtnModel?
    var removeCartModel:RemoveCartModel?
    
    //Getting data
    var cid = String()
    var sum = 0
    var addCart = [Int:Int]()
    
    //min and max quantity change
    var quantity = Int()
    var price = String()
    
    //product list count
    var productCount = Int()
    
    //CoreData Arrays
    var productListArray:[NSManagedObject] = []
    var indexList:[NSManagedObject]=[]
    
    //Cart total
    var totalArray = [Int]()
    var total = Int()
    
    
    @IBAction func checkOutBtnAction(_ sender: Any) {
        
        if UserDefaults.standard.string(forKey: "userid") != nil {
            
            let vc = storyboard?.instantiateViewController(identifier: "CartViewController") as! CartViewController
            self.present(vc, animated: false, completion: nil)
            
        }else {
            let vc = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            cartValue = "cart"
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func searchNotifyBtnAction(_ sender: Any) {
        
        if UserDefaults.standard.string(forKey: "userid") != nil {
            
            let vc = self.storyboard?.instantiateViewController(identifier: "NotificationsViewController") as! NotificationsViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        }else {
            showAlertMessage(vc: self, titleStr: "", messageStr: "Login/Signup to see the notifications")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if Reachability.isConnectedToNetwork(){
            
            userStaticCategoryList()
            
            if UserDefaults.standard.string(forKey: "userid") != nil {
                self.ChechOutView.isHidden = true
                productListAPI(uid: UserDefaults.standard.string(forKey: "userid")!, cids: cid)
                cartTotal()
            }else{
                fetchRequestResult()
                productListAPI(uid: "", cids: cid)
            }
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        productCollectionview.reloadData()
        
        self.tabBarController?.tabBar.isHidden = false // tabBarController exists
    }
    
    //MARK:-API call
    
    //Static Category list
    func userStaticCategoryList() {
        
        RestService.serviceCall(url: staticCategoryList_URL, method: .get, parameters: nil, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(CategoryStaticList.self, from: response) else{return}
            
            if responseJson.status == 200 {
                self.categoryStaticList = responseJson
                print(responseJson.data?.count)
                
                DispatchQueue.main.async {
                    self.scrollItemsCollectionView.reloadData()
                }
                
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //product list based on category
    func productListAPI(uid:String, cids:String) {
        
        let params = [
            "cid": cids,
            "uid":uid
        ]
        print(params, "vikas")
        
        RestService.serviceCall(url: singleCtgryProList_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(ProductListByCategory.self, from: response) else{return}
            
            if responseJson.status == 200 {
                self.productCatgryList = responseJson
                DispatchQueue.main.async {
                    self.productCount = responseJson.data!.count ?? 0
                    self.productCollectionview.reloadData()
                }
            }else{
                self.productCount = 0
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    self.productCollectionview.reloadData()
                })
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //Adding product to whishlist
    func addingToWishlist(cat_id:String, pro_id:String) {
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        
        let params = [
            "uid": uid,
            "pid": pro_id,
            "cid": cat_id
        ]
        
        RestService.serviceCall(url: addWishlist_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(AddToWishlist.self, from: response) else{return}
            
            if responseJson.status == 200 {
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
                DispatchQueue.main.asyncAfter(deadline: .now()+2.1, execute: {
                    self.productListAPI(uid: UserDefaults.standard.string(forKey: "userid")!, cids: cat_id)
                })
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //removefrom wishlist
    func removeWishlist(pro_id:String, catg_id:String) {
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        
        let params = [
            "uid": uid,
            "pid": pro_id,
            "cid": catg_id
        ]
        
        RestService.serviceCall(url: deleteWishlist_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(RemoveWishlist.self, from: response) else{return}
            
            if responseJson.status == 200 {
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
                DispatchQueue.main.asyncAfter(deadline: .now()+2.1, execute: {
                    self.productListAPI(uid: UserDefaults.standard.string(forKey: "userid")!, cids: catg_id)
                })
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //Total items in cart
    func cartTotal() {
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        
        let params = [
            "uid":uid
        ]
        
        RestService.serviceCall(url: cartList_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(CartListModel.self, from: response) else {return}
            self.cartListModel = responseJson
            
            if responseJson.status == 200 {
                self.sum = 0
                self.ChechOutView.isHidden = false
                for i in 0..<responseJson.data!.count {
                    let priceValue = responseJson.data?[i].price
                    self.sum = self.sum + (priceValue! as NSString).integerValue
                    print(responseJson.data?[i].price, "price")
                }
                
                if responseJson.data!.count != 0 {
                    self.tabBarController?.tabBar.items?[3].badgeValue = "\(responseJson.data?.count ?? 0)"
                }
                self.totalPriceLbl.text = "\(self.sum)"
                self.totalItemslbl.text = "\(responseJson.data?.count ?? 0)"
                
            }else{
                //showAlertMessage(vc: self, titleStr: "", messageStr: self.cartListModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
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
                self.removeCartModel = responseJson
                if responseJson.status == 200 {
                    print("removed from cart")
                    DispatchQueue.main.async {
                        self.productListAPI(uid: uid, cids: self.cid)
                        self.ChechOutView.isHidden = true
                        self.cartTotal()
                    }
                }else{
                    
                    print("error 1")
                    showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
                }
            }catch{
                print("error 2")
                showAlertMessage(vc: self, titleStr: "", messageStr: self.removeCartModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //Add to cart
    func addToCart(pid:String, price:String, quantityNo:String) {
        
        let charSet = CharacterSet(charactersIn: " kg")
        let trim = quantityNo.trimmingCharacters(in: charSet)
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        let params = [
            "uid": uid,
            "pid": pid,
            "cid": "",
            "price": price,
            "quantity": quantityNo
        ]
        
        print(params)
        
        RestService.serviceCall(url: addToCartSingle_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(AddToCartBtnModel.self, from: response) else {return}
            self.addToCartBtnModel = responseJson
            if responseJson.status == 200 {
                DispatchQueue.main.async {
                    self.productListAPI(uid: UserDefaults.standard.string(forKey: "userid")!, cids: self.cid)
                    self.cartTotal()
                }
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.addToCartBtnModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    
}

//MARK:- Collection View delgates
extension ProductsListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == scrollItemsCollectionView {
            if let count = categoryStaticList?.data?.count {
                return count
            }else{
                return 0
            }
        }else{
            return productCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == scrollItemsCollectionView {
            let cell = scrollItemsCollectionView.dequeueReusableCell(withReuseIdentifier: "ScrollCollectionViewCell", for: indexPath) as! ScrollCollectionViewCell
            
            cell.scrollImage.contentMode = .scaleAspectFit
            cell.scrollImage.sd_setImage(with: URL(string: categoryStaticList!.data?[indexPath.row].fixedCategoryIos?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ?? ""), placeholderImage: UIImage(named: ""))
            cell.scrollLabel.text = categoryStaticList?.data?[indexPath.item].name ?? ""
            return cell
            
        }
        
        self.price = ""
        
        let cell = productCollectionview.dequeueReusableCell(withReuseIdentifier: "ProductsListCollectionViewCell", for: indexPath) as! ProductsListCollectionViewCell
        
        cell.configProductList(list: productCatgryList!, index: indexPath.row)
        
        cell.favouriteBtnOutlet.tag = indexPath.row
        cell.favouriteBtnOutlet.addTarget(self, action: #selector(favBtn(_:)), for: .touchUpInside)
        
        cell.addToCartBtn.tag = indexPath.row
        cell.addToCartBtn.addTarget(self, action: #selector(addToCart(_:)), for: .touchUpInside)
        
        cell.imageView.sd_setImage(with: URL(string: productCatgryList!.data![indexPath.row].imageIos!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage(named: ""))
        cell.quantityBtn.setTitle(productCatgryList!.data![indexPath.row].quantity!, for: .normal)
        cell.minValueBtn.tag = indexPath.row
        cell.maxValueBtn.tag = indexPath.row
        cell.minValueBtn.addTarget(self, action: #selector(minBtnAction(_:)), for: .touchUpInside)
        cell.maxValueBtn.addTarget(self, action: #selector(maxBtnAction(_:)), for: .touchUpInside)
        
        cell.quantityBtn.setTitle("1", for: .normal)
        
        if UserDefaults.standard.string(forKey: "userid") != nil {
            
            if productCatgryList!.data![indexPath.row].wishlist == "Yes" {
                cell.favouriteBtnOutlet.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
            }else{
                cell.favouriteBtnOutlet.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
            }
            
            if productCatgryList!.data![indexPath.row].cart == "Yes" {
                cell.addToCartBtn.isHidden = true
                cell.quantityBtn.setTitle("\(productCatgryList!.data![indexPath.row].quantity ?? "0")", for: .normal)
            }else{
                cell.addToCartBtn.isHidden = false
            }
            
        }else{
            
            cell.favouriteBtnOutlet.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
            
            indexList.removeAll()
            print(productCatgryList!.data![indexPath.row].id, "prdt id")
            print(productCatgryList!.data![indexPath.row].catID, "cat id")
            print(indexPath.row, "row id")
            fetchRequestProductResult(prdtId: productCatgryList!.data![indexPath.row].id ?? "",cateId: productCatgryList!.data![indexPath.row].catID ?? "")
            
            if indexList.count > 0 {
                let person = indexList[0]
                if person.value(forKey: "productId") as? String == productCatgryList!.data![indexPath.row].id && person.value(forKey: "categoryId") as? String == productCatgryList!.data![indexPath.row].catID{
                    cell.addToCartBtn.isHidden = true
                    cell.quantityBtn.setTitle("\(person.value(forKey: "qty") ?? "")", for: .normal)
                }else{
                    cell.addToCartBtn.isHidden = false
                }
            }else{
                cell.addToCartBtn.isHidden = false
            }
            
        }
        
        if productCatgryList!.data![indexPath.row].stockStatus == "0" {
            cell.outOfStockLbl.isHidden = false
            cell.addToCartBtn.isUserInteractionEnabled = false
        }else {
            cell.outOfStockLbl.isHidden = true
            cell.addToCartBtn.isUserInteractionEnabled = true
        }
        
        
        return cell
    }
    
    @objc func minBtnAction(_ sender: UIButton) {
        print("minbutton")
        
        if UserDefaults.standard.string(forKey: "userid") != nil {
            
            let indexpath = IndexPath(row: sender.tag, section: 0)
            let cell = productCollectionview.cellForItem(at: indexpath) as! ProductsListCollectionViewCell
            
            quantity = 0
            price = ""
            
            quantity = Int(productCatgryList!.data![sender.tag].quantity ?? "")!
            
            if quantity > 1 {
                quantity -= 1
                cell.quantityBtn.setTitle("\(quantity) kg", for: .normal)
                price = "\(quantity * (productCatgryList!.data![sender.tag].productPrice! as NSString).integerValue)"
                print(quantity, price)
                
                DispatchQueue.main.async {
                    self.addToCart(pid: self.productCatgryList!.data![sender.tag].id ?? "", price: self.price, quantityNo: "\(self.quantity)")
                }
                
            }else if quantity <= 1 {
                
                DispatchQueue.main.async {
                    self.removeItemFromCart(uid: UserDefaults.standard.string(forKey: "userid")!, pid: self.productCatgryList!.data![sender.tag].id ?? "")
                    
                }
            }
            
        }else{
            //before login
            
            print("minbutton")
            let indexpath = IndexPath(row: sender.tag, section: 0)
            let cell = productCollectionview.cellForItem(at: indexpath) as! ProductsListCollectionViewCell
            
            quantity = 0
            price = ""
            var str:String = ""
            fetchRequestProductResult(prdtId: productCatgryList!.data![sender.tag].id ?? "",cateId: productCatgryList!.data![sender.tag].catID ?? "")
            if indexList.count > 0 {
                let person = indexList[0]
                if person.value(forKey: "productId") as? String == productCatgryList!.data![sender.tag].id {
                    str = person.value(forKey: "qty") as! String
                    quantity = Int(str) ?? 0
                }
            }
            
            // quantity = Int(bestSeller!.data[sender.tag].quantity)!
            
            if quantity > 1 {
                quantity -= 1
                cell.quantityBtn.setTitle("\(quantity) kg", for: .normal)
                price = "\(quantity * (productCatgryList!.data![sender.tag].productPrice! as NSString).integerValue)"
                print(quantity, price, "quantity,price of product min button")
                
                DispatchQueue.main.async {
                    self.updsteDB(prdtId: self.productCatgryList!.data![sender.tag].id ?? "", cateId: self.productCatgryList!.data![sender.tag].catID ?? "", qty: "\(self.quantity)", priceQty: self.productCatgryList!.data![sender.tag].productPrice ?? "")
                    self.productCollectionview.reloadData()
                }
                
            }else if quantity == 1 {
                //add to cart button
                //db deletion
                deleteItem(prdtId: self.productCatgryList!.data![sender.tag].id ?? "")
            }
            
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
                fetchRequestResult()
                try context.save()
                self.productCollectionview.reloadData()
            }
        } catch {
            print(" deleteItem Failed")
        }
    }
    
    @objc func maxBtnAction(_ sender: UIButton) {
        
        if UserDefaults.standard.string(forKey: "userid") != nil {
            
            quantity = 0
            price = ""
            
            print("maxbutton")
            quantity = Int(productCatgryList!.data![sender.tag].quantity ?? "")!
            print(quantity,price, "maxbutton values")
            let indexpath = IndexPath(row: sender.tag, section: 0)
            let cell = productCollectionview.cellForItem(at: indexpath) as! ProductsListCollectionViewCell
            
            if quantity > 0 {
                quantity += 1
                
                print(quantity,price, "maxbutton values")
                
                cell.quantityBtn.setTitle("\(quantity) kg", for: .normal)
                price = "\(quantity * (productCatgryList!.data![sender.tag].productPrice! as NSString).integerValue)"
                print(quantity, price)
                
                DispatchQueue.main.async {
                    self.addToCart(pid: self.productCatgryList!.data![sender.tag].id ?? "", price: self.price, quantityNo: "\(self.quantity)")
                }
                
            }
            
        } else {
            //before login
            quantity = 0
            price = ""
            
            print("maxbutton")
            var str = ""
            fetchRequestProductResult(prdtId: productCatgryList!.data![sender.tag].id ?? "",cateId: productCatgryList!.data![sender.tag].catID ?? "")
            if indexList.count > 0 {
                let person = indexList[0]
                if person.value(forKey: "productId") as? String == productCatgryList!.data![sender.tag].id{
                    str = person.value(forKey: "qty") as! String
                    quantity = Int(str) ?? 0
                }
            }
            
            print(quantity,price, "maxbutton values")
            let indexpath = IndexPath(row: sender.tag, section: 0)
            let cell = productCollectionview.cellForItem(at: indexpath) as! ProductsListCollectionViewCell
            
            if quantity > 0 {
                quantity += 1
                
                print(quantity,price, "quantity, price ")
                
                cell.quantityBtn.setTitle("\(quantity) kg", for: .normal)
                price = "\(quantity * (productCatgryList!.data![sender.tag].productPrice! as NSString).integerValue)"
                print(quantity, price, " quantity, price max button")
                
                DispatchQueue.main.async {
                    self.updsteDB(prdtId: self.productCatgryList!.data![sender.tag].id ?? "", cateId: self.productCatgryList!.data![sender.tag].catID ?? "", qty: "\(self.quantity)", priceQty: self.productCatgryList!.data![sender.tag].productPrice ?? "")
                    //check the label text it is fluctuating
                    self.productCollectionview.reloadData()
                }
                
            }
        }
        
    }
    
    @objc func addToCart(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(identifier: "AddToCartPopupVC") as! AddToCartPopupVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.tag = sender.tag
        vc.delegate = self
        vc.cid = productCatgryList!.data![sender.tag].catID ?? ""
        vc.pid = productCatgryList!.data![sender.tag].id ?? ""
        vc.price = productCatgryList!.data![sender.tag].productPrice ?? ""
        vc.productImage = productCatgryList!.data![sender.tag].productPhotos ?? ""
        vc.productName = productCatgryList!.data![sender.tag].productName ?? ""
        present(vc, animated: false, completion: nil)
        
    }
    
    @objc func favBtn(_ sender: UIButton){
        //adding to wish list
        if UserDefaults.standard.string(forKey: "userid") != nil {
            
            if productCatgryList!.data![sender.tag].wishlist == "Yes" {
                removeWishlist(pro_id: productCatgryList!.data![sender.tag].id ?? "", catg_id: productCatgryList!.data![sender.tag].catID ?? "")
            }else{
                addingToWishlist(cat_id: productCatgryList!.data![sender.tag].catID ?? "", pro_id: productCatgryList!.data![sender.tag].id ?? "")
            }
        }else{
            showAlertMessage(vc: self, titleStr: "", messageStr: "Login/Signup to add product to wishlist")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == scrollItemsCollectionView {
            
            self.cid = categoryStaticList!.data?[indexPath.row].catID ?? ""
            print(self.cid, "cid value")
            
            
            if UserDefaults.standard.string(forKey: "userid") != nil {
                productListAPI(uid: UserDefaults.standard.string(forKey: "userid")!, cids: self.cid)
            }else{
                productListAPI(uid: "", cids: self.cid)
            }
            
            
        }else if collectionView == productCollectionview {
            
            let vc = storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
            vc.cid = productCatgryList!.data![indexPath.row].catID ?? ""
            vc.pid = productCatgryList!.data![indexPath.row].id ?? ""
            
            present(vc, animated: false, completion: nil)
        }
    }
}

extension ProductsListViewController: UICollectionViewDelegateFlowLayout, AddCartProtocol {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == scrollItemsCollectionView {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == scrollItemsCollectionView {
            return CGSize(width: 80, height: 60)
        }else {
            let size = productCollectionview.frame.size
            return CGSize(width: size.width, height: 358)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == scrollItemsCollectionView {
            return 10.0
        }else {
            return 0.0
        }
    }
    
    //MARK:-Coredata
    //Fetch all records Result //not used
    func fetchRequestResult() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
        
        do {
            productListArray = try managedContext.fetch(fetchRequest)
            print(productListArray)
            
            if productListArray.count != 0 {
                self.tabBarController?.tabBar.items?[3].badgeValue = "\(productListArray.count)"
            }
            
            if productListArray.count > 0 {
                self.ChechOutView.isHidden = false
                self.totalItemslbl.text = "\(productListArray.count)"
                
                if productListArray.count > 0 {
                    totalArray.removeAll()
                    for i in 0..<productListArray.count {
                        
                        let price = (productListArray[i].value(forKey: "price") as? String as! NSString).integerValue * (productListArray[i].value(forKey: "qty") as? String as! NSString).integerValue
                        print(price, "price")
                        totalArray.append(price)
                    }
                    total = 0
                    if totalArray.count > 0 {
                        var values = 0
                        for i in 0..<totalArray.count {
                            values = values + totalArray[i]
                        }
                        total = values
                        self.totalPriceLbl.text = "\(total)"
                    }
                    
                }
                
            }else{
                self.ChechOutView.isHidden = true
            }
            
            //Added:-
            self.productCollectionview.reloadData()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    //UpdatedDB
    func updsteDB(prdtId :String,cateId :String,qty:String, priceQty:String)  {
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
                self.productCollectionview.reloadData()
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
            fetchRequestResult()
        }
        catch {
            print("Saving Core Data Failed: \(error)")
        }
    }
    
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
            print(indexList)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    
    //Protocol
    func didTapCart(tagValue: String) {
        
        self.cid = tagValue
        
        print(tagValue, "tagValue")
        if Reachability.isConnectedToNetwork() {
            
            if UserDefaults.standard.string(forKey: "userid") != nil {
                guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
                DispatchQueue.main.async {
                    self.productListAPI(uid: uid, cids: self.cid)
                    self.cartTotal()
                }
            } else {
                fetchRequestResult()
                productListAPI(uid: "", cids: self.cid)
                self.productCollectionview.reloadData()
            }
        } else {
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
    }
    
}

