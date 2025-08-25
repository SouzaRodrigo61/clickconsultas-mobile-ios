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
                            .offset(y: 10)
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
                        store.send(.finishTapped)
                    } label: {
                        Text("Confirmar")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(.primaryButton)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
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

// Componente de confete melhorado
struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Group {
                    if particle.type == .circle {
                        Circle()
                            .fill(particle.color)
                    } else if particle.type == .square {
                        Rectangle()
                            .fill(particle.color)
                    } else {
                        Image(systemName: "star.fill")
                            .foregroundColor(particle.color)
                    }
                }
                .frame(width: particle.size, height: particle.size)
                .position(particle.position)
                .opacity(particle.opacity)
                .rotationEffect(.degrees(particle.rotation))
            }
        }
        .onAppear {
            createParticles()
        }
    }
    
    private func createParticles() {
        let colors: [Color] = [.blue, .green, .red, .yellow, .purple, .orange, .pink, .cyan]
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let centerX = screenWidth / 2
        let centerY = screenHeight / 2
        
        // Criar partículas em explosão
        for _ in 0..<80 {
            let angle = Double.random(in: 0...2 * .pi)
            let distance = Double.random(in: 50...200)
            let finalX = centerX + cos(angle) * distance
            let finalY = centerY + sin(angle) * distance
            
            let particle = ConfettiParticle(
                id: UUID(),
                position: CGPoint(x: centerX, y: centerY),
                finalPosition: CGPoint(x: finalX, y: finalY),
                color: colors.randomElement() ?? .blue,
                size: CGFloat.random(in: 6...12),
                opacity: Double.random(in: 0.8...1.0),
                type: ConfettiType.allCases.randomElement() ?? .circle,
                rotation: Double.random(in: 0...360),
                delay: Double.random(in: 0...0.3)
            )
            particles.append(particle)
        }
        
        // Animar partículas com explosão
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for i in particles.indices {
                let particle = particles[i]
                
                withAnimation(.easeOut(duration: 2.0).delay(particle.delay)) {
                    particles[i].position = particle.finalPosition
                    particles[i].opacity = 0
                    particles[i].rotation += Double.random(in: 180...720)
                }
            }
        }
    }
}

enum ConfettiType: CaseIterable {
    case circle, square, star
}

struct ConfettiParticle: Identifiable {
    let id: UUID
    var position: CGPoint
    let finalPosition: CGPoint
    let color: Color
    let size: CGFloat
    var opacity: Double
    let type: ConfettiType
    var rotation: Double
    let delay: Double
}

#Preview {
    VStack(spacing: 20) {
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
        
        // Exemplo 2: Conta criada
        Success.ContentView(
            store: Store(initialState: Success.Feature.State(
                title: "Conta Criada!",
                subtitle: "Sua conta foi criada com sucesso. Bem-vindo ao ClickConsultas!",
                iconName: "person.badge.plus.fill",
                iconColor: .blue
            )) {
                Success.Feature()
            }
        )
        
        // Exemplo 3: Pagamento confirmado
        Success.ContentView(
            store: Store(initialState: Success.Feature.State(
                title: "Pagamento Confirmado!",
                subtitle: "Seu pagamento foi processado com sucesso. Você receberá um email de confirmação.",
                iconName: "creditcard.fill",
                iconColor: .orange
            )) {
                Success.Feature()
            }
        )
    }
} 
