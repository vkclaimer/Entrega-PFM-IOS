//
//  ProductoViewCell.swift
//  daintybox
//
//  Created by Julio Rodriguez on 05/10/22.
//
import UIKit

class ProductoViewCell: UICollectionViewCell{
    @IBOutlet var iw_product: UIImageView!
    @IBOutlet var lbl_name: UILabel!
    @IBOutlet var lbl_desc: UILabel!
    @IBOutlet var lbl_price: UILabel!
    var id: String!
}
