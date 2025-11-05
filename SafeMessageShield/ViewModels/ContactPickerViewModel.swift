import Foundation
import Combine

class ContactPickerViewModel: ObservableObject {
    @Published var selectedPhoneNumber: String = ""
    @Published var isPickerPresented: Bool = false
}
