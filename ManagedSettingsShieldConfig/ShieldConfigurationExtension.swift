//
//  ShieldConfigurationExtension.swift
//  ManagedSettingsShieldConfig
//
//  Created by Daniel Crompton on 3/9/25.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    
    static private let applicationShieldConfig = ShieldConfiguration(
        backgroundColor: nil,
        icon: UIImage(systemName: "lock.app.dashed"),
        title: .init(
            text: "You can't use any apps when you're offline!",
            color: .systemRed
        ),
        subtitle: .init(
            text: "Open the Offline Game to go back online",
            color: .secondaryLabel
        ),
        primaryButtonLabel: .init(
            text: "OK",
            color: .white
        ),
        primaryButtonBackgroundColor: .systemRed
    )
    
    
    static private let webShieldConfig = ShieldConfiguration(
        backgroundColor: nil,
        icon: UIImage(systemName: "lock.rectangle.on.rectangle.dashed"),
        title: .init(
            text: "You can't use the internet when you're offline!",
            color: .systemBlue
        ),
        subtitle: .init(
            text: "Open the Offline Game to go back online",
            color: .secondaryLabel
        ),
        primaryButtonLabel: .init(
            text: "OK",
            color: .white
        ),
        primaryButtonBackgroundColor: .systemBlue
    )
    
    
    override func configuration(shielding: Application) -> ShieldConfiguration {
        Self.applicationShieldConfig
    }
    
    override func configuration(shielding: Application, in: ActivityCategory) -> ShieldConfiguration {
        Self.applicationShieldConfig
    }
    
    
    
    override func configuration(shielding: WebDomain) -> ShieldConfiguration {
        Self.webShieldConfig
    }
    
    override func configuration(shielding: WebDomain, in: ActivityCategory) -> ShieldConfiguration {
        Self.webShieldConfig
    }
}
