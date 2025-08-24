//
//  GlassScaleButtonStyle.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 21/04/25.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI
import SwiftGlass

public struct GlassScaleButtonStyle: ButtonStyle {
	public func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.glass(
				radius: 12,
				color: Color(.secondarySystemGroupedBackground).opacity(0.8),
				material: .regularMaterial,
				gradientOpacity: 0.2,
				shadowRadius: 0,
				shadowY: 0
			)
			.scaleEffect(configuration.isPressed ? 0.97 : 1.0)
			.animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
	}

	public init() {}
} 


extension ButtonStyle where Self == GlassScaleButtonStyle {
    static var glassScale: GlassScaleButtonStyle { GlassScaleButtonStyle() }
}

#Preview {
    VStack(spacing: 20) {
        Text("GlassScaleButtonStyle")
            .font(.headline)
            .padding(.bottom)
        
        // Botão com texto
        Button("Glass Scale Button") {
            print("Glass Scale Button tapped")
        }
        .buttonStyle(.glassScale)
        
        // Botão com ícone
        Button {
            print("Icon button tapped")
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.title2)
        }
        .buttonStyle(.glassScale)
        
        // Botão com texto e ícone
        Button {
            print("Text + Icon button tapped")
        } label: {
            HStack {
                Image(systemName: "arrow.right")
                Text("Continuar")
            }
        }
        .buttonStyle(.glassScale)
        
        // Botão longo
        Button("Botão com texto mais longo para demonstrar o comportamento") {
            print("Long button tapped")
        }
        .buttonStyle(.glassScale)
    }
    .padding()
    .background(
        LinearGradient(
            colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
}
