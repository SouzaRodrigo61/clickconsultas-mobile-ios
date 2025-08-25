//
//  OTPCode+View.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension OTPCode {
    struct ContentView: View {
        @Bindable var store: StoreOf<Feature>
        @Namespace private var buttonNamespace
        
        var body: some View {
            ZStack {
                RadialGradient.authenticationBackground
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Enviamos um código de verificação para \(store.email)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.inputContainerTextFieldFill.opacity(0.6))
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                    
                    // OTP Code Field
                    OTP.Form(
                        length: 6,
                        groupSize: 3,
                        code: $store.otpCode
                    )
                    .onChange(of: store.otpCode) { _, newValue in
                        store.send(.otpCodeChanged(newValue))
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    
                    // Timer e Reenviar
                    HStack {
                        if store.otpTimer > 0 {
                            Text("Reenviar em \(store.otpTimer)s")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.inputContainerTextFieldFill.opacity(0.6))
                                .matchedGeometryEffect(id: "timer", in: buttonNamespace)
                                .transition(.scale.combined(with: .opacity))
                        } else {
                            Button {
                                store.send(.resendOTPTapped)
                            } label: {
                                Text("Reenviar código")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.primaryButton)
                            }
                            .matchedGeometryEffect(id: "resend", in: buttonNamespace)
                            .transition(.scale.combined(with: .opacity))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .animation(.easeInOut(duration: 0.3), value: store.otpTimer)
                    
                    if let errorMessage = store.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.red)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .animation(.easeInOut(duration: 0.3), value: store.errorMessage)
                    }
                    
                    Spacer()
                    
                    Button {
                        store.send(.verifyOTPTapped)
                    } label: {
                        HStack(alignment: .center) {
                            if store.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .matchedGeometryEffect(id: "loading", in: buttonNamespace)
                                    .transition(.scale.combined(with: .opacity))
                            }
                            
                            if !store.isLoading {
                                Text(store.errorMessage != nil ? "Tentar Novamente" : "Verificar Código")
                                    .font(.system(size: 18, weight: .bold))
                                    .matchedGeometryEffect(id: "text", in: buttonNamespace)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.pill(backgroundColor: (store.otpCode.isEmpty || store.isLoading || store.errorMessage == nil) ? .primaryButton.opacity(0.65) : .primaryButton))
                    .disabled(store.otpCode.isEmpty || store.isLoading || store.errorMessage == nil)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .animation(.easeInOut(duration: 0.3), value: store.isLoading)
                    .animation(.easeInOut(duration: 0.3), value: store.errorMessage)
                    .animation(.easeInOut(duration: 0.3), value: store.otpCode.isEmpty)
                }
            }
            .navigationTitle("Código de Verificação")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                store.send(.onAppear)
            }
            .navigationDestination(
                item: $store.scope(state: \.destination?.newPassword, action: \.destination.newPassword), 
                destination: NewPassword.ContentView.init(store:)
            )
        }
    }
}

#Preview {
    OTPCode.ContentView(
        store: Store(initialState: OTPCode.Feature.State(email: "test@example.com")) {
            OTPCode.Feature()
        }
    )
} 
