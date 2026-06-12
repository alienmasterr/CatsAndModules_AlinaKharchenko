//
//  CatListView.swift
//  CatsAndModules_AlinaKharchenko
//
//  Created by alina on 15.05.2026.
//

import FirebaseCrashlytics
import Networking
import SwiftUI

private let emojis = [
    "🌸", "🐱", "🐈", "🐈‍⬛️", "❤️", "💛", "💘",
]

struct CatListView: View {
    @StateObject private var viewModel = CatViewModel()
    @State private var showMeow = false

    var body: some View {
        NavigationStack {
            ZStack {
                Group {
                    if viewModel.isLoading && viewModel.cats.isEmpty {
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.5)
                            Text("Бусінки вже біжать...")
                                .foregroundColor(.secondary)
                        }
                    } else if let error = viewModel.errorMessage {
                        VStack(spacing: 16) {
                            Image(systemName: "wifi.slash")
                                .font(.system(size: 50))
                                .foregroundColor(.secondary)
                            Text(error)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                            Button("Спробувати ще раз") {
                                Task { await viewModel.loadCats() }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                    } else {
                        List(viewModel.cats) { item in
                            NavigationLink {
                                CatDetailView(item: item)
                            } label: {
                                CatRowView(item: item)
                            }
                            .accessibilityIdentifier("cat_\(item.cat.id)")
                            
                            .simultaneousGesture(
                                TapGesture().onEnded {
                                    Crashlytics.crashlytics().log(
                                        "User tapped cat: \(item.randomName)"
                                    )
                                    Crashlytics.crashlytics().setCustomValue(
                                        item.randomName,
                                        forKey: "last_tapped_cat"
                                    )
                                    Crashlytics.crashlytics().setCustomValue(
                                        item.cat.id,
                                        forKey: "last_tapped_cat_id"
                                    )
                                    Crashlytics.crashlytics().setCustomValue(
                                        item.cat.breeds?.first?.name
                                            ?? "Unknown",
                                        forKey: "last_tapped_breed"
                                    )

//                                    withAnimation(.spring(response: 0.3)) {
//                                        showMeow = true
//                                    }
//                                    DispatchQueue.main.asyncAfter(
//                                        deadline: .now() + 1.2
//                                    ) {
//                                        withAnimation(.easeOut) {
//                                            showMeow = false
//                                        }
//                                    }
                                }
                            )
                        }
                        .refreshable {
                            await viewModel.loadCats()
                        }
                    }
                }

//                if showMeow {
//                    MeowBubbleView()
//                        .transition(.scale.combined(with: .opacity))
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .allowsHitTesting(false)
//                }
            }
            .navigationTitle("Бусінки")
            .toolbar {
                if !viewModel.isLoading {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            Task { await viewModel.loadCats() }
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Апокаліпсис") {
                        Crashlytics.crashlytics().log("User triggered test crash")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                fatalError("Test crash")
                            }
//                        let arr: [Int] = []
//                        let _ = arr[5]
                        
//                        let arr2 = [1, 0]
//                        for i in arr2 {
//                            let b = 1/i
//                        }
                    }
                    .foregroundColor(.red)
                }

            }
        }
        .task {
            await viewModel.loadCats()
        }
    }
}

struct MeowBubbleView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.15)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Text("hi \(emojis.randomElement() ?? "🐾")")
                    .font(.system(size: 36, weight: .bold))
                    .padding(.horizontal, 28)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white)
                            .shadow(
                                color: .black.opacity(0.15),
                                radius: 10,
                                x: 0,
                                y: 4
                            )
                    )

                Triangle()
                    .fill(Color.white)
                    .frame(width: 24, height: 14)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}
// test
// test
// test
