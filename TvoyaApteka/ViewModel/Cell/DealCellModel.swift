//
//  DealCellModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 27.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

class DealCellModel {
    
    let promotion: Promotion
    let titleText: String
    let dealImageUrl: URL?
    let descriptionText: String
    private(set) var subtitleText: String!
    let timeInfoText = BehaviorSubject<String>(value: "")
    
    private weak var timer: Timer?
    private var timerSeconds: Int = 0
    
    init(promotion: Promotion) {
        self.promotion = promotion
        
        self.titleText = promotion.title
        self.dealImageUrl = promotion.getMainImageUrl()
        self.descriptionText = promotion.text
        self.subtitleText = self.getTextInterval(for: promotion)
        setupTime(promotion: promotion)
    }
    
    private func setupTime(promotion: Promotion) {
        guard let endDate = promotion.endDate else {
            timeInfoText.onNext("Бессрочно")
            return
        }
        
        let endDateSecondsSinceNow = Int(endDate.timeIntervalSinceNow)
        
        guard endDateSecondsSinceNow > 0 else {
            timeInfoText.onNext("Завершена")
            return
        }
        
        timerSeconds = endDateSecondsSinceNow
        showTimeInfoText()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc
    private func update() {
        guard timerSeconds > 1 else {
            timer?.invalidate()
            timeInfoText.onNext("Завершена")
            return
        }
        
        timerSeconds -= 1
        showTimeInfoText()
    }
    
    private func showTimeInfoText() {
        let text = convertToLabel(endDate: promotion.endDate!)
        timeInfoText.onNext(text)
    }
    
    private func convertToLabel(endDate: Date) -> String {
        let calendar = Calendar.current
        let today = Date()
        let components = calendar.dateComponents([.day, .hour, .minute], from: today, to: endDate)
        
        var result: String = "До конца акции: "
        
        if let days = components.day, days > 0 {
            let daysPluralForm = days.pluralForm(form1: "день", form2: "дня", form5: "дней")
            let hoursPluralForm = components.hour!.pluralForm(form1: "час", form2: "часа", form5: "часов")
            result += "\(days) \(daysPluralForm) \(components.hour!) \(hoursPluralForm)"
            return result
        }
        
        result += getClockTime(hours: components.hour!, minutes: components.minute!)
        return result
    }
    
    private func getClockTime(hours: Int, minutes: Int) -> String {
        let hoursString = hours > 10 ? "\(hours)": "0\(hours)"
        let minutesString = minutes > 10 ? "\(minutes)": "0\(minutes)"
        return "\(hoursString):\(minutesString)"
    }
    
    private func getTextInterval(for promotion: Promotion) -> String {
        if promotion.startDate == nil && promotion.endDate == nil {
            return ""
        }
        
        if promotion.startDate != nil && promotion.endDate == nil {
            return "От " + promotion.startDate!.toString(withFormat: .dateShortDottedText)
        }
        
        if promotion.startDate == nil && promotion.endDate != nil {
            return "До " + promotion.endDate!.toString(withFormat: .dateShortDottedText)
        }
        
        if promotion.startDate != nil && promotion.endDate != nil {
            let startDateString = promotion.startDate!.toString(withFormat: .dateShortDottedText)
            let endDateString = promotion.endDate!.toString(withFormat: .dateShortDottedText)
            return "\(startDateString) - \(endDateString)"
        }
        
        return ""
    }
    
    func destroyTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}
