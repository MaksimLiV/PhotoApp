//
//  ImageLoader.swift
//  PhotoApp
//
//  Created by Maksim Li on 04/08/2025.
//

import UIKit

class ImageLoader {
    
    // MARK: - Singleton
    static let shared = ImageLoader()
    
    // MARK: - Properties
    private let cache: NSCache<NSString, UIImage>
    private let session: URLSession
    private var activeTasks: [String: URLSessionDataTask] = [:]
    
    // MARK: - Initialization
    
    private init() {
        cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        session = URLSession(configuration: config)
    }
    
    // MARK: - Public Methods
    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        print("ImageLoader.loadImage called for: \(url)")
        
        let cacheKey = NSString(string: url)
        
        if let cachedImage = cache.object(forKey: cacheKey) {
            print("Found in cache: \(url)")
            
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
        
        guard let imageURL = URL(string: url) else {
            print("Invalid URL: \(url)")
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        
        print ("Start image load: \(url)")
        
        let task = session.dataTask(with: imageURL) { [weak self] data, response, error in
            self?.activeTasks.removeValue(forKey: url)
            
            if let error = error {
                print("Loading error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let data = data else {
                print("No data returned for URL: \(url)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let image = UIImage(data: data) else {
                print("Error creating UIImage from data: \(url)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let cacheKey = NSString(string: url)
            
            self?.cache.setObject(image, forKey: cacheKey)
            
            print ("Image loaded and saved in cache: \(url)")
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        activeTasks[url] = task
        
        task.resume()
        print("Task resumed for: \(url)")
        
    }
    
    func cancelLoad(for url: String) {
        
        if let task = activeTasks[url] {
            
            task.cancel()
            
            activeTasks.removeValue(forKey: url)
            print("Cancelled loading: \(url)")
        }
    }
    
    func clearCache() {
        
        cache.removeAllObjects()
        
        print("Image cache cleared")
    }
}
