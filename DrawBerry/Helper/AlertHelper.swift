//
//  AlertHelper.swift
//  DrawBerry
//
//  Created by See Zi Yang on 18/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class AlertHelper {
    static var alert: UIAlertController?

    static func makeInputAlert(title: String, message: String, placeholder: String,
                               handler: @escaping (String) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = placeholder
            textField.addTarget(self, action: #selector(validateTextField(_:)), for: .editingChanged)
        })

        let enterAction = UIAlertAction(
            title: "Ok",
            style: .default,
            handler: { _ in
                if let input = StringHelper.trim(string: alert.textFields?.first?.text) {
                    handler(input)
                }
            })
        enterAction.isEnabled = false
        alert.addAction(enterAction)

        self.alert = alert
        return alert
    }

    @objc static func validateTextField(_ sender: UITextField) {
        // text field cannot be empty/contain only spaces
        alert?.actions[0].isEnabled =
            !(sender.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
    }
}
