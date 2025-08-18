//
//  DivinaSlidePresentationController.swift
//  iosApp
//
//  Created by Rodrigo Souza on 13/05/25.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import Transmission
import UIKit
import SwiftUI

// NEW: Options for our custom horizontal slide transition
public struct DivinaHorizontalSlideTransitionOptions {
    // FIXME: Correct type for PresentationShadow is needed from Transmission library source.
    // Using Any for now to allow compilation.
    // public typealias OriginalPresentationShadow = Transmission.SlidePresentationLinkTransition.Options.PresentationShadow
    public typealias OriginalPresentationShadow = Any 

    public var edge: Edge
    public var prefersScaleEffect: Bool
    public var preferredCornerRadius: CGFloat?
    // FIXME: Correct type for PresentationShadow is needed.
    // preferredPresentationShadow: OriginalPresentationShadow = .standard
    public var preferredPresentationShadow: OriginalPresentationShadow = "standard" // Placeholder string

    public init(
        edge: Edge = .bottom, // Default to bottom, adjust as needed
        prefersScaleEffect: Bool = true,
        preferredCornerRadius: CGFloat? = nil,
        preferredPresentationShadow: OriginalPresentationShadow = "standard" // Placeholder string
    ) {
        self.edge = edge
        self.prefersScaleEffect = prefersScaleEffect
        self.preferredCornerRadius = preferredCornerRadius
        self.preferredPresentationShadow = preferredPresentationShadow
    }
}

// NEW: Our custom transition representable focusing on horizontal gestures
public struct DivinaHorizontalSlideTransition: PresentationLinkTransitionRepresentable {
    public typealias UIPresentationControllerType = DivinaHorizontalSlidePresentationController

    let divinaOptions: DivinaHorizontalSlideTransitionOptions
    let representableOptions: PresentationLinkTransition.Options

    public init(divinaOptions: DivinaHorizontalSlideTransitionOptions, representableOptions: PresentationLinkTransition.Options) {
        self.divinaOptions = divinaOptions
        self.representableOptions = representableOptions
    }

    public func makeUIPresentationController(
        presented: UIViewController,
        presenting: UIViewController?,
        context: Context
    ) -> DivinaHorizontalSlidePresentationController {
        let controller = DivinaHorizontalSlidePresentationController(
            divinaOptions: self.divinaOptions,
            presentedViewController: presented,
            presenting: presenting,
            source: context.sourceView
        )
        // Further configuration based on representableOptions if needed
        // controller.isInteractive = representableOptions.isInteractive // Example
        // controller.preferredPresentationBackgroundColor = representableOptions.preferredPresentationBackgroundColor // Example
        return controller
    }

    public func updateUIPresentationController(
        presentationController: DivinaHorizontalSlidePresentationController,
        context: Context
    ) {
        // Update the controller if its properties need to change based on view updates.
        // For example, if divinaOptions could change:
        // presentationController.customOptions = self.divinaOptions
        // presentationController.configure(with: self.divinaOptions) // hypothetical method
    }
}

// NEW: Our custom presentation controller with modified gesture handling
public class DivinaHorizontalSlidePresentationController: InteractivePresentationController {
    
    var customOptions: DivinaHorizontalSlideTransitionOptions
    var sourceView: UIView? // Store the source view

