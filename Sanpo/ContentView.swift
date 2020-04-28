//
//  ContentView.swift
//  Sanpo
//
//  Created by yas on 2020/04/21.
//  Copyright © 2020 yas. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation
import Combine

struct ContentView: View {
    @ObservedObject var locationManager = LocationManager()
    @State var checkPoints: [CheckPoint] = []
    @State private var lastCheckpoint: CheckPoint?
    @State private var history: [WalkHistory] = []
    @State private var timer: Timer?
    @State private var isRecording = false
    @State var shouldGoCurrent = false
    @State var shouldShowAllPins = false
    @State private var showHistory = false
    @State private var showDistance = false
    @State var distance: Double = 0.0
        
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                ZStack(alignment: .bottomTrailing) {
                    MapView(coordinate: self.locationManager.coordinate,
                            checkPoints: checkPoints,
                            lastCheckPoint: $lastCheckpoint,
                            shouldGoCurrent: $shouldGoCurrent,
                            shouldShowAllPins: $shouldShowAllPins)
                        .edgesIgnoringSafeArea(.top)
                    
                    Button(action: {
                        self.shouldGoCurrent = true
                    }) {
                        Image(systemName: "location.fill")
                            .imageScale(.large)
                            .padding(.bottom, 40.0)
                            .padding(.trailing, 10.0)
                    }
                }
                
                if showDistance {
                    Text("Distance: \(String(format: "%.0f", distance)) meters")
                        .foregroundColor(.black)
                        .background(
                            Capsule()
                                .frame(width: 200, height: 50)
                                .shadow(color: .gray, radius: 20)
                                .foregroundColor(.white)
                        )
                        .padding(.top, 20.0)
                        .transition(.opacity)
                }

            }
            
            ZStack {
                HStack {
                    Button(action: {
                        self.showHistory.toggle()
                    }) {
                        Image(systemName: "list.dash")
                            .imageScale(.large)
                            .padding()
                    }
                    .sheet(isPresented: self.$showHistory) {
                        // 履歴を表示
                        HistoryView(shouldShowAllPins: self.$shouldShowAllPins,
                                    checkPoints: self.$checkPoints,
                                    history: self.$history,
                                    isRecording: self.isRecording,
                                    showDistance: self.$showDistance,
                                    distance: self.$distance)
                            .onDisappear {
                                HistoryDataManager.setAll(walkHistoryList: self.history)
                        }
                    }
                    Spacer()
                }
                
                HStack {
                    Button(action: {
                        if self.isRecording {
                            self.stop()
                        } else {
                            self.start()
                        }
                        self.isRecording.toggle()
                    }) {
                        Text( isRecording ? "Stop" : "Start" )
                    }
                    .buttonStyle(RecordButtonStyle(pressed: self.isRecording))
                }
            }
            .padding(.bottom, 10.0)
        }.onAppear {
            self.history = HistoryDataManager.load()
        }
    }
    
    // 距離計測スタート
    private func start() {
        self.timer?.invalidate()
        self.locationManager.startBackGround()

        self.showDistance = false
        self.checkPoints = []
        let addCheckpoint = {
            let checkpoint = CheckPoint(title: "\(self.checkPoints.count + 1)", coordinate: self.locationManager.coordinate)
            self.lastCheckpoint = checkpoint
            self.checkPoints.append(checkpoint)
        }
        self.timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            addCheckpoint()
        }
    }
    
    // 距離計測ストップ
    private func stop() {
        self.timer?.invalidate()
        self.locationManager.stopBackGround()

        self.history.append(WalkHistory(Date(), self.checkPoints))
        HistoryDataManager.setAll(walkHistoryList: self.history)
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let locationManager = MockLocationManager()
        return ContentView(locationManager: locationManager,
                           checkPoints: MockData.checkpoints,
                           shouldGoCurrent: true,
                           shouldShowAllPins: true)
            .environment(\.colorScheme, .dark)
    }
}
