//
//  TiendaTabViewController.swift
//  daintybox
//
//  Created by Julio Rodriguez on 05/10/22.
//

import UIKit
import Firebase
import AlamofireImage

class TiendaTabViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    let db = Firestore.firestore()
    
    var arrMasVendidos = [QueryDocumentSnapshot]()
    var arrOfertas = [QueryDocumentSnapshot]()
    
    @IBOutlet var loading_vendidos: UIActivityIndicatorView!
    @IBOutlet var collectionMasVendidos: UICollectionView!
    
    
    @IBOutlet var loading_ofertas: UIActivityIndicatorView!
    @IBOutlet var collectionOfertas: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMasVendidos()
        getOfertas()
    }
    
    func getMasVendidos(){
        
        loading_vendidos.isHidden = false
        loading_vendidos.startAnimating()
        
        db.collection("productos").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //let id = document.documentID
                    //let data = document.data()
                    
                    self.arrMasVendidos.append(document)
                    
                    self.collectionMasVendidos.reloadData()
                }
            }
            
            self.loading_vendidos.isHidden = true
        }
        
    
    }
    
    func getOfertas(){
        
        loading_ofertas.isHidden = false
        loading_ofertas.startAnimating()
        
        db.collection("productos").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //let id = document.documentID
                    //let data = document.data()
                    
                    self.arrOfertas.append(document)
                    
                    self.collectionOfertas.reloadData()
                }
            }
            
            self.loading_ofertas.isHidden = true
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if( collectionView == self.collectionMasVendidos ){
            return arrMasVendidos.count
        }else{
            return arrOfertas.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductoViewCell", for: indexPath) as! ProductoViewCell
        
        let productData = collectionView == self.collectionMasVendidos ? arrMasVendidos[indexPath.row] : arrOfertas[indexPath.row]
        let arrImages = productData["images"] as? NSArray ?? []
        
        // Imagen de la discoteca
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
        
        if let cellView = sender.view as? ProductoViewCell {
            
            let id = cellView.id
            
            // Pantalla a llamar
            let storyboard = UIStoryboard(name: "Producto", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ProductoViewController") as! ProductoViewController
            controller.id_product = id
            
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
        
    }
    
}
