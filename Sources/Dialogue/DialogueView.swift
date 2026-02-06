import Foundation
import SwiftUI

public extension View {
    /// Hides the view if a given array is empty.
    @ViewBuilder
    func ifEmpty(
        _ arr: Array<Any>,
        view: (() -> some View)? = { EmptyView() }
    ) -> some View {
        if !arr.isEmpty {
            self
        }
        else if let view = view?() {
            view
        }
    }
}
