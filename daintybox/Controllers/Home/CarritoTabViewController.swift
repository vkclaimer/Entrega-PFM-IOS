//
//  CarritoTabViewController.swift
//  daintybox
//
//  Created by Julio Rodriguez on 05/12/22.
//
import UIKit
import Firebase

class CarritoTabViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var tableViewItems: UITableView!
    @IBOutlet var loading_items: UIActivityIndicatorView!
    
    let db = Firestore.firestore()
    var arrItems: [[String: Any]] = []
    var arrItemsNormal: [[String: Any]] = []
    var doc_ref_user_cart: DocumentReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableViewItems.delegate = self
        tableViewItems.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCarritoData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCarritoViewCell")! as! ItemCarritoViewCell
        
        let itemData = arrItems[indexPath.row]
        let productData = itemData["product"] as! QueryDocumentSnapshot
        let arrImages = productData["images"] as? NSArray ?? []
        
        // Imagen del producto
        let url = URL(string: arrImages[0] as! String)!
        
        cell.iw_product.af.setImage(withURL: url)
        cell.iw_product.clipsToBounds = true
        
        
        cell.lbl_name.text = productData["name"] as? String
        cell.lbl_desc.text = productData["description"] as? String
        cell.lbl_cantidad.text = itemData["cantidad"] as? String
        
        
        let cantidad = itemData["cantidad"] as! Int
        cell.lbl_cantidad.text = "\(cantidad)"
        
        let price = productData["price"] as! NSNumber
        cell.lbl_price.text = "$"+price.stringValue
        
        cell.id = productData.documentID
        
        let gestureVerProd = UITapGestureRecognizer(target: self, action: #selector (self.tapProducto(_:)))
        gestureVerProd.cancelsTouchesInView = false;
        cell.addGestureRecognizer(gestureVerProd)
        
        
        let gestureMas = MasMenosTap(target: self, action: #selector (self.tapMas(_:)))
        gestureMas.id = productData.documentID
        cell.btn_mas.addGestureRecognizer(gestureMas)
        
        let gestureMenos = MasMenosTap(target: self, action: #selector (self.tapMenos(_:)))
        gestureMenos.id = productData.documentID
        cell.btn_menos.addGestureRecognizer(gestureMenos)
        
        let gestureDelete = MasMenosTap(target: self, action: #selector (self.tapDelete(_:)))
        gestureDelete.id = productData.documentID
        cell.iw_delete.addGestureRecognizer(gestureDelete)
        
        return cell
    }
    
    @objc func tapProducto(_ sender:UITapGestureRecognizer){
        
        if let cellView = sender.view as? ItemCarritoViewCell {
            
            let id = cellView.id
            
            // Pantalla a llamar
            let storyboard = UIStoryboard(name: "Producto", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ProductoViewController") as! ProductoViewController
            controller.id_product = id
            
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
        
    }
    
    @objc func tapMas(_ sender:MasMenosTap){
        
        let id = sender.id
        
        var pi = 0
        for parsedItem in self.arrItems{
            
            if( parsedItem["id_product"] as! String == id ){
                
                var cantidad = parsedItem["cantidad"] as! Int
                
                if(cantidad<=99){
                    
                    cantidad += 1
                    
                    self.arrItems[pi]["cantidad"] = cantidad
                    self.arrItemsNormal[pi]["cantidad"] = cantidad
                    self.tableViewItems.reloadData()
                    
                    
                    let new_cart: [String: Any] = [
                        "items": arrItemsNormal
                    ]
                    
                    doc_ref_user_cart?.setData(new_cart)
                    
                    break
                }
                
            }
            pi += 1
        }
            
        
        
    }
    
    @objc func tapMenos(_ sender:MasMenosTap){
            
        let id = sender.id
        
        var pi = 0
        for parsedItem in self.arrItems{
            if( parsedItem["id_product"] as! String == id ){
                
                var cantidad = parsedItem["cantidad"] as! Int
                
                if(cantidad>1){
                    
                    cantidad -= 1
                    
                    self.arrItems[pi]["cantidad"] = cantidad
                    self.arrItemsNormal[pi]["cantidad"] = cantidad
                    self.tableViewItems.reloadData()
                    
                    
                    let new_cart: [String: Any] = [
                        "items": arrItemsNormal
                    ]
                    
                    doc_ref_user_cart?.setData(new_cart)
                    
                    break
                }
                
            }
            pi += 1
        }
        
    }
    
    
    @objc func tapDelete(_ sender:MasMenosTap){
        
        let id = sender.id
        var pi = 0
        
        for parsedItem in self.arrItems{
            if( parsedItem["id_product"] as! String == id ){
                
                self.arrItems.remove(at: pi)
                self.arrItemsNormal.remove(at: pi)
                self.tableViewItems.reloadData()
                
                
                let new_cart: [String: Any] = [
                    "items": arrItemsNormal
                ]
                
                doc_ref_user_cart?.setData(new_cart)
                
            }
            pi += 1
        }
        
        
    }
    
    func getCarritoData(){
        arrItems.removeAll()
        arrItemsNormal.removeAll()
        loading_items.startAnimating()
        loading_items.isHidden = false
        
        let user = Auth.auth().currentUser
        
        if user != nil {
            
            self.doc_ref_user_cart = db.collection("carrito").document(user!.uid)
            
            self.doc_ref_user_cart?.getDocument { (document, error) in
                
                if let document = document, document.exists {
                    
                    let itemsResult = document["items"] as? [NSDictionary] ?? []
                    
                    var arrProdIds = [String]()
                    
                    for item in itemsResult{
                        arrProdIds.append(item.value(forKey: "id_product") as! String)
                        
                        let parsed_cart_item: [String: Any] = [
                            "cantidad": item.value(forKey: "cantidad") as! Int,
                            "id_product": item.value(forKey: "id_product") as! String
                        ]
                        
                        self.arrItems.append(parsed_cart_item)
                        self.arrItemsNormal.append(parsed_cart_item)
                    }
                    
                    let rsProducts = self.db.collection("productos").whereField(FieldPath.documentID(), in: arrProdIds)
                    
                    rsProducts.getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                let id = document.documentID
                                //let data = document.data()
                                
                                var pi = 0
                                for parsedItem in self.arrItems{
                                    if( parsedItem["id_product"] as! String == id ){
                                        self.arrItems[pi]["product"] = document
                                    }
                                    pi += 1
                                }
                                
                                self.tableViewItems.reloadData()
                            }
                        }
                        
                        self.loading_items.isHidden = true
                    }
                    
                }
                
            }
            
        }
    }
    
    
}


class MasMenosTap: UITapGestureRecognizer {
    var id = String()
}
