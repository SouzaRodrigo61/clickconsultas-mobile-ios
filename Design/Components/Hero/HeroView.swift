//
//  HeroView.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 15/05/25.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

extension Hero {
    struct ContentView<Content: View>: View {
        let store: StoreOf<Feature>
        let sourceRect: CGRect
        let destinationRect: CGRect
        
        let content: () -> Content

        init(store: StoreOf<Feature>, sourceRect: CGRect, destinationRect: CGRect, @ViewBuilder _ content: @escaping () -> Content) {
            self.store = store
            self.sourceRect = sourceRect
            self.destinationRect = destinationRect
            self.content = content
        }
        
        var body: some View {
            SwiftUI.Group {
                Color.clear
                    .onAppear {
                        store.send(.updateRect(source: sourceRect, destination: destinationRect))
                    }
                    .onChange(of: store.isDragging) { oldValue, newValue in
                        if newValue && !oldValue {
                            store.send(.updateRect(source: sourceRect, destination: destinationRect))
                        }
                    }
            }
            
            let actualInitialSourceRect = (store.hasInitialPositions && store.initialSourceRect != .zero) ? store.initialSourceRect : sourceRect
            let actualInitialDestRect = (store.hasInitialPositions && store.initialDestRect != .zero) ? store.initialDestRect : destinationRect
            
            let diffSize = CGSize(
                width: actualInitialDestRect.width - actualInitialSourceRect.width,
                height: actualInitialDestRect.height - actualInitialSourceRect.height
            )
            
            let initialDiffOrigin = CGPoint(
                x: actualInitialDestRect.minX - actualInitialSourceRect.minX,
                y: actualInitialDestRect.minY - actualInitialSourceRect.minY
            )
            
            let currentAnimatedHeight = actualInitialSourceRect.height + (diffSize.height * store.heroProgress)
            let radius = currentAnimatedHeight / 2
            
            ZStack {
                self.content()
                    .opacity(store.showHeroView ? 1 : 0)
                    .frame(
                        width: actualInitialSourceRect.width + (diffSize.width * store.heroProgress),
                        height: currentAnimatedHeight
                    )
                    .clipShape(.rect(cornerRadius: radius))
                    .offset(
                        x: actualInitialSourceRect.minX + (initialDiffOrigin.x * store.heroProgress),
                        y: actualInitialSourceRect.minY + (initialDiffOrigin.y * store.heroProgress)
                    )
            }
        }
    }
}
