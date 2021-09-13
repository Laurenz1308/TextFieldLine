import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioRecorder: ObservableObject {
    
    let chatId: String
        
    var audioRecorder: AVAudioRecorder!
    @Published var recording = false
    
    @Published var player: AVAudioPlayer?
    var audioFile: Data? {
        player?.data
    }
    @Published var currentPlayingTime: Double = 0
    @Published var isPlaying = false
    
    var totalDuration: Double {
        Double(player?.duration ?? 0)
    }
    
    init(chatId: String) {
        self.chatId = chatId
        
        player = try? AVAudioPlayer(contentsOf: getPath())
        player?.prepareToPlay()
    }
    
    func startRecording() {
        if AVAudioSession.sharedInstance().recordPermission == AVAudioSession.RecordPermission.granted {
            initiateRecording()
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                if granted {
                    self.initiateRecording()
                } else {
                    print("Permission not granted")
                }
            })
        }
    }
    
    private func initiateRecording() {
        
        guard !recording else { return }
        
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording")
            return
        }
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: getPath(), settings: settings)
            print(getPath())
            audioRecorder.record()
            recording = true
        } catch {
            print("Could not start recording")
        }
    }
    
    func stopRecording() {
        
        guard let audioRecorder = self.audioRecorder else { return }
        audioRecorder.stop()
        recording = false
        player = try? AVAudioPlayer(contentsOf: getPath())
        player?.prepareToPlay()
    }
    
    func getPath() -> URL {
        
        let fm = FileManager.default
        let path = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        return path.appendingPathComponent("record_\(chatId).m4a")
        
    }
    
    func storeAudioFile(at location: String) {
        let fm = FileManager.default
        let path = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fullPath = path.appendingPathComponent(location)
        print(fullPath.absoluteString)
        
        guard let data = try? Data(contentsOf: getPath()) else {
            print("No data")
            return
        }
        
        do {
            let directoryPath = path.appendingPathComponent("\(chatId)").path
            var isDir: ObjCBool = false
            if fm.fileExists(atPath: directoryPath, isDirectory: &isDir) {
                if isDir.boolValue {
                    try data.write(to: fullPath)
                }
            } else {
                try fm.createDirectory(atPath: path.appendingPathComponent("\(chatId)").path, withIntermediateDirectories: false, attributes: nil)
                try data.write(to: fullPath)
            }
            print("Data saving successful")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func handlePlayPause() {
        if !isPlaying {
            playRecording()
        } else {
            pauseRecording()
        }
    }
    
    func playRecording() {
        if let player = player {
            player.play()
        } else {
            player = try? AVAudioPlayer(contentsOf: getPath())
            player?.prepareToPlay()
            player?.play()
        }
        isPlaying = true
    }
    
    func pauseRecording() {
        if let player = player {
            player.pause()
        }
        isPlaying = false
    }
    
    func getAudioFileDataForSending() -> Data? {
        let data = try? Data(contentsOf: getPath())
        return data
    }
    
    func getAudioFile(from data: Data) {
        player = try? AVAudioPlayer(data: data)
    }
    
    func deleteDefaultStoredFile() {
        
        let fm = FileManager.default
        let path = getPath()
        if fm.isDeletableFile(atPath: path.path) {
            print("Can be deleted")
            player = nil
            isPlaying = false
            currentPlayingTime = 0
            do {
                try fm.removeItem(at: path)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

extension Date {
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}
