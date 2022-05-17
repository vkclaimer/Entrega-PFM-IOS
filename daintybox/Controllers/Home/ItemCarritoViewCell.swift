//
//  ItemCarritoViewCell.swift
//  daintybox
//
//  Created by Julio Rodriguez on 05/12/22.
//
import UIKit

class ItemCarritoViewCell: UITableViewCell{
    @IBOutlet var iw_product: UIImageView!
    @IBOutlet var lbl_name: UILabel!
    @IBOutlet var lbl_desc: UILabel!
    @IBOutlet var lbl_price: UILabel!
    @IBOutlet var lbl_cantidad: UILabel!
    @IBOutlet var btn_mas: UIButton!
    @IBOutlet var btn_menos: UIButton!
    @IBOutlet var iw_delete: UIImageView!
    var id: String!
}

