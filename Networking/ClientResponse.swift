import Foundation

public struct ClientResponse {
    public var error: NSError?
    public var data: Data?
}

extension ClientResponse {

    /// Decodes standard tmdb response data (keypath `results`) into array of expected model type
    ///
    /// - Returns: optional array of Codable expected model type
    func decodeResults<T: Decodable>() -> [T]? {
        if let data = data,
           let decodedWrapper = try? JSONDecoder().decode(WrapperResults<T>.self, from: data) {
            return decodedWrapper.results
        }
        return nil
    }

    /// - Returns: optional of Codable expected model type
    func decode<T: Decodable>() -> T? {
        if let data = data,
           let decoded = try? JSONDecoder().decode(T.self, from: data) {
            return decoded
        }
        return nil
    }
}
