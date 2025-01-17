//
//  AttributionsView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/16/25.
//

import SwiftUI

struct AttributionsView: View {
    
    private let decoder = JSONDecoder()
    
    @State private var attributions: [AttributionModel] = []
    @State private var error = ""
    
    var body: some View {
        
        List(attributions, id: \.self) { attr in
            
            attributionRowContent(attr)
            
        }
        .navigationTitle("Attributions")
        .onAppear(perform: loadAttributions)
        .alert("Could not fetch attributions.", isPresented: $error.condition(\.isEmpty, inverse: true)) {
            
            Button("OK", role: .destructive) {
                error = ""
            }
            
        } message: {
            Text(error)
        }

    }
    
    
    private func loadAttributions() {
        
        do {
            guard let attributionsUrl = Bundle.main.url(forResource: "attributions", withExtension: "json") else {
                print("Could not get attributions.json file")
                return
            }
            
            let data = try Data(contentsOf: attributionsUrl)
            
            attributions = try decoder.decode([AttributionModel].self, from: data)
        } catch {
            
            self.error = error.localizedDescription
            
        }
    }
    
    
    @ViewBuilder private func attributionRowContent(_ attribution: AttributionModel) -> some View {
        Section {
            
            ForEach(attribution.attributions, id: \.self) { attribution in
                Text(attribution)
                    .font(.main14)
                    .padding(.vertical, 8)
            }
            
        } header: {
            Text(attribution.category)
                .font(.main26)
        }
    }
}

#Preview {
    AttributionsView()
}
