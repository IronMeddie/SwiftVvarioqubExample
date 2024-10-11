//
//  VarioHelper.swift
//  VarioqubTestApp
//
//  Created by Mikhail Taranyuk on 11.10.2024.
//

import Varioqub
import Foundation


final class VarioHelper {
    
    private let varioqub = VarioqubFacade.shared
    
    init() {
        varioqub.initialize(clientId: "appmetrica.4638238", idProvider: nil, reporter: nil)
    }
    
    func setup() {
        varioqub.fetchAndActivateConfig { status in
            switch status {
            case .success, .throttled, .cached:
                NSLog("MYLOG fetchConfig %@", VarioqubFacade.shared.allItems)
            case .error(_):
                NSLog("MYLOG fetchConfig error")
            @unknown default:
                NSLog("MYLOG unknown default")
            }
        }
    }
}
