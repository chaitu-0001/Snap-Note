//
//  SettingsViewController.swift
//  SnapNote
//
//  Created by chaitanya on 26/05/25.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    @IBAction func notificationSwitch(_ sender: Any) {
    }
    @IBOutlet weak var notificationSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load saved switch state
        let isEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        enableNotificationSwitch.isOn = isEnabled
    }

    @IBOutlet weak var enableNotificationSwitch: UISwitch!
    
    @IBAction func notificationSwitchToggled(_ sender: UISwitch) {
        _ = sender.isOn
        UserDefaults.standard.set(sender.isOn, forKey: "notificationsEnabled")
        print("Notifications are now \(sender.isOn ? "enabled" : "disabled")")
    }
}

