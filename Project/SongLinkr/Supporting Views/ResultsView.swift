//
//  ResultsView.swift
//  SongLinkr
//
//  Created by Harry Day on 28/06/2020.
//

import SwiftUI
import StoreKit
import SongLinkrNetworkCore

struct ResultsView: View {
    @EnvironmentObject var userSettings: UserSettings
    @State private var showShareSheet = false
    @State private var shareSheetURL: URL = "https://song.link"
    @Binding var showResults: Bool
    let results: ResultsModel
    let saveFunction: @MainActor () async -> Bool
    
    var gridItemLayout = [
        GridItem(.adaptive(minimum: 250))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    MediaDetailView(
                        artworkURL: results.artworkURL,
                        mediaTitle: results.mediaTitle,
                        artistName: results.artistName,
                        displaySaveButton: results.isFromShazam && !userSettings.saveToShazamLibrary,
                        saveFunction: saveFunction
                    )                    
                    
                    ForEach(results.response) { platform in
                        PlatformLinkButtonView(platform: platform)
                            .contextMenu {
                                Button(action: {
                                    self.shareSheetURL = platform.url
                                    self.showShareSheet = true
                                }) {
                                    Text("Share", comment: "A context menu item, launches the share sheet")
                                    Image(systemName: "square.and.arrow.up")
                                }
                                
                                Button(action: { UIPasteboard.general.url = platform.url }) {
                                    Text("Copy", comment: "A context menu item, copies the link to clipboard")
                                    Image(systemName: "doc.on.doc")
                                }
                                
                                Button(action: { UIApplication.shared.open(platform.url) }) {
                                    Text("Open", comment: "A context menu item, opens the link")
                                    Image(systemName: "safari")
                                }
                                
                                if platform.nativeAppUriMobile != nil {
                                    Button(action: { UIApplication.shared.open(platform.nativeAppUriMobile!) }) {
                                        Text("Open in App", comment: "A context menu item, opens the link in the relevant music app")
                                        Image(systemName: "square.on.square")
                                    }
                                } else {
                                    EmptyView()
                                }
                            }
                    }
                    SongLinkCreditView()
                }
                .popover(
                    isPresented: self.$showShareSheet,
                    attachmentAnchor: .point(.bottom),
                    arrowEdge: .bottom
                ) {
                    ShareSheet(activityItems: [self.shareSheetURL])
                }
            }
            .navigationBarTitle(Text("Pick your platform", comment: "The modal view title"), displayMode: .inline)
            .navigationBarItems(trailing: Button("Done", action: {
                self.showResults = false
                // Request Review
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
                
            }))
            .padding()
            .background(Color.offWhite)
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static let response = [
        PlatformLinks(id: Platform.yandex, url: URL(string: "https://music.yandex.ru/track/59994505")!),
        PlatformLinks(id: Platform.youtube, url: URL(string: "https://www.youtube.com/watch?v=QfnVrp2bPuE")!),
        PlatformLinks(id: Platform.google, url: URL(string: "https://play.google.com/music/m/Tpubjccp2vd46677axbqaec726i?signup_if_needed=1")!),
        PlatformLinks(id: Platform.youtubeMusic, url: URL(string: "https://music.youtube.com/watch?v=QfnVrp2bPuE")!),
        PlatformLinks(id: Platform.amazonStore, url: URL(string: "https://amazon.com/dp/B081QMVJ42?tag=songlink0d-20")!),
        PlatformLinks(id: Platform.soundcloud, url: URL(string: "https://soundcloud.com/inzo_music/inzo-angst")!),
        PlatformLinks(id: Platform.itunes, url: URL(string: "https://geo.music.apple.com/us/album/_/1488452376?i=1488452377&mt=1&app=itunes&at=1000lHKX")!, nativeAppUriMobile: URL(string: "itmss://itunes.apple.com/us/album/_/1488452376?i=1488452377&mt=1&app=itunes&at=1000lHKX")!, nativeAppUriDesktop: URL(string: "itmss://itunes.apple.com/us/album/_/1488452376?i=1488452377&mt=1&app=itunes&at=1000lHKX")!),
        PlatformLinks(id: Platform.amazonMusic, url: URL(string: "https://music.amazon.com/albums/B081QNFXHB?trackAsin=B081QMVJ42&do=play")!),
        PlatformLinks(id: Platform.appleMusic, url: URL(string: "https://geo.music.apple.com/us/album/_/1488452376?i=1488452377&mt=1&app=music&at=1000lHKX")!, nativeAppUriMobile: URL(string: "itmss://itunes.apple.com/us/album/_/1488452376?i=1488452377&mt=1&app=music&at=1000lHKX")!, nativeAppUriDesktop: URL(string: "music://itunes.apple.com/us/album/_/1488452376?i=1488452377&mt=1&app=music&at=1000lHKX")!),
        PlatformLinks(id: Platform.googleStore, url: URL(string: "https://play.google.com/store/music/album?id=Btq6ws6c5cdsrc2kookzr2ujmkm&tid=song-Tpubjccp2vd46677axbqaec726i")!),
        PlatformLinks(id: Platform.spotify, url: URL(string: "https://open.spotify.com/track/3NivHilTTTs8SQwp51yG0X")!),
        PlatformLinks(id: Platform.pandora, url: URL(string: "https://pandora.app.link/?$desktop_url=https%3A%2F%2Fwww.pandora.com%2FTR%3A26063002&$ios_deeplink_path=pandorav4%3A%2F%2Fbackstage%2Ftrack%3Ftoken%3DTR%3A26063002&$android_deeplink_path=pandorav4%3A%2F%2Fbackstage%2Ftrack%3Ftoken%3DTR%3A26063002")!),
        PlatformLinks(id: Platform.deezer, url: URL(string: "https://www.deezer.com/track/811904832")!),
        PlatformLinks(id: Platform.tidal, url: URL(string: "https://listen.tidal.com/track/123030090")!),
    ].sorted(by: { $0.id.rawValue < $1.id.rawValue })
    
    static var previews: some View {
        ResultsView(
            showResults: .constant(true),
            results: ResultsModel(
                artworkURL: URL(string: "https://m.media-amazon.com/images/I/51jNytp9pxL._AA500.jpg"),
                mediaTitle: "Humble",
                artistName: "Kendrick Lamar",
                isFromShazam: true,
                response: response
            ),
            saveFunction: { return true }
        ).environmentObject(UserSettings())
    }
}
