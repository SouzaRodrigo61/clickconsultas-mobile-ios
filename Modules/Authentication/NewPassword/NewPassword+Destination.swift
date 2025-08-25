//
//  NewPassword+Destination.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture

extension NewPassword {
    @Reducer
    struct Destination {
        @ObservableState
        enum State: Equatable {
            case success(Success.Feature.State)
        }
        
        enum Action: Equatable {
            case success(Success.Feature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.success, action: \.success) {
                Success.Feature()
            }
        }
    }
}
