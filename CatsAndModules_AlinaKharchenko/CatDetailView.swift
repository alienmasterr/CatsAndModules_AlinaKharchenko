//
//  CatDetailView.swift
//  CatsAndModules_AlinaKharchenko
//
//  Created by alina on 15.05.2026.
//

import Networking
import SwiftUI

struct CatDetailView: View {
    let item: CatItem

    @State private var showCopied = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                Button {
                    UIPasteboard.general.string = item.cat.url
                    withAnimation(.spring(response: 0.3)) {
                        showCopied = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.easeOut) {
                            showCopied = false
                        }
                    }
                } label: {
                    AsyncImage(url: URL(string: item.cat.url)) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .overlay(ProgressView())
                                .frame(height: 400)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                        case .failure:
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .overlay(
                                    VStack {
                                        Image(systemName: "photo")
                                            .font(.largeTitle)
                                        Text("Бусінки сплять")
                                    }
                                    .foregroundColor(.gray)
                                )
                                .frame(height: 300)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                .overlay(alignment: .bottom) {
                    if !showCopied {
                        Label("Скопіювати бусінку", systemImage: "link")
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .padding(.bottom, 8)
                    }
                }
                .overlay(alignment: .center) {
                    if showCopied {
                        VStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.green)
                            Text("Скопійовано!")
                                .font(.headline)
                                .bold()
                        }
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .transition(.scale.combined(with: .opacity))
                    }
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text(item.randomName)
                        .font(.largeTitle)
                        .bold()

                    if let breed = item.cat.breeds?.first {
                        Divider()
                        if let name = breed.name {
                            InfoRow(label: "Порода", value: name)
                        }
                        if let origin = breed.origin {
                            InfoRow(label: "Походження", value: origin)
                        }
                        if let temperament = breed.temperament {
                            InfoRow(label: "Темперамент", value: temperament)
                        }
                        if let description = breed.life_span {
                            Divider()
                            Text("Про породу")
                                .font(.headline)
                            Text(description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .navigationTitle(item.randomName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 120, alignment: .leading)
            Text(value)
                .font(.subheadline)
        }
    }
}
