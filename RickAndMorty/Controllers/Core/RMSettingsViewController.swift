//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by User on 23/02/2025.
//

import UIKit
import SwiftUI
import SafariServices
import StoreKit
/// Contoller to show app settings
final class RMSettingsViewController: UIViewController {
    private var settingsSwiftUIController: UIHostingController<RMSettingsView>?



    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"
        addSwiftUIController()

    }
    
    private func addSwiftUIController() {
            let settingsSwiftUIController = UIHostingController(
                rootView: RMSettingsView{option in
                    self.handleTap(option: option)
                }
            )
            addChild(settingsSwiftUIController)
            settingsSwiftUIController.didMove(toParent: self)

            view.addSubview(settingsSwiftUIController.view)
            settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                settingsSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                settingsSwiftUIController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                settingsSwiftUIController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                settingsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])

            self.settingsSwiftUIController = settingsSwiftUIController
        }
    private func handleTap(option: RMSettingsOption) {
          guard Thread.current.isMainThread else {
              return
          }

          if let url = option.targetUrl {
              // Open website
              let vc = SFSafariViewController(url: url)
              present(vc, animated: true)
          } else if option == .rateApp {
              // Show rating prompt
              if let windowScene = view.window?.windowScene {
                  SKStoreReviewController.requestReview(in: windowScene)
              }
          }
      }
}
