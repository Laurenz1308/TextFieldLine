import SwiftUI

struct WrappedTextView: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    let textDidChange: (UITextView) -> Void
    var cursorColor = UIColor.blue

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isEditable = true
        view.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        view.backgroundColor = .white
        view.delegate = context.coordinator
        view.tintColor = cursorColor
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = self.text
        uiView.tintColor = cursorColor
        DispatchQueue.main.async {
            self.textDidChange(uiView)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, textDidChange: textDidChange)
    }
    
    func hideCursor(shouldHide: Bool) -> WrappedTextView {
        var view = self
        if shouldHide {
            view.cursorColor = .clear
        } else {
            view.cursorColor = .blue
        }
        return view
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        let textDidChange: (UITextView) -> Void

        init(text: Binding<String>, textDidChange: @escaping (UITextView) -> Void) {
            self._text = text
            self.textDidChange = textDidChange
        }

        func textViewDidChange(_ textView: UITextView) {
            self.text = textView.text
            self.textDidChange(textView)
        }
    }
}
