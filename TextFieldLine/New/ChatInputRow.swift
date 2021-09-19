import SwiftUI

struct ChatInputRow: View {
    
    @ObservedObject var chatInputViewModel: ChatInputViewModel
    
    // WrappedTextView
    let minHeight: CGFloat = 35
    @State private var textViewHeight: CGFloat?
        
    // Recorder
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var textFieldHeight: CGFloat {
        var value = textViewHeight ?? minHeight
        if chatInputViewModel.imageList.count > 0 {
            value += 70
        }
        return value
    }
    
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
                    ImagePickerControl(imageSet: $chatInputViewModel.imageList)
                        .padding([.top, .leading], 5)
                        .animation(.easeInOut)
                }
                .padding(.bottom, 7)
            }
            
            if chatInputViewModel.recording && !chatInputViewModel.recordingLocked {
                Spacer()
                ShimmerText()
            } else {
                Spacer()
            }
            
            VStack {
                Spacer(minLength: 0)
                if chatInputViewModel.imageList.count > 0 {
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        HStack {
                            ForEach(chatInputViewModel.imageList) { image in
                                Image(uiImage: image.image)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                        }
                    })
                    .frame(height: 60)
                    .padding(.horizontal, 10)
                    .padding(.top, 5)
                    
                    Divider()
                }
                
                HStack(spacing: 5) {
                    WrappedTextView(text: $chatInputViewModel.messsage, textDidChange: textDidChange(_:))
                        .hideCursor(shouldHide: chatInputViewModel.recording && !chatInputViewModel.recordingLocked)
                        .frame(height: textViewHeight ?? minHeight, alignment: .center)
                        .padding(.leading, 16)
                    
                    SendButton(chatInputViewModel: self.chatInputViewModel)
                }
            }
            .frame(height: textFieldHeight, alignment: .center)
            .overlay(RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(lineWidth: 1.5)
                        .foregroundColor(chatInputViewModel.recording ? .clear : .black))
            .background(RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(chatInputViewModel.recording ? .clear : .white))
            .padding(.trailing, 10)
            
        }
        .frame(height: textFieldHeight + 10, alignment: .center)
        .background(Color.white
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
