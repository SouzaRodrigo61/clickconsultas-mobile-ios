//
//  Phone+Destination.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture

extension Phone {
    @Reducer
    struct Destination {
        @ObservableState
        enum State: Equatable {
            case newPassword(NewPassword.Feature.State)
        }
        
        enum Action: Equatable {
            case newPassword(NewPassword.Feature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.newPassword, action: \.newPassword) {
                NewPassword.Feature()
            }
        }
    }
}
