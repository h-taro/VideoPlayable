//
//  HomeView.swift
//  demo
//
//  Created by 平石　太郎 on 2022/10/14.
//

import VideoPlayable
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        contentView
            .onAppear(perform: viewModel.onAppear)
    }
    
    private var contentView: some View {
        videoPreview
    }
    
    private var videoPreview: some View {
        VStack(alignment: .center, spacing: 20) {
            videoPlayViewRepresentable
            
            HStack(alignment: .center, spacing: .zero) {
                playButton
            }
        }
    }
    
    private var videoPlayViewRepresentable: some View {
        VideoPlayViewRepresentable(videoPlayable: viewModel)
            .frame(width: viewModel.screenWidth, height: viewModel.screenWidth)
    }
    
    private var playButton: some View {
        Button(action: viewModel.onTapPlayButton) {
            Image(systemName: viewModel.playButton)
                .resizable()
                .frame(width: 36, height: 36)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
