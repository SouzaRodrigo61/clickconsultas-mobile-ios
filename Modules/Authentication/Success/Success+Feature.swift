//
//  Success+Feature.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension Success {
    @Reducer
    struct Feature {
        @ObservableState
        struct State: Equatable {
            var isLoading: Bool = false
        }
        
        enum Action: Equatable {
            case onAppear
            case finishTapped
            case finishFlow
        }
        
        var body: some ReducerOf<Self> {
            Reduce { state, action in
                switch action {
                case .onAppear:
                    return .none
                    
                case .finishTapped:
                    return .send(.finishFlow)
                    
                case .finishFlow:
                    return .none
                }
            }
        }
    }
} 