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
            Group {
                if let destination = store.destination {
                    switch destination {
                    case .authentication:
                        Authentication.ContentView(
                            store: store.scope(
                                state: \.destination?.authentication,
                                action: \.destination.authentication
                            )!
                        )
                    case .home:
                        Home.ContentView(
                            store: store.scope(
                                state: \.destination?.home,
                                action: \.destination.home
                            )!
                        )
                    }
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
} 