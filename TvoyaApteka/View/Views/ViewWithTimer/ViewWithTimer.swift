//
//  ViewWithTimer.swift
//  TvoyaAptekaInterface
//
//  Created by BuidMac on 10.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class ViewWithTimer: UIView {
    
    // MARK: Public API
    
    /// Set custom view
    public var innerView: UIView = UIView() {
        willSet(oldView) {
            oldView.removeFromSuperview()
        }
        didSet {
            addSubview(innerView)
            setupInnerViewLayout()
            updateState()
        }
    }
    
    // Set custom button
    public var actionButton: UIButton = FlatButton() {
        willSet(oldView) {
            oldView.removeFromSuperview()
        }
        didSet {
            addSubview(actionButton)
            setupActionButtonLayout()
            updateState()
            addActionToButton()
        }
    }
    
    /// Set text to action button
    public var actionText: String? {
        didSet {
            actionButton.setTitle(actionText, for: .normal)
        }
    }
    
    /// Will executed when user touchUpInside on button
    public var didTapAction: (() -> Void)?
    
    /// Will executed when start timer and will called every second
    public var updateTimer: ((TimeInterval) -> Void)?
    
    /// Show inner view and to started timer, after called this method you can get remaining time in method updateTimer
    public func start() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(countDownAction),
                                     userInfo: nil, repeats: true)
        
        countdown = seconds
        innerViewIsHidden = false
        updateTimer?(countdown)
    }
    
    /// Show action button and to stoped timer
    public func stop() {
        timer?.invalidate()
        innerViewIsHidden = true
    }
    
    // MARK: Private API
    private var timer: Timer?
    private var seconds: TimeInterval
    private var countdown: TimeInterval = 0
    
    private var innerViewIsHidden = false {
        didSet {
            updateState()
        }
    }
    
    private let lineViewTop: UIView = {
        let view = UIView()
        view.backgroundColor = .taGray
        return view
    }()
    
    private let lineViewBottom: UIView = {
        let view = UIView()
        view.backgroundColor = .taGray
        return view
    }()
    
    public init(seconds: TimeInterval) {
        self.seconds = seconds
        super.init(frame: .zero)
        setupLayout()
        innerViewIsHidden = true
        addActionToButton()
        self.backgroundColor = .taAlmostWhite
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(lineViewTop)
        addSubview(lineViewBottom)
        addSubview(actionButton)
        addSubview(innerView)
        
        setupInnerViewLayout()
        setupActionButtonLayout()
        
        lineViewTop.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        lineViewBottom.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    private func setupInnerViewLayout() {
        innerView.snp.makeConstraints { make in
            make.top.equalTo(lineViewTop.snp.bottom)
            make.bottom.equalTo(lineViewBottom.snp.top)
            make.left.greaterThanOrEqualToSuperview()
            make.right.greaterThanOrEqualToSuperview()
        }
    }
    
    private func setupActionButtonLayout() {
        actionButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func updateState() {
        innerView.isHidden = innerViewIsHidden
        actionButton.isHidden = !innerViewIsHidden
    }
    
    private func addActionToButton() {
        actionButton.addTarget(self, action: #selector(tapHandlerAction), for: .touchUpInside)
    }
    
    @objc
    private func tapHandlerAction() {
        didTapAction?()
        start()
    }
    
    @objc
    private func countDownAction() {
        if countdown <= 0 {
            stop()
        }
        
        countdown -= 1
        updateTimer?(countdown >= 0 ? countdown : 0)
    }
    
}
