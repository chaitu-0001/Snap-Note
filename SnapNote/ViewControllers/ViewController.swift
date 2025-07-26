//
//  ViewController.swift
//  SnapNote
//
//  Created by chaitanya on 23/05/25.
//

import AVFoundation
import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import CoreData
import PDFKit
import Photos

class ViewController: UIViewController {
    
    var signedInUserName: String?
    var signedInUserEmail: String?
    var signedInUserProfilePictureURL: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //override func viewDidAppear(_ animated: Bool) {
    ///    super.viewDidAppear(animated)
    
    // Optional: Only auto-navigate if user is already signed in
    /*
     if Auth.auth().currentUser != nil {
     navigateToHome()
     }
     */
    // }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("Missing Firebase client ID")
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
            if let error = error {
                print("Google Sign-In error: \(error.localizedDescription)")
                return
            }
            
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken else {
                print("Missing Google auth tokens")
                return
            }
            
            
    let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
    Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                print("Firebase Sign-In error: \(error.localizedDescription)")
                    return
                }
                
            guard let user = result?.user else {
                print("Firebase user not found")
                    return
                }
                
            let name = user.displayName ?? "No Name"
            let email = user.email ?? "No Email"
            let profileURL = user.photoURL?.absoluteString ?? ""
                
            self.signedInUserName = name
            self.signedInUserEmail = email
            self.signedInUserProfilePictureURL = profileURL
                
                // Save user data to Core Data
                self.saveUserToCoreData(name: name, email: email, profilePictureURL: profileURL)
                
                // Navigate to Home
                DispatchQueue.main.async {
                    self.navigateToHome()
                }
            }
        }
    }
    
    
    func navigateToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            self.navigationController?.pushViewController(homeVC, animated: true)
        } else {
            print("HomeViewController not found in storyboard")
        }
    }
    
    func saveUserToCoreData(name: String, email: String, profilePictureURL: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "CDUser", in: context) else {
            print("Could not find 'CDUser'")
            return
        }
        
        let user = NSManagedObject(entity: entity, insertInto: context)
        user.setValue(name, forKey: "name")
        user.setValue(email, forKey: "email")
        user.setValue(profilePictureURL, forKey: "profilePictureURL")
        
        do {
            try context.save()
            print("User saved to Core Data")
            print("User:")
            print("Name: \(name)")
            print("Email: \(email)")
            print("Profile Picture URL: \(profilePictureURL)")
        } catch {
            print("Core Data save failed: \(error.localizedDescription)")
        }
    }
    
    func saveProductsToCoreData(_ products: [Product]) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        
        for product in products {
            let cdProduct = CDProduct(context: context)
            cdProduct.id = product.id
            cdProduct.name = product.name
            
            if let dataDict = product.data as? [String: Any] {
                if let jsonData = try? JSONSerialization.data(withJSONObject: dataDict, options: []) {
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    cdProduct.data = jsonString
                }
            }
        }
        
        do {
            try context.save()
            print("Products saved!")
        } catch {
            print("Failed to save products: \(error)")
        }
    }
    
}
