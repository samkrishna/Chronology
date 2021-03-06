//
//  Anchored.swift
//  ChronologyPackageDescription
//
//  Created by Dave DeLong on 5/17/18.
//

import Foundation

public extension Anchored where Self: EraField {
    func format(era: Template<EraField>) -> String {
        return format(anchored: [era])
    }
}

public extension Anchored where Self: YearField {
    func format(era: Template<EraField>? = nil,
                year: Template<YearField>,
                timeZone: Template<TimeZone>? = nil) -> String {
        return format(anchored: [era, year, timeZone])
    }
}

public extension Anchored where Self: MonthField {
    func format(era: Template<EraField>? = nil,
                year: Template<YearField>,
                month: Template<MonthField>,
                timeZone: Template<TimeZone>? = nil) -> String {
        return format(anchored: [era, year, month, timeZone])
    }
}

public extension Anchored where Self: DayField {
    func format(era: Template<EraField>? = nil,
                year: Template<YearField>,
                month: Template<MonthField>,
                day: Template<DayField>,
                weekday: Template<Weekday>? = nil,
                timeZone: Template<TimeZone>? = nil) -> String {
        return format(anchored: [era, year, month, day, weekday, timeZone])
    }
}

public extension Anchored where Self: HourField {
    func format(era: Template<EraField>? = nil,
                year: Template<YearField>,
                month: Template<MonthField>,
                day: Template<DayField>,
                weekday: Template<Weekday>? = nil,
                hour: Template<HourField>,
                timeZone: Template<TimeZone>? = nil) -> String {
        return format(anchored: [era, year, month, day, weekday, hour, timeZone])
    }
}

public extension Anchored where Self: MinuteField {
    func format(era: Template<EraField>? = nil,
                year: Template<YearField>,
                month: Template<MonthField>,
                day: Template<DayField>,
                weekday: Template<Weekday>? = nil,
                hour: Template<HourField>,
                minute: Template<MinuteField>,
                timeZone: Template<TimeZone>? = nil) -> String {
        return format(anchored: [era, year, month, day, weekday, hour, minute, timeZone])
    }
}

public extension Anchored where Self: SecondField {
    func format(era: Template<EraField>? = nil,
                year: Template<YearField>,
                month: Template<MonthField>,
                day: Template<DayField>,
                weekday: Template<Weekday>? = nil,
                hour: Template<HourField>,
                minute: Template<MinuteField>,
                second: Template<SecondField>,
                timeZone: Template<TimeZone>? = nil) -> String {
        return format(anchored: [era, year, month, day, weekday, hour, minute, second, timeZone])
    }
}

public extension Anchored where Self: NanosecondField {
    func format(era: Template<EraField>? = nil,
                year: Template<YearField>,
                month: Template<MonthField>,
                day: Template<DayField>,
                weekday: Template<Weekday>? = nil,
                hour: Template<HourField>,
                minute: Template<MinuteField>,
                second: Template<SecondField>,
                nanosecond: Template<NanosecondField>,
                timeZone: Template<TimeZone>? = nil) -> String {
        return format(anchored: [era, year, month, day, weekday, hour, minute, second, nanosecond, timeZone])
    }
}
