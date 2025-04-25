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
func kMeansCluster(colors: [Color], clusters: Int, iterations: Int = 10) -> [Color] {
    guard !colors.isEmpty, clusters > 0 else { return [] }

    // Initialize random centroids
    var centroids = (0 ..< clusters).map { _ in
        colors.randomElement()!
        // swiftlint:disable:previous force_unwrapping
    }

    for _ in 0..<iterations {
        var clusterArray = Array(repeating: [Color](), count: clusters)

        // Assign each color to the closest centroid
        for color in colors {
            let distances = centroids.map {
                pow(color.redValue - $0.redValue, 2) +
                pow(color.redValue - $0.greenValue, 2) +
                pow(color.redValue - $0.blueValue, 2)
            }

            guard let closestIndex = distances.enumerated().min(by: { $0.element < $1.element }).offset else {
                continue
            }

            clusterArray[closestIndex].append(color)
        }

        // Update centroids
        centroids = clusterArray.map { cluster in
            guard !cluster.isEmpty else {
                return centroids.randomElement()!
                // swiftlint:disable:previous force_unwrapping
            }

            let red = cluster.map { $0.redValue }.reduce(0, +) / Double(cluster.count)
            let green = cluster.map { $0.greenValue }.reduce(0, +) / Double(cluster.count)
            let blue = cluster.map { $0.blueValue }.reduce(0, +) / Double(cluster.count)
            return .init(.displayP3, red: red, green: green, blue: blue)
        }
    }

    return centroids
}
#endif
