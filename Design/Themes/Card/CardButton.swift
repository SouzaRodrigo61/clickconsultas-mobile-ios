//
//  CardView.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 25/05/25.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

extension Card {
	struct Button<Content: View>: View {
		let action: () -> Void
		let style: AnyButtonStyle
		let content: () -> Content

		init(
			style: some ButtonStyle = SolidButtonStyle(
				backgroundColor: .white.opacity(0.1),
				insets: .init(top: 0, leading: 4, bottom: 0, trailing: 4),
				innerPadding: .init(top: 8, leading: 12, bottom: 8, trailing: 12)
			),
			action: @escaping () -> Void,
			@ViewBuilder content: @escaping () -> Content
		) {
			self.style = AnyButtonStyle(style) // ✅ type erase aqui
			self.action = action
			self.content = content
		}

		var body: some View {
			SwiftUI.Button(action: action) {
				content()
			}
			.buttonStyle(style)
		}
	}
}

#Preview { 
    struct PreviewScreen: View { 
        var body: some View { 
            Card.Button(action: {}) { 
                Text("Button")
            }
        }
    }

    return PreviewScreen()
}