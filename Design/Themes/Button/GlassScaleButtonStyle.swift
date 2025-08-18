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
