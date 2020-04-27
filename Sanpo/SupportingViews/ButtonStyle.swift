//
//  ButtonStyle.swift
//  Sanpo
//
//  Created by yas on 2020/04/25.
//  Copyright © 2020 yas. All rights reserved.
//

import SwiftUI

struct BaseButtonStyleConfiguration: View {
    let configuration: ButtonStyleConfiguration
    let color: Color
    var body: some View {
        return configuration.label
            .frame(width: 60)
            .padding(.vertical, 10.0)
            .padding(.leading, 20.0)
            .padding(.trailing, 20.0)
            .foregroundColor(.white)
            .background(color)
            .cornerRadius(20)
            .shadow(color: .gray, radius: 5.0)
            .scaleEffect(configuration.isPressed ? 0.6: 1)
    }
}

struct RecordButtonStyle: ButtonStyle {
    let pressed: Bool
    private var color: Color {
        pressed ? .red : .green
    }

    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        return BaseButtonStyleConfiguration(configuration: configuration, color: color)
    }
}

struct ButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button(action: {}) {
                Text("Hello")
            }
            .buttonStyle(RecordButtonStyle(pressed: true))
            .padding()
            
            Button(action: {}) {
                Text("World")
            }
            .buttonStyle(RecordButtonStyle(pressed: false))
            .padding()
        }
    }
}
