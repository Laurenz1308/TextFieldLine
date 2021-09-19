import SwiftUI

struct ImagePickerControl: View {
    
    @State var selected = false
    @State var isAnimated = false
    @Binding var imageSet: [ImageElement]
    
    @Namespace var buttonSlide
    
    var body: some View {
        HStack {
            
            if selected {
                Button(action: selectAction, label: {
                    Image(systemName: "xmark.circle")
                        .font(.title)
                        .animation(.easeInOut)
                        .foregroundColor(.black)
                        .padding(.leading, 5)
                })
            } else {
                ZStack {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.title2)
                        .animation(isAnimated ? .easeIn : .none)
                        .foregroundColor(.clear)
                        .matchedGeometryEffect(id: "ID2", in: buttonSlide)
                    
                    Button(action: selectAction, label: {
                        Image(systemName: "camera.circle.fill")
                            .font(.title)
                            .animation(isAnimated ? .easeIn : .none)
                            .foregroundColor(.black)
                    })
                    .matchedGeometryEffect(id: "ID", in: buttonSlide)
                }
            }
            
            if selected {
                Button(action: addImage, label: {
                    Image(systemName: "camera.circle.fill")
                        .font(.title)
                        .animation(isAnimated ? .easeInOut : .none)
                        .foregroundColor(.black)
                })
                    .matchedGeometryEffect(id: "ID", in: buttonSlide)
                
                Button(action: addImage, label: {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.title2)
                        .animation(.easeIn(duration: 0.1))
                        .padding(.trailing, 10)
                        .foregroundColor(.black)
                })
                    .matchedGeometryEffect(id: "ID2", in: buttonSlide)
            }
            
        }
        .animation(isAnimated ? .easeOut : .none)
        .overlay(RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(lineWidth: 1.5)
                    .foregroundColor(selected ? .black : .clear))
        .background(RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(selected ? .secondary : .clear)
                        .blur(radius: 2))
    }
    
    private func selectAction() {
        isAnimated = true
        withAnimation {
            selected.toggle()
        }
        isAnimated = false
    }
    
    private func addImage() {
        if imageSet.count < 6 {
            guard let image = UIImage(named: "Apple-Logo") else { return }
            imageSet.append(ImageElement(image: image))
        }
    }
    
}

struct ImagePickerControl_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            ImagePickerControl(imageSet: .constant([]))
                .padding(.leading, 10)
            Spacer()
        }
    }
}
