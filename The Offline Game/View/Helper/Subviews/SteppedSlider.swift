//
//  SteppedSlider.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 2/8/25.
//

import SwiftUI


struct AlignmentScrollTargetBehavior: ScrollTargetBehavior {
    
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        // We can get the size with container size
        // Then find the middle of the container
        // If the target's x-axis center is close to the center of the container then set it to the container center
        
        let halfWidth = target.rect.width / 2
        let containerHalfWidth = context.containerSize.width / 2
        let centerToContainerCenter = target.rect.midX.distance(to: containerHalfWidth)
        
        if centerToContainerCenter < halfWidth {
            
            let newMinX = (target.rect.minX + target.rect.midX) / 2
            target.rect = CGRect(
                origin: CGPoint(x: newMinX, y: target.rect.minY),
                size: target.rect.size
            )
        }
        
    }
    
}


extension ScrollTargetBehavior where Self == AlignmentScrollTargetBehavior {
    static func alignment() -> some ScrollTargetBehavior {
        AlignmentScrollTargetBehavior()
    }
}


struct SteppedSlider<Value: Strideable & BinaryFloatingPoint>: View {
    
    //MARK: - PROPERTIES
    struct StepProperty: Identifiable, Equatable {
        let id: UUID
        let range: ClosedRange<Value>
        let spacing: CGFloat
        let step: Value.Stride
        @ViewBuilder var marker: (Value) -> AnyView
        
        static func ==(lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
        
        init<Content: View>(
            range: ClosedRange<Value>,
            spacing: CGFloat,
            step: Value.Stride,
            @ViewBuilder marker: @escaping (Value) -> Content
        ) {
            self.id = UUID()
            self.range = range
            self.spacing = spacing
            self.step = step
            self.marker = { value in AnyView(marker(value)) } // To convert (V)->Content to (V)->AnyView
        }
        
        init(
            range: ClosedRange<Value>,
            spacing: CGFloat,
            step: Value.Stride,
            // properties to help create the marker
            color: Color = .black,
            font: Font = .body,
            markerSize: CGSize = CGSize(width: 1, height: 20)
        ) {
            self.id = UUID()
            self.range = range
            self.spacing = spacing
            self.step = step
            
            self.marker = { value in AnyView(
                VStack {
                    Capsule()
                        .frame(width: markerSize.width, height: markerSize.height)
                    
                    Text(value.formatted())
                        .font(font)
                        .fixedSize()
                        .frame(width: 0)
                }
                    .foregroundStyle(color)
            )}
            
        }
        
        var values: [Value] {
            Array(stride(from: range.lowerBound, through: range.upperBound, by: step))
        }
        
        func isLastValue(_ value: Value) -> Bool {
            value == range.upperBound
        }
    }
    
    
    
    //MARK: - Initialization properties
    
    @Binding var value: Value
    
    // The properties encapsulate the range and attributes
    var properties: [StepProperty]
    var alignment: VerticalAlignment
    
    
    // Initialization with a single range
    init(value: Binding<Value>, range: ClosedRange<Value>, spacing: CGFloat, step: Value.Stride, alignment: VerticalAlignment = .center) {
        
        self._value = value
        self.alignment = alignment
        
        self.properties = [
            StepProperty(range: range, spacing: spacing, step: step)
        ]
        
    }
    
    
    // Create with multiple ranges each with different properties
    init(value: Binding<Value>, properties: [StepProperty], alignment: VerticalAlignment = .center) {
        self._value = value
        self.properties = properties
        self.alignment = alignment
    }
    
    
    
    //MARK: - MAIN
    
    var body: some View {
        
        GeometryReader { geomProxy in
            // geomProxy used for the safe area padding
            
            ScrollView(.horizontal) {
                
                propertyList(geomProxy: geomProxy)
//                    .safeAreaPadding(.horizontal, geomProxy.size.width / 2)
                
            }
            .scrollIndicators(.hidden, axes: .horizontal)
//            .scrollTargetBehavior(.viewAligned)
            .scrollTargetBehavior(.alignment())
                
        }
    }
    
    
    @ViewBuilder private func propertyView(_ property: StepProperty) -> some View {
        
        // For each property create another HStack with correct spacing, and markers
        LazyHStack(alignment: alignment, spacing: /*property.spacing*/ 0) {
            
            // Now loop through the range to get all the values, and get the marker
            ForEach(property.values, id: \.self) { value in
                
                // IF this is the last value of the A range BUT this is NOT the last range
                //      Don't display it since it will be included in the next range
                
                if !property.isLastValue(value) || properties.last == property {
                    property.marker(value)
                        .frame(width: property.spacing)
                }
                
            }
            
        }
        .scrollTargetLayout()
        .padding(.trailing, properties.last == property ? 0 : property.spacing)
        
    }
    
    
    @ViewBuilder private func propertyList(geomProxy: GeometryProxy) -> some View {
        
        // Contains all the other HStacks for the properties
        // It has no spacing -- spacing is added as padding by other properties
        LazyHStack(alignment: alignment, spacing: 0) {
                        
            // Loop through the properties
            ForEach(properties) { property in
                propertyView(property)
            }
            
        }
    }

}




#Preview {
    
    @Previewable @State var value = 10.0
    
    
    VStack(spacing: 30) {
        
        Circle()
            .frame(width: 20, height: 20)
        
//        SteppedSlider(value: $value, range: 0.0...10.0, spacing: 40, step: 1.0)
        
        SteppedSlider(value: $value, properties: [
            .init(range: 0.0...25.0, spacing: 20, step: 1, color: .red),
            .init(range: 25.0...50.0, spacing: 30, step: 5, color: .blue),
            .init(range: 50.0...100.0, spacing: 50, step: 10, color: .pink)
        ])
            .frame(height: 50)
        
        Button("50") {
            value = 50
        }
    }
}



#Preview("VIEW ALIGNED") {
    ScrollView(.horizontal) {
        LazyHStack {
            
            ForEach([Color.green, Color.red], id: \.self) { col in
                LazyHStack {
                    ForEach(0..<5) { number in
                        Text(verbatim: String(number))
                            .frame(width: 150, height: 150)
                            .background(col)
                        
                    }
                }
                .scrollTargetLayout()
            }
        }
    }
    .scrollTargetBehavior(.viewAligned)
}
