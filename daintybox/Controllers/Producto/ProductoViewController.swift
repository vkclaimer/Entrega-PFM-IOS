//
//  ProductoViewController.swift
//  daintybox
//
//  Created by Julio Rodriguez on 05/10/22.
//
import UIKit
import Firebase
import AlamofireImage

class ProductoViewController: DtBaseUIViewController, UIScrollViewDelegate{
    
    let db = Firestore.firestore()
    
    @IBOutlet var sc_main: UIScrollView!
    @IBOutlet var view_main: UIView!
    @IBOutlet var view_producto_img_holder: UIView!
    @IBOutlet var lbl_name: UILabel!
    @IBOutlet var lbl_desc: UILabel!
    @IBOutlet var lbl_price: UILabel!
    @IBOutlet var lbl_details: UILabel!
    @IBOutlet var iw_producto: UIImageView!
    @IBOutlet var iw_favorite: UIImageView!
    @IBOutlet var btn_add_cart: UIButton!
    
    @IBOutlet var loading_main: UIActivityIndicatorView!
    
    var documentProd: DocumentSnapshot?
    
    var id_product: String!
    var isFavorite: Bool! = false
    
    //datos del carrito
    var doc_ref_user_cart: DocumentReference?
    var cart_exist: Bool! = false
    var arrItems: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sc_main.delegate = self
        
        
        self.sc_main.isHidden = true
        getProduct()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        detectNavigationScroll(scrollView)
    }
    
    func detectNavigationScroll(_ scrollView: UIScrollView){
        let alpha = 0 + ( scrollView.contentOffset.y / (view_producto_img_holder.frame.height/3) )
        self.navigationController?.setAlphaNavigationBar(alpha: alpha)
        
        if(alpha >= 0.8 && documentProd != nil ){
            self.navigationItem.title = documentProd!["name"] as? String
        }else{
            self.navigationItem.title = ""
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.presentTransparentNavigationBar()
        detectNavigationScroll(self.sc_main)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.hideTransparentNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationItem.title = ""
    }
    
    
    func getProduct(){
        loading_main.startAnimating()
        
        let docRef = db.collection("productos").document(id_product)

        docRef.getDocument { (document, error) in
            
            self.loading_main.stopAnimating()
            self.loading_main.isHidden = true
            self.sc_main.isHidden = false
            
            if let document = document, document.exists {
                self.documentProd = document
                
                self.lbl_name.text = document["name"] as? String
                self.lbl_desc.text = document["description"] as? String
                self.lbl_details.text = document["details"] as? String
                
                let price = document["price"] as! NSNumber
                self.lbl_price.text = "$"+price.stringValue
                
                // Imagen de la discoteca
                let arrImages = document["images"] as? NSArray ?? []
                let url = URL(string: arrImages[0] as! String)!
                
                self.iw_producto.af.setImage(withURL: url)
                self.iw_producto.clipsToBounds = true
                
                self.getFavoriteData()
                self.getCarritoData()
            } else {
                //print("Document does not exist")
            }
        }
        
        
    }
    
    func getFavoriteData(){
        //var isFavorite = false
        let user = Auth.auth().currentUser
        
        if user != nil {
            
            let docRef = db.collection("favoritos").document(user!.uid)
            
            docRef.getDocument { (document, error) in
                
                if let document = document, document.exists {
                    
                    let arrProdIds = document["productos"] as? NSArray ?? []
                    
                    if( arrProdIds.contains(self.id_product!) ){
                        self.isFavorite = true
                    }
                    
                    self.populateFavorite(self.isFavorite)
                }else{
                    self.populateFavorite(self.isFavorite)
                }
                
            }
            
        }
    }
    
    func getCarritoData(){
        let user = Auth.auth().currentUser
        
        if user != nil {
            
            doc_ref_user_cart = db.collection("carrito").document(user!.uid)
            
            doc_ref_user_cart?.getDocument { (document, error) in
                
                if let document = document, document.exists {
                    
                    self.arrItems = document["items"] as? [NSDictionary] ?? []
                    //print(self.arrItems[0].value(forKey: "id_product"))
                    self.cart_exist = true
                }else{
                    self.cart_exist = false
                }
                
            }
            
        }
    }
    
    
    func populateFavorite(_ isFavorite : Bool){
        
        var fav_image = UIImage(named: "ic_fav_off.png")
        
        if(isFavorite){
            fav_image = UIImage(named: "ic_fav_activo.png")
        }
        
        iw_favorite.image = fav_image
        
        
        let gestureFav = UITapGestureRecognizer(target: self, action: #selector (self.tapFavorite(_:)))
        iw_favorite.addGestureRecognizer(gestureFav)
        
    }
    
    @objc func tapFavorite(_ sender:UITapGestureRecognizer){
        var isRemoving = false
        
        // Hago el swift
        var fav_image = UIImage(named: "ic_fav_off.png")
        
        if(isFavorite){
            fav_image = UIImage(named: "ic_fav_off.png")
            isRemoving = true
            self.isFavorite = false
        }else{
            fav_image = UIImage(named: "ic_fav_activo.png")
            isRemoving = false
            self.isFavorite = true
        }
        
        iw_favorite.image = fav_image
        
        let user = Auth.auth().currentUser
        
        if user != nil {
            
            let docRef = db.collection("favoritos").document(user!.uid)
            
            docRef.getDocument { (document, error) in
                
                if let document = document, document.exists {
                    
                    var arrProdIds = document["productos"] as? [String] ?? []
                    
                    if(isRemoving){
                        if let index = arrProdIds.firstIndex(of: self.id_product) {
                            arrProdIds.remove(at: index)
                        }
                    }else{
                        if( !arrProdIds.contains(self.id_product!) ){
                            arrProdIds.append(self.id_product)
                        }
                    }
                    
                    let docNewData: [String: Any] = [
                        "productos": arrProdIds
                    ]
                    
                    docRef.setData(docNewData)
                }else{
                    
                    var arrProdIds = [String]()
                    
                    
                    if(isRemoving){
                        if let index = arrProdIds.firstIndex(of: self.id_product) {
                            arrProdIds.remove(at: index)
                        }
                    }else{
                        if( !arrProdIds.contains(self.id_product!) ){
                            arrProdIds.append(self.id_product)
                        }
                    }
                    
                    let docNewData: [String: Any] = [
                        "productos": arrProdIds
                    ]
                    
                    self.db.collection("favoritos").document(user!.uid).setData(docNewData)
                }
                
            }
            
        }
        
    }
    
    @IBAction func pressedAddCart(_ sender: Any) {
        
        let user = Auth.auth().currentUser
        
        if(cart_exist){
            
            let new_cart_item: [String: Any] = [
                "cantidad": 1,
                "id_product": self.id_product
            ]
            
            var is_added = false
            
            for item in arrItems{
                if( (item.value(forKey: "id_product") as! String) == self.id_product ){
                    is_added = true
                }
            }
            
            if(!is_added){
                arrItems.append(new_cart_item as NSDictionary)
            }
            
            let new_cart: [String: Any] = [
                "items": arrItems
            ]
            
            doc_ref_user_cart?.setData(new_cart)
            
            Utils.showToast(context: self, message: "Articulo agregado al carrito",pos_y_offset: 150)
        }else{
            
            let new_cart_item: [String: Any] = [
                "cantidad": 1,
                "id_product": self.id_product
            ]
            
            arrItems.append(new_cart_item as NSDictionary)
            
            let new_cart: [String: Any] = [
                "items": arrItems
            ]
            
            self.db.collection("carrito").document(user!.uid).setData(new_cart)
            
            Utils.showToast(context: self, message: "Articulo agregado al carrito",pos_y_offset: 150)
        }
        
        
    }
    
}
