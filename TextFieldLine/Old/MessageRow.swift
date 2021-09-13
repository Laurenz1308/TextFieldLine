import SwiftUI

struct MessageRow: View {
    
    var message: String
    var isSendByUser = Bool.random()
    
    var body: some View {
        HStack(spacing: 0) {
            
            if isSendByUser {
                Spacer()
            }
            
            VStack(alignment: isSendByUser ? .trailing : .leading, spacing: 10) {
                Text(message)
                
                HStack {
                    Text(Date(), style: .time)
                        .font(.caption)
                        .foregroundColor(Color(UIColor.lightGray))
                }
            }
            .padding([.horizontal, .top])
            .padding(.bottom, 8)
            .background(isSendByUser ? Color.blue : Color.gray.opacity(0.4))
            .clipShape(ChatBubble(corners: isSendByUser ? [.topLeft, .topRight, .bottomLeft]
                                    : [.topLeft, .topRight, .bottomRight]))
            .foregroundColor(isSendByUser ? .white : .primary)
            .frame(width: UIScreen.main.bounds.width - 150, alignment: isSendByUser ? .trailing : .leading)
            .padding(.horizontal, 15)
            
            if !isSendByUser {
                Spacer()
            }
            
        }
    }
    
}
