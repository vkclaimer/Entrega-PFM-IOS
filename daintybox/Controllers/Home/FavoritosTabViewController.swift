//
//  FavoritosTabViewController.swift
//  daintybox
//
//  Created by Julio Rodriguez on 05/11/22.
//
import UIKit
import Firebase

class FavoritosTabViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var tableViewFavoritos: UITableView!
    @IBOutlet var loading_favoritos: UIActivityIndicatorView!
    
    let db = Firestore.firestore()
    var arrFavoritos = [QueryDocumentSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableViewFavoritos.delegate = self
        tableViewFavoritos.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFavoriteData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFavoritos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductoFavViewCell")! as! ProductoFavViewCell
        
        let productData = arrFavoritos[indexPath.row]
        let arrImages = productData["images"] as? NSArray ?? []
        
        // Imagen del producto
        let url = URL(string: arrImages[0] as! String)!
        
        cell.iw_product.af.setImage(withURL: url)
        cell.iw_product.clipsToBounds = true
        
        
        cell.lbl_name.text = productData["name"] as? String
        cell.lbl_desc.text = productData["description"] as? String
        
        let price = productData["price"] as! NSNumber
        cell.lbl_price.text = "$"+price.stringValue
        
        cell.id = productData.documentID
        
        let gestureVerProd = UITapGestureRecognizer(target: self, action: #selector (self.tapProducto(_:)))
        cell.addGestureRecognizer(gestureVerProd)
        
        return cell
    }
    
    @objc func tapProducto(_ sender:UITapGestureRecognizer){
        
        if let cellView = sender.view as? ProductoFavViewCell {
            
            let id = cellView.id
            
            // Pantalla a llamar
            let storyboard = UIStoryboard(name: "Producto", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ProductoViewController") as! ProductoViewController
            controller.id_product = id
            
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
        
    }
    
    
    func getFavoriteData(){
        arrFavoritos.removeAll()
        loading_favoritos.startAnimating()
        loading_favoritos.isHidden = false
        
        let user = Auth.auth().currentUser
        
        if user != nil {
            
            let docRef = db.collection("favoritos").document(user!.uid)
            
            docRef.getDocument { (document, error) in
                
                if let document = document, document.exists {
                    
                    let arrProdIds = document["productos"] as? [String] ?? []
                    
                    let rsFavoritos = self.db.collection("productos").whereField(FieldPath.documentID(), in: arrProdIds)
                    
                    rsFavoritos.getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                //let id = document.documentID
                                //let data = document.data()
                                
                                self.arrFavoritos.append(document)
                                
                                self.tableViewFavoritos.reloadData()
                            }
                        }
                        
                        self.loading_favoritos.isHidden = true
                    }
                    
                }
                
            }
            
        }
    }
    
}
