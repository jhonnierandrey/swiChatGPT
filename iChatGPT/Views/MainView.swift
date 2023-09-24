//
//  MainView.swift
//  iChatGPT
//
//  Created by Jhonnier Zapata on 9/24/23.
//

import SwiftUI
import OpenAISwift

struct MainView: View {
    @State private var chatText = ""
    @State private var isSearching : Bool = false
    @FocusState private var searchIsFocused: Bool
    @EnvironmentObject private var model: Model
    
    let openAI = OpenAISwift(config: OpenAISwift.Config.makeDefaultOpenAI(apiKey: ""))
    
    private var isFormValid : Bool {
        !chatText.isEmptyOrWhiteSpace
    }
    
    private func performSearch(chatTextInput : String) {
        openAI.sendCompletion(with: chatTextInput, maxTokens: 500) { result in
            switch result {
            case .success(let success):
                let answer = success.choices?.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                
                let query = Query(question: chatTextInput, answer: answer)
                
                DispatchQueue.main.async {
                    model.queries.append(query)
                }
                
                do {
                    try model.saveQuery(query)
                } catch {
                    print(error.localizedDescription)
                }
                
                isSearching = false
            case .failure(let failure):
                print(failure)
                isSearching = false
            }
        }
    }
    
    var body: some View {
        VStack{
            ScrollView{
                ScrollViewReader { proxi in
                    ForEach(model.queries) { query in
                        VStack(alignment: .leading) {
                            ChatBubble(direction: .right) {
                                Text(query.question)
                                    .padding(.all, 10)
                                    .foregroundColor(Color.white)
                                    .background(Color.blue)
                            }
                            ChatBubble(direction: .left) {
                                Text(query.answer)
                                    .padding(.all, 10)
                                    .foregroundColor(Color.white)
                                    .background(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.bottom], 10)
                        .id(query.id)
                        .listRowSeparator(.hidden)
                    }.onChange(of: model.queries) { oldValue, newValue in
                            if !model.queries.isEmpty {
                                let lastQuery = model.queries[model.queries.endIndex - 1]
                                
                                withAnimation {
                                    proxi.scrollTo(lastQuery.id)
                                }
                            }
                        }
                }
            }.padding()
            
            Spacer()
            HStack {
                TextField("Search...", text: $chatText)
                    .focused($searchIsFocused)
                    .textFieldStyle(.roundedBorder)
                Button {
                    isSearching = true
                    searchIsFocused = false
                    performSearch(chatTextInput: chatText)
                    chatText = ""
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title)
                }.buttonStyle(.borderless)
                    .tint(.green)
                    .disabled(!isFormValid)
            }
        }.padding()
            .onTapGesture {
                if searchIsFocused {
                    searchIsFocused = false
                }
            }
        .onChange(of: model.query) { oldValue, newValue in
            model.queries.append(newValue)
        }
        .overlay(alignment : .center){
            if isSearching {
                ProgressView("Searching...")
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(Model())
}
