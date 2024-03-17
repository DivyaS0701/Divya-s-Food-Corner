//
//  RestaurantViewModel.swift
//  DivyasFoodCorner
//
//  Created by Bandi, Divya Sravani on 3/16/24.
//

import Foundation

class RestaurantViewModel: ObservableObject{
    @Published var incomeViewModel = IncomeViewModel()
    @Published var expenseViewModel = ExpenseViewModel()
    @Published var shouldRefreshUtilitiesView = false
    
    func loadAllData(){
        incomeViewModel.loadIncomeSources()
        expenseViewModel.loadExpenseSources()
    }
}
