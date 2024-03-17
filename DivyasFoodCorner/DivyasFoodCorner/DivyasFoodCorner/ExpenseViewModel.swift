//
//  ExpenseViewModel.swift
//  DivyasFoodCorner
//
//  Created by Bandi, Divya Sravani on 3/16/24.
//


import Foundation
class ExpenseViewModel: ObservableObject {
    @Published var expenseSources: [ExpenseSource] = [
        ExpenseSource(name: "Utilities", amount: 500, additionalInfo: "Electricity, Water"),
        ExpenseSource(name: "Employee Salaries", amount: 800, additionalInfo: "Chefs, Waiters"),
        ExpenseSource(name: "Food Costs - Meat", amount: 400, additionalInfo: "All kinds of meat, eggs"),
        ExpenseSource(name: "Other Food costs", amount: 400, additionalInfo: "Rice, Dough"),
        ExpenseSource(name: "Rent payment", amount: 600, additionalInfo: "Rent per month"),
    ]
    func loadExpenseSources(){
        expenseSources = expenseSources
    }
}