    // CORRECTED: Add a pan gesture recognizer
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(customHandlePanGestureRecognized(_:)))
        recognizer.delegate = self
        return recognizer
    }()

    public init(
        divinaOptions: DivinaHorizontalSlideTransitionOptions,
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController?,
        source: UIView? = nil
    ) {
        self.customOptions = divinaOptions
        self.sourceView = source // Store source
        super.init(
            presentedViewController: presentedViewController,
            presenting: presentingViewController
        )
        print("DivinaHorizontalSlidePresentationController initialized. Adding gesture recognizer in presentationTransitionWillBegin.")
    }

    @objc private func customHandlePanGestureRecognized(_ gesture: UIPanGestureRecognizer) {
        print("customHandlePanGestureRecognized state: \(gesture.state.rawValue)")
        let translation = gesture.translation(in: gesture.view?.superview ?? containerView)
        var progress: CGFloat = 0.0

        let interactiveDimension: CGFloat
        switch customOptions.edge {
        case .leading, .trailing:
            interactiveDimension = presentedView?.frame.width ?? containerView?.bounds.width ?? UIScreen.main.bounds.width
        case .top, .bottom:
            interactiveDimension = presentedView?.frame.height ?? containerView?.bounds.height ?? UIScreen.main.bounds.height
        @unknown default:
            interactiveDimension = 0
        }

        if interactiveDimension == 0 {
            // If dimension is zero, cannot calculate progress. Might cancel or ignore.
            if gesture.state == .began || gesture.state == .changed {
                gesture.state = .cancelled // Or .failed
            }
            return
        }

        switch customOptions.edge {
        case .leading:
            progress = -translation.x / interactiveDimension
            if abs(translation.y) > abs(translation.x) * 1.5 {
                 // gesture.state = .cancelled // Optional: cancel if too much Y movement
            }
        case .trailing:
            progress = translation.x / interactiveDimension
             if abs(translation.y) > abs(translation.x) * 1.5 {
                // Similar heuristic
            }
        case .top, .bottom:
            // For vertical slides, we'd use translation.y
            // This part of the logic would need to be robust if we also supported vertical custom pans.
            // For now, if top/bottom, this custom handler might not be ideal,
            // or it should use the original InteractivePresentationController's logic.
            // This example focuses on X-axis for leading/trailing.
            // If we want to fallback to superclass for top/bottom, we can't, as we don't override.
            // So, this custom handler should correctly handle all specified edges or be used selectively.
            // For simplicity, let's assume this controller is *only* for custom horizontal pans.
            // If customOptions.edge is .top or .bottom, this handler might behave unexpectedly
            // unless we add proper y-axis logic here.
            // Fallback for now:
            if customOptions.edge == .top { progress = -translation.y / interactiveDimension }
            if customOptions.edge == .bottom { progress = translation.y / interactiveDimension }

        @unknown default:
            if gesture.state == .began || gesture.state == .changed { gesture.state = .cancelled }
            return
        }
        
        progress = max(0.0, min(1.0, progress))

        switch gesture.state {
        case .began:
            print("Gesture began, attempting to dismiss presentedViewController interactively.")
            self.presentedViewController.dismiss(animated: true, completion: nil)
        case .changed:
            print("Gesture changed, updating progress: \(progress)")
        case .ended:
            let velocity: CGFloat
            var shouldFinish = false
            switch customOptions.edge {
            case .leading:
                velocity = gesture.velocity(in: gesture.view?.superview).x
                shouldFinish = progress > 0.5 || velocity < -500 
            case .trailing:
                velocity = gesture.velocity(in: gesture.view?.superview).x
                shouldFinish = progress > 0.5 || velocity > 500
            case .top:
                velocity = gesture.velocity(in: gesture.view?.superview).y
                shouldFinish = progress > 0.5 || velocity < -500
            case .bottom:
                velocity = gesture.velocity(in: gesture.view?.superview).y
                shouldFinish = progress > 0.5 || velocity > 500
            @unknown default:
                velocity = 0
            }
            
            if shouldFinish {
                print("Gesture ended, finishing interactive transition.")
            } else {
                print("Gesture ended, cancelling interactive transition.")
            }
        case .cancelled, .failed:
            print("Gesture cancelled or failed, cancelling interactive transition.")
        default:
            break
        }
    }
    
    // Placeholder: These methods also need to be adapted from the original SlidePresentationController.swift
    // or implemented based on the desired visual behavior of the slide.
    public override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        // This is a VERY simplified placeholder and does not respect customOptions.edge,
        // scale effects, corner radius, etc. The original implementation is needed.
        var frame = containerView.bounds
        switch customOptions.edge {
        case .leading:
            frame.size.width *= 0.8 // Example width
            // frame.origin.x would be 0 when fully presented
        case .trailing:
            frame.size.width *= 0.8 // Example width
            // frame.origin.x would be containerView.bounds.width * 0.2 when fully presented
        case .bottom:
            frame.size.height *= 0.7 // Example height
            frame.origin.y = containerView.bounds.height * 0.3 // When fully presented
        case .top:
            frame.size.height *= 0.7
            // frame.origin.y would be 0 when fully presented
        @unknown default:
            break
        }
        // Centering for placeholder simplicity if not full width/height
        // if customOptions.edge == .leading || customOptions.edge == .trailing {
        //    frame.origin.y = (containerView.bounds.height - frame.size.height) / 2
        // } else if customOptions.edge == .top || customOptions.edge == .bottom {
        //    frame.origin.x = (containerView.bounds.width - frame.size.width) / 2
        // }
        return frame
    }
    
    public override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        if let targetView = presentedView ?? containerView { 
            print("presentationTransitionWillBegin: Adding pan gesture to targetView: \(targetView)")
            targetView.addGestureRecognizer(panGestureRecognizer)
            targetView.isUserInteractionEnabled = true // Ensure view can receive touch
        } else {
            print("presentationTransitionWillBegin: Target view for gesture recognizer is nil.")
        }
        // Setup dimming view, animations for presenting view, etc.
        // This requires careful adaptation from the original Transmission code.
    }

    public override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        // Animations for dismissing view, removing dimming view, etc.
        // This requires careful adaptation from the original Transmission code.
    }
}

extension PresentationLinkTransition {

    /// The default ClickConsultas slide presentation style.
    public static let divinaSlide: PresentationLinkTransition = .divinaSlide(edge: .leading) // Default to .leading or .bottom as preferred

    /// Creates a ClickConsultas slide presentation style with specific options.
    public static func divinaSlide(
        _ transitionOptions: DivinaHorizontalSlideTransitionOptions,
        options: PresentationLinkTransition.Options = .init(
            modalPresentationCapturesStatusBarAppearance: true
        )
    ) -> PresentationLinkTransition {
        .custom(
            options: options, // These are PresentationLinkTransition.Options
            DivinaHorizontalSlideTransition(divinaOptions: transitionOptions, representableOptions: options)
        )
    }

    /// Convenience function to create a ClickConsultas slide presentation style.
    public static func divinaSlide(
        edge: Edge = .leading,
        prefersScaleEffect: Bool = false, 
        preferredCornerRadius: CGFloat? = nil,
        isInteractive: Bool = true,
        preferredPresentationBackgroundColor: Color? = .clear
    ) -> PresentationLinkTransition {
        // FIXME: Correct type for PresentationShadow is needed.
        // let shadowOption: Transmission.SlidePresentationLinkTransition.Options.PresentationShadow = preferredPresentationBackgroundColor == .clear ? .clear : .minimal
        let shadowOption: Any = preferredPresentationBackgroundColor == .clear ? "clear" : "minimal" // Placeholder string
        
        let divinaOptions = DivinaHorizontalSlideTransitionOptions(
            edge: edge,
            prefersScaleEffect: prefersScaleEffect,
            preferredCornerRadius: preferredCornerRadius,
            preferredPresentationShadow: shadowOption
        )
        
        let representableOpts = PresentationLinkTransition.Options(
            isInteractive: isInteractive,
            modalPresentationCapturesStatusBarAppearance: true,
            preferredPresentationBackgroundColor: preferredPresentationBackgroundColor
        )
        
        return .divinaSlide(divinaOptions, options: representableOpts)
    }
}
