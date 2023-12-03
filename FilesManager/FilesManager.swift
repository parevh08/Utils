
import UIKit


final class FilesManager {
    
    class var shared: FilesManager {
        struct Static {
            static let shared: FilesManager = FilesManager()
        }
        return Static.shared
    }
    
    func clearCache() {
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: cachesDirectory, includingPropertiesForKeys: nil, options: [])
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getNumberOfItems() -> Int {
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return 0 }
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: cachesDirectory, includingPropertiesForKeys: nil, options: [])
            return fileURLs.count
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
}

//MARK: - Image
extension FilesManager {
    
    struct Image {
        
        //MARK: - DownloadedImage
        static func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let imageData = data, let image = UIImage(data: imageData) else {
                    completion(nil)
                    return
                }
                completion(image)
            }.resume()
        }
        
        //MARK: - WorkWithDisk
        static func isImageCached(withIdentifier identifier: String) -> Bool {
            guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return false }
            let fileURL = cachesDirectory.appendingPathComponent("\(identifier).jpg")
            return FileManager.default.fileExists(atPath: fileURL.path)
        }
        
        static func saveImageToDisk(image: UIImage, identifier: String) {
            guard let data = image.jpegData(compressionQuality: 1.0) else {
                return
            }
            
            guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                return
            }
            
            let fileURL = cachesDirectory.appendingPathComponent("\(identifier).jpg")
            
            do {
                try data.write(to: fileURL)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        static func loadImageFromDisk(withIdentifier identifier: String) -> UIImage? {
            guard let imageData = getImageDataFromDisk(withIdentifier: identifier) else { return nil }
            let image = UIImage(data: imageData)
            return image
        }
        
        static func getImageDataFromDisk(withIdentifier identifier: String) -> Data? {
            guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
            let fileURL = cachesDirectory.appendingPathComponent("\(identifier).jpg")
            
            do {
                let imageData = try Data(contentsOf: fileURL)
                return imageData
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
    }
    
    
