import Foundation
import UserNotifications

final class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            
            if let error = error {
                print("Notification permission error: \(error)")
            }
            
            print("Permission granted: \(granted)")
            completion(granted)
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UserDefaults.standard.set(0, forKey: AlarmSettings.savedAlarmCountKey)
    }
    
    func getSavedAlarmCount() -> Int {
        UserDefaults.standard.integer(forKey: AlarmSettings.savedAlarmCountKey)
    }
    
    func scheduleDailySounds(timesPerDay: Int, completion: @escaping (Int) -> Void) {
        cancelAllNotifications()
        
        let times = AlarmScheduler.generateRandomTimes(count: timesPerDay)
        
        guard !times.isEmpty else {
            UserDefaults.standard.set(0, forKey: AlarmSettings.savedAlarmCountKey)
            completion(0)
            return
        }
        
        for (index, time) in times.enumerated() {
            let content = UNMutableNotificationContent()
            content.title = "Lucid Dreams Token"
            content.body = "Your dream reminder sound is ready."
            content.sound = UNNotificationSound(
                named: UNNotificationSoundName(AlarmSettings.soundFileName)
            )
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: time,
                repeats: true
            )
            
            let request = UNNotificationRequest(
                identifier: "lucid_dream_sound_\(index)",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("Scheduled notification \(index)")
                }
            }
        }
        
        UserDefaults.standard.set(times.count, forKey: AlarmSettings.savedAlarmCountKey)
        completion(times.count)
    }
}
