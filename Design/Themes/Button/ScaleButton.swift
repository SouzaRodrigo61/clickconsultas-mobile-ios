//
//  ScaleButton.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 10/05/2025.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == ScaleButtonStyle {
    static var scale: ScaleButtonStyle { ScaleButtonStyle() }
}

#Preview {
    VStack(spacing: 20) {
        Text("ScaleButtonStyle")
            .font(.headline)
            .padding(.bottom)
        
        // Botão com texto
        Button("Scale Button") {
            print("Scale Button tapped")
        }
        .buttonStyle(.scale)
        
        // Botão com ícone
        Button {
            print("Icon scale button tapped")
        } label: {
            Image(systemName: "star.fill")
                .font(.title)
                .foregroundColor(.yellow)
        }
        .buttonStyle(.scale)
        
        // Botão com texto e ícone
        Button {
            print("Text + Icon scale button tapped")
        } label: {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Confirmar")
            }
            .foregroundColor(.green)
        }
        .buttonStyle(.scale)
        
        // Botão com imagem
        Button {
            print("Image scale button tapped")
        } label: {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue)
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(.white)
                )
        }
        .buttonStyle(.scale)
    }
    .padding()
} 