// 
//  Container.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 18/08/2025.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

enum Container {}

extension Container { 
    struct ContentView<Content: View>: View {
        @ViewBuilder let content: Content
        let padding: CGFloat
        let color: Color
        let cornerRadius: CGFloat

        init(
            padding: CGFloat = 16,
            color: Color = Color(.inputContainer).opacity(0.12),
            cornerRadius: CGFloat = 16,
            @ViewBuilder content: @escaping () -> Content
        ) {
            self.content = content()
            self.padding = padding
            self.color = color
            self.cornerRadius = cornerRadius
        }

        var body: some View {
            content
                .frame(minHeight: 57)
                .padding(.horizontal, padding)
                .background(color)
                .cornerRadius(cornerRadius)
        }
    }
}

#Preview {
    ScrollView { 
        Container.ContentView {
            HStack(alignment: .center) { 
                VStack(alignment: .leading, spacing: 4) { 
                    Text("Email")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.inputContainerTextFieldFill.opacity(0.65))
                    TextField("Digite seu email", text: .constant("souza.rodrigo61@gmail.com"))
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.inputContainerTextFieldFill)
                }
                
                Button { 
                    
                } label: { 
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.inputContainerTextFieldFill.opacity(0.35))
                }
            }
        }
        .padding(.horizontal)
        
        Container.ContentView {
            HStack(alignment: .center) { 
                VStack(alignment: .leading, spacing: 4) { 
                    Text("CPF")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.inputContainerTextFieldFill.opacity(0.65))
                    TextField("Digite seu email", text: .constant("034.505.615-00"))
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.inputContainerTextFieldFill)
                }
                
                Button { 
                    
                } label: { 
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.inputContainerTextFieldFill.opacity(0.35))
                }
            }
        }
        .padding(.horizontal)
        
        Container.ContentView {
            HStack(alignment: .center) { 
                TextField("Digite seu email", text: .constant("email@contato.com"))
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.inputContainerTextFieldFill)
                
                Button { 
                    
                } label: { 
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.inputContainerTextFieldFill.opacity(0.35))
                }
            }
        }
        .padding(.horizontal)
        
        Button { 
            
        } label: { 
            Text("Se já tem uma conta, faça o login!")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.primaryButton)
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
        
        Container.ContentView { 
            Text("Ou continue com")
                .frame(maxWidth: .infinity)
                .frame(height: 450)
        }
        .padding(.horizontal)
        
    }
}
