//
//  VideoPlayView.swift
//  
//
//  Created by 平石　太郎 on 2022/10/13.
//

import AVFoundation
import Combine
import UIKit

protocol VideoPlayViewDelegate: AnyObject {
    func onFinish()
}

public class VideoPlayView: UIView {
    private var cancellables: Set<AnyCancellable> = []
    weak var delegate: VideoPlayViewDelegate?
    
    public override class var layerClass: AnyClass {
        AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get {
            playerLayer.player
        }
        
        set {
            subscribeFinishCancellable()
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.player = newValue
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    // MARK: - PRIVATE METHODS
    private func subscribeFinishCancellable() {
        NotificationCenter.default.publisher(for: NSNotification.Name.AVPlayerItemDidPlayToEndTime)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.onFinish()
            }
            .store(in: &cancellables)
    }
}
