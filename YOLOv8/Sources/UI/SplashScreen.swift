//
//  SplashScreen.swift
//  YOLOv8
//
//  Created by tim on 4/6/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            MainView() // Your main view
        } else {
            VStack {
                ProgressView() // SwiftUI's built-in circular progress indicator
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1) // Increase the size of the loader
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Adjust delay as needed
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
