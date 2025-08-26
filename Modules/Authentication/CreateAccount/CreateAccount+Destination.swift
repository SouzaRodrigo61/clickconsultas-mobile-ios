//
//  CreateAccount+Destination.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture

extension CreateAccount {
    @Reducer
    struct Destination {
        @ObservableState
        enum State: Equatable {
            case cpf(CPF.Feature.State)
        }
        
        enum Action: Equatable {
            case cpf(CPF.Feature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.cpf, action: \.cpf) {
                CPF.Feature()
            }
        }
    }
}
