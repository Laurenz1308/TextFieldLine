import SwiftUI

struct PulsatingMic: View {
    
    @State var animate = false
    
    var body: some View {
        Image(systemName: "mic.fill")
            .font(.title)
            .foregroundColor(.red)
            .opacity(animate ? 0.6 : 1)
            .scaleEffect(animate ? 0.9 : 1)
            .onAppear{ animate.toggle() }
            .animation(Animation.linear(duration: 1.7).repeatForever(autoreverses: true))
    }
}

struct PulsatingMic_Previews: PreviewProvider {
    static var previews: some View {
        PulsatingMic()
    }
}
