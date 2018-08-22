//
//  Moment.swift
//  Chronology
//
//  Created by Dave DeLong on 11/22/17.
//

import Foundation

// TODO: make this more resilient against overflow
// It could be worthwhile having checks to see if it's better to convert from one epoch to another
// based on how close to a particular epoch an Moment is.
// For example, if we get a value in early 2038 based on the Unix epoch, we might want to consider
// recognizing this and instead basing it off the Reference epoch instead
// (note: the 2038 problem isn't an issue with Moment because it's based on Double and not Int32, but still)

public struct Moment: Hashable, Comparable {
    
    public static func ==(lhs: Moment, rhs: Moment) -> Bool {
        return lhs.intervalSinceReferenceEpoch == rhs.intervalSinceReferenceEpoch
    }
    
    public static func <(lhs: Moment, rhs: Moment) -> Bool {
        return lhs.intervalSinceReferenceEpoch < rhs.intervalSinceReferenceEpoch
    }
    
    public static func -(lhs: Moment, rhs: Moment) -> SISeconds {
        return lhs.intervalSinceReferenceEpoch - rhs.intervalSinceReferenceEpoch
    }
    
    public static func +(lhs: Moment, rhs: SISeconds) -> Moment {
        return Moment(interval: lhs.intervalSinceEpoch + rhs, since: lhs.epoch)
    }
    
    public let epoch: Epoch
    public let intervalSinceEpoch: SISeconds
    
    private let intervalSinceReferenceEpoch: SISeconds
    internal var date: Foundation.Date { return Date(timeIntervalSinceReferenceDate: intervalSinceReferenceEpoch.value) }
    
    public var hashValue: Int { return intervalSinceReferenceEpoch.hashValue }
    
    public init(interval: SISeconds, since epoch: Epoch) {
        self.epoch = epoch
        self.intervalSinceEpoch = interval
        self.intervalSinceReferenceEpoch = epoch.offsetFromReferenceDate + interval
    }
    
    internal init(date: Foundation.Date) {
        self.init(interval: SISeconds(date.timeIntervalSinceReferenceDate), since: .reference)
    }
    
    public func converting(to epoch: Epoch) -> Moment {
        if epoch == self.epoch { return self }
        let epochOffset = epoch.offsetFromReferenceDate - self.epoch.offsetFromReferenceDate
        let epochInterval = intervalSinceEpoch - epochOffset
        return Moment(interval: epochInterval, since: epoch)
    }
}
