//
//  ContentView.swift
//  MusicKitArtworkTest
//
//  Created by Adam Wienconek on 05/02/2024.
//

import SwiftUI
import MusicKit

struct ContentView: View {
    
    @State
    private var songs: [Song] = []
    
    var body: some View {
        VStack {
            List(songs) { song in
                HStack {
                    if let artwork = song.artwork {
                        ArtworkImage(artwork, height: 54)
                    }
                    Text(song.title)
                }
            }
        }
        .padding()
        .task {
            songs = await loadSongs()
        }
    }
    
    func loadSongs() async -> [Song] {
        guard await MusicAuthorization.request() == .authorized else {
            print("Not authorized!")
            return []
        }
        do {
            let songs = try await MusicLibraryRequest<Song>()
                .response()
                .items
                .prefix(30)
            return Array(songs)
        } catch {
            print("Could not get songs")
        }
        return []
    }
    
}

#Preview {
    ContentView()
}
