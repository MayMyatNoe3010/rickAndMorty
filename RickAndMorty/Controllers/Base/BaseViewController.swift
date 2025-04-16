//
//  BaseViewController.swift
//  RickAndMorty
//
//  Created by User on 13/04/2025.
//

import UIKit

class BaseViewController: UIViewController {
    
    func handleScrollView(
        scrollView: UIScrollView,
        thresholdOffset: CGFloat = 0,
        onLoadMore: () -> Void
    ) {
        let offset = scrollView.contentOffset.y
        let totalContentHeight = scrollView.contentSize.height
        let totalScrollViewFixedHeight = scrollView.frame.size.height
        
        print("Offset: \(offset)")
        print("TotalContentHeight: \(totalContentHeight)")
        print("ScrollViewHeight: \(totalScrollViewFixedHeight)")
        
        if offset >= (totalContentHeight - totalScrollViewFixedHeight - thresholdOffset) {
            onLoadMore()
        }
    }
}
