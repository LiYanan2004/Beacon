//
//  iCONView.swift
//  Beacon
//
//  Created by LiYanan2004 on 2024/3/16.
//

import SwiftUI

struct iCONView: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(.blue.quaternary.shadow(.inner(color: .blue, radius: 30)))
            Circle()
                .foregroundStyle(.blue.tertiary)
                .scaleEffect(0.65)
            Circle()
                .foregroundStyle(.blue.secondary)
                .scaleEffect(0.3)
        }
        .padding(50)
        .background(.white)
        .preferredColorScheme(.light)
        .frame(width: 1024, height: 1024)
    }
}

#Preview {
    iCONView()
}
