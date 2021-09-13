//
//  ShimmerText.swift
//  ShimmerText
//
//  Created by Lori Hill on 07.08.21.
//

import SwiftUI

struct ShimmerText: View {
    
    @State var show = false
    
    var body: some View {
        
        ZStack {
            HStack {
                Text("Wischen zum Abbrechen")
                    .bold()
                    .opacity(0.3)
                    .foregroundColor(.black)
                
                Image(systemName: "chevron.left")
                    .opacity(0.3)
                    .foregroundColor(.black)
            }
            
            HStack {
                Text("Wischen zum Abbrechen")
                    .bold()
                    .opacity(0.7)
                    .foregroundColor(.black)
                
                Image(systemName: "chevron.left")
                    .opacity(0.7)
                    .foregroundColor(.black)
            }
            .mask(
            Capsule()
                .fill(LinearGradient(gradient: .init(colors: [.clear, .black, .clear]), startPoint: .top, endPoint: .bottom))
                .rotationEffect(.degrees(30))
                .offset(x: show ? -130 : 180))
            
        }
        .onAppear {
            withAnimation(Animation.default.speed(0.2).delay(0).repeatForever(autoreverses: false)) {
                show.toggle()
            }
        }
        
    }
    
}

struct ShimmerText_Previews: PreviewProvider {
    static var previews: some View {
        ShimmerText()
    }
}
