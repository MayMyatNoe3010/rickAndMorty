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

extension UIScrollView {
    func handleLoadMore(thresholdOffset: CGFloat = 0, onLoadMore: () -> Void) {
        let offset = self.contentOffset.y
        let totalContentHeight = self.contentSize.height
        let totalScrollViewFixedHeight = self.frame.size.height

        if offset >= (totalContentHeight - totalScrollViewFixedHeight - thresholdOffset) {
            onLoadMore()
        }
    }
}

