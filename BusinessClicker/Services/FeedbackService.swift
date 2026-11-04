import AVFoundation
import AudioToolbox
import UIKit
import UserNotifications

@MainActor final class FeedbackService {
    private var musicPlayer: AVAudioPlayer?
    func apply(_ settings: Settings) {
        if settings.music {
            if musicPlayer == nil, let url = Bundle.main.url(forResource: "ambience", withExtension: "wav") {
                musicPlayer = try? AVAudioPlayer(contentsOf: url); musicPlayer?.numberOfLoops = -1; musicPlayer?.volume = 0.13
            }
            musicPlayer?.play()
        } else { musicPlayer?.pause() }
    }
    func play(_ name: String, settings: Settings) {
        if settings.haptics { UIImpactFeedbackGenerator(style: name == "success" ? .medium : .light).impactOccurred() }
        guard settings.sound, let url = Bundle.main.url(forResource: name, withExtension: "wav") else { return }
        var sound: SystemSoundID = 0
        guard AudioServicesCreateSystemSoundID(url as CFURL, &sound) == kAudioServicesNoError else { return }
        let identifier = sound
        AudioServicesPlaySystemSoundWithCompletion(identifier) { AudioServicesDisposeSystemSoundID(identifier) }
    }
    func notifications(enabled: Bool) async throws -> Bool {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily"])
        guard enabled else { return false }
        guard try await center.requestAuthorization(options: [.alert, .sound]) else { return false }
        let content = UNMutableNotificationContent(); content.title = "Votre empire vous attend"; content.body = "Un nouveau service, une nouvelle occasion de grandir."
        var date = DateComponents(); date.hour = 19
        try await center.add(UNNotificationRequest(identifier: "daily", content: content, trigger: UNCalendarNotificationTrigger(dateMatching: date, repeats: true)))
        return true
    }
}
