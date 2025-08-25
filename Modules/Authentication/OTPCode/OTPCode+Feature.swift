//
//  OTPCode+Feature.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension OTPCode {
    @Reducer
    struct Feature {
        @ObservableState
        struct State: Equatable {
            let email: String
            var otpCode: String = ""
            var otpTimer: Int = 60
            var canResendOTP: Bool = false
            var isLoading: Bool = false
            var errorMessage: String?
            
            @Presents var destination: Destination.State?
        }
        
        enum Action: Equatable, BindableAction {
            case onAppear
            case verifyOTPTapped
            case resendOTPTapped
            case otpTimerTick
            case verifyOTPSucceeded
            case verifyOTPFailed(String)
            case destination(PresentationAction<Destination.Action>)
            case binding(BindingAction<State>)
        }
        
        var body: some ReducerOf<Self> {
            BindingReducer()
                .onChange(of: \.otpCode) { _, code in
                    Reduce { state, _ in
                        if code.count == 6 {
                            return .send(.verifyOTPTapped)
                        }
                        return .none
                    }
                }
            
            Reduce { state, action in
                switch action {
                case .onAppear:
                    // Iniciar timer para reenvio
                    return .run { send in
                        for _ in 0..<60 {
                            try await Task.sleep(for: .seconds(1))
                            await send(.otpTimerTick)
                        }
                    }
                    
                case .verifyOTPTapped:
                    state.isLoading = true
                    state.errorMessage = nil
                    
                    return .run { send in
                        try await Task.sleep(for: .seconds(1))
                        await send(.verifyOTPSucceeded)
                    }
                    
                case .resendOTPTapped:
                    state.otpTimer = 60
                    state.canResendOTP = false
                    state.otpCode = ""
                    state.errorMessage = nil
                    
                    return .run { send in
                        for _ in 0..<60 {
                            try await Task.sleep(for: .seconds(1))
                            await send(.otpTimerTick)
                        }
                    }
                    
                case .otpTimerTick:
                    if state.otpTimer > 0 {
                        state.otpTimer -= 1
                    } else {
                        state.canResendOTP = true
                    }
                    return .none
                    
                case .verifyOTPSucceeded:
                    state.isLoading = false
                    state.destination = .newPassword(NewPassword.Feature.State(email: state.email))
                    return .none
                    
                case let .verifyOTPFailed(error):
                    state.isLoading = false
                    state.errorMessage = error
                    return .none
                    
                case .destination:
                    return .none
                    
                case .binding:
                    return .none
                }
            }
            .ifLet(\.$destination, action: \.destination) {
                Destination()
            }
        }
    }
} 
