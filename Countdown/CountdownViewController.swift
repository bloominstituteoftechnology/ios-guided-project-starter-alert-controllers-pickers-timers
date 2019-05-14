//
//  CountdownViewController.swift
//  Countdown
//
//  Created by Paul Solt on 5/8/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit

class CountdownViewController: UIViewController {

    @IBOutlet var countdownPickerView: CountdownPicker!
    @IBOutlet var countdownLabel: UILabel!
    
    private let countdown: Countdown = Countdown()
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SS"
        formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countdown.duration = countdownPickerView.duration
        self.countdown.delegate = self
        
        self.countdownPickerView.countDownDelegate = self
        
        // Use a fixed width font, so numbers don't "pop" and update UI to show duration
        self.countdownLabel.font = UIFont.monospacedDigitSystemFont(ofSize: self.countdownLabel.font.pointSize, weight: .medium)
        self.updateViews()
    }

    @IBAction func startButtonTapped(_ sender: Any) {
        self.countdown.start()
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        self.countdown.reset()
        self.updateViews()
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Timer Finished!", message: "Your countdown is over.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func timerFinished(time: Timer) {
        self.updateViews()
        self.showAlert()
    }
    
    func string(from duration: TimeInterval) -> String {
        let date = Date(timeIntervalSinceReferenceDate: duration)
        return dateFormatter.string(from: date)
    }
}

extension CountdownViewController: CountdownDelegate {
    func countdownDidUpdate(timeRemaining: TimeInterval) {
        updateViews()
    }
    
    func countdownDidFinish() {
        updateViews()
        self.showAlert()
    }
    
    private func updateViews() {
        switch self.countdown.state {
        case .started:
            self.countdownLabel.text = string(from: self.countdown.timeRemaining)
        case .finished:
            self.countdownLabel.text = string(from: 0)
        case .reset:
            self.countdownLabel.text = string(from: self.countdown.duration)
        }
    }
}


extension CountdownViewController: CountdownPickerDelegate {
    func countdownPickerDidSelect(duration: TimeInterval) {
        // Update countdown to use new picker duration value
        self.countdown.duration = duration
        self.updateViews()
    }
}

