//
//  LinearGradient+Extension.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 10/05/2025.
//
//

import SwiftUI

extension LinearGradient {
    static let ClickConsultasBackground = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color("ClickConsultas.Primary"), location: 0.00),  // topo: roxo
            .init(color: .black,                     location: 0.45),  // ~45% já é preto
            .init(color: .black,                     location: 1.00)   // mantém preto até o fim
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
}
