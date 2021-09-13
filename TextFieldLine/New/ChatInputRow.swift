import SwiftUI

struct ChatInputRow: View {
    
    @ObservedObject var chatInputViewModel: ChatInputViewModel
    
    // WrappedTextView
    let minHeight: CGFloat = 35
    @State private var textViewHeight: CGFloat?
        
    // Recorder
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(spacing: 0) {
            
            if chatInputViewModel.recording {
                PulsatingMic()
                    .padding(.horizontal, 10)
                    .padding(.bottom, 7)

                
                Text(formatTime(chatInputViewModel.recordingTime))
                    .onReceive(timer, perform: { _ in
                        if chatInputViewModel.recording {
                            chatInputViewModel.recordingTime += 1
                        }
                    })
                    .padding(.bottom, 7)
            } else {
                VStack {
                    Spacer(minLength: 0)
                    
                    ImagePickerControl()
                }
                .padding(.bottom, 7)
            }
            
            if chatInputViewModel.recording && !chatInputViewModel.recordingLocked {
                Spacer()
                ShimmerText()
            } else {
                Spacer()
            }
            
            HStack(spacing: 5) {
                if !chatInputViewModel.recording {
                    WrappedTextView(text: $chatInputViewModel.messsage, textDidChange: textDidChange(_:))
                        .frame(height: textViewHeight ?? minHeight, alignment: .center)
                        .padding(.leading, 16)
                }
                
                VStack {
                    Spacer(minLength: 0)
                    
                    if chatInputViewModel.messsage.isEmpty {
                        
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
                        Button(action: {sendMessage()}, label: {
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
            .frame(height: textViewHeight ?? minHeight, alignment: .center)
            .overlay(RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(lineWidth: 1.5)
                        .foregroundColor(chatInputViewModel.recording ? .clear : .black))
            .background(RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(chatInputViewModel.recording ? .clear : .white))
            .padding(.trailing, 10)
            
        }
        .frame(height: (textViewHeight ?? minHeight) + 10, alignment: .center)
        .background(Color.secondary
                        .edgesIgnoringSafeArea(.bottom))
    }
    
    private func textDidChange(_ textView: UITextView) {
        let newHeight = max(textView.contentSize.height, minHeight)
        self.textViewHeight = min(newHeight, 150)
    }
    
    private func sendMessage() {
        chatInputViewModel.messsage = ""
    }
    
    private func formatTime(_ value: Double) -> String {
        let min = Int(value) / 60
        let sec = Int(value) % 60
        return String(format: "%02i:%02i", min, sec)
    }
    
}

struct ChatInputRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatInputRow(chatInputViewModel: ChatInputViewModel(chatId: "test"))
    }
}
