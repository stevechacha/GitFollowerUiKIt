//
//  SearchViewController.swift
//  GitFollowerUiKIt
//
//  Created by stephen chacha on 23/08/2024.
//

import UIKit
import SwiftUI

class SearchViewController: UIViewController {
    let logoImageView = UIImageView()
    let usernameTextField = GFTextField()
    let callToActionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")
    
    var isUsernameEntered: Bool { return !usernameTextField.text!.isEmpty }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    func createDismissKeyboardTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushFollowesListController (){
        guard isUsernameEntered  else {
            pressGFAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who yo look for ", buttuonTitle: "Ok")
            return
        }
        let followerControllerList = FollowerListViewController()
        followerControllerList.username = usernameTextField.text
        followerControllerList.title = usernameTextField.text
        
        navigationController?.pushViewController(followerControllerList, animated: true)
        
    }
    
    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "gh-logo")
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureTextField() {
        view.addSubview(usernameTextField)
        usernameTextField.delegate = self
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.widthAnchor.constraint(equalToConstant: 300),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCallToActionButton() {
        view.addSubview(callToActionButton)
        callToActionButton.translatesAutoresizingMaskIntoConstraints = false
        callToActionButton.addTarget(self, action: #selector(pushFollowesListController), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            callToActionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            callToActionButton.widthAnchor.constraint(equalToConstant: 300),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}



extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowesListController()
        return true
    }
}


extension String {
    var isValidEmail: Bool {
        let emailRegEx = "^(?!\\.)([A-Z0-9a-z_%+-]?[\\.]?[A-Z0-9a-z_%+-])+@[A-Za-z0-9-]{1,20}(\\.[A-Za-z0-9]{1,15}){0,10}\\.[A-Za-z]{2,20}$"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
   }
    
    var isValidatePassword: Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: self)
    }

}

// Step 1: Create a UIViewControllerRepresentable to wrap the UIKit view controller
struct SearchViewControllerRepresentable:UIViewControllerRepresentable{
    func makeUIViewController(context: Context) ->SearchViewController{
        return SearchViewController()
    }

    func updateUIViewController(_ uiViewController: SearchViewController, context: Context) {
        // Handle updates if needed
    }
}

// Step 2: Add a SwiftUI Preview
struct SearchViewController_Previews: PreviewProvider {
    static var previews: some View {
        SearchViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all) // Optional: Ignore safe area for full preview
            .previewDisplayName("Search View Controller")
    }
}

