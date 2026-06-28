import SwiftUI

struct AlarmHomeView: View {
    
    @State private var timesPerDay: Double = 5
    @State private var scheduledAlarmCount: Int = 0
    @State private var message: String = "Choose how many times the sound should play daily."
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                Text("Lucid Dreams Token")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                
                Text("Daily Sound Reminder")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                
                VStack(spacing: 8) {
                    Text("Currently programmed")
                        .font(.headline)
                    
                    Text("\(scheduledAlarmCount) alarms per day")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(scheduledAlarmCount > 0 ? .green : .secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.gray.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Text("Times per day: \(Int(timesPerDay))")
                    .font(.title2)
                
                Slider(
                    value: $timesPerDay,
                    in: Double(AlarmSettings.minimumTimesPerDay)...Double(AlarmSettings.maximumTimesPerDay),
                    step: 1
                )
                
                Text("Minimum gap: \(AlarmSettings.minimumGapMinutes) minutes")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Button {
                    NotificationManager.shared.requestPermission { granted in
                        DispatchQueue.main.async {
                            if granted {
                                NotificationManager.shared.scheduleDailySounds(
                                    timesPerDay: Int(timesPerDay)
                                ) { count in
                                    DispatchQueue.main.async {
                                        scheduledAlarmCount = count
                                        message = "Scheduled \(count) sounds per day."
                                    }
                                }
                            } else {
                                message = "Notification permission was not granted."
                            }
                        }
                    }
                } label: {
                    Text("Activate Daily Sounds")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Button {
                    NotificationManager.shared.cancelAllNotifications()
                    scheduledAlarmCount = 0
                    message = "All scheduled sounds were cancelled."
                } label: {
                    Text("Cancel Sounds")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.red)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
            .padding()
            .onAppear {
                scheduledAlarmCount = NotificationManager.shared.getSavedAlarmCount()
            }
        }
    }
}

#Preview {
    AlarmHomeView()
}
