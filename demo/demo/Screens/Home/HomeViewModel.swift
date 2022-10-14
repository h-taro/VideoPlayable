//
//  HomeViewModel.swift
//  demo
//
//  Created by 平石　太郎 on 2022/10/14.
//

import SwiftUI
import UIKit
import AVFoundation
import VideoPlayable
import Combine

class HomeViewModel: ObservableObject {
    @Published var isPlaying = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var playerItem: AVPlayerItem = {
        let url = Bundle.main.url(forResource: "video", withExtension: "mp4")!
        return AVPlayerItem(url: url)
    }()
    
    let player = AVPlayer()
    
    init() {
        subscribeIsPlaying()
    }
    
    func onAppear() {
        setPlayerItem(playerItem)
        player.play()
    }
    
    func onTapPlayButton() {
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }
}

// MARK: - VideoPlayable
extension HomeViewModel: VideoPlayable {
    func onFinish() {
        Task {
            await player.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero)
            player.play()
        }
    }
    
    private func subscribeIsPlaying() {
        player.publisher(for: \.timeControlStatus)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self = self else { return }
                
                switch status {
                case .playing:
                    withAnimation {
                        self.isPlaying = true
                    }
                    
                case .paused:
                    withAnimation {
                        self.isPlaying = false
                    }
                    
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - UI PROPERTIES
extension HomeViewModel {
    var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }
    
    var playButton: String {
        isPlaying ? "pause.circle.fill" : "play.circle.fill"
    }
}
