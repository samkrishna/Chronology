//
//  Clock.swift
//  Chronology
//
//  Created by Dave DeLong on 11/22/17.
//

import Foundation


/// A `Clock` is how you know what "now" is.
public struct Clock {
    
    /**
     Implementation details:
     - This uses an internal "ClockImplementation" to simplify the distinction between a custom clock and a system clock
     - If you specify a custom flow-rate of time, it must be greater than zero. You can't stop or reverse time. Sorry.
     **/
    
    /// The system clock
    public static let system = Clock()
    
    public static let UTC = Clock(region: .currentUTC)
    
    private let impl: ClockImplementation
    
    public let region: Region
    public var calendar: Calendar { return region.calendar }
    public var timeZone: TimeZone { return region.timeZone }
    public var locale: Locale { return region.locale }
    
    private init(implementation: ClockImplementation, region: Region) {
        self.impl = implementation
        self.region = region
    }
    
    
    /// Create a clock that reflects the current system time
    public init(region: Region = .autoupdatingCurrent) {
        self.init(implementation: SystemClock(), region: region)
    }
    
    
    /// Create a clock with a custom start time and flow rate
    ///
    /// - Parameters:
    ///   - referenceDate: The moment "now" from which the clock will start counting
    ///   - rate: The rate at which time progresses in the clock, relative to the supplied calendar.
    ///           1.0 (the default) means one second on the system clock correlates to a second passing in the clock.
    ///           2.0 would mean that every second elapsing on the system clock would be 2 seconds on this clock (ie, time progresses twice as fast)
    ///   - timeZone: The TimeZone in which moments are produced
    ///   - calendar: The Calendar relative to which the rate is calculated
    public init(startingFrom referenceMoment: Moment, rate: Double = 1.0, region: Region = .autoupdatingCurrent) {
        guard rate > 0.0 else { fatalError("Clocks can only count forwards") }
        
        let implementation = CustomClock(referenceMoment: referenceMoment, rate: rate, calendar: region.calendar)
        self.init(implementation: implementation, region: region)
    }
    
    
    /// Create a clock with a custom start time and flow rate
    ///
    /// - Parameters:
    ///   - referenceEpoch: The moment "now" from which the clock will start counting
    ///   - rate: The rate at which time progresses in the clock.
    ///           1.0 (the default) means one second on the system clock correlates to a second passing in the clock.
    ///           2.0 would mean that every second elapsing on the system clock would be 2 seconds on this clock (ie, time progresses twice as fast)
    ///   - timeZone: The TimeZone in which moments are produced
    public init(startingFrom referenceEpoch: Epoch, rate: Double = 1.0, region: Region = .autoupdatingCurrent) {
        let referenceMoment = Moment(interval: 0, since: referenceEpoch)
        self.init(startingFrom: referenceMoment, rate: rate, region: region)
    }
    
    
    /// Retrieve the current moment
    ///
    /// - Returns: A `Moment` representing the current time on the clock.
    public func thisMoment() -> Moment {
        return impl.now()
    }
    
    /// Offset a clock
    ///
    /// - Parameter by: A `TimeInterval` by which to create an offseted clock
    /// - Returns: A new `Clock` that is offset by the specified `TimeInterval` from the receiver
    public func offset(by: TimeInterval) -> Clock {
        let offset = OffsetClock(offset: by, from: impl)
        return Clock(implementation: offset, region: region)
    }
    
    
    /// Convert a clock to a new time zone
    ///
    /// - Parameter timeZone: The `TimeZone` of the new `Clock`
    /// - Returns: A new `Clock` that reports values in the specified `TimeZone`
    public func converting(to timeZone: TimeZone) -> Clock {
        if timeZone == self.timeZone { return self }
        let newRegion = Region(calendar: region.calendar, timeZone: timeZone, locale: region.locale)
        return self.converting(to: newRegion)
    }
    
    public func converting(to calendar: Calendar) -> Clock {
        if calendar == self.calendar { return self }
        // TODO: if the new calendar defines a different scaling of SI Seconds... ?
        let newRegion = Region(calendar: calendar, timeZone: region.timeZone, locale: region.locale)
        return self.converting(to: newRegion)
    }
    
    public func converting(to newRegion: Region) -> Clock {
        // TODO: compare the existing region to the new region and short-circuit if possible
        // TODO: if the new calendar defines a different scaling of SI Seconds... ?
        return Clock(implementation: impl, region: newRegion)
    }
}


