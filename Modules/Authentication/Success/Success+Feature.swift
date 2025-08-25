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
            let title: String
            let subtitle: String
            let iconName: String
            let iconColor: Color
            var isLoading: Bool = false
            
            init(
                title: String = "Tudo pronto!",
                subtitle: String = "Operação realizada com sucesso.",
                iconName: String = "checkmark.circle.fill",
                iconColor: Color = .blue
            ) {
                self.title = title
                self.subtitle = subtitle
                self.iconName = iconName
                self.iconColor = iconColor
            }
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