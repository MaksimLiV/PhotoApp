//
//  Photo.swift
//  PhotoApp
//
//  Created by Maksim Li on 24/07/2025.
//

import Foundation

struct Photo: Codable {
    let id: Int
    let albumId: Int
    let title: String
    let url: String
    let thumbnailUrl: String
    
    var workingThumbnailUrl: String {
        return AppConfig.thumbnailUrl(for: id)
    }
    
    var workingFullImageUrl: String {
        return AppConfig.fullImageUrl(for: id)
    }
    
}
