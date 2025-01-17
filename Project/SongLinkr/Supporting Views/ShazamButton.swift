//
//  ShazamButton.swift
//  SongLinkr
//
//  Created by Harry Day on 20/06/2021
//  
//
//  Twitter: https://twitter.com/realharryday
//  Github: https://github.com/harryday123
//


import SwiftUI

struct ShazamButton: View {
    /// The view model for making a request
    @EnvironmentObject var viewModel: RequestViewModel
    
    /// The user settings stored in the environment
    @EnvironmentObject var userSettings: UserSettings
    
    /// Declares whether a request is being made
    @Binding var shazamState: RequestViewModel.ShazamState
    
    /// The function to use to start a shazam match
    let startShazam: () -> Void
    
    /// The function to stop recording and matching on Shazam
    let stopShazam: () -> Void
    
    var body: some View {
        Button(action: {
            if shazamState == .matching {
                stopShazam()
            } else {
                startShazam()
            }
        }) {
            switch shazamState {
                case .idle:
                    Label("Match with Shazam", image: "shazam.fill")
                
                case .matching:
                    ProgressView("Listening")
                        .tint(.secondary)
                
                case .matchFound:
                    ProgressView("Shazam Match Found")
                        .tint(.secondary)
                case .finished:
                    Label("Matches Found", systemImage: "checkmark.icloud")
            }
        }
        // Button Styling
        .tint(.blue)
        .buttonStyle(.bordered)
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        // Disabled if already matching
        .disabled(shazamState == .matchFound || shazamState == .finished)
    }
}

struct ShazamButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ShazamButton(shazamState: .constant(.idle), startShazam: {}, stopShazam: {})
                .previewLayout(.fixed(width: 300, height: 100))
        }
    }
}
