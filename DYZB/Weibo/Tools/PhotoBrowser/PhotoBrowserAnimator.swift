//
//  PhotoBrowserAnimator.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/29.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

class PhotoBrowserAnimator: NSObject,UIViewControllerTransitioningDelegate {
    private var isPresented = false
    
    // 返回提供modal展现的 动画的对象
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    // 返回提供dismiss展现的 动画的对象
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}


extension PhotoBrowserAnimator:UIViewControllerAnimatedTransitioning {
    // 动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    // 实现具体的动画效果,一时实现了此方法，所有的动画代码都交由程序员负责
    /*
     containerView
     容器视图，将Modal要展现的视图包装在容器视图中,存放的视图要显示，要指定大小。
     completeTransition:无论转场是否被取消，都必须被调用，否则系统不做其他事件处理
     */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 自动布局系统不会对根视图做任何约束
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        print(fromVC as Any,toVC as Any)
        
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        print(fromView as Any,toView as Any)
        
        isPresented ? presentAnimation(transitionContext: transitionContext):dismissAnimaiton(transitionContext:transitionContext)
    }
    
    // dismissAnimaiton
    private func dismissAnimaiton(transitionContext: UIViewControllerContextTransitioning) {
        // 获取 dismiss 要展现的控制器的根视图
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
  
        UIView.animate(withDuration:transitionDuration(using:transitionContext), animations: {
            fromView?.alpha = 0.0
        }, completion: { (_) in
            fromView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
    
    // presentAnimation
    private func presentAnimation(transitionContext: UIViewControllerContextTransitioning) {
        // 获取 modal 要展现的控制器的根视图
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        // 将视图添加到容器视图中
        transitionContext.containerView.addSubview(toView!)
        toView?.alpha = 0.0;
        
        UIView.animate(withDuration:transitionDuration(using:transitionContext), animations: {
            toView?.alpha = 1.0
        }, completion: { (_) in
            transitionContext.completeTransition(true)
        })
        
    }
}


























