//
//  ScrollView.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 11/05/25.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
    
    typealias Value = CGPoint
    
}

struct ScrollViewOffsetModifier: ViewModifier {
    let coordinateSpace: String
    @Binding var offset: CGPoint
    
    func body(content: Content) -> some View {
        ZStack {
            content
            GeometryReader { proxy in
                let x = proxy.frame(in: .named(coordinateSpace)).minX
                let y = proxy.frame(in: .named(coordinateSpace)).minY
                Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: CGPoint(x: x * -1, y: y * -1))
            }
        }
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
            offset = value
        }
    }
}

struct ScrollDetector: UIViewRepresentable {
    
    var onScroll: (CGSize, CGPoint, UIEdgeInsets) -> ()
    /// On Will Dragging End
    var onWillEndDragging: (CGFloat, CGFloat) -> ()
    /// On Dragging Start
    var onDraggingStart: (CGSize, CGPoint, UIEdgeInsets) -> ()
    /// On Dragging End
    var onEndDragging: () -> ()

    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView, !context.coordinator.isDelegateAdded {
                scrollView.delegate = context.coordinator
                context.coordinator.isDelegateAdded = true
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    /// ScrollView Delegate Methods
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollDetector
        
        init(_ parent: ScrollDetector) {
            self.parent = parent
        }

        var isDelegateAdded: Bool = false

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.onScroll(scrollView.contentSize, scrollView.contentOffset, scrollView.contentInset)
        }

        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            parent.onDraggingStart(scrollView.contentSize, scrollView.contentOffset, scrollView.contentInset)
        }

        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            parent.onWillEndDragging(scrollView.contentOffset.y, velocity.y)
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) { }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            parent.onEndDragging()
        }
    }
}

struct ResizableHeaderScrollView<Header: View, StickyHeader: View, Background: View, Content: View>: View {
    var spacing: CGFloat = 10
    @ViewBuilder var header: Header
    @ViewBuilder var stickyHeader: StickyHeader
    @ViewBuilder var background: Background
    @ViewBuilder var content: Content

    @Binding var currentDragOffset: CGFloat
    @Binding var previousDragOffset: CGFloat
    @Binding var headerOffset: CGFloat
    @Binding var headerSize: CGFloat
    @Binding var scrollOffset: CGFloat

	var onStartDragging: () -> ()
	var willEndDragging: (CGFloat, CGFloat) -> ()
	var onEndDragging: () -> ()

    init(spacing: CGFloat = 10, 
        currentDragOffset: Binding<CGFloat>,
        previousDragOffset: Binding<CGFloat>,
        headerOffset: Binding<CGFloat>,
        headerSize: Binding<CGFloat>,
        scrollOffset: Binding<CGFloat>,
		onStartDragging: @escaping () -> (),
		willEndDragging: @escaping (CGFloat, CGFloat) -> (),
		onEndDragging: @escaping () -> (),
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder stickyHeader: @escaping () -> StickyHeader,
        @ViewBuilder background: @escaping () -> Background,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.spacing = spacing
        self.header = header()
        self.stickyHeader = stickyHeader()
        self.background = background()
        self.content = content()
        self._currentDragOffset = currentDragOffset
        self._previousDragOffset = previousDragOffset
        self._headerOffset = headerOffset
        self._headerSize = headerSize
        self._scrollOffset = scrollOffset
		self.onStartDragging = onStartDragging
		self.willEndDragging = willEndDragging
		self.onEndDragging = onEndDragging
    }

    var body: some View {
        ScrollView(.vertical) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    ScrollDetector { translation, offset, inset in
                        DispatchQueue.main.async {
                            scrollOffset = offset.y + inset.top
                            
                            let dragOffset = -max(0, abs(translation.height) - 50 * (translation.height < 0 ? -1 : 1))
                            previousDragOffset = currentDragOffset
                            currentDragOffset = dragOffset
                            
                            let deltaOffset = (currentDragOffset - previousDragOffset).rounded()
                            
                            headerOffset = max(min(headerOffset + deltaOffset, headerSize), 0)
                        }
                        
                    } onWillEndDragging: { offset, velocity in
                        willEndDragging(offset, velocity)
                    } onDraggingStart: { _, offset,_ in
						onStartDragging()
                        headerSize = offset.y
                    } onEndDragging: {
						onEndDragging()
                        currentDragOffset = 0
                        previousDragOffset = 0
                        headerSize = 0
                    }
                }
        }
        .frame(maxWidth: .infinity)
        .safeAreaInset(edge: .top, spacing: spacing) {
            CombineHeaderView()
        } 
    }

    @ViewBuilder
    private func CombineHeaderView() -> some View {
        VStack(spacing: spacing) {
            header
            stickyHeader
        }
        .offset(y: -headerOffset)
        .clipped() 
        .background {
            if scrollOffset > headerSize {
                background
                    .ignoresSafeArea(edges: [.top, .horizontal])
                    .offset(y: -headerOffset)
                    .transition(.identity)
            }
        }
    }
}
