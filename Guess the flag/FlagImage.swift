//
//  FlagImage.swift
//  Guess the flag
//
//  Created by Giovanni Gaffé on 2021/9/27.
//

import SwiftUI



struct FlagImage: ViewModifier {
    var imageName: String
    func body(content: Content) -> some View {
        
        Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

extension View {
    func flagStyle(of imageName: String) -> some View {
        return self.modifier(FlagImage(imageName: imageName))
    }
}

extension Image {
    func flagImage() -> some View {
        self
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}
