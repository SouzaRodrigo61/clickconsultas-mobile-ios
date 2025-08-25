//
//  LinearGradient+Extension.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 10/05/2025.
//
//

import SwiftUI

// MARK: - Color Extensions
extension Color {
    static let gradientStart = Color(hex: "C4E6F3")    // 0%
    static let gradientMiddle = Color(hex: "E3F3FA")   // 62%
    static let gradientEnd = Color.white               // 100%
}

// MARK: - LinearGradient Extensions
extension LinearGradient {
    static let ClickConsultasBackground = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color("ClickConsultas.Primary"), location: 0.00),  // topo: roxo
            .init(color: .black, location: 0.45),  // ~45% já é preto
            .init(color: .black, location: 1.00)   // mantém preto até o fim
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - RadialGradient Extensions
extension RadialGradient {
    static let authenticationBackground = RadialGradient(
        gradient: Gradient(stops: [
            .init(color: Color(red: 0.77, green: 0.90, blue: 0.95), location: 0.0),    // C4E6F3
            .init(color: Color(red: 0.89, green: 0.95, blue: 0.98), location: 0.62),   // E3F3FA
            .init(color: .white, location: 1.0)
        ]),
        center: .top,
        startRadius: 100,
        endRadius: 800
    )
}

#Preview("Gradientes") {
    //        Text("Linear Gradient")
    //            .font(.headline)
    //        
    //        RoundedRectangle(cornerRadius: 12)
    //            .fill(LinearGradient.ClickConsultasBackground)
    //            .frame(height: 100)
    //        
    //        Text("Radial Gradient")
    //            .font(.headline)
    //        
    //        RoundedRectangle(cornerRadius: 12)
    //            .fill(RadialGradient.authenticationBackground)
    //            .frame(height: 200)
    //            .frame(maxWidth: .infinity)
    //        
    //        Text("Radial Gradient (Full Screen)")
    //            .font(.headline)
    
    ZStack(alignment: .top) { 
        RadialGradient.authenticationBackground
            .frame(
                maxWidth: .infinity, 
                maxHeight: .infinity,
                alignment: .top
            )
            .clipShape(.rect)
            .ignoresSafeArea()
            
    }
    
}

#Preview("Cores Hex") {
    VStack(spacing: 20) {
        Text("Teste das Cores")
            .font(.headline)
        
        HStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gradientStart)
                .frame(width: 60, height: 60)
                .overlay(Text("Start").font(.caption))
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gradientMiddle)
                .frame(width: 60, height: 60)
                .overlay(Text("Middle").font(.caption))
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gradientEnd)
                .frame(width: 60, height: 60)
                .overlay(Text("End").font(.caption))
        }
    }
    .padding()
}
