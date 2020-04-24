//
//  UIAlertController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/23/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func showAlert(on vc: UIViewController, message: String?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error occured",
                                                    message: message,
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            vc.present(alertController, animated: true, completion: nil)
        }
    }
}
