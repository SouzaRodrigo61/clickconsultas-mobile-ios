//
//  AnyButtonStyle.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 25/05/25.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

struct AnyButtonStyle: ButtonStyle {
	private let _makeBody: (Configuration) -> AnyView

	init<S: ButtonStyle>(_ style: S) {
		_makeBody = { configuration in
			AnyView(style.makeBody(configuration: configuration))
		}
	}

	func makeBody(configuration: Configuration) -> some View {
		_makeBody(configuration)
	}
}

#Preview {
    VStack(spacing: 20) {
        Text("AnyButtonStyle - Wrapper para outros estilos")
            .font(.headline)
            .padding(.bottom)
        
        // Exemplo usando GlassScaleButtonStyle
        Button("Glass Scale Button") {
            print("Glass Scale Button tapped")
        }
        .buttonStyle(AnyButtonStyle(GlassScaleButtonStyle()))
        
        // Exemplo usando OutlinedButtonStyle
        Button("Outlined Button") {
            print("Outlined Button tapped")
        }
        .buttonStyle(AnyButtonStyle(OutlinedButtonStyle()))
        
        // Exemplo usando SolidButtonStyle
        Button("Solid Button") {
            print("Solid Button tapped")
        }
        .buttonStyle(AnyButtonStyle(SolidButtonStyle.solid()))
        
        // Exemplo usando ScaleButtonStyle
        Button("Scale Button") {
            print("Scale Button tapped")
        }
        .buttonStyle(AnyButtonStyle(ScaleButtonStyle()))
        
        // Exemplo usando PillButtonStyle
        Button("Pill Button") {
            print("Pill Button tapped")
        }
        .buttonStyle(AnyButtonStyle(PillButtonStyle.pill()))
        
        // Exemplo usando PillButtonStyle com cor personalizada
        Button("Custom Pill") {
            print("Custom Pill Button tapped")
        }
        .buttonStyle(AnyButtonStyle(PillButtonStyle.pill(backgroundColor: .green)))
        
        // Exemplo usando PillButtonStyle com largura total
        Button("Full Width Pill") {
            print("Full Width Pill Button tapped")
        }
        .buttonStyle(AnyButtonStyle(PillButtonStyle.pill(backgroundColor: .purple)))
        .frame(maxWidth: .infinity)
    }
    .padding()
}

