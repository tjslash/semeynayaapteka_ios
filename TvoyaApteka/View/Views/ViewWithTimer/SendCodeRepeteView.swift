//
//  SendCodeRepeteView.swift
//  TvoyaAptekaInterface
//
//  Created by BuidMac on 07.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class SendCodeRepeteView: UIView {
    
    /// Will executed when user touchUpInside on button
    public var didTapAction: (() -> Void)? {
        didSet {
            viewWithTimer.didTapAction = didTapAction
        }
    }
    
    private let viewWithTimer: ViewWithTimer
    private let innerView = InnerView()
    
    public init(seconds: TimeInterval) {
        viewWithTimer = ViewWithTimer(seconds: seconds)
        super.init(frame: .zero)
        setupLayout()
        setupViewWithTimer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(viewWithTimer)
        
        viewWithTimer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupViewWithTimer() {
        innerView.iconTimer.image = #imageLiteral(resourceName: "stopwatch")
        viewWithTimer.innerView = innerView
        viewWithTimer.actionText = "Выслать код повторно".uppercased()
        
        viewWithTimer.updateTimer = { [weak self] seconds in
            self?.updateTextLabel(seconds)
        }
    }
    
    private func updateTextLabel(_ seconds: TimeInterval) {
        let time = convertToTimeString(seconds)
        innerView.textLabel.text = "Отправить код повторно\nможно через \(time) с"
    }
    
    private func convertToTimeString(_ seconds: TimeInterval) -> String {
        let min = Int(seconds / 60)
        let sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        let secString = sec < 10 ? "0\(sec)" : "\(sec)"
        return "\(min):\(secString)"
    }
    
    /// Start timer and show view with timer
    public func start() {
        viewWithTimer.start()
    }
    
    /// Stop timer and return view to start state
    public func stop() {
        viewWithTimer.stop()
    }

}

private class InnerView: UIView {
    
    let iconTimer: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.Title.h3
        label.textColor = .taGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setypLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setypLayout() {
        addSubview(iconTimer)
        addSubview(textLabel)
        
        iconTimer.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(66)
            make.width.equalTo(24)
            make.height.equalTo(27)
        }
        
        textLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconTimer.snp.right).offset(17)
            make.right.equalToSuperview().offset(-66)
        }
    }
    
}
