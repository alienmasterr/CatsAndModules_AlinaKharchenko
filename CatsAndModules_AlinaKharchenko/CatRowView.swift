//
//  CatRowView.swift
//  CatsAndModules_AlinaKharchenko
//
//  Created by alina on 15.05.2026.
//

import FirebasePerformance
import Networking
import SwiftUI

struct CatRowView: View {
    let item: CatItem
    @State private var imageTrace: Trace?

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: item.cat.url)) { phase in
                switch phase {
                case .empty:
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .overlay(ProgressView())
                        .onAppear {
                            imageTrace = Performance.startTrace(
                                name: "cat_image_load"
                            )
                            imageTrace?.setValue(
                                item.cat.url,
                                forAttribute: "image_url"
                            )
                        }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .onAppear {
                            imageTrace?.setValue(
                                "success",
                                forAttribute: "status"
                            )
                            imageTrace?.stop()
                        }
                case .failure:
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            Image(systemName: "photo").foregroundColor(.gray)
                        )
                        .onAppear {
                            imageTrace?.setValue(
                                "failure",
                                forAttribute: "status"
                            )
                            imageTrace?.stop()
                        }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.randomName)
                    .font(.headline)

                if let breed = item.cat.breeds?.first?.name {
                    Text(breed)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                if let origin = item.cat.breeds?.first?.origin {
                    Label(origin, systemImage: "mappin.circle.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
