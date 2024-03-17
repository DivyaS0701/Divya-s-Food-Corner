//
//  IncomeViewModel.swift
//  DivyasFoodCorner
//
//  Created by Bandi, Divya Sravani on 3/16/24.
//

import Foundation

class IncomeViewModel: ObservableObject {
    @Published var incomeSources: [IncomeSource] = [
        IncomeSource(name: "Food Sales", amount: 1000, additionalInfo: "Best-selling item: Biryani"),
        IncomeSource(name: "Catering", amount: 500, additionalInfo: "Events: Wedding, Birthday"),
        IncomeSource(name: "Beverage Sales", amount: 300, additionalInfo: "Best-Selling drink: Iced Tea, soft drinks in the second place"),
        IncomeSource(name: "Delivery Services", amount: 500, additionalInfo: "Most delivered item: Biryani Combo with soft drinks, Gulab Jamun"),
        IncomeSource(name: "Online Orders", amount: 450, additionalInfo: "More orders from 3.00 p.m to 8.30 p.m"),
        // Add more initial income sources here
    ]
    func loadIncomeSources(){
        incomeSources = incomeSources
    }
}



