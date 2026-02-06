import Foundation
import SwiftUI

public extension View {
    /// Changes the view if a given array is empty.
    @ViewBuilder
    func ifEmpty(
        _ arr: Array<Any>,
        replacementView: () -> some View = { EmptyView() }
    ) -> some View {
        if !arr.isEmpty {
            self
        }
        else {
            replacementView()
        }
    }
}
