//
//  Success+View.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension Success {
    struct ContentView: View {
        @Bindable var store: StoreOf<Feature>
        @State private var showConfetti = false
        
        var body: some View {
            ZStack {
                RadialGradient.authenticationBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Ícone de sucesso
                    ZStack {
                        Circle()
                            .fill(store.iconColor.opacity(0.1))
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: store.iconName)
                            .font(.system(size: 60))
                            .foregroundStyle(store.iconColor)
                    }
                    .background { 
                        Image("Particles")
                            .frame(width: 350, height: 500)
                    }
                    .padding(.bottom, 24)
                    
                    Text(store.title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.primary)
                        .padding(.bottom, 16)
                    
                    Text(store.subtitle)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.inputContainerTextFieldFill.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 48)
                    
                    Spacer()
                    
                    Button {
                        // Haptic feedback para confirmação
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                        
                        store.send(.finishTapped)
                    } label: {
                        Text("Vamos la!")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.vertical, 4)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.pill(backgroundColor: .primaryButton, foregroundColor: .white))
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
            .navigationTitle("Sucesso")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                store.send(.onAppear)
                
                // Haptic feedback para sucesso
                let notificationFeedback = UINotificationFeedbackGenerator()
                notificationFeedback.notificationOccurred(.success)
                
                withAnimation(.easeInOut(duration: 0.5)) {
                    showConfetti = true
                }
            }
        }
    }
}

#Preview {
    // Exemplo 1: Senha atualizada
    Success.ContentView(
        store: Store(initialState: Success.Feature.State(
            title: "Senha Atualizada!",
            subtitle: "Sua senha foi atualizada com sucesso. Agora você pode fazer login com sua nova senha.",
            iconName: "checkmark.shield.fill",
            iconColor: .green
        )) {
            Success.Feature()
        }
    )
} 
