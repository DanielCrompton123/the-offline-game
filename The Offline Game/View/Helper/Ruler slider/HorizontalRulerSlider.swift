//
//  HorizontalRulerSlider.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 2/8/25.
//

import SwiftUI



struct HorizontalRulerSlider: View {
    
    @Binding var value: Double
    
    var range: ClosedRange<Double> = 0...100
    var spacing: Double = 4
    var steps: Double = 10
    
    
    var body: some View {
        
        ZStack {
            GeometryReader { geomProxy in
                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: spacing) {
                            
                            let values = Array(stride(from: range.lowerBound, through: range.upperBound, by: 1))
                            ForEach(values, id: \.self) { value in
                                
                                // placeholder
                                placeholderRuler(index: value)
                                    .scrollTransition(axis: .horizontal, transition: { content, phase in
                                    
                                        content
                                            .opacity(phase == .topLeading ? 1 : 1.8)
                                    })
                                    .overlay(alignment: .top) {
                                        // placeholder foreground
                                        if value.truncatingRemainder(dividingBy: steps) == 0 {
                                            Text(Int(value / 10).formatted())
                                                .font(.body.monospaced())
                                                .foregroundStyle(Int(value * 10) == Int(value) ? .accent : .secondary)
                                                .fixedSize()
                                                .scrollTransition(axis: .horizontal) { content, phase in
                                                    content
                                                        .opacity(phase.isIdentity ? 10 : 0.4)
                                                }
                                                .offset(y: 10)
                                        }
                                    }
//                                
                            }
                        }
                        .scrollTargetLayout()
                        
                        
                    }
                    .scrollIndicators(.hidden, axes: .horizontal)
                    
                    .safeAreaPadding(.horizontal, geomProxy.size.width / 2)
                    .scrollTargetBehavior(SnapScrollTargetBehaviour(step: spacing + 1))
                    .scrollPosition(id: Binding(get: {
                        value
                    }, set: { value in
                        if let value { self.value = value / 10 }
                    }))
                    .disablesBounces()
                    
                    .onChange(of: value, initial: true) { old, new in
                        if old == new {
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                scrollProxy.scrollTo(new * 10, anchor: .center)
                            }
                        }
                    }
                    
                    .overlay {
                        overlayIndicator
                    }
                }
            }
        }
        .sensoryFeedback(.selection, trigger: Int(value))
        
        
    }
    
    
    
    @ViewBuilder private func placeholderRuler(index: Double) -> some View {
        
        let isPrimary = index.truncatingRemainder(dividingBy: steps) == 0

        VStack(spacing: 10) {
            Spacer()
            Rectangle()
                .frame(width: 1, height: isPrimary ? 20 : 8)
                .frame(maxHeight: 20, alignment: .bottom)
        }
        
    }
    
    
    @ViewBuilder private var overlayIndicator: some View {
        Rectangle()
            .fill(.accent)
            .frame(width: 1)
    }
    
}



extension View {
    func disablesBounces() -> some View {
        modifier(DisablesBouncesModifier())
    }
}


fileprivate struct DisablesBouncesModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                UIScrollView.appearance().bounces = false
            }
            .onDisappear {
                UIScrollView.appearance().bounces = true
            }
    }
}



#Preview {
    @Previewable @State var value: Double = 1
    
    VStack {
        Text("Ruler slider SwiftUI")
        
        Spacer()
        
        Text(value, format: .number)
        
        HorizontalRulerSlider(value: $value, range: 0...200)
//            .accentColor(.)
            .frame(maxHeight: 56)
        
        Spacer()
    }
    .environment(\.layoutDirection, .rightToLeft)
}
