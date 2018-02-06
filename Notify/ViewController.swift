//
//  ViewController.swift
//  Notify
//
//  Created by Perry Fraser on 2/6/18.
//  Copyright © 2018 Perry Fraser. All rights reserved.
//

import UIKit
import UserNotifications

extension Array {
    var random: Element { return self[Int(arc4random_uniform(UInt32(count)))] }
}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        
        var result = [["Error", "Error"]]
        
        if let path = Bundle.main.path(forResource: "quotes", ofType: "json") {
            do {
                let data = try String(contentsOfFile: path).data(using: .utf8, allowLossyConversion: false)
                result = try! JSONDecoder().decode([[String]].self, from: data!)
            } catch {
                print("Couldn't load contents")
            }
        } else {
            print("File not found or something")
        }
        
        for i in 1...1000 {
            // Quote, author
            let quote = result.random
            let content = UNMutableNotificationContent()
            content.title = quote[1]
            content.body = quote[0]
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "Spam+\(i)", content: content, trigger: trigger)
            
            center.add(request) { (error : Error?) in
                if let theError = error {
                    print(theError.localizedDescription)
                }
            }
            UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

