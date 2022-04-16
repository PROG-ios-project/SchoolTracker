//
//  NotificationManager.swift
//  SchoolTracker
//
//  Created by Danil Andriuschenko on 05.04.2022.
//

import Foundation
import UserNotifications
class NotificationManager{
    static let shared = NotificationManager()
    
    
    //Set up notifications for all assessments
    func setUpNotifications(assessmnets: [Assessment]){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for assessmnet in assessmnets {
            if !assessmnet.isComplete && assessmnet.willNotify{
                guard let request = getNotificationRequest(assessment: assessmnet) else{
                    continue
                }
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
    
    //returns notification request for an assessment
    private func getNotificationRequest(assessment: Assessment) -> UNNotificationRequest?{
        let content = UNMutableNotificationContent()
        content.title = "Assessment due date is approaching"
        content.body = assessment.notificationTime == 0 ? "Activity due now" : "Activity due in \(assessment.notificationTime) minutes"
        
        
        let identifier = UUID().uuidString
        
        content.sound = .default
        content.badge = 1
        
        guard let notificationDate = Calendar.current.date(byAdding: .minute, value: assessment.notificationTime, to: assessment.dateDue) else{
            return nil
        }
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.weekOfMonth,.day,.hour,.minute], from: notificationDate), repeats: false)
        return UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    }
    
    
}
