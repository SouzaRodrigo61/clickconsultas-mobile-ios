//
//  Root+Destination.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 18/08/2025.
//

import ComposableArchitecture

extension Root {
    @Reducer
    struct Destination {
        @ObservableState
        enum State: Equatable {
            case authentication(Authentication.Feature.State)
            case home(Home.Feature.State)
        }
        
        enum Action: Equatable {
            case authentication(Authentication.Feature.Action)
            case home(Home.Feature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.authentication, action: \.authentication) {
                Authentication.Feature()
            }
            Scope(state: \.home, action: \.home) {
                Home.Feature()
            }
        }
    }
}
