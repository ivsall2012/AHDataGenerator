//
//  AHAnimator.swift
//  AHWeiBo
//
//  Created by Andy Hurricane on 3/2/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHAnimator: NSObject {
    var presentedViewFrame: CGRect = CGRect.zero
    fileprivate var isPresented = false
    fileprivate var callback: ((_ isPresented: Bool)->())?
    init(_ callback: @escaping (_ isPresented: Bool)->()) {
        self.callback = callback
    }
}

extension AHAnimator : UIViewControllerTransitioningDelegate{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentationVC =  AHPresentationVC(presentedViewController: presented, presenting: presenting)
        presentationVC.presentedViewFrame = presentedViewFrame
        return presentationVC
    }
    
    // wil animate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // about to present the animation, so isPresented is sort of true
        isPresented = true
        self.callback!(isPresented)
        
        return self
    }
    // did animate
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        self.callback!(isPresented)
        
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
        // get presentedView by UITransitionContextViewKey.to
        if let presentedView = context.view(forKey: UITransitionContextViewKey.to){
            // add to subview manually
            context.containerView.addSubview(presentedView)
            
            // do animation
            presentedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
            presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            UIView.animate(withDuration: transitionDuration(using: context), animations: {
                    presentedView.transform = CGAffineTransform.identity
                }, completion: { (_) in
                    context.completeTransition(true)
            })
        }
        
        
        
    }
    /// For dismissing animation
    func animationTransitionForDismissing(using context: UIViewControllerContextTransitioning){
        // get presentedView by UITransitionContextViewKey.from
        if let dismissedView = context.view(forKey: UITransitionContextViewKey.from) {
            // do animation
            UIView.animate(withDuration: transitionDuration(using: context), animations: {
                dismissedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0001)
            }) { (_) in
                dismissedView.removeFromSuperview()
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
        setupBackgroundMask()
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




