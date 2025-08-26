//
//  Phone+View.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension Phone {
    struct ContentView: View {
        @Bindable var store: StoreOf<Feature>
        
        var body: some View {
            NavigationStack {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Seu número será usado apenas para contato e segurança da sua conta.")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.inputContainerTextFieldFill.opacity(0.6))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 24)
                    }
                    
                    // Phone Input
                    VStack(spacing: 8) {
                        HStack(spacing: 0) {
                            // Country Code
                            HStack(spacing: 4) {
                                Image(systemName: "flag.fill")
                                    .foregroundColor(.blue)
                                Text("+55")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 16)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8, corners: [.topLeft, .bottomLeft])
                            
                            // Phone Number
                            Input.Field(
                                placeholder: "(00) 00000-0000",
                                showClearButton: true,
                                font: .system(size: 16, weight: .medium),
                                textColor: .primary,
                                cursorColor: .blue,
                                keyboardType: .phonePad,
                                returnKeyType: .done,
                                autocorrectionDisabled: true,
                                autocapitalization: .never,
                                text: $store.phone
                            )
                            .cornerRadius(8, corners: [.topRight, .bottomRight])
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 16)
                    
                    // Error Message
                    if let errorMessage = store.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.red)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                    }
                    
                    Spacer()
                    
                    Button {
                        store.send(.continueTapped)
                    } label: {
                        HStack(alignment: .center) {
                            Text("Continuar")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.pill(backgroundColor: store.phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression).count >= 10 ? .primaryButton : .primaryButton.opacity(0.65)))
                    .disabled(store.phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression).count < 10)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                .background(
                    RadialGradient.authenticationBackground
                        .ignoresSafeArea()
                )
                .navigationTitle("Telefone de Contato")
                .navigationBarTitleDisplayMode(.large)
                .onAppear {
                    store.send(.onAppear)
                }
                .navigationDestination(
                    item: $store.scope(state: \.destination?.newPassword, action: \.destination.newPassword),
                    destination: NewPassword.ContentView.init(store:)
                )
            }
        }
    }
}

// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    Phone.ContentView(
        store: Store(initialState: Phone.Feature.State(
            email: "test@example.com",
            cpf: "000.000.000-00",
            firstName: "João",
            lastName: "Silva"
        )) {
            Phone.Feature()
        }
    )
} 