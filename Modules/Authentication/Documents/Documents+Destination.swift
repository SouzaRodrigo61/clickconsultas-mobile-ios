//
//  Documents+Destination.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture

extension Documents {
    @Reducer
    struct Destination {
        @ObservableState
        enum State: Equatable {
            case phone(Phone.Feature.State)
        }
        
        enum Action: Equatable {
            case phone(Phone.Feature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.phone, action: \.phone) {
                Phone.Feature()
            }
        }
    }
}
