//
// Created by moonl1ght 27.02.2023.
//

import SwiftUI
import UIKit

struct MainView: View {
  @State private var showingObjectSegmentation = true

  var body: some View {
    ObjectDetectionView(modelType: .withSegmentation)
  }

  @ViewBuilder
  private func button(title: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      HStack {
        Text(title).font(.system(size: 20)).bold()
      }
      .frame(width: 250, height: 62)
      .foregroundColor(.white)
      .background(
        RoundedRectangle(cornerRadius: 15, style: .continuous)
          .fill(Color.blue)
      )
    }
  }
}
