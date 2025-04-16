//
//  StringExtensions.swift
//  RickAndMorty
//
//  Created by User on 15/04/2025.
//

import Foundation
extension String{
    var formattedDateString: String?{
        guard let date = DateFormatter.dateFormatter.date(from: self) else{
            return nil
        }
        return DateFormatter.shortDateFormatter.string(from: date)
    }
}


