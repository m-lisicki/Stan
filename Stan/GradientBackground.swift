//
//  GradientBackground.swift
//  Stan
//
//  Created by Michał Lisicki on 03/01/2025.
//

import SwiftUI

struct GradientBackground: View {
    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                [0, 0], [0, 0.7], [0, 1],
                [0.8, 0], [0.4, 0.5], [0.7, 1.0],
                [1, 0], [1, 0.4], [1, 1]
            ],
            colors: [
                Color(red: 15/255, green: 31/255, blue: 22/255),
                Color(red: 15/255, green: 31/255, blue: 22/255),
                Color(red: 15/255, green: 31/255, blue: 22/255),
                
                Color(red: 37/255, green: 77/255, blue: 54/255),
                Color(red: 15/255, green: 31/255, blue: 22/255),
                Color(red: 37/255, green: 77/255, blue: 54/255),
                
                Color(red: 55/255, green: 24/255, blue: 37/255),
                Color(red: 15/255, green: 31/255, blue: 22/255),
                Color(red: 15/255, green: 31/255, blue: 22/255)
            ]
        )
        .ignoresSafeArea()
    }
}
