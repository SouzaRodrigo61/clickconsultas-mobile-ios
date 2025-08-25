//
//  Root+Feature.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 18/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension Root {
    @Reducer
    struct Feature {
        @ObservableState
        struct State: Equatable {
            var isAuthenticated: Bool = false
            @Presents var destination: Destination.State?
        }
        
        enum Action: Equatable {
            case onAppear
            case authenticationSucceeded
            case logoutRequested
            case destination(Destination.Action)
        }
        
        var body: some ReducerOf<Self> {
            Reduce { state, action in
                switch action {
                case .onAppear:
                    // TODO: Verificar se usuário está logado (implementar persistência)
                    // Por enquanto, sempre começa não autenticado
                    state.isAuthenticated = false
                    state.destination = .authentication(Authentication.Feature.State())
                    return .none
                    
                case .authenticationSucceeded:
                    state.isAuthenticated = true
                    state.destination = .home(Home.Feature.State())
                    return .none
                    
                case .logoutRequested:
                    state.isAuthenticated = false
                    state.destination = .authentication(Authentication.Feature.State())
                    return .none
                    
                case .destination(.authentication(.loginSucceeded)):
                    state.isAuthenticated = true
                    state.destination = .home(Home.Feature.State())
                    return .none
                    
                case .destination(.home(.logoutTapped)):
                    state.isAuthenticated = false
                    state.destination = .authentication(Authentication.Feature.State())
                    return .none
                    
                case .destination:
                    return .none
                }
            }
            .ifLet(\.destination, action: \.destination) {
                Destination()
            }
        }
    }
} 
