
struct ErrorHandler {
    
    enum DecoderError: Error {
        case modelDecodingError
    }
    
    enum NetworkError: Error {
        case urlError
        case responseError
        case chacheError
        case dataIsEmpty
        case error
    }
    
    public static func handle(of error: Error, errorDescription: String) {
        switch error {
        case NetworkError.urlError:
            debugPrint(errorDescription)
        case NetworkError.responseError:
            debugPrint(errorDescription)
        case NetworkError.chacheError:
            debugPrint(errorDescription)
        case NetworkError.dataIsEmpty:
            debugPrint(errorDescription)
        case NetworkError.error:
            debugPrint(errorDescription)
        case DecoderError.modelDecodingError:
            debugPrint(errorDescription)
        default:
            return
        }
    }
}
