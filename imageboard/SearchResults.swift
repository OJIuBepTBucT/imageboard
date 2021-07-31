//
//  SearchResults.swift
//  imageboard
//
//  Created by User on 21.07.2021.
//

import Foundation

struct SearchResults: Decodable {
    let total: Int
    let results: [UnsplashPhoto]
    
}

struct UnsplashPhoto: Decodable {
    
    let width: Int
    let height: Int
    let urls: [URLKing.RawValue:String]
    
    
    
    
    enum URLKing: String {
        case rav
        case full
        case regular
        case small
        case thumb
        
    }
    
}
