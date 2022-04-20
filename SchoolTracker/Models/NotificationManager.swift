//
//  NotificationManager.swift
//  SchoolTracker
//
//  Created by Danylo Andriuschenko on 05.04.2022.
//

import Foundation
import UserNotifications
class NotificationManager{
    static let shared = NotificationManager()
    
    
    //Set up notifications for all assessments
    func setUpNotifications(assessmnets: [Assessment]){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        for assessmnet in assessmnets {
            if !assessmnet.isComplete && assessmnet.willNotify && Date() < getNotificationDate(assessment: assessmnet) ?? assessmnet.dateDue{
                guard let request = getNotificationRequest(assessment: assessmnet) else{
                    continue
                }
                UNUserNotificationCenter.current().add(request)
                print("Successfully added notification")
            }
        }
    }
    //returns notification date from assessment
    private func getNotificationDate(assessment: Assessment) -> Date?{
        guard let notificationDate = Calendar.current.date(byAdding: .minute, value: -1 * assessment.notificationTime, to: assessment.dateDue) else{
            return nil
        }
        return notificationDate
    }
    
    //returns notification request for an assessment
    private func getNotificationRequest(assessment: Assessment) -> UNNotificationRequest?{
        let content = UNMutableNotificationContent()
        content.title = "Due date is soon"
        content.body = assessment.notificationTime == 0 ? "Activity due now" : "Activity due in \(assessment.notificationTime) minutes"
        
        
        let identifier = UUID().uuidString
        
        content.sound = .default
        content.badge = 1
        
        guard let notificationDate = getNotificationDate(assessment: assessment) else{
            return nil
        }
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.weekOfMonth,.day,.hour,.minute], from: notificationDate), repeats: false)

        
        return UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    }
    
    
}
