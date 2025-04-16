//
//  Extensions.swift
//  RickAndMorty
//
//  Created by User on 27/02/2025.
//

import Foundation
import UIKit
extension UIView{
    func addSubViews(_ views: UIView...){
        views.forEach({
            addSubview($0)
        })
    }
}
