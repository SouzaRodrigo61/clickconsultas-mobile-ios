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
                            .fill(.green.opacity(0.1))
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.green)
                    }
                    .padding(.bottom, 24)
                    
                    Text("Tudo pronto!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.primary)
                        .padding(.bottom, 16)
                    
                    Text("Sua senha foi atualizada com sucesso. Agora você pode fazer login com sua nova senha.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.inputContainerTextFieldFill.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 48)
                    
                    Button {
                        store.send(.finishTapped)
                    } label: {
                        Text("Continuar")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(.primaryButton)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    
                    Spacer()
                }
                
                // Confete animado
                if showConfetti {
                    ConfettiView()
                        .allowsHitTesting(false)
                }
            }
            .navigationTitle("Sucesso")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                store.send(.onAppear)
                withAnimation(.easeInOut(duration: 0.5)) {
                    showConfetti = true
                }
            }
        }
    }
}

// Componente de confete
struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
            }
        }
        .onAppear {
            createParticles()
        }
    }
    
    private func createParticles() {
        let colors: [Color] = [.blue, .green, .red, .yellow, .purple, .orange]
        
        for _ in 0..<50 {
            let particle = ConfettiParticle(
                id: UUID(),
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: -20
                ),
                color: colors.randomElement() ?? .blue,
                size: CGFloat.random(in: 4...8),
                opacity: Double.random(in: 0.7...1.0)
            )
            particles.append(particle)
        }
        
        // Animar partículas
        withAnimation(.easeOut(duration: 3.0)) {
            for i in particles.indices {
                particles[i].position.y = UIScreen.main.bounds.height + 50
                particles[i].opacity = 0
            }
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id: UUID
    var position: CGPoint
    let color: Color
    let size: CGFloat
    var opacity: Double
}

#Preview {
    Success.ContentView(
        store: Store(initialState: Success.Feature.State()) {
            Success.Feature()
        }
    )
} 