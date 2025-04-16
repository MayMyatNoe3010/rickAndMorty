//
//  DateFormatterExtension.swift
//  RickAndMorty
//
//  Created by User on 15/04/2025.
//

import Foundation
extension DateFormatter{
    
    static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
            formatter.timeZone = .current
            return formatter
        }()

        static let shortDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            formatter.timeZone = .current
            return formatter
        }()

}
