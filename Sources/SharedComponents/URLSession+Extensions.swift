import Foundation

extension URLSession {
    
    public static var cacheSession: URLSession {
        URLCache.shared.memoryCapacity = 512 * 1024 * 1024
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: configuration)
    }
    
    public static var defaultSession: URLSession {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }
}
