//
//  UserSettings.swift
//  COSC345-Project
//
//  Created by Hunter Kingsbeer on 28/05/21.
//

import Foundation
import SwiftUI
import Combine

/// Class of settings that the user may specify, impacting the interface.
class UserSettings: ObservableObject {
    @Published var darkMode: Bool {
        didSet {
            UserDefaults.standard.set(darkMode, forKey: "darkMode")
        }
    }
    
    @Published var style: Int {
        didSet {
            UserDefaults.standard.set(style, forKey: "style")
        }
    }
    
    @Published var thinFolders: Bool {
        didSet {
            UserDefaults.standard.set(thinFolders, forKey: "thinFolders")
        }
    }
    
    @Published var shadows: Bool {
        didSet {
            UserDefaults.standard.set(shadows, forKey: "shadows")
        }
    }

    /// Default settings.
    init() {
        /// Dark mode.
        self.darkMode = UserDefaults.standard.object(forKey: "darkMode") as? Bool ?? false
        /// Enables shadows on objects.
        self.shadows = UserDefaults.standard.object(forKey: "shadows") as? Bool ?? true
        /// Colour scheme for background gradients.
        self.style = UserDefaults.standard.object(forKey: "style") as? Int ?? 0
        /// Enables the original thinner folder style, instead of the newer big folders.
        self.thinFolders = UserDefaults.standard.object(forKey: "thinFolders") as? Bool ?? true
    }
}
