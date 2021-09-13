import SwiftUI

struct ImagePickerControl: View {
    
    @State var selected = false
    
    @Namespace var buttonSlide
    
    var body: some View {
        HStack {
            
            if selected {
                Button(action: selectAction, label: {
                    Image(systemName: "xmark.circle")
                        .font(.title)
                        .animation(.easeInOut)
                        .foregroundColor(.black)
                })
            } else {
                ZStack {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.title2)
                        .animation(.easeInOut)
                        .foregroundColor(.clear)
                        .matchedGeometryEffect(id: "ID2", in: buttonSlide)
                    
                    Button(action: selectAction, label: {
                        Image(systemName: "camera.circle.fill")
                            .font(.title)
                            .animation(.easeInOut)
                            .foregroundColor(.black)
                    })
                    .matchedGeometryEffect(id: "ID", in: buttonSlide)
                }
            }
            
            if selected {
                Button(action: {}, label: {
                    Image(systemName: "camera.circle.fill")
                        .font(.title)
                        .animation(.easeInOut)
                        .foregroundColor(.black)
                })
                    .matchedGeometryEffect(id: "ID", in: buttonSlide)
                
                Button(action: {}, label: {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.title2)
                        .animation(.easeIn(duration: 0.1))
                        .padding(.trailing, 10)
                        .foregroundColor(.black)
                })
                    .matchedGeometryEffect(id: "ID2", in: buttonSlide)
            }
            
        }
        .animation(.easeOut)
        .overlay(RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(lineWidth: 1.5)
                    .foregroundColor(selected ? .black : .clear))
        .background(RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(selected ? .secondary : .clear)
                        .blur(radius: 2))
    }
    
    private func selectAction() {
        withAnimation {
            selected.toggle()
        }
    }
    
}

struct ImagePickerControl_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            ImagePickerControl()
                .padding(.leading, 10)
            Spacer()
        }
    }
}
