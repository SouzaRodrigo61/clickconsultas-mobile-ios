//
//  CPF+View.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension CPF {
    struct ContentView: View {
        @Bindable var store: StoreOf<Feature>
        
        var body: some View {
            VStack {
                Text("CPF Module")
                    .font(.title)
            }
            .padding()
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
} 