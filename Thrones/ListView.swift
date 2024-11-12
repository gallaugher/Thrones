// File: ListView.swift Project: Thrones
// Created by: Prof. John Gallaugher on 11/10/24
// YouTube.com/profgallaugher  -  threads.net/john.gallaugher

import SwiftUI
import AVFAudio

struct ListView: View {
    @State private var housesVM = HousesViewModel()
    @State private var audioPlayer: AVAudioPlayer!
    var body: some View {
        NavigationStack {
            ZStack {
                List(housesVM.houses) { house in
                    LazyVStack(alignment: .leading) {
                        NavigationLink {
                            DetailView(house: house)
                        } label: {
                            Text(house.name)
                                .font(.title2)
                        }
                    }
                    .task {
                        await housesVM.loadNextIfNeeded(house: house)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Houses of Westeros")
                
                if housesVM.isLoading {
                    ProgressView()
                        .scaleEffect(4)
                        .tint(.red)
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Load All") {
                        Task {
                            await housesVM.loadAll()
                        }
                    }
                }
                ToolbarItem(placement: .status) {
                    Text("\(housesVM.houses.count) Houses Returned")
                }
            }
        }
        .task {
            await housesVM.getData()
        }
        .onAppear() {
            playSound(soundName: "GoT_theme")
        }
    }
    
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 Could not read file named \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: \(error.localizedDescription) creating audioPlayer.")
        }
    }
}

#Preview {
    ListView()
}
