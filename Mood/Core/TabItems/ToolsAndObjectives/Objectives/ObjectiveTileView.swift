//
//  ObjectiveView.swift
//  Mood
//
//  Created by Nate Leake on 4/2/25.
//

import SwiftUI

struct WavyCircle: Shape {
    var waves: Int = 30
    var amplitude: CGFloat = 30
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let baseRadius = (min(rect.width, rect.height) / 2) - (amplitude * 0.5)
        
        let step = (2 * .pi) / CGFloat(waves)
        var path = Path()
        
        for i in 0..<waves {
            let angle1 = step * CGFloat(i)
            let angle2 = step * CGFloat(i + 1)
            
            // Points on the reduced circle
            let point1 = pointOnCircle(center: center, angle: angle1, radius: baseRadius)
            let point2 = pointOnCircle(center: center, angle: angle2, radius: baseRadius)
            
            // Control point (offset outward for the wave effect)
            let midAngle = (angle1 + angle2) / 2
            let controlPoint = pointOnCircle(center: center, angle: midAngle, radius: baseRadius + amplitude)
            
            if i == 0 {
                path.move(to: point1)
            }
            path.addQuadCurve(to: point2, control: controlPoint)
        }
        
        path.closeSubpath() // Close the shape
        return path
    }
    
    /// Function to get a point on a circle given an angle and radius
    private func pointOnCircle(center: CGPoint, angle: CGFloat, radius: CGFloat) -> CGPoint {
        return CGPoint(
            x: center.x + radius * cos(angle),
            y: center.y + radius * sin(angle)
        )
    }
}

struct ObjectiveTileView: View {
    var frameSize: CGFloat = 150
    var label: String
    var color: Color
    
    var body: some View {
        ZStack {
            WavyCircle(waves: Int(frameSize / 15), amplitude: 20)
                .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .fill(color)
            
            Text(label)
                .foregroundStyle(color.isLight() ? .black : .white)
                .multilineTextAlignment(.center)
                .bold()
                .padding()
        }
        .frame(width: frameSize, height: frameSize)
    }
    
}

#Preview {
    ObjectiveTileView(frameSize: 150, label: "meet more friends", color: .pink)
}
