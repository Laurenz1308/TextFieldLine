//
//  KeyboardResponder.swift
//  SimpleChat
//
//  Created by Lori Hill on 25.04.21.
//

import Combine
import SwiftUI

final class KeyboardResponder: ObservableObject {

    private var cancellables: Set<AnyCancellable> = []
    
    @Published var height: CGFloat = 0
    
    init() {
        NotificationCenter
            .default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { (notification) in
                if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                    self.height = keyboardSize.height
                }
            }
            .store(in: &cancellables)
        
        NotificationCenter
            .default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { (notification) in
                self.height = 0
            }
            .store(in: &cancellables)
    }
    
}
