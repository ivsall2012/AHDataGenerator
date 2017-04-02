//
//  AHAnimator.swift
//  AHWeiBo
//
//  Created by Andy Hurricane on 3/2/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

protocol AHAnimatorDelegate: NSObjectProtocol {
    func AHAnimatorStartFrameFor(indexPath : IndexPath) -> CGRect
    func AHAnimatorEndFrameFor(indexPath : IndexPath) -> CGRect
    func AHAnimatorView(indexPath : IndexPath) -> UIView
    func AHAnimatorEndIndexPath() -> IndexPath
}

class AHAnimator: NSObject {
    weak var delegate: AHAnimatorDelegate?
    
    var actingIndexPath: IndexPath?
    var isPresented = false
}


extension AHAnimator : UIViewControllerTransitioningDelegate{
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        
//        let presentationVC =  AHPresentationVC(presentedViewController: presented, presenting: presenting)
//        presentationVC.presentedViewFrame = presentedViewFrame
//        return presentationVC
//    }
    
    // wil animate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // about to present the animation, so isPresented is sort of true
        isPresented = true
        
        return self
    }
    // did animate
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        
        return self
    }
}

extension AHAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationTransitionForPresenting(using: transitionContext) :animationTransitionForDismissing(using: transitionContext)
    }
    
    // for presenting aniamtion
    func animationTransitionForPresenting(using context: UIViewControllerContextTransitioning){
        guard let delegate = delegate, let actingIndexPath = actingIndexPath else {
            return
        }
        
        // get presentedView by UITransitionContextViewKey.to
        if let presentedView = context.view(forKey: UITransitionContextViewKey.to){
            presentedView.alpha = 0.0
            // add to subview manually
            context.containerView.addSubview(presentedView)
            let animatedView = delegate.AHAnimatorView(indexPath: actingIndexPath)
            animatedView.frame = delegate.AHAnimatorStartFrameFor(indexPath: actingIndexPath)
            context.containerView.addSubview(animatedView)
            // do animation
            
            UIView.animate(withDuration: transitionDuration(using: context), animations: {
                animatedView.frame = delegate.AHAnimatorEndFrameFor(indexPath: actingIndexPath)
                }, completion: { (_) in
                    animatedView.removeFromSuperview()
                    presentedView.alpha = 1.0
                    context.completeTransition(true)
            })
            
//            UIView.animate(withDuration: transitionDuration(using: context), delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
//                animatedView.frame = delegate.AHAnimatorEndFrameFor(indexPath: actingIndexPath)
//                }, completion: { (_) in
//                    animatedView.removeFromSuperview()
//                    presentedView.alpha = 1.0
//                    context.completeTransition(true)
//            })
        }
        
        
        
    }
    /// For dismissing animation
    func animationTransitionForDismissing(using context: UIViewControllerContextTransitioning){
        
        guard let delegate = delegate else {
            return
        }
        
        // get presentedView by UITransitionContextViewKey.from
        if let dismissedView = context.view(forKey: UITransitionContextViewKey.from) {
            dismissedView.removeFromSuperview()
            // do animation
            let actingIndexPath = delegate.AHAnimatorEndIndexPath()
            let animatedView = delegate.AHAnimatorView(indexPath: actingIndexPath)
            animatedView.frame = delegate.AHAnimatorEndFrameFor(indexPath: actingIndexPath)
            context.containerView.addSubview(animatedView)
            
            UIView.animate(withDuration: transitionDuration(using: context), animations: {
                animatedView.frame = delegate.AHAnimatorStartFrameFor(indexPath: actingIndexPath)
            }) { (_) in
                animatedView.removeFromSuperview()
                context.completeTransition(true)
            }
        }
        
        
    }
}





class AHPresentationVC: UIPresentationController {
    fileprivate lazy var maskView = UIView()
    var presentedViewFrame = CGRect.zero
    override func containerViewWillLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        // adjust presentedView position
        presentedView?.frame = presentedViewFrame
        
        // setup mask
//        setupBackgroundMask()
    }
}


// MARK:- setup UI
extension AHPresentationVC {
    fileprivate func setupBackgroundMask() {
        containerView?.insertSubview(maskView, at: 0)
        
        maskView.frame = (containerView?.bounds)!
        maskView.backgroundColor = UIColor.clear
        maskView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(maskTapped(_:)))
        maskView.addGestureRecognizer(tapGesture)
    }
}

// MARK:- Events
extension AHPresentationVC {
    @objc fileprivate func maskTapped(_ sender: UIGestureRecognizer){
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}




