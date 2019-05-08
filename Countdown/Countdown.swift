//
//  Countdown.swift
//  CountdownDemo
//
//  Created by Paul Solt on 5/7/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import Foundation

protocol CountdownDelegate: AnyObject {
    func countdownDidUpdate(timeRemaining: TimeInterval)
    func countdownDidFinish()
}

enum CountdownState {
    case started
    case finished
    case reset
}

class Countdown {
    
    init() {
        timer = nil
        stopDate = nil
        duration = 0
        state = .reset
    }
    
    func start() {
        // Cancel timer before starting new timer
        cancelTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: updateTimer(timer:))
        stopDate = Date(timeIntervalSinceNow: duration)
        state = .started
    }
    
    func reset() {
        stopDate = nil
        cancelTimer()
        state = .reset
    }
    
    func cancelTimer() {
        // We must invalidate a timer, or it will continue to run even if we
        // start a new timer
        timer?.invalidate()
        timer = nil
    }
    
    private func updateTimer(timer: Timer) {
        
        if let stopDate = stopDate {
            let currentTime = Date()
            if currentTime <= stopDate {
                // Timer is active, keep counting down
                delegate?.countdownDidUpdate(timeRemaining: timeRemaining)
                
            } else {
                // Timer is finished, reset and stop counting down
                state = .finished
                cancelTimer()
                self.stopDate = nil
                delegate?.countdownDidFinish()
            }
        }
    }
    
    weak var delegate: CountdownDelegate?
    var duration: TimeInterval
    var timeRemaining: TimeInterval {
        
        if let stopDate = stopDate {
            let timeRemaining = stopDate.timeIntervalSinceNow
            return timeRemaining
        } else {
            return 0
        }
        
    }
    
    private var timer: Timer?
    private var stopDate: Date?
    private(set) var state: CountdownState
}
