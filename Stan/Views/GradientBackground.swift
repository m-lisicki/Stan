//
//  GradientBackground.swift
//  Stan
//
//  Created by Michał Lisicki on 03/01/2025.
//

import SwiftUI

struct GradientBackground: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        if colorScheme == .dark {
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
        } else {
            MeshGradient(
                width: 3,
                height: 3,
                points: [
                    [0, 0], [0, 0.93], [0, 1],
                    [0.8, 0], [0.3, 0.7], [0.7, 1.0],
                    [1, 0], [1, 0.4], [1, 1]
                ],
                colors: [
                    Color(red: 200/255, green: 220/255, blue: 180/255), // Light olive tone
                    Color(red: 200/255, green: 220/255, blue: 180/255), // Light olive tone
                    Color(red: 0/255, green: 124/255, blue: 146/255), // Light olive tone
                    
                    Color(red: 180/255, green: 210/255, blue: 160/255), // Lighter olive
                    Color(red: 200/255, green: 220/255, blue: 180/255), // Light olive tone
                    Color(red: 180/255, green: 210/255, blue: 160/255), // Lighter olive
                    
                    Color(red: 150/255, green: 180/255, blue: 140/255), // Soft olive
                    Color(red: 200/255, green: 220/255, blue: 180/255), // Light olive tone
                    Color(red: 150/255, green: 180/255, blue: 140/255)  // Soft olive
                ]
            )
            .ignoresSafeArea()
        }
    }
}

#Preview {
    GradientBackground()
}
