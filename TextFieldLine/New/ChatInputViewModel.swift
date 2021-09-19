import Foundation
import SwiftUI
import Combine

class ChatInputViewModel: ObservableObject {
    
    // message data
    @Published var messsage: String = ""
    @Published var imageList: [ImageElement] = []

    // InputLine representation
    @Published var recordingLocked = false
    @Published var upswipeOffset: CGFloat = 0
    
    // AudioRecorder
    var cancellables = [AnyCancellable]()
    @Published var audioRecorder: AudioRecorder
    @Published var showPlayer = false
    @Published var recordingTime: Double = 0
    @Published var recording = false
    
    // Swipe Gesture
    var gestureActive = false
    var leftSwipeOffset: CGFloat = 0
    var leftSwipeMax: CGFloat {
        UIScreen.main.bounds.size.width * 0.45
    }
    let upswipeMax: CGFloat = 100
    var showTrash = false
    var checkForUpdates = true
    var cancelOnEnded = false
    
    // MatchedGeometry
    @Namespace var inputElements
    var leftButton = "leftButton"
    var rightButton = "rightButton"
    
    
    init(chatId: String) {
        audioRecorder = AudioRecorder(chatId: chatId)
        setUpCombine()
    }
    
    
    func mainGesture() -> _EndedGesture<_ChangedGesture<SimultaneousGesture<SimultaneousGesture<DragGesture, _EndedGesture<_ChangedGesture<DragGesture>>>, _ChangedGesture<DragGesture>>>> {
        return DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .simultaneously(with: leftSwipeToDeleteGesture())
            .simultaneously(with: swipeUpToLockGesture())
            .onChanged({ value in
                self.startRecordingTap()
            })
            .onEnded({ value in
                self.stopRecordingTap()
            })
    }
    
    func stopButtonTapped() {
        audioRecorder.stopRecording()
        recordingTime = 0
        gestureActive = false
        recordingLocked = false
        checkForUpdates = true
        cancelOnEnded = false
    }
    
    private func startRecordingTap() {
        gestureActive = checkForUpdates
        if checkForUpdates {
            audioRecorder.startRecording()
        }
    }
    
    private func stopRecordingTap() {
        gestureActive = false
        if !recordingLocked {
            audioRecorder.stopRecording()
        }
        recordingTime = 0
    }
    
    private func leftSwipeToDeleteGesture() -> _EndedGesture<_ChangedGesture<DragGesture>> {
        return DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({ value in
                self.leftSwipeOnChange(value)
            })
            .onEnded({ value in
                self.checkForUpdates = true
            })
    }
    
    private func swipeUpToLockGesture() -> _ChangedGesture<DragGesture> {
        return DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({ value in
                if self.checkForUpdates {
                    let distance = value.startLocation.y - value.location.y
                    
                    if value.startLocation.y > value.location.y {
                        self.upswipeOffset = distance
                        
                        if distance >= self.upswipeMax {
                            self.upswipeOffset = self.upswipeMax
                            self.checkForUpdates = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                self.upswipeOffset = 0
                                self.recordingLocked = true
                            }
                            // ShowLock and Lockanimation
                            
                            // Stop showing leftswipeToDelete
                        }
                    }
                }
            })
    }
    
    private func leftSwipeOnChange(_ value: DragGesture.Value) {
        // Get swipe distance to left
        if checkForUpdates {
            let distance = value.startLocation.x - value.location.x
            if value.startLocation.x > value.location.x {
                leftSwipeOffset = distance
                
                if distance >= leftSwipeMax {
                    // MARK: Delete recording muss hier auch eingebaut werden
                    audioRecorder.stopRecording()
                    showTrash = true
                    checkForUpdates = false
                    cancelOnEnded = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        self.leftSwipeOffset = 0
                        self.showTrash = false
                    }
                } else if distance >= leftSwipeMax - 50 {
                    showTrash = true
                } else {
                    showTrash = false
                }
                
            } else {
                leftSwipeOffset = 0
            }
        }
    }
    
    private func setUpCombine() {
        audioRecorder.$player
            .sink { player in
                self.showPlayer = player != nil
            }
            .store(in: &cancellables)
        
        audioRecorder.$recording
            .assign(to: \.recording, on: self)
            .store(in: &cancellables)
    }
}
