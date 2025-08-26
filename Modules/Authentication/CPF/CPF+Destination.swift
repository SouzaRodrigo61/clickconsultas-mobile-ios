//
//  CPF+Destination.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture

extension CPF {
    @Reducer
    struct Destination {
        @ObservableState
        enum State: Equatable {
            case documents(Documents.Feature.State)
        }
        
        enum Action: Equatable {
            case documents(Documents.Feature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.documents, action: \.documents) {
                Documents.Feature()
            }
        }
    }
}
