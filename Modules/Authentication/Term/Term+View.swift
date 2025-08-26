//
//  Term+View.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension Term {
    struct ContentView: View {
        @Bindable var store: StoreOf<Feature>
        
        var body: some View {
            NavigationStack {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Leia e aceite os termos para continuar")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.inputContainerTextFieldFill.opacity(0.6))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 24)
                    }
                    
                    // Terms Content
                    ScrollView {
                        VStack(spacing: 16) {
                            Text("Termos e Condições de Uso")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("""
                                1. Aceitação dos Termos
                                Ao usar o ClickConsultas, você concorda com estes termos de uso.
                                
                                2. Uso do Serviço
                                O app é destinado para agendamento de consultas médicas.
                                
                                3. Privacidade
                                Seus dados pessoais serão tratados conforme nossa política de privacidade.
                                
                                4. Responsabilidades
                                Você é responsável pela veracidade das informações fornecidas.
                                
                                5. Limitações
                                O serviço não substitui atendimento médico de emergência.
                                
                                6. Modificações
                                Estes termos podem ser atualizados a qualquer momento.
                                
                                7. Contato
                                Para dúvidas, entre em contato através do suporte.
                                """)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.1))
                        )
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 16)
                    
                    // Terms Checkbox
                    HStack(spacing: 12) {
                        Button {
                            store.send(.toggleTerms)
                        } label: {
                            Image(systemName: store.acceptedTerms ? "checkmark.square.fill" : "square")
                                .foregroundColor(store.acceptedTerms ? .blue : .gray)
                                .font(.title2)
                        }
                        
                        Text("Li e aceito os termos de uso")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
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
                    
                    // Create Account Button
                    Button {
                        store.send(.createAccountTapped)
                    } label: {
                        HStack(alignment: .center) {
                            if store.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            
                            if store.isLoading == false {
                                Text("Criar Conta")
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.pill(backgroundColor: store.acceptedTerms ? .primaryButton : .primaryButton.opacity(0.65)))
                    .disabled(!store.acceptedTerms || store.isLoading)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                .background(
                    RadialGradient.authenticationBackground
                        .ignoresSafeArea()
                )
                .navigationTitle("Termos de Uso")
                .navigationBarTitleDisplayMode(.large)
                .onAppear {
                    store.send(.onAppear)
                }
                .navigationDestination(
                    item: $store.scope(state: \.destination?.success, action: \.destination.success),
                    destination: Success.ContentView.init(store:)
                )
            }
        }
    }
}

#Preview {
    Term.ContentView(
        store: Store(initialState: Term.Feature.State(
            email: "test@example.com",
            cpf: "000.000.000-00",
            firstName: "João",
            lastName: "Silva",
            phone: "(11) 99999-9999",
            password: "Senha123!"
        )) {
            Term.Feature()
        }
    )
} 