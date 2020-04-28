//
//  HistoryView.swift
//  Sanpo
//
//  Created by yas on 2020/04/27.
//  Copyright © 2020 yas. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var shouldShowAllPins: Bool
    @Binding var checkPoints: [CheckPoint]
    @Binding var history: [WalkHistory]
    let isRecording: Bool
    @Binding var showDistance: Bool
    @Binding var distance: Double

    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .recording

    private enum ActiveAlert {
        case recording, deleteAll
    }

    private let recordingAlert = Alert(
        title: Text("Notice"),
        message: Text("Press \"Stop\" button before showing history"),
        dismissButton: .default(Text("OK"))
    )
    
    private func deleteAllAlert(destructiveMethod: (() -> Void)?) -> Alert {
        return Alert(
            title: Text("Notice"),
            message: Text("Delete all histories?"),
            primaryButton: .cancel(Text("Cancel")),
            secondaryButton: .destructive(Text("Delete all"), action: {
                destructiveMethod?()
            })
        )
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.history) { walk in
                    Text("\(walk.date.formattedDate())")
                        .onTapGesture {
                            if self.isRecording {
                                self.activeAlert = .recording
                                self.showAlert.toggle()
                            } else {
                                self.checkPoints = walk.getCheckPoints()
                                self.distance = walk.distance
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    self.showDistance = true
                                }
                                self.shouldShowAllPins = true
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                        .onLongPressGesture {
                            self.activeAlert = .deleteAll
                            self.showAlert.toggle()
                        }
                        .alert(isPresented: self.$showAlert) {
                            switch self.activeAlert {
                            case .recording:
                                return self.recordingAlert
                            case .deleteAll:
                                return (self.deleteAllAlert(destructiveMethod: {
                                    self.history = []
                                }))
                            }
                        }
                }
                .onDelete { indices in
                    indices.forEach {
                        self.history.remove(at: $0)
                    }
                }
            }
            .navigationBarTitle("History", displayMode: .inline)
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                }
            )
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(shouldShowAllPins: .constant(false),
                    checkPoints: .constant([]),
                    history: .constant(MockData.history),
                    isRecording: false,
                    showDistance: .constant(false),
                    distance: .constant(0.0))
    }
}
