//
//  MAnchorKey.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 12/05/25.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

struct MAnchorKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    
    static func reduce(value: inout [String: Anchor<CGRect>], nextValue: () -> [String: Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}

