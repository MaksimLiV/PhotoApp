//
//  APPConfig.swift
//  PhotoApp
//
//  Created by Maksim Li on 09/08/2025.
//

struct AppConfig {
    
    // MARK: - Image Service Configuration
    static let imageBaseUrl = "https://picsum.photos"
    static let thumbnailSize = "150/150"
    static let fullImageSize = "600/400"
    
    // MARK: - URL Generation Methods
    static func thumbnailUrl(for photoId: Int) -> String {
        return "\(imageBaseUrl)/\(thumbnailSize)?random=\(photoId)"
    }
    
    static func fullImageUrl(for photoId: Int) -> String {
        return "\(imageBaseUrl)/\(fullImageSize)?random=\(photoId)"
    }
    
    // MARK: - Fallback URLs
    static func originalThumbnailUrl(for photo: Photo) -> String {
        return photo.thumbnailUrl
    }
    
    static func originalFullImageUrl(for photo: Photo) -> String {
        return photo.url
    }
}
