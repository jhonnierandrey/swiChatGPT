//
//  MainView.swift
//  iChatGPT
//
//  Created by Jhonnier Zapata on 9/20/23.
//

import SwiftUI
import OpenAISwift

struct MainView: View {
    
    @State private var chatText = ""
    @EnvironmentObject private var model: Model
//    @State private var answers : [String] = []
    
    let openAI = OpenAISwift(config: OpenAISwift.Config.makeDefaultOpenAI(apiKey: ""))
    
    private var isFormValid : Bool {
        !chatText.isEmptyOrWhiteSpace
    }
    
    private func performSearch() {
        openAI.sendCompletion(with: chatText, maxTokens: 500) { result in
            switch result {
            case .success(let success):
                let answer = success.choices?.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                
                let query = Query(question: chatText, answer: answer)
                
                DispatchQueue.main.async {
                    model.queries.append(query)
                }
                
                do {
                    try model.saveQuery(query)
                } catch {
                    print(error.localizedDescription)
                }
//                answers.append(answer)
                
                chatText = ""
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    var body: some View {
        VStack{
            ScrollView{
                ScrollViewReader { proxi in
                    ForEach(model.queries) { query in
                        VStack(alignment: .leading) {
                            Text(query.question)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Text(query.answer)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.bottom], 10)
                        .id(query.id)
                        .listRowSeparator(.hidden)
                    }.listStyle(.plain)
                        .onChange(of: model.queries) { oldValue, newValue in
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
                    .textFieldStyle(.roundedBorder)
                Button {
                    // action
                    performSearch()
                } label: {
                    Image(systemName: "paperplane.circle.fill")
                        .font(.title)
                        .rotationEffect(Angle(degrees: 45))
                }.buttonStyle(.borderless)
                    .tint(.blue)
                    .disabled(!isFormValid)
            }
        }.padding()
            .onChange(of: model.query) { oldValue, newValue in
                model.queries.append(newValue)
            }
    }
}

#Preview {
    MainView()
        .environmentObject(Model())
}
