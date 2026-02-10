import AVFoundation
import UIKit

class SoundService {
    static let shared = SoundService()
    private var audioPlayer: AVAudioPlayer?
    
    func playClick() {
        guard DataService.shared.settings.soundEnabled else { return }
        
        // Try to load sound file
        if let url = Bundle.main.url(forResource: "click", withExtension: "wav") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                // Fallback: use system sound
                AudioServicesPlaySystemSound(1104)
            }
        } else {
            // No sound file, use system sound
            AudioServicesPlaySystemSound(1104)
        }
    }
    
    func vibrate() {
        guard DataService.shared.settings.vibrationEnabled else { return }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func playAddHole() {
        playClick()
        vibrate()
    }
}
