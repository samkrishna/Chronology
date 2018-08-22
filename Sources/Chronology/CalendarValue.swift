//
//  DateComponentsField.swift
//  Chronology
//
//  Created by Dave DeLong on 2/19/18.
//

import Foundation

public protocol CalendarValue {
    static var representedComponents: Set<Calendar.Component> { get }
    var region: Region { get }
    var dateComponents: DateComponents { get }
    init(region: Region, dateComponents: DateComponents)
}

public extension CalendarValue {
    
    public static var smallestRepresentedComponent: Calendar.Component {
        let order: Array<Calendar.Component> = [.nanosecond, .second, .minute, .hour, .day, .month, .year, .era]
        let represented = self.representedComponents
        let component = order.first(where: { represented.contains($0) })
        return component.unwrap("\(Self.self) defines impossible represented units: \(represented)")
    }
    
    public var calendar: Calendar { return region.calendar }
    public var timeZone: TimeZone { return region.timeZone }
    public var locale: Locale { return region.locale }
    
    internal init(date: Date, region: Region) {
        let dc = region.calendar.dateComponents(in: region.timeZone, from: date)
        self.init(region: region, dateComponents: dc.requireAndRestrict(to: Self.representedComponents))
    }
    
    internal init(moment: Moment, region: Region) {
        self.init(date: moment.date, region: region)
    }
    
    public func convert(to region: Region) -> Self {
        return Self.init(region: region, dateComponents: dateComponents)
    }
    
    public func convert(to calendar: Calendar) -> Self {
        let newRegion = Region(calendar: calendar, timeZone: timeZone, locale: locale)
        return self.convert(to: newRegion)
    }
    
    public func convert(to timeZone: TimeZone) -> Self {
        let newRegion = Region(calendar: calendar, timeZone: timeZone, locale: locale)
        return self.convert(to: newRegion)
    }
    
    public func convert(to locale: Locale) -> Self {
        let newRegion = Region(calendar: calendar, timeZone: timeZone, locale: locale)
        return self.convert(to: newRegion)
    }
    
}

/// Access individual field values

public extension CalendarValue where Self: EraField {
    var era: Era { return Era(region: region, dateComponents: dateComponents) }
    var eraValue: Int { return dateComponents.era.unwrap("An EraField must have an era value") }
}

public extension CalendarValue where Self: YearField {
    var year: Year { return Year(region: region, dateComponents: dateComponents) }
    var yearValue: Int { return dateComponents.year.unwrap("A YearField must have a year value") }
}

public extension CalendarValue where Self: MonthField {
    var month: Month { return Month(region: region, dateComponents: dateComponents) }
    var monthValue: Int { return dateComponents.month.unwrap("A MonthField must have a month value") }
}

public extension CalendarValue where Self: DayField {
    var day: Day { return Day(region: region, dateComponents: dateComponents) }
    var dayValue: Int { return dateComponents.day.unwrap("A DayField must have a day value") }
}

public extension CalendarValue where Self: HourField {
    var hour: Hour { return Hour(region: region, dateComponents: dateComponents) }
    var hourValue: Int { return dateComponents.hour.unwrap("An HourField must have an hour value") }
}

public extension CalendarValue where Self: MinuteField {
    var minute: Minute { return Minute(region: region, dateComponents: dateComponents) }
    var minuteValue: Int { return dateComponents.minute.unwrap("A MinuteField must have a minute value") }
}

public extension CalendarValue where Self: SecondField {
    var second: Second { return Second(region: region, dateComponents: dateComponents) }
    var secondValue: Int { return dateComponents.second.unwrap("A SecondField must have a second value") }
}

public extension CalendarValue where Self: NanosecondField {
    var nanosecond: Nanosecond { return Nanosecond(region: region, dateComponents: dateComponents) }
    var nanosecondValue: Int { return dateComponents.nanosecond.unwrap("A NanosecondField must have a nanosecond value") }
}

/// Access the less-precise fields on Anchored values

public extension Anchored where Self: YearField {
    var era: Era { return Era(region: region, dateComponents: dateComponents) }
}

public extension Anchored where Self: MonthField {
    var year: Year { return Year(region: region, dateComponents: dateComponents) }
}

public extension Anchored where Self: DayField {
    var yearMonth: YearMonth { return YearMonth(region: region, dateComponents: dateComponents) }
    
