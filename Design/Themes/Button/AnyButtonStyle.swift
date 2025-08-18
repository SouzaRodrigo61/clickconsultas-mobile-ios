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

