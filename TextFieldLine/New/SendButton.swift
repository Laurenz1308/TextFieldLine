//
//  SendButton.swift
//  TextFieldLine
//
//  Created by Lori Hill on 14.09.21.
//

import SwiftUI

struct SendButton: View {
    
    @ObservedObject var chatInputViewModel: ChatInputViewModel
    
    var body: some View {
        VStack {
            Spacer(minLength: 0)
            
            if chatInputViewModel.messsage.isEmpty && chatInputViewModel.imageList.isEmpty {
                
                if chatInputViewModel.recordingLocked {
                    Button(action: chatInputViewModel.stopButtonTapped, label: {
                        Image(systemName: "stop.circle.fill")
                            .font(.title)
                            .animation(.easeInOut)
                            .foregroundColor(.red)
                            .transition(.opacity)
                            .padding(.trailing, 2)
                    })

                } else {
                    Image(systemName: "waveform.circle")
                        .font(.title)
                        .animation(.easeInOut)
                        .gesture(chatInputViewModel.mainGesture())
                        .foregroundColor(chatInputViewModel.recording ? .red : .black)
                        .opacity(chatInputViewModel.gestureActive ? 0.7 : 1)
                        .scaleEffect(chatInputViewModel.gestureActive ? 0.8 : 1)
                        .transition(.opacity)
                        .padding(.trailing, 2)
                }
                
            } else {
                Button(action: {}, label: {
                    Image(systemName: "paperplane.circle.fill")
                        .font(.title)
                        .animation(.easeInOut)
                        .foregroundColor(.black)
                        .transition(.opacity)
                })
                .padding(.trailing, 2)
            }
        }
        .padding(.bottom, 2)
    }
}

struct SendButton_Previews: PreviewProvider {
    static var previews: some View {
        SendButton(chatInputViewModel: ChatInputViewModel(chatId: ""))
    }
}
