//
//  ContentView.swift
//  MacMultipeer
//
//  Created by Rizky Azmi Swandy on 02/10/24.
//
import SwiftUI

struct MacMultipeerTestView: View {
    @StateObject private var viewModel = MacMultipeerViewModel()
    @State private var messageToSend = ""
    @State private var selectedElement: String?

    var body: some View {
        VStack {
            if viewModel.isHosting {
                Text("Room Code: \(viewModel.roomCode)")
                    .font(.headline)
                    .padding()
            }

            Button(viewModel.isHosting ? "Hosting" : "Host Room") {
                if !viewModel.isHosting {
                    viewModel.hostRoom()
                }
            }
            .disabled(viewModel.isHosting)
            .padding()
        
            Text("Connected Peers:")
                .font(.headline)
            List(viewModel.connectedPeers, id: \.self) { peer in
                Text(peer)
            }

            Text("Element Assignments:")
                .font(.headline)
            List(viewModel.elementAssignments.keys.sorted(), id: \.self) { peer in
                Text("\(peer): \(viewModel.elementAssignments[peer] ?? "Unassigned")")
            }

            Text("Element Messages:")
                .font(.headline)
            Picker("Select Element", selection: $selectedElement) {
                Text("All").tag(String?.none)
                ForEach(Array(viewModel.elementMessages.keys), id: \.self) { element in
                    Text(element).tag(String?.some(element))
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            List {
                if let element = selectedElement {
                    ForEach(viewModel.elementMessages[element] ?? [], id: \.self) { message in
                        Text(message)
                    }
                } else {
                    ForEach(Array(viewModel.elementMessages.keys), id: \.self) { element in
                        Section(header: Text(element)) {
                            ForEach(viewModel.elementMessages[element] ?? [], id: \.self) { message in
                                Text(message)
                            }
                        }
                    }
                }
            }

            HStack {
                TextField("Enter message", text: $messageToSend)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    viewModel.sendMessage(messageToSend)
                    messageToSend = ""
                }
            }
            .padding()
        }
        .padding()
    }
}

struct MacMultipeerTestView_Previews: PreviewProvider {
    static var previews: some View {
        MacMultipeerTestView()
    }
}