    var isWeekend: Bool { return calendar.isDateInWeekend(approximateMidPoint.date) }
    var isWeekday: Bool { return !isWeekend }
    var dayOfWeek: Int { return calendar.component(.weekday, from: approximateMidPoint.date) }
}

public extension Anchored where Self: HourField {
    var yearMonthDay: YearMonthDay { return YearMonthDay(region: region, dateComponents: dateComponents) }
}

public extension Anchored where Self: MinuteField {
    var yearMonthDayHour: YearMonthDayHour { return YearMonthDayHour(region: region, dateComponents: dateComponents) }
}

public extension Anchored where Self: SecondField {
    var yearMonthDayHourMinute: YearMonthDayHourMinute { return YearMonthDayHourMinute(region: region, dateComponents: dateComponents) }
}

public extension Anchored where Self: NanosecondField {
    var yearMonthDayHourMinuteSecond: YearMonthDayHourMinuteSecond { return YearMonthDayHourMinuteSecond(region: region, dateComponents: dateComponents)}
}

/// Access the two-unit floating values

public extension CalendarValue where Self: MonthField & DayField {
    var monthDay: MonthDay { return MonthDay(region: region, dateComponents: dateComponents) }
}

public extension CalendarValue where Self: DayField & HourField {
    var dayHour: DayHour { return DayHour(region: region, dateComponents: dateComponents) }
}

public extension CalendarValue where Self: HourField & MinuteField {
    var hourMinute: HourMinute { return HourMinute(region: region, dateComponents: dateComponents) }
}

public extension CalendarValue where Self: MinuteField & SecondField {
    var minuteSecond: MinuteSecond { return MinuteSecond(region: region, dateComponents: dateComponents) }
}

public extension CalendarValue where Self: SecondField & NanosecondField {
    var secondNanosecond: SecondNanosecond { return SecondNanosecond(region: region, dateComponents: dateComponents) }
}

/// Access the three-unit floating values

public extension CalendarValue where Self: MonthField & DayField & HourField {
    var monthDayHour: MonthDayHour { return MonthDayHour(region: region, dateComponents: dateComponents) }
}

public extension CalendarValue where Self: DayField & HourField & MinuteField {
    var dayHourMinute: DayHourMinute { return DayHourMinute(region: region, dateComponents: dateComponents) }
}

public extension CalendarValue where Self: HourField & MinuteField & SecondField {
    var hourMinuteSecond: HourMinuteSecond { return HourMinuteSecond(region: region, dateComponents: dateComponents) }
}

public extension CalendarValue where Self: MinuteField & SecondField & NanosecondField {
    var minuteSecondNanosecond: MinuteSecondNanosecond { return MinuteSecondNanosecond(region: region, dateComponents: dateComponents) }
}

/// Access the four-unit floating values

public extension CalendarValue where Self: MonthField & DayField & HourField & MinuteField {
    var monthDayHourMinute: MonthDayHourMinute { return MonthDayHourMinute(region: region, dateComponents: dateComponents) }
}

public extension CalendarValue where Self: DayField & HourField & MinuteField & SecondField {
    var dayHourMinuteSecond: DayHourMinuteSecond { return DayHourMinuteSecond(region: region, dateComponents: dateComponents) }
}

public extension CalendarValue where Self: HourMinuteSecondNanosecondFields {
    var hourMinuteSecondNanosecond: HourMinuteSecondNanosecond { return HourMinuteSecondNanosecond(region: region, dateComponents: dateComponents) }
}

/// Access the five- and six-unit floating values

public extension CalendarValue where Self: MonthField & DayField & HourField & MinuteField & SecondField {
    var monthDayHourMinuteSecond: MonthDayHourMinuteSecond { return MonthDayHourMinuteSecond(region: region, dateComponents: dateComponents) }
}

public extension CalendarValue where Self: DayHourMinuteSecondNanosecondFields {
    var dayHourMinuteSecondNanosecond: DayHourMinuteSecondNanosecond { return DayHourMinuteSecondNanosecond(region: region, dateComponents: dateComponents) }
}

public extension CalendarValue where Self: MonthDayHourMinuteSecondNanosecondFields {
    var monthDayHourMinuteSecondNanosecond: MonthDayHourMinuteSecondNanosecond { return MonthDayHourMinuteSecondNanosecond(region: region, dateComponents: dateComponents) }
}

