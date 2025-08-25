//
//  PillButton.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 18/08/2025.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

struct PillButtonStyle: ButtonStyle {
    var backgroundColor: Color = .accentColor
    var foregroundColor: Color = .white
    var padding: EdgeInsets = .init(top: 12, leading: 20, bottom: 12, trailing: 20)
    var scaleAmount: CGFloat = 0.95
    var animationDuration: Double = 0.2
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(foregroundColor)
            .padding(padding)
            .background(
                Capsule()
                    .fill(backgroundColor)
            )
            .scaleEffect(configuration.isPressed ? scaleAmount : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PillButtonStyle {
    static func pill(
        backgroundColor: Color = .accentColor, 
        foregroundColor: Color = .white
    ) -> PillButtonStyle {
        PillButtonStyle(
            backgroundColor: backgroundColor, 
            foregroundColor: foregroundColor
        )
    }
    
    static func pillScale(
        backgroundColor: Color = .accentColor,
        foregroundColor: Color = .white,
        scaleAmount: CGFloat = 0.95
    ) -> PillButtonStyle {
        PillButtonStyle(
            backgroundColor: backgroundColor, 
            foregroundColor: foregroundColor,
            scaleAmount: scaleAmount
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("PillButtonStyle")
            .font(.headline)
            .padding(.bottom)
        
        // Botão básico
        Button("Pill Button") {
            print("Pill Button tapped")
        }
        .buttonStyle(.pill())
        
        // Botão com cor personalizada
        Button("Custom Color") {
            print("Custom color pill button tapped")
        }
        .buttonStyle(.pill(backgroundColor: .green))
        
        // Botão com escala personalizada
        Button("Custom Scale") {
            print("Custom scale pill button tapped")
        }
        .buttonStyle(.pillScale(backgroundColor: .purple, scaleAmount: 0.9))
        
        // Botão com ícone
        Button {
            print("Icon pill button tapped")
        } label: {
            HStack {
                Image(systemName: "heart.fill")
                Text("Favoritar")
            }
            .font(.system(size: 18, weight: .semibold))
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.pillScale(backgroundColor: .red, scaleAmount: 0.97))
        
        // Botão pequeno
        Button("Pequeno") {
            print("Small pill button tapped")
        }
        .buttonStyle(.pill(backgroundColor: .blue))
        
        // Botão longo
        Button {
            print("Long pill button tapped")
        } label: { 
            Text("Full Width")
                .font(.system(size: 18, weight: .bold))
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.pill(backgroundColor: .orange))
        
        // Botão com cor escura
        Button("Dark Theme") {
            print("Dark theme pill button tapped")
        }
        .buttonStyle(.pill(backgroundColor: .black, foregroundColor: .white))
        
        // Botão com cor clara
        Button("Light Theme") {
            print("Light theme pill button tapped")
        }
        .buttonStyle(.pill(backgroundColor: .gray.opacity(0.2), foregroundColor: .black))
        
        // Botão com largura total (full width)
        Button("Full Width Button") {
            print("Full width pill button tapped")
        }
        .buttonStyle(.pill(backgroundColor: .blue))
        .frame(maxWidth: .infinity)
        
        // Botão com largura total e cor diferente
        Button("Outro Full Width") {
            print("Another full width pill button tapped")
        }
        .buttonStyle(.pill(backgroundColor: .green))
        .frame(maxWidth: .infinity)
    }
    .padding()
}
