//
//  MacMultipeerConnectivityViewModel.swift
//  MacMultipeer
//
//  Created by Rizky Azmi Swandy on 02/10/24.
//

import Foundation
import Combine
import MultipeerConnectivity

class MacMultipeerViewModel: ObservableObject {
    private let manager: MacMultipeerConnectivityManager
    private var cancellables: Set<AnyCancellable> = []

    @Published var connectedPeers: [String] = []
    @Published var receivedMessages: [String] = []
    @Published var elementAssignments: [String: String] = [:]
    @Published var elementMessages: [String: [String]] = [
        "Fire": [],
        "Water": [],
        "Rock": [],
        "Wind": []
    ]
    @Published var roomCode: String = ""
    @Published var isHosting: Bool = false

    init() {
        manager = MacMultipeerConnectivityManager()
        setupBindings()
    }

    private func setupBindings() {
        manager.$connectedPeers
            .map { peers in peers.map { $0.displayName } }
            .assign(to: &$connectedPeers)

        manager.$receivedMessages
            .assign(to: &$receivedMessages)
        
        manager.$elementAssignments
            .map { assignments in
                Dictionary(uniqueKeysWithValues: assignments.map { (key, value) in
                    (key.displayName, value)
                })
            }
            .assign(to: &$elementAssignments)
        
        manager.$elementMessages
            .assign(to: &$elementMessages)
    }

    func hostRoom() {
        manager.hostRoom()
        roomCode = manager.getRoomCode()
        isHosting = true
    }

    func sendMessage(_ message: String) {
        manager.sendMessage(message)
    }
}
