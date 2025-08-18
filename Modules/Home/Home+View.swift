//
//  Home+View.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 17/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension Home {
    struct ContentView: View {
        @Bindable var store: StoreOf<Feature>
        
        var body: some View {
            VStack {
                Text("Home Module")
                    .font(.title)
            }
            .padding()
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
} 