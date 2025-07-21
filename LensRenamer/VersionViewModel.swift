//
//  VersionViewModel.swift
//  LensRenamer
//
//  Created by Eliseo Martelli on 21/07/25.
//

import Foundation

class VersionViewModel: ObservableObject {
    @Published var latestVersion: String = Bundle.main.buildVersion!
    @Published var errorMessage: String?
    @Published var isUpdateAvailable: Bool = false
   
    init() {
        self.fetchLatestVersion()
    }
    
    private func fetchLatestVersion() {
        GithubVersionRepository.shared.getVersion { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let version):
                    self.latestVersion = version
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                self.isUpdateAvailable = Bundle.main.buildVersion != self.latestVersion
            }
        }
    }
}

extension Bundle {
    var buildVersion: String? {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
