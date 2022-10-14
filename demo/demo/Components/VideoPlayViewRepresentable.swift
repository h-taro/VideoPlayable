//
//  VideoPlayViewRepresentable.swift
//  demo
//
//  Created by 平石　太郎 on 2022/10/14.
//

import VideoPlayable
import SwiftUI

struct VideoPlayViewRepresentable: UIViewRepresentable {
    private let videoPlayable: VideoPlayable
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    init(videoPlayable: VideoPlayable) {
        self.videoPlayable = videoPlayable
    }
    
    func makeUIView(context: Context) -> VideoPlayView {
        let view = VideoPlayView()
        view.player = videoPlayable.player
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: VideoPlayView, context: Context) {
    }
    
    class Coordinator: NSObject, VideoPlayViewDelegate {
        private let parent: VideoPlayViewRepresentable
        
        init(_ parent: VideoPlayViewRepresentable) {
            self.parent = parent
        }
        
        func onFinish() {
            parent.videoPlayable.onFinish()
        }
    }
}
