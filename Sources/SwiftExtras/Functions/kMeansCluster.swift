//
//  SwiftExtras.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// A simple K-Means clustering algorithm for colors
///
/// This function takes an array of colors and clusters them into a specified number of groups.
/// It uses the K-Means algorithm to find the centroids of the clusters.
/// The algorithm iteratively assigns colors to the nearest centroid and then recalculates the centroids
/// based on the assigned colors.
/// The process is repeated for a specified number of iterations.
/// The centroids are returned as an array of colors.
///
/// - Parameters:
///   - colors: The array of colors to cluster.
///   - clusters: The number of clusters to create.
///   - iterations: The number of iterations to run the algorithm.
/// - Returns: An array of colors representing the cluster centroids.
/// - Note: This implementation uses the Euclidean distance in RGB space to determine the distance between colors.
public func kMeansCluster(colors: [Color], clusters: Int, iterations: Int = 10) -> [Color] {
    guard !colors.isEmpty, clusters > 0 else { return [] }

    let points = colors.map {
        let components = $0.components
        return (
            red: Double(components.red),
            green: Double(components.green),
            blue: Double(components.blue),
            opacity: Double(components.opacity)
        )
    }
    var centroids = (0..<clusters).map { points[$0 % points.count] }

    for _ in 0..<max(iterations, 0) {
        var sums = Array(
            repeating: (red: 0.0, green: 0.0, blue: 0.0, count: 0),
            count: clusters
        )

        for point in points {
            var closestIndex = 0
            var closestDistance = Double.greatestFiniteMagnitude

            for (index, centroid) in centroids.enumerated() {
                let redDistance = point.red - centroid.red
                let greenDistance = point.green - centroid.green
                let blueDistance = point.blue - centroid.blue
                let distance = redDistance * redDistance
                    + greenDistance * greenDistance
                    + blueDistance * blueDistance

                if distance < closestDistance {
                    closestDistance = distance
                    closestIndex = index
                }
            }

            sums[closestIndex].red += point.red
            sums[closestIndex].green += point.green
            sums[closestIndex].blue += point.blue
            sums[closestIndex].count += 1
        }

        for index in centroids.indices {
            let sum = sums[index]
            guard sum.count > 0 else {
                centroids[index] = points[index % points.count]
                continue
            }

            let count = Double(sum.count)
            centroids[index] = (
                red: sum.red / count,
                green: sum.green / count,
                blue: sum.blue / count,
                opacity: 1
            )
        }
    }

    return centroids.map {
        Color(.sRGB, red: $0.red, green: $0.green, blue: $0.blue)
    }
}
#endif
