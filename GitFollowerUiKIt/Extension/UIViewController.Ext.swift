//
//  UIViewController.Ext.swift
//  GitFollowerUiKIt
//
//  Created by stephen chacha on 24/08/2024.
//

import UIKit

fileprivate var containerView : UIView!

extension UIViewController {
    func pressGFAlertOnMainThread(title: String, message: String, buttuonTitle: String){
        DispatchQueue.main.async {
            let alertViewController = GFAlertViewController(alertTitle: title, message: message, buttonTitle: buttuonTitle)
            alertViewController.modalPresentationStyle = .overFullScreen
            alertViewController.modalTransitionStyle = .crossDissolve
            self.present(alertViewController, animated: true)
        }
    }
    
    func shouldShowLoadingView(){
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) { containerView.alpha = 0.8 }
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func dismissLoading(){
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
       
    }
    
    func showEmptyStateView(with message: String, in view : UIView){
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
