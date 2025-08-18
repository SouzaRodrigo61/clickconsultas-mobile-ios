//
//  BorderrButton.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 16/05/25.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

// NOVO ESTILO DE BOTÃO SÓLIDO
struct SolidButtonStyle: ButtonStyle {
    static let INNER_PADDING: EdgeInsets = .init(top: 16, leading: 10, bottom: 16, trailing: 10)
    
    @Environment(\.colorScheme) private var colorScheme
    var backgroundColor: Color = .accentColor
    var insets: EdgeInsets = EdgeInsets()
    var innerPadding: EdgeInsets = EdgeInsets()
    
    var isScaleEnabled: Bool = false
    
    private func scale() -> CGFloat {
        isScaleEnabled ? 0.97 : 1.0
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(innerPadding)
            .clipShape(.rect)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(configuration.isPressed ? backgroundColor : .clear) // Fundo sólido
            )
            .brightness(configuration.isPressed ? -0.1 : 0) // Escurece um pouco ao pressionar
            .scaleEffect(configuration.isPressed ? scale() : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
            .padding(insets)
    }
}

extension ButtonStyle where Self == SolidButtonStyle {
    
    static func solid(backgroundColor: Color = .accentColor,
                      insets: EdgeInsets = EdgeInsets(),
                      innerPadding: EdgeInsets = SolidButtonStyle.INNER_PADDING) -> SolidButtonStyle {
        SolidButtonStyle(backgroundColor: backgroundColor, insets: insets, innerPadding: innerPadding)
    }
    
    static func solidScale(backgroundColor: Color = .accentColor,
                           insets: EdgeInsets = EdgeInsets(),
                           innerPadding: EdgeInsets = SolidButtonStyle.INNER_PADDING,
                           isScaleEnabled: Bool = true) -> SolidButtonStyle {
        SolidButtonStyle(backgroundColor: backgroundColor, insets: insets, innerPadding: innerPadding, isScaleEnabled: isScaleEnabled)
    }
}
