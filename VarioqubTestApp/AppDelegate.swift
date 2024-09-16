//
//  AppDelegate.swift
//  VarioqubTestApp
//
//  Created by Mikhail Taranyuk on 16.09.2024.
//

import UIKit
import Varioqub
import MetricaAdapterReflection
import AppMetricaCore

let adapter = AppmetricaAdapter()
let adapterGovna = VQAppmetricaAdapter()
let configuration = AppMetricaConfiguration(apiKey: "b42685b7-6f47-4e40-934e-935a45e8d4c2")

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        configuration?.areLogsEnabled = false
//        configuration?.sessionsAutoTracking = true
        AppMetrica.activate(with: configuration!)
        
        // Конфигурируем настройки Varioqub SDK
        var vqCfg = VarioqubConfig.default

        vqCfg.fetchThrottle = 2
//        VarioqubFacade.shared.sendEventOnChangeConfig = true
        // Инициализируем Varioqub SDK
        VarioqubFacade.shared.initialize(clientId: "appmetrica.4393405", config: vqCfg, idProvider: adapter, reporter: adapter)
        VarioqubFacade.shared.sendEventOnChangeConfig = true
        VarioqubFacade.shared.fetchConfig({ status in
            switch status {
            case .success: NSLog("MYLOG fetchConfig success")
            case .throttled, .cached: NSLog("MYLOG fetchConfig throttled")
            case .error(let e): NSLog("MYLOG fetchConfig error")
            }
        })
        
        VarioqubFacade.shared.activateConfigAndWait()
        let myFlag = VarioqubFlag(rawValue: "testFlag1")
        VarioqubFacade.shared.activateConfig(nil)
        
        let value = VarioqubFacade.shared.getString(for: myFlag, defaultValue: "это дефолтное локальное значение")
        
        let test = VarioqubFacade.shared.getValue(for: myFlag).stringValueOrDefault
        print("флаг получен и он такой: " + test)
        
        
        VarioqubFacade.shared.clientFeatures.setFeature("test", forKey: "feature")
        let flag = VarioqubFlag(rawValue: "testFlag1")
        let flagValue = VarioqubFacade.shared.getValue(for: flag).stringValueOrDefault
        print("флаг получен и он такой: " + flagValue)
        
        AppMetrica.sendEventsBuffer()
        
        return true
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


}
