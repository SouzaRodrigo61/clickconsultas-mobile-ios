//
//  HeroController.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 15/05/25.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

extension Hero {
    @Reducer
    struct Feature {
        @ObservableState
        struct State: Equatable {
            var heroProgress: CGFloat = 0
            var showHeroView: Bool = true
            var initialSourceRect: CGRect = .zero
            var initialDestRect: CGRect = .zero
            var hasInitialPositions: Bool = false
            var isDragging: Bool = false
            var selectedID: UUID?
        }
        
        enum Action: Equatable {
            case startTransition(to: UUID)
            case resetTransition
            case endDrag(offset: CGFloat, velocity: CGFloat, viewSize: CGSize, shouldClose: Bool)
            case setDragging(Bool)
            case updateRect(source: CGRect, destination: CGRect)
            case setProgress(CGFloat)
            case setShowHeroView(Bool)
            case transitionDidEnd
        }
        
        var body: some ReducerOf<Self> {
            Reduce { state, action in
                switch action {
                case let .startTransition(to: id):
                    state.selectedID = id
                    state.showHeroView = true
                    state.hasInitialPositions = true
                    state.initialSourceRect = .zero
                    state.initialDestRect = .zero
                    return .run { send in
                        await send(.setProgress(1.0), animation: .snappy(duration: 0.35, extraBounce: 0))
                        try? await Task.sleep(for: .seconds(0.35))
                        await send(.setShowHeroView(false))
                    }
                    
                case .resetTransition:
                    state.showHeroView = true
                    return .run { send in
                        await send(.setProgress(0.0), animation: .snappy(duration: 0.35, extraBounce: 0))
                        try? await Task.sleep(for: .seconds(0.35))
                        await send(.transitionDidEnd)
                    }
                    
                case .transitionDidEnd:
                    state.selectedID = nil
                    state.hasInitialPositions = false
                    state.initialSourceRect = .zero
                    state.initialDestRect = .zero
                    state.heroProgress = 0
                    state.showHeroView = true
                    return .none
                    
                case let .endDrag(_, _, _, shouldClose):
                    state.isDragging = false
                    if shouldClose {
                        return .send(.resetTransition)
                    } else {
                        return .run { send in
                            await send(.setProgress(1.0), animation: .snappy(duration: 0.35, extraBounce: 0))
                            try? await Task.sleep(for: .seconds(0.35))
                            await send(.setShowHeroView(false))
                        }
                    }
                    
                case let .setDragging(isDragging):
                    state.isDragging = isDragging
                    if isDragging {
                        if !state.hasInitialPositions {
                            state.hasInitialPositions = true
                            state.initialSourceRect = .zero
                            state.initialDestRect = .zero
                        }
                    }
                    return .none
                    
                case let .updateRect(source, destination):
                    if state.hasInitialPositions && state.initialSourceRect == .zero {
                        state.initialSourceRect = source
                        state.initialDestRect = destination
                    }
                    return .none
                    
                case let .setProgress(progress):
                    state.heroProgress = progress
                    return .none
                    
                case let .setShowHeroView(show):
                    state.showHeroView = show
                    return .none
                }
            }
        }
    }
}
