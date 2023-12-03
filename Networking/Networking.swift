public class Networking {
    
    static func networkRequest(url: String, httpMethod: String = "GET", parameters: [String: AnyObject], completion: @escaping (ClientResponse) -> Void) {
        var apiReturn = ClientResponse()
        let apikey = Config.apikey
        var params = parameters
        params["api_key"] = apikey as AnyObject
        request(url, httpMethod: httpMethod, parameters: params) { (data, _, error) in
            if let data = data {
                apiReturn.data = data
            }
            apiReturn.error = error as NSError?
            completion(apiReturn)
        }
    }
    
    static func request(_ url: String, httpMethod: String = "GET", parameters: [String: AnyObject], completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let parameterString = parameters.stringFromHttpParameters()
        let urlString = url + "?" + parameterString
        let requestURL = URL(string: urlString)!
        let request = NSMutableURLRequest(url: requestURL)
        request.httpMethod = httpMethod
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            DispatchQueue.main.async(execute: { () -> Void in
                if error != nil {
                    completionHandler(nil, nil, error as Error?)
                } else {
                    completionHandler(data, response, nil)
                }
            })
        })
        
        task.resume()
    }
}

