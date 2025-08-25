//
//  ForgotPassword+Destination.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture

extension ForgotPassword {
    @Reducer
    struct Destination {
        @ObservableState
        enum State: Equatable {
            case otpCode(OTPCode.Feature.State)
        }
        
        enum Action: Equatable {
            case otpCode(OTPCode.Feature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.otpCode, action: \.otpCode) {
                OTPCode.Feature()
            }
        }
    }
}
