//
//  InputRowAudioPlayer.swift
//  SimpleChat
//
//  Created by Lori Hill on 12.08.21.
//

import SwiftUI

struct InputRowAudioPlayer: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
//    @Binding var isPlaying: Bool
//    @Binding var currentPlayingTime: Double
//    var totalDuration: Double
//    var playingAction: (() -> Void)?
    private let timer = Timer.publish(every: 0.11, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { g in
            HStack {
                Button(action: audioRecorder.handlePlayPause, label: {
                    Image(systemName: audioRecorder.isPlaying ? "pause.fill" : "play.fill")
                })
                .foregroundColor(.black)
                
                Text("\(formatTime(audioRecorder.currentPlayingTime))")
                    .onReceive(timer, perform: { _ in
                        if audioRecorder.isPlaying && audioRecorder.currentPlayingTime < audioRecorder.totalDuration {
                            audioRecorder.currentPlayingTime += 0.1
                        }
                        
                        if audioRecorder.isPlaying && audioRecorder.currentPlayingTime >= audioRecorder.totalDuration {
                            audioRecorder.isPlaying = false
                            audioRecorder.currentPlayingTime = 0
                        }
                    })
                
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.black.opacity(0.1))
                        .frame(width: g.size.width * 0.7,
                               height: 8,
                           alignment: .leading)
                    
                    Capsule()
                        .fill(Color.red)
                        .frame(width: getWidthForPlayer(with: g.size.width * 0.7),
                               height: 8,
                           alignment: .leading)
                        .gesture(DragGesture()
                                    .onChanged({ value in
                                        let x = value.location.x
                                        let maxWidth = g.size.width * 0.7
                                        
                                        let percentOfWidth = max(x, 0) / maxWidth
                                        audioRecorder.currentPlayingTime = Double(percentOfWidth) * audioRecorder.totalDuration
                                    })
                                    .onEnded({ value in
                                        audioRecorder.player?.currentTime = audioRecorder.currentPlayingTime
                                    }))
                }
            }
            .position(x: g.frame(in: .local).midX, y: g.frame(in: .local).midY)
        }
//        .onAppear {
//
//            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (_) in
//                if audioRecorder.isPlaying && audioRecorder.currentPlayingTime < audioRecorder.totalDuration {
//                    audioRecorder.currentPlayingTime += 0.01
//                }
//
//                if audioRecorder.isPlaying && audioRecorder.currentPlayingTime >= audioRecorder.totalDuration {
//                    audioRecorder.isPlaying = false
//                    audioRecorder.currentPlayingTime = 0
//                }
//            }
//
//        }
        .frame(height: 30)
    }
    
    func getWidthForPlayer(with maxWidth: CGFloat) -> CGFloat {
        let currentPecantage = audioRecorder.currentPlayingTime / audioRecorder.totalDuration
        return maxWidth * CGFloat(currentPecantage)
    }
    
    private func formatTime(_ value: Double) -> String {
        let min = Int(value) / 60
        let sec = Int(value) % 60
        return String(format: "%02i:%02i", min, sec)
    }
    
}

struct InputRowAudioPlayer_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapperView()
    }
    
    struct PreviewWrapperView: View {
        @State var isPlaying = false
        @State var playingTime: Double = 1
        var body: some View {
            InputRowAudioPlayer(audioRecorder: AudioRecorder(chatId: "")
//                                ,
//                                isPlaying: $isPlaying,
//                                currentPlayingTime: $playingTime,
//                                totalDuration: 5.0,
//                                playingAction: {isPlaying.toggle()}
            )
        }
    }
    
}
