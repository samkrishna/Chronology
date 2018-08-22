//
//  ClockImplementation.swift
//  Chronology
//
//  Created by Dave DeLong on 11/22/17.
//

import Foundation

internal extension Moment {
    init() {
        let now = Foundation.Date.timeIntervalSinceReferenceDate
        self.init(interval: SISeconds(now), since: .reference)
    }
}

internal protocol ClockImplementation {
    var SISecondsPerCalendarSecond: Double { get }
    func now() -> Moment
    
}

internal struct SystemClock: ClockImplementation {
    let SISecondsPerCalendarSecond: Double = 1.0
    func now() -> Moment { return Moment() }
}

internal struct CustomClock: ClockImplementation {
    
    let absoluteStart = Moment()
    let clockStart: Moment
    let rate: Double
    let calendar: Calendar
    var SISecondsPerCalendarSecond: Double { return calendar.SISecondsPerSecond }
    
    private let actualRate: Double
    
    init(referenceMoment: Moment, rate: Double, calendar: Calendar) {
        self.clockStart = referenceMoment
        self.calendar = calendar
        self.rate = rate
        self.actualRate = rate * calendar.SISecondsPerSecond
    }
    
    func now() -> Moment {
        let absoluteNow = Moment()
        let elapsedTime = absoluteNow - absoluteStart
        let scaledElapsedTime = elapsedTime * actualRate
        return clockStart + scaledElapsedTime
    }
    
}

internal struct OffsetClock: ClockImplementation {
    
    let base: ClockImplementation
    let offset: TimeInterval
    var SISecondsPerCalendarSecond: Double { return base.SISecondsPerCalendarSecond }
    
    init(offset: TimeInterval, from base: ClockImplementation) {
        self.base = base
        self.offset = offset
    }
    
    func now() -> Moment {
        let scaled = offset * SISecondsPerCalendarSecond
        return base.now() + SISeconds(scaled)
    }
    
}
