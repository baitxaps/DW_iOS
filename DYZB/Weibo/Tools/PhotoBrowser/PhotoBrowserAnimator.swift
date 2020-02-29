//
//  PhotoBrowserAnimator.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/29.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit
// MARK:-展现动画协议
protocol PhotoBrowserPresentDelegate:NSObjectProtocol {
    // 指定indexPath 对应的imageVIew 用来做动画效果
    func imageViewForPresent(indexPath:NSIndexPath) -> UIImageView
    //动画转场的起始位置
    func photoBrowserPresentFromRect(indexPath:NSIndexPath) -> CGRect
    // 动画转场的目标位置
    func photoBrowserPresentToRect(indexPath:NSIndexPath) -> CGRect
}

// MARK:-解除动画协议
protocol PhotoBrowserDismissDelegate:NSObjectProtocol {
    // 解除转场的图像视图
    func imageViewForDismiss() -> UIImageView
    // 解除转场的图像索引
    func indexPathForDismiss() -> NSIndexPath
}

//--------模型-----------
class PhotoBrowserAnimator: NSObject,UIViewControllerTransitioningDelegate {
    
    weak var presentDelegate : PhotoBrowserPresentDelegate?
    weak var dismissDelegate : PhotoBrowserDismissDelegate?
    var indexPath: NSIndexPath?
    
    private var isPresented = false
    
    
    func setPresentDelegate(presentDelegate:PhotoBrowserPresentDelegate,
        indexPath:NSIndexPath,
        dismissDelegate:PhotoBrowserDismissDelegate) {
        
        self.dismissDelegate = dismissDelegate
        self.presentDelegate = presentDelegate
        self.indexPath = indexPath
    }
    
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
        return 0.35
    }
    
    // 实现具体的动画效果,一时实现了此方法，所有的动画代码都交由程序员负责
    /*
     containerView
     容器视图，将Modal要展现的视图包装在容器视图中,存放的视图要显示，要指定大小。
     completeTransition:无论转场是否被取消，都必须被调用，否则系统不做其他事件处理
     */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 自动布局系统不会对根视图做任何约束
        /*
         let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
         let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
         print(fromVC as Any,toVC as Any)
         
         let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
         let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
         print(fromView as Any,toView as Any)
         */
        isPresented ? presentAnimation(transitionContext: transitionContext):dismissAnimaiton(transitionContext:transitionContext)
    }
    
    // dismissAnimaiton
    private func dismissAnimaiton(transitionContext: UIViewControllerContextTransitioning) {
        guard let presentDelegate = presentDelegate,
            let dismissDelegate = dismissDelegate else {
                return
        }
        
        // 获取 dismiss 要展现的控制器的根视图
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        fromView?.removeFromSuperview()
        
        // 获取图像视图
        let iv = dismissDelegate.imageViewForDismiss()
        transitionContext.containerView.addSubview(iv)
        
        let indexPath = dismissDelegate.indexPathForDismiss()
        UIView.animate(withDuration:transitionDuration(using:transitionContext), animations: {
            // 让IV 运动到目标位置
            iv.frame = presentDelegate.photoBrowserPresentFromRect(indexPath: indexPath)
           
        }, completion: { (_) in
            iv.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
    
    // presentAnimation
    private func presentAnimation(transitionContext: UIViewControllerContextTransitioning) {
        guard let presentDelegate = presentDelegate,let indexPath = indexPath else {
            return
        }
        
        // 获取 modal 要展现的控制器的根视图
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
         toView?.alpha = 0.0;
        // 将视图添加到容器视图中
        transitionContext.containerView.addSubview(toView!)
        
        // 图像视图
        let iv = presentDelegate.imageViewForPresent(indexPath: indexPath)
        // 提定图像位置
        iv.frame = presentDelegate.photoBrowserPresentFromRect(indexPath: indexPath)
        transitionContext.containerView.addSubview(iv)

        UIView.animate(withDuration:transitionDuration(using:transitionContext), animations: {
            iv.frame = presentDelegate.photoBrowserPresentToRect(indexPath: indexPath)
            toView?.alpha = 1.0
            
        }, completion: { (_) in
            iv.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
        
    }
}
//--------模型-----------

























