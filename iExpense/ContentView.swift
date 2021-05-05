//
//  ContentView.swift
//  iExpense
//
//  Created by Esben Viskum on 21/04/2021.
//

import SwiftUI

/*
class User: ObservableObject {
    @Published var firstName = "Anders"
    @Published var lastName = "And"
}

struct SecondView: View {
    @Environment(\.presentationMode) var presentationMode
    var name: String
    
    var body: some View {
//        Text("Second View: \(name)")
        Button("Dismiss") {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}
 */

/*
struct User: Codable {
    var firstName: String
    var lastName: String
}
*/


struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }
        self.items = []
    }
}

struct ContentView: View {
//    @ObservedObject private var user = User()
//    @State private var showingSecondView = false

//    @State private var numbers = [Int]()
//    @State private var currentNumber = 1
    
//    @State private var tapCount =
//        UserDefaults.standard.integer(forKey: "Tap")
    
//    @State private var user = User(firstName: "Anders", lastName: "And")
    
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
/*        VStack {
            Text("Dit navn er \(user.firstName) \(user.lastName)")
            
            TextField("First name", text: $user.firstName)
            TextField("Last name", text: $user.lastName)
*/
/*        Button("Show sheet") {
            self.showingSecondView.toggle()
        }
        .sheet(isPresented: $showingSecondView) {
            SecondView(name: "Hej med dig")
        }
*/
/*
        NavigationView {
            VStack {
                List {
                    ForEach(numbers, id: \.self) {
                        Text("\($0)")
                    }
                    .onDelete(perform: removeRows)
                }
                
                Button("Tilføj tal") {
                    self.numbers.append(self.currentNumber)
                    self.currentNumber += 1
                }
            }
            .navigationBarItems(leading: EditButton())
        }
*/
//        Button("Tap count: \(tapCount)") {
//            self.tapCount += 1
//            UserDefaults.standard.set(self.tapCount, forKey: "Tap")
//        }
/*
        Button("Save user") {
            let encoder = JSONEncoder()
            
            if let data = try? encoder.encode(self.user) {
                UserDefaults.standard.set(data, forKey: "UserData")
            }
        }
*/
        
        NavigationView {
            List {
                ForEach(expenses.items, id: \.id) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text("€\(item.amount)")
                            .foregroundColor(Int(item.amount) < 10 ? Color.green : Int(item.amount) < 100 ? Color.yellow : Color.red)
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("iExpenses")
            .navigationBarItems(leading: EditButton(), trailing:
                                    Button(action: {
//                                        let expense = ExpenseItem(name: "Test", type: "Personal", amount: 10)
//                                        self.expenses.items.append(expense)
                                        self.showingAddExpense = true
                                    }) {
                                        Image(systemName: "plus")
                                    })
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: self.expenses)
            }
        }
        
    }

    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }

    
//    func removeRows(at offsets: IndexSet) {
//        numbers.remove(atOffsets: offsets)
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
