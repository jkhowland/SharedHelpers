/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import Foundation

public extension Date {
    
    // MARK: - Formatters
    
    static fileprivate var ISO8601MillisecondFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }
    
    static fileprivate var ISO8601SecondFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }
    
    static fileprivate var ISO8601YearMonthDayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    static fileprivate var dateAndTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    static fileprivate var fullDateAndTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }
    
    static fileprivate var fullDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
    static fileprivate var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    static fileprivate var dayAndMonthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMM d", options: 0, locale: Locale.current)
        return formatter
    }
    
    static fileprivate let parsingFormatters = [ISO8601MillisecondFormatter, ISO8601SecondFormatter, ISO8601YearMonthDayFormatter]
    
    static public func fromISO8601String(_ dateString:String) -> Date? {
        for formatter in parsingFormatters {
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        return .none
    }
    
    static public func fromMillisecondsSince1970(_ milliseconds: Double) -> Date {
        let dateSeconds = milliseconds / 1000.0
        let dateInterval = TimeInterval(dateSeconds)
        let date = Date(timeIntervalSince1970: dateInterval)
        return date
    }
    
    
    // MARK: - Formatted computed vars
    
    /// E.g. "3:30 PM"
    public var timeString: String {
        return Date.timeFormatter.string(from: self)
    }
    
    /// E.g. "Nov 23, 1937, 3:30 PM"
    public var dateAndTimeString: String {
        return Date.dateAndTimeFormatter.string(from: self)
    }
    
    /// E.g. "Tuesday, November 23, 1937 at 3:30 PM"
    public var fullDateAndTimeString: String {
        return Date.fullDateAndTimeFormatter.string(from: self)
    }
    
    /// E.g. "Tuesday, November 23, 1937"
    public var fullDateString: String {
        return Date.fullDateFormatter.string(from: self)
    }
    
    /// E.g. "1937-11-23T15:30:00-0700"
    public var iso8601DateAndTimeString: String {
        return Date.ISO8601SecondFormatter.string(from: self)
    }
    
    /// E.g. "1937-11-23T15:30:00.023-0700"
    public var iso8601MillisecondString: String {
        return Date.ISO8601MillisecondFormatter.string(from: self)
    }
    
    /// E.g. "1937-11-23"
    public var iso8601DateString: String {
        return Date.ISO8601YearMonthDayFormatter.string(from: self)
    }
    
    public var millisecondsSince1970: TimeInterval {
        return round(self.timeIntervalSince1970 * 1000)
    }
    
    /// E.g. "Nov 23"
    public var dayAndMonthString: String {
        return Date.dayAndMonthFormatter.string(from: self)
    }
    
    /// `Today`, `Yesterday`, or month and day (e.g. Aug 15)
    public var relativeDayAndMonthString: String {
        let now = Date()
        if isSameDay(as: now - 1.days) {
            return NSLocalizedString("Yesterday", comment: "Relative date string for previous day")
        }
        if isSameDay(as: now) {
            return NSLocalizedString("Today", comment: "Relative date string for current day")
        }
        if isSameDay(as: now + 1.days) {
            return NSLocalizedString("Tomorrow", comment: "Relative date string for next day")
        }
        return dayAndMonthString
    }
    
    public var relativeDayAndTimeString: String {
        return String.localizedStringWithFormat(NSLocalizedString("%@, %@", comment: "Relative date and time string. First parameter is relative date, second is time."), relativeDayAndMonthString, timeString)
    }
    
    
    // MARK: - Helper computed vars
    
    public var isToday: Bool {
        let now = Date()
        return isSameDay(as: now)
    }
    
    public var startOfDay: Date {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.era, .year, .month, .day], from: self)
        let startOfDate = calendar.date(from: components)!
        return startOfDate
    }
    
    public var endOfDay: Date {
        let calendar = Calendar.current
        let nextDay = (calendar as NSCalendar).date(byAdding: .day, value: 1, to: self, options: [])!
        let components = (calendar as NSCalendar).components([.era, .year, .month, .day], from: nextDay)
        let startOfDate = calendar.date(from: components)!
        return startOfDate
    }
    
    
    // MARK: - Functions
        
    public func isSameDay(as date: Date) -> Bool {
        let calender = Calendar.current
        let components: Set<Calendar.Component> = [.day, .month, .year]
        let componentsOne = calender.dateComponents(components, from: self)
        let componentsTwo = calender.dateComponents(components, from: date)
        return componentsOne.day == componentsTwo.day && componentsOne.month == componentsTwo.month && componentsOne.year == componentsTwo.year
    }
    
}


// MARK: - Time intervals on Int

public extension Int {
    
    public var seconds: TimeInterval {
        return TimeInterval(self)
    }

    public var minutes: TimeInterval {
        return TimeInterval(self * 60)
    }
    
    public var hours: TimeInterval {
        return TimeInterval(minutes * 60)
    }
    
    public var days: TimeInterval {
        return TimeInterval(hours * 24)
    }
    
    public var weeks: TimeInterval {
        return TimeInterval(days * 7)
    }

}
