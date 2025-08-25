//
//  Authentication+View.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 17/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension Authentication {
    struct ContentView: View {
        @Bindable var store: StoreOf<Feature>
        
        @State private var titleText = ""
        
        var body: some View {
            ZStack { 
                RadialGradient.authenticationBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Image("Logo")
                        .padding(.top, 32)
                        .padding(.bottom, 36)
                    
                    Text("Bem Vindo")
                        .font(.system(size: 30, weight: .bold))
                        .padding(.bottom, 36)
                    
                    Input.Title(
                        title: "Email",
                        placeholder: "Digite seu email",
                        showClearButton: true,
                        font: .system(size: 16, weight: .medium),
                        textColor: .primary,
                        cursorColor: .blue,
                        keyboardType: .emailAddress,
                        returnKeyType: .next,
                        autocorrectionDisabled: true,
                        autocapitalization: .never,
                        text: $titleText
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    
                    Input.Title(
                        title: "Senha",
                        placeholder: "Digite seu senha",
                        showClearButton: true,
                        font: .system(size: 16, weight: .medium),
                        textColor: .primary,
                        cursorColor: .blue,
                        keyboardType: .emailAddress,
                        returnKeyType: .next,
                        autocorrectionDisabled: true,
                        autocapitalization: .never,
                        text: $titleText
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                    
                    Button { 
                        
                    } label: { 
                        Text("Esqueci minha senha")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.primaryButton)
                            .padding(.vertical, 4)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer()
                    
                    Button {
                        print("Long pill button tapped")
                    } label: { 
                        Text("Continuar")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.vertical, 4)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.pill(backgroundColor: .primaryButton))
                    .padding(.horizontal, 16)
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

#Preview {
    Authentication.ContentView(
        store: Store(initialState: Authentication.Feature.State()) {
            Authentication.Feature()
        }
    )
}
