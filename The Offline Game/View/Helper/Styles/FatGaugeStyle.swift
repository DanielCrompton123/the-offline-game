//
//  FatGaugeView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/31/24.
//

import SwiftUI


struct FatGaugeStyle: GaugeStyle {
    var isTall = false
    var cornerRadius: CGFloat = 18

    func makeBody(configuration: Configuration) -> some View {
        let height: CGFloat = isTall ? 50 : 25
        
        GeometryReader { geom in
            let width: CGFloat = geom.size.width * configuration.value
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.thinMaterial)
                
                UnevenRoundedRectangle(bottomTrailingRadius: cornerRadius, topTrailingRadius: cornerRadius)
                    .foregroundStyle(.accent)
                    .frame(width: width)
                
                Group {
                    label(configuration: configuration)
                        .foregroundStyle(.accent)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
                    label(configuration: configuration)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .mask(alignment: .leading) {
                            UnevenRoundedRectangle(bottomTrailingRadius: cornerRadius, topTrailingRadius: cornerRadius)
                                .frame(width: width)
                        }
                }
                .compositingGroup()
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
            
        }
        .frame(height: height)
    }
    
    @ViewBuilder private func label(configuration: Configuration) -> some View {
        if isTall {
            HStack {
                configuration.label
                    .labelStyle(.iconOnly)
                Spacer(minLength: 0)
                configuration.currentValueLabel
            }
            .padding(.horizontal)
        }
    }
    
}


#Preview {
    Gauge(value: 0.9) {
        Label("Offline Progress", systemImage: "star.fill")
    } currentValueLabel: {
        Text("7Hrs")
            .bold()
    }
    .gaugeStyle(FatGaugeStyle(isTall: true))
    .padding()

}
