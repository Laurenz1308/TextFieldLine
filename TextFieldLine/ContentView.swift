import SwiftUI

struct ContentView: View {
    
    @StateObject var chatInputViewModel = ChatInputViewModel(chatId: "test")
    @ObservedObject var keyboardResponder = KeyboardResponder()
    
    
    var messages = ["Hallo", "Ja", "Nein", "Passt", "perfekt", "bis morgen", "ja", "gut", "Warum?", "Depp"]
    
    var body: some View {
        
        ZStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                ForEach(messages, id: \.self) { message in
                    MessageRow(message: message)
                }
            })
            .disabled(chatInputViewModel.recording)
            
            
            if chatInputViewModel.recording {
                Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: "lock.circle.fill")
                            .font(.largeTitle)
                            .overlay(Circle().strokeBorder(lineWidth: 1.5).foregroundColor(.black))
                            .background(Circle().foregroundColor(.white))
                            .padding(.trailing, 15)
                            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0))
                            .scaleEffect(chatInputViewModel.recordingLocked ? 1.2 : 1)
                    }
                    .padding(.bottom, 70)
                }
            }
            
            
            if chatInputViewModel.showPlayer {
                VStack {
                    Spacer()
                    HStack {
                        // Delete Recording
                        Button(action: chatInputViewModel.audioRecorder.deleteDefaultStoredFile) {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red)
                        }
                        
                        HStack(spacing: 10) {
                            InputRowAudioPlayer(
                                audioRecorder: chatInputViewModel.audioRecorder
                            )
                            
                            // Send recording
                            Button(action: {}, label: {
                                Image(systemName: "paperplane.circle.fill")
                                    .font(.title)
                                    .animation(.easeInOut)
                                    .foregroundColor(.black)
                                    .transition(.opacity)
                            })
                        }
                        .padding(.vertical, 2)
                        .padding(.horizontal, 2)
                        .overlay(RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder(lineWidth: 1.5)
                                .foregroundColor(.black))
                    }
                    .padding(.top, 5)
                    .padding(.horizontal, 10)
                    .frame(height: 45, alignment: .center)
                    .background(Color.secondary
                                    .edgesIgnoringSafeArea(.bottom))
                }
            } else {
                VStack {
                    Spacer()
                    ChatInputRow(chatInputViewModel: chatInputViewModel)
                }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
