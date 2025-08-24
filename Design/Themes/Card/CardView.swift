//
//  CardView.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 25/05/25.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

extension Card {
	struct ContentView<Content: View>: View {
		let title: String?
		let footer: String?
		let content: () -> Content

		init(
			title: String? = nil,
			footer: String? = nil,
			@ViewBuilder content: @escaping () -> Content
		) {
			self.title = title
			self.footer = footer
			self.content = content
		}

		var body: some View {
			VStack(alignment: .leading, spacing: 8) {
				if let title = title {
					Text(title)
						.font(.subheadline)
						.foregroundColor(.secondary)
						.padding(.horizontal, 16)
				}

				content()

				if let footer = footer {
					Text(footer)
						.font(.footnote)
						.foregroundColor(.secondary)
						.padding(.horizontal, 16)
				}
			}
			.padding(.vertical, 4)
			.background {
				RoundedRectangle(cornerRadius: 12)
					.fill(.white.opacity(0.1))
			}
		}
	}
}

#Preview { 
    struct PreviewScreen: View { 
        var body: some View { 
            Card.ContentView(title: "Title", footer: "Footer") { 
                Text("Content")
            }
        }
    }

    return PreviewScreen()
}
