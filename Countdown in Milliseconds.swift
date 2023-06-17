import Foundation

struct Utils {
    
    public static func getWeeklyDate(from epochMS: Int) -> String {
        let format = Constants.DateFormat.weekday
        let date = self.date (from: epochMS)
        let stringDate = getDate (from: epochMS, of: format)
        let phase = self.getDayPhase(from: date).rawValue
        return phase + " " + stringDate
    }
    
    public static func getDate(from epochMS: Int, of format: String) -> String {
        let dateFormatter = DateFormatter ()
        dateFormatter.dateFormat = format
        let date = self.date (from: epochMS)
        return dateFormatter.string (from: date)
    }
    
    public static func date(from epochMS: Int) -> Date {
        let seconds = TimeInterval (epochMS / 1000)
        return Date(timeIntervalSince1970: seconds)
    }
    
    public static func getDayPhase (from date: Date) -> DayPhase {
        let hour = Calendar.current.component (.hour, from: date)
        switch hour {
        case 5..<12:
            return .morning
        case 12:
            return .noon
        case 13..<17:
            return .afternoon
        case 17..<22:
            return .night
        default:
            return .morning
        }
    }
}

enum DayPhase: String {
    case morning = "Morning"
    case noon = "Noon"
    case afternoon = "Afternoon"
    case evening = "Evening"
    case night = "Night"
}

struct Constants {
    struct DateFormat {
        static let weekday = "EEEE"
        static let time = "HH: mm"
        static let day = " dd MMMM yyyy"
    }
}
