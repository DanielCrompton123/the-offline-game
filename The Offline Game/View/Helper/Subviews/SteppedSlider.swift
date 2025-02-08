//
//  SteppedSlider.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 2/8/25.
//

import SwiftUI

struct SteppedSlider<Value: Strideable & BinaryFloatingPoint>: View {
    
    //MARK: - PROPERTIES
    struct StepProperty {
        let range: Range<Value>
        let spacing: CGFloat
        let step: Value
        @ViewBuilder var marker: (Value) -> AnyView
        
        init<Content: View>(range: Range<Value>, spacing: CGFloat, step: Value, @ViewBuilder marker: @escaping (Value) -> Content) {
            self.range = range
            self.spacing = spacing
            self.step = step
            self.marker = { value in AnyView(marker(value)) } // To convert (V)->Content to (V)->AnyView
        }
        
        init(range: Range<Value>, spacing: CGFloat, step: Value, color: Color = .black, font: Font = .body, markerSize: CGSize = CGSize(width: 1, height: 20)) {
            self.range = range
            self.spacing = spacing
            self.step = step
            self.marker = { value in AnyView(
                VStack {
                    Capsule()
                        .frame(width: markerSize.width, height: markerSize.height)
                    
                    Text(value.formatted())
                        .font(font)
                }
                    .foregroundStyle(color)
            )}
        }
    }
    
    
    
    //MARK: - Initialization properties
    
    @Binding var value: Value
    var range: ClosedRange<Value>
    var step: Value.Stride
    var properties: [StepProperty]? = nil
    // Defaults
    var alignment = VerticalAlignment.center
    
    
    
    //MARK: - MAIN
    
    var body: some View {
        
        GeometryReader { geomProxy in
            ScrollView(.horizontal) {
                
                LazyHStack(alignment: alignment, spacing: 20) {
                    
                    let values = stride(from: range.lowerBound, through: range.upperBound, by: step)
                    ForEach(Array(Array(values).enumerated()), id: \.offset) { index, value in
                        
                        VStack {
                            Capsule()
                                .frame(width: 2, height: nil)
                            Text(value.formatted())
                        }
                    }
                    
                }
                .safeAreaPadding(.horizontal, geomProxy.size.width / 2)
                
            }
            .scrollIndicators(.hidden, axes: .horizontal)
        }
    }
}




#Preview {
    
    @Previewable @State var value = 10.0
    
    
    VStack(spacing: 30) {
        
        Circle()
            .frame(width: 20, height: 20)
        
        SteppedSlider(value: $value, range: 0.0...100.0, step: 1.0)
            .frame(height: 50)
    }
}
