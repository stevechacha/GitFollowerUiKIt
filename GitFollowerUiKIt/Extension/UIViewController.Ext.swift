//
//  UIViewController.Ext.swift
//  GitFollowerUiKIt
//
//  Created by stephen chacha on 24/08/2024.
//

import UIKit
import ObjectiveC

private var containerViewKey: UInt8 = 0

extension UIViewController {
    private var containerView: UIView? {
        get {
            return objc_getAssociatedObject(self, &containerViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &containerViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func pressGFAlertOnMainThread(title: String, message: String, buttonTitle: String){
        DispatchQueue.main.async {
            let alertViewController = GFAlertViewController(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alertViewController.modalPresentationStyle = .overFullScreen
            alertViewController.modalTransitionStyle = .crossDissolve
            self.present(alertViewController, animated: true)
        }
    }
    
    func shouldShowLoadingView(){
        guard containerView == nil else { return }
        
        let loadingContainerView = UIView(frame: view.bounds)
        containerView = loadingContainerView
        view.addSubview(loadingContainerView)
        
        loadingContainerView.backgroundColor = .systemBackground
        loadingContainerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) { loadingContainerView.alpha = 0.8 }
        let activityIndicator = UIActivityIndicatorView(style: .large)
        loadingContainerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func dismissLoading(){
        DispatchQueue.main.async {
            self.containerView?.removeFromSuperview()
            self.containerView = nil
        }
       
    }
    
    func showEmptyStateView(with message: String, in view : UIView){
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
