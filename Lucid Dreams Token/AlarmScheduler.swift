//
//  AlarmScheduler.swift
//  Lucid Dreams Token
//
//  Created by jhonalejo zh on 9/6/26.
//
import Foundation

struct AlarmScheduler {
    
    static func generateRandomTimes(
        count: Int,
        minimumGapMinutes: Int = AlarmSettings.minimumGapMinutes
    ) -> [DateComponents] {
        
        let totalMinutesInDay = 24 * 60
        
        guard count >= AlarmSettings.minimumTimesPerDay,
              count <= AlarmSettings.maximumTimesPerDay else {
            return []
        }
        
        var selectedMinutes: [Int] = []
        var attempts = 0
        let maxAttempts = 20_000
        
        while selectedMinutes.count < count && attempts < maxAttempts {
            attempts += 1
            
            let randomMinute = Int.random(in: 0..<totalMinutesInDay)
            
            let isFarEnough = selectedMinutes.allSatisfy { existingMinute in
                abs(existingMinute - randomMinute) >= minimumGapMinutes
            }
            
            if isFarEnough {
                selectedMinutes.append(randomMinute)
            }
        }
        
        selectedMinutes.sort()
        
        return selectedMinutes.map { minuteOfDay in
            let hour = minuteOfDay / 60
            let minute = minuteOfDay % 60
            
            var components = DateComponents()
            components.hour = hour
            components.minute = minute
            
            return components
        }
    }
}
