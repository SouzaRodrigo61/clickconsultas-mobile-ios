//
//  Home+Feature.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 17/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension Home {
    @Reducer
    struct Feature {
        @ObservableState
        struct State: Equatable {
            var userName: String = "Usuário"
            var isLoading: Bool = false
        }
        
        enum Action: Equatable {
            case onAppear
            case logoutTapped
            case searchTapped
            case profileTapped
        }
        
        var body: some ReducerOf<Self> {
            Reduce { state, action in
                switch action {
                case .onAppear:
                    // TODO: Carregar dados do usuário
                    return .none
                    
                case .logoutTapped:
                    // TODO: Implementar logout real (limpar tokens, etc.)
                    return .none
                    
                case .searchTapped:
                    // TODO: Navegar para tela de busca
                    return .none
                    
                case .profileTapped:
                    // TODO: Navegar para perfil
                    return .none
                }
            }
        }
    }
} 