//
//  Root+View.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 18/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension Root {
    struct ContentView: View {
        @Bindable var store: StoreOf<Feature>
        
        var body: some View {
            VStack {
                Text("Root Module")
                    .font(.title)
            }
            .padding()
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
} 