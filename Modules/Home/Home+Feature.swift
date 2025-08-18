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
            // Estado do módulo
        }
        
        enum Action: Equatable {
            case onAppear
        }
        
        var body: some ReducerOf<Self> {
            Reduce { state, action in
                switch action {
                case .onAppear:
                    return .none
                }
            }
        }
    }
} 