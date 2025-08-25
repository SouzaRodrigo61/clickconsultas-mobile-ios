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
        @Dependency(\.continuousClock) var clock
        
        @ObservableState
        struct State: Equatable {
            let email: String
            var otpCode: String = ""
            var otpTimer: Int = 60
            var canResendOTP: Bool = false
            var isLoading: Bool = false
            var errorMessage: String?
            var isTimerActive: Bool = true
            
            @Presents var destination: Destination.State?
        }
        
        enum Action: Equatable, BindableAction {
            case onAppear
            case verifyOTPTapped
            case resendOTPTapped
            case otpTimerTick
            case verifyOTPSucceeded
            case verifyOTPFailed(String)
            case otpCodeChanged(String)
            case destination(PresentationAction<Destination.Action>)
            case binding(BindingAction<State>)
        }
        
        var body: some ReducerOf<Self> {
            BindingReducer()
            
            Reduce { state, action in
                switch action {
                case .onAppear:
                    // Iniciar timer para reenvio usando continuousClock
                    return .run { send in
                        for await _ in clock.timer(interval: .seconds(1)) {
                            await send(.otpTimerTick)
                        }
                    }
                    .cancellable(id: "OTPTimer")
                    
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
                    state.isTimerActive = true // Reativar o timer
                    
                    // Cancelar timer anterior e iniciar novo
                    return .run { send in
                        for await _ in clock.timer(interval: .seconds(1)) {
                            await send(.otpTimerTick)
                        }
                    }
                    .cancellable(id: "OTPTimer")
                    
                case .otpTimerTick:
                    if state.isTimerActive && state.otpTimer > 0 {
                        state.otpTimer -= 1
                    } else if state.otpTimer == 0 {
                        state.canResendOTP = true
                    }
                    return .none
                    
                case let .otpCodeChanged(code):
                    // Verificar automaticamente quando o código estiver completo
                    if code.count == 6 {
                        return .send(.verifyOTPTapped)
                    }
                    return .none
                    
                case .verifyOTPSucceeded:
                    state.isLoading = false
                    state.isTimerActive = false // Parar o timer
                    state.destination = .newPassword(NewPassword.Feature.State(email: state.email))
                    return .cancel(id: "OTPTimer") // Cancelar o timer
                    
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
