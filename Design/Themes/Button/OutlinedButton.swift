//
//  BorderrButton.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 16/05/25.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

struct OutlinedButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .contentShape(Rectangle()) // Garante que toda a área do padding seja clicável
            .foregroundColor(colorScheme == .dark ? .white : .black) // Cor do texto adaptável
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(colorScheme == .dark ? Color.white.opacity(0.5) : Color.gray.opacity(0.5), lineWidth: 1) // Borda sutil
            )
            .opacity(configuration.isPressed ? 0.75 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == OutlinedButtonStyle {
    static var outlined: OutlinedButtonStyle { OutlinedButtonStyle() }
}
