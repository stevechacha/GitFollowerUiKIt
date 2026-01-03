//
//  GFImageView.swift
//  GitFollowerUiKIt
//
//  Created by stephen chacha on 24/08/2024.
//

import UIKit

class GFImageView: UIImageView {
    
    let cache = ImageCacheService.shared.cache
    
    let placeholder = UIImage(named: "avatar-placeholder")
    
    private var task: URLSessionDataTask?

    override init(frame: CGRect){
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    private func configure(){
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholder
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func downloadImage(from urlString: String){
        // Cancel previous task if exists
        task?.cancel()
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey){
            self.image = image
            return
        }
        
        // Reset to placeholder while loading
        image = placeholder
        
        guard let url = URL(string: urlString) else { return }
        
        task = URLSession.shared.dataTask(with: url) { [weak self] data , response , error in
            guard let self = self else { return }
            
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            
            self.cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task?.resume()
    }
    
    func cancelDownload() {
        task?.cancel()
        task = nil
    }
}
