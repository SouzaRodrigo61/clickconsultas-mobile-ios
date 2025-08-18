//
//  Avatar.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 13/05/25.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

struct Avatar: View {
    let title: String
    let size: CGFloat
    let backgroundColor: Color
    let foregroundColor: Color
    let font: Font

    var body: some View {
        Text(title)
            .font(font)
            .foregroundStyle(foregroundColor)
            .frame(width: size, height: size, alignment: .center)
            .background(backgroundColor)
            .clipShape(Circle())
    }
}
