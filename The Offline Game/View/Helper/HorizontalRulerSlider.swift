//
//  HorizontalRulerSlider.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 2/8/25.
//

import SwiftUI



struct SnapScrollTargetBehaviour: ScrollTargetBehavior {
    let step: Double
    
    
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        
        let oldX = target.rect.origin.x
        
        target.rect.origin.x = closestMultiple(a: oldX, b: step)
        
    }
    
    
    fileprivate func closestMultiple(a: Double, b: Double) -> Double {
        let lowerMultiple = floor(a / b) * b
        let upperMultiple = lowerMultiple + b
        
        return abs(a - lowerMultiple) <= abs(a - upperMultiple) ? lowerMultiple : upperMultiple
    }
    
}



extension ScrollTargetBehavior where Self == SnapScrollTargetBehaviour {
    
    static func snap(step: Double) -> some ScrollTargetBehavior {
        SnapScrollTargetBehaviour(step: step)
    }
    
}



struct HorizontalRulerSlider: View {
    
    @Binding var value: Double
    
    var range: ClosedRange<Double>
    var step: Double
    var spacing: Double = 20
    @ViewBuilder var marker: (Double) -> AnyView
    
    init<Marker: View>(value: Binding<Double>, range: ClosedRange<Double>, step: Double, spacing: Double = 20, @ViewBuilder marker: @escaping (Double) -> Marker) {
        self._value = value
        self.range = range
        self.step = step
        self.spacing = spacing
        
        self.marker = { AnyView(marker( $0 )) }
    }
    
    init(value: Binding<Double>, range: ClosedRange<Double>, step: Double, spacing: Double = 20) {
        self._value = value
        self.range = range
        self.step = step
        self.spacing = spacing
        
        self.marker = { value in
            AnyView(
                VStack {
                    Capsule()
                        .frame(width: 1)
                    
                    Text(value.formatted())
                        .fixedSize()
                        .frame(width: 0)
                }
            )
        }
    }
    
    
    var body: some View {
        
        GeometryReader { geomProxy in
            ScrollViewReader { scrollProxy in
                    
                valuesList()
                    .safeAreaPadding(.horizontal, geomProxy.size.width / 2)
                    .scrollTargetBehavior(.snap(step: spacing + 1))
                    .scrollPosition(id: Binding(get: {
                        value
                    }, set: { value in
                        if let value { self.value = value }
                    }))
                    
                    .onChange(of: value, initial: true) { old, new in
                        if old == new {
                            scrollProxy.scrollTo(min(new, range.upperBound), anchor: .center)
                        }
                    }
            }
        }
        
        .sensoryFeedback(.selection, trigger: Int(value))
        
    }
    
    
    @ViewBuilder private func valuesList() -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: spacing) {
                
                let values = Array(stride(from: range.lowerBound, through: range.upperBound, by: step))
                
                ForEach(values, id: \.self) { value in
                    marker(value)
                }
            }
            .scrollTargetLayout()
            
        }
        .scrollIndicators(.hidden, axes: .horizontal)

    }
}



#Preview {
    @Previewable @State var value: Double = 0
    
    VStack {
        Text("Ruler slider SwiftUI")
        
        Spacer()
        
        Text(value, format: .number)
        
        HorizontalRulerSlider(value: $value, range: 0...10, step: 1)
            .frame(height: 100)
        
        Spacer()
        
        Button("1") {
            withAnimation {
                value = 1
            }
        }
        Button("50") {
            value = 50
        }
    }
}
