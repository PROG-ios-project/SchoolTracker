//
//  AppDelegate.swift
//  SchoolTracker
//
//  Created by Danil Andriuschenko on 24.03.2022.
//

import UIKit
import CoreData
import SQLite3

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let databaseName : String? = "SchoolDatabase.db"
    var databasePath : String?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let documentsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        databasePath = documentsDir.appending("/" + databaseName!)
        checkAndCreateDatabase()
        
        return true
    }
    
    func checkAndCreateDatabase()
    {

        var success = false
        let fileManager = FileManager.default
        
        success = fileManager.fileExists(atPath: databasePath!)
    
        if success {
            return
        }
    
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
        
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
    
        return
    }
    
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    
    
    //Will resign active - set notifications
    func applicationWillResignActive(_ application: UIApplication) {
        let courses = SchoolDB.shared.getAllCourses()
        var assessments: [Assessment] = []
        courses.forEach({
            let assessmentList = SchoolDB.shared.getAssessmentList(courseId: $0.id)
            for assessment in assessmentList{
                assessments.append(assessment)
            }
        })
        NotificationManager.shared.setUpNotifications(assessmnets: assessments)
    }

}

