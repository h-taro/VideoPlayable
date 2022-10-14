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
    @Published var currentTime: Double = .zero
    
    private var cancellables: Set<AnyCancellable> = []
    private var timeObserver: Any?
    
    private lazy var playerItem: AVPlayerItem = {
        let url = Bundle.main.url(forResource: "video", withExtension: "mp4")!
        return AVPlayerItem(url: url)
    }()
    
    var durationSeconds: Double {
        playerItem.asset.duration.seconds
    }
    
    let player = AVPlayer()
    
    init() {
        subscribeIsPlaying()
        addPeriodicTimeObserver()
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
    
    private func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 0.005, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        timeObserver = player.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .global()
        ) { [weak self] time in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.currentTime = time.seconds
            }
        }
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
