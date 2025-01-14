//
//  ToastView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/11/25.
//

import SwiftUI

struct ToastViewModifier<InnerView: View>: ViewModifier {
    @Binding var isPresented: Bool
    var edge = VerticalEdge.bottom
    var duration: TimeInterval = 3
    @ViewBuilder var label: () -> InnerView
    
    @State private var offset: CGFloat = 0
    
    private var alignment: Alignment {
        edge == .top ? .top : .bottom
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: alignment) {
            content
            
            // TOAST
            if isPresented {
                HStack {
                    Image(systemName: "xmark")
                        .foregroundStyle(.secondary)
                    label()
                }
                .onTapGesture {
                    withAnimation(.easeOut) {
                        isPresented = false
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(.regularMaterial, in: .rect(cornerRadius: 12))
                .padding(.horizontal)
                
                .delay(time: .now() + duration) {
                    withAnimation(.easeOut) {
                        isPresented = false
                    }
                }
                
                .transition(.asymmetric(
                    insertion: .move(edge: edge == .top ? .top : .bottom),
                    removal: .opacity))
                .animation(.bouncy(duration: 0.3, extraBounce: 0.2)/*, value: isPresented*/) // The value parameter stops it animating in
                .zIndex(1) // We need the zIndex to see the animation out
            }
        }
        .frame(maxHeight: .infinity)
    }
}


extension View {
    @ViewBuilder func toast<InnerView: View>(
        isPresented: Binding<Bool>,
        edge: VerticalEdge = VerticalEdge.bottom,
        duration: TimeInterval = 3,
        @ViewBuilder label: @escaping () -> InnerView
    ) -> some View {
        modifier(ToastViewModifier(isPresented: isPresented, edge: edge, duration: duration, label: label))
    }
}


#Preview {
    @Previewable @State var p = false
    
    List {
        Button("Toast") {
            p = true
        }
        ForEach(0..<30) { i in
            Text("\(i)")
        }
    }
    .toast(isPresented: $p, edge: .bottom) {
        VStack {
            Label("Warning Ex Nisi Est Animi Cupiditate Quaerat Odit Magni Eius Et", systemImage: "app.badge")
            Button("Hello") {
                
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
