//
//  VideoPlayable.swift
//
//
//  Created by 平石　太郎 on 2022/10/13.
//

import AVFoundation

public protocol VideoPlayable: AnyObject {
    var player: AVPlayer { get }
    func onFinish()
    func setPlayerItem(_ playerItem: AVPlayerItem)
}
