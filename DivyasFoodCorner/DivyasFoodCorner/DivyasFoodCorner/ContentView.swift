//
//  ContentView.swift
//  DivyasFoodCorner
//
//  Created by Bandi, Divya Sravani on 3/16/24.
//
//Import necessary libraries
import SwiftUI
import Combine

//ContentView struct to act as the main entry point
struct ContentView:View{
    var body: some View{
        RestaurantApp() //Display the RestaurantApp view
    }
}

//Struct Model for income source
struct IncomeSource: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    var additionalInfo: String // Additional information about income source
}

// Model for expense source
struct ExpenseSource: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    var additionalInfo: String // Additional information about expense source
}

//RestaurantApp struct representing the main view of the restaurant application
struct RestaurantApp: View {
    let restaurantName = "Divya's Food Corner" // Define the restaurant name
    @State private var showUtilities = false //State variable to control navigation to UtilitiesView
    
    var body: some View {
        NavigationView {
            VStack {
                Text(restaurantName) //Display restaurant name
                    .font(.title)
                // Add appropriate image here
                Image("restaurantimage") //Display restaurant image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .onTapGesture {
                        showUtilities = true //Tap gesture to navigate to UtilitiesView
                    }
                
                // NavigationLink to UtilitiesView
                NavigationLink(destination: UtilitiesView(), isActive: $showUtilities) {
                    EmptyView() //Using EmptyView to hide the navigation link text
                }
                
            }
        }
    }
}
    
//UtilitiesView struct representing the view displaying utility options
struct UtilitiesView: View{
    //State objects for income and expense view models
    @ObservedObject private var incomeViewModel = IncomeViewModel()
    @ObservedObject private var expenseViewModel = ExpenseViewModel()
    var body: some View{
        VStack{
            List{
                // Display profit/loss percentage and color
                Text(profitLossPercentage())
                    .foregroundColor(profitLossColor())
                    .font(.headline)
                
                // NavigationLinks to income and expense screens (IncomeView and ExpenseView)
                NavigationLink(destination: IncomeView(viewModel: incomeViewModel)) {
                    Text("View and Modify Incomes")
                }
                NavigationLink(destination: ExpenseView(viewModel: expenseViewModel)) {
                    Text("View and Modify Expenses")
                }
            }
            //Display asynchronous images
            AsyncImageView(url: URL(string: "https://cdn.vox-cdn.com/thumbor/kLdyb9MwmRW-TZY6IP7-VFJOrog=/0x0:2000x1333/1200x0/filters:focal(0x0:2000x1333):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/16187469/TheVault_PChang_3986.jpg"))
                .padding()
            AsyncImageView(url: URL(string: "https://thevendry.com/cdn-cgi/image/width=3840,quality=75,fit=contain,metadata=none,format=auto/https%3A%2F%2Fs3.amazonaws.com%2Fuploads.thevendry.co%2F20510%2F1640140834107_Priviate-Dining-Room-Rectangles.jpg")).padding()
           AsyncImageView(url: URL(string: "https://media.architecturaldigest.com/photos/61aebcdec08880e1f2206c49/3:2/w_3600,h_2400,c_limit/Boulevard_Dining%20Room.jpg")).padding()
        }
        .onAppear{
            incomeViewModel.loadIncomeSources()//Load income sources
            expenseViewModel.loadExpenseSources()//Load expense sources
        }
        .navigationTitle("Utilities") //Set navigation title
    }
    
    
    //Function to Calculate profit/loss percentage
    private func profitLossPercentage() -> String {
        let totalIncome = incomeViewModel.incomeSources.reduce(0) {
            $0 + $1.amount
        }
        let totalExpense = expenseViewModel.expenseSources.reduce(0) {
            $0 + $1.amount
        }
        let profitLoss = totalIncome - totalExpense
        let percentage = (profitLoss / totalIncome) * 100
        
        if percentage > 0 {
            return "Profit: \(percentage)%"
        } else if percentage < 0 {
            return "Loss: \(percentage)%"
        } else {
            return "Break-even"
        }
    }
    
    //Function to Determine profit/loss color
    private func profitLossColor() -> Color {
        let totalIncome = incomeViewModel.incomeSources.reduce(0) {
            $0 + $1.amount
        }
        let totalExpense = expenseViewModel.expenseSources.reduce(0) {
            $0 + $1.amount
        }
        let profitLoss = totalIncome - totalExpense
        
        if profitLoss > 0 {
            return .green
        } else if profitLoss < 0 {
            return .red
        } else {
            return .blue
        }
    }
}

//IncomeView struct representing the view for displaying and modifying income sources
struct IncomeView: View {
    @ObservedObject var viewModel: IncomeViewModel //ObservedObject for managing income view model
    @State private var isAddingNewIncome = false //State variable to control new income addition
    
    var body: some View {
        VStack {
            List {//Displaying list of income sources
                ForEach(viewModel.incomeSources) { source in //NavigationLink to IncomeDetail view for each income source.
                    NavigationLink(destination: IncomeDetail(incomeSource: source, viewModel: viewModel)) {
                        Text("\(source.name): $\(String(format: "%.2f", source.amount))")//Display income source name and amount
                    }
                }
            }
            Text("Total Income: $\(String(format: "%.2f", totalIncome()))") //Display total income
                .padding()
            Button("Add New Income Source"){ //Button to add new income source
                isAddingNewIncome=true //Set isAddingNewIncome to true
            }
            //NavigationLink to AddIncomeView for adding new income source
            NavigationLink(destination: AddIncomeView(viewModel: viewModel, isAddingNewIncome: $isAddingNewIncome), isActive: $isAddingNewIncome) {
                EmptyView() //Using EmptyView to hide the navigation link text
            }
        }
        .navigationTitle("Income") //Set navigation title
    }
    //Function to calculate totalincome
    private func totalIncome() -> Double {
        return viewModel.incomeSources.reduce(0) { $0 + $1.amount } //Sum of all income amounts
    }
}

//IncomeDetail struct representing the view for displaying and modifying details of an income source
struct IncomeDetail: View {
    @ObservedObject var viewModel: IncomeViewModel //ObservedObject for managing income view model
    @State private var updatedAdditionalInfo: String //State variable to store updated additional info
    let incomeSource: IncomeSource //Income source to display details for

    //Initialize IncomeDetail view with income source and view model
    init(incomeSource: IncomeSource, viewModel: IncomeViewModel) {
        self.incomeSource = incomeSource
        self.viewModel = viewModel
        //Set initial value for updatedAdditionalInfo using income source's additional info
        _updatedAdditionalInfo = State(initialValue: incomeSource.additionalInfo)
    }

    var body: some View {
        VStack {
            Text("\(incomeSource.name)") //Display income source name
                .font(.title)
            Text("Amount: $\(String(format: "%.2f", incomeSource.amount))") //Display income source amount
            TextField("Additional Info", text: $updatedAdditionalInfo) //Textfield to edit additional info
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Save") { //Button to save changes to additional info
                updateAdditionalInfo() //Call function to update additional info
            }
            .padding()
        }
        .padding()
        .navigationTitle(incomeSource.name) //Set navigation title to income source
    }

    //Function to update additional info for the income source
    private func updateAdditionalInfo() {
        //Find index of income source in view model
        if let index = viewModel.incomeSources.firstIndex(where: { $0.id == incomeSource.id }) {
            //Update additional info for the income source
            viewModel.incomeSources[index].additionalInfo = updatedAdditionalInfo
        }
    }
}


//AddIncomeView struct representing the view for adding a new income source
struct AddIncomeView: View {
    @ObservedObject var viewModel: IncomeViewModel
    @Binding var isAddingNewIncome: Bool
    @State private var newSourceName = ""
    @State private var newSourceAmount = ""
    @State private var additionalInfo = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Income Source Name", text: $newSourceName) //Textfield for entering new income source name
                TextField("Amount", text: $newSourceAmount)//Textfield for entering new income source amount
                    .keyboardType(.decimalPad)
                TextField("Additional Info", text: $additionalInfo)//Textfield for entering new income source additional info
            }
            .navigationTitle("Add New Income") //Set navigation title
            .navigationBarItems(
                leading: Button("Cancel") { //Button to cancel adding new income source
                    presentationMode.wrappedValue.dismiss() //Dismiss AddIncomeView
                },
                trailing: Button("Save") { //Button to save new income source
                    saveNewIncome() //Call function to save new income source
                }
            )
        }
    }
    //function to save new income source
    private func saveNewIncome() {
        guard let amount = Double(newSourceAmount) else { return }
        //Create new income source object
        let newIncomeSource = IncomeSource(name: newSourceName, amount: amount, additionalInfo: additionalInfo)
        //Append new income source to view model
        viewModel.incomeSources.append(newIncomeSource)
        //Set isAddingNewIncome to false to dismiss AddIncomeView
        isAddingNewIncome = false
        //Dismiss AddIncomeView
        presentationMode.wrappedValue.dismiss()
    }
}

//ExpenseView struct representing the view for displaying and modifying expense sources
struct ExpenseView: View {
    @ObservedObject var viewModel: ExpenseViewModel //ObservedObject for managing expense view model
    @State private var isAddingNewExpense = false //State variable to control new expense addition
   
    var body: some View {
        VStack {
            List {//Displaying list of expense sources
                ForEach(viewModel.expenseSources) { source in //NavigationLink to ExpenseDetail view for each expense source.
                    NavigationLink(destination: ExpenseDetail(expenseSource: source, viewModel: viewModel)) {
                        Text("\(source.name): $\(String(format: "%.2f", source.amount))")//Display expense source name and amount
                    }
                }
            }
           
            Text("Total Expense: $\(String(format: "%.2f", totalExpense()))") //Display total expense
                .padding()
           
            Button("Add New Expense Source") { //Button to add new expense source
                isAddingNewExpense = true //Set isAddingNewExpense to true
            }
            //NavigationLink to AddExpenseView for adding new expense source
            NavigationLink(destination: AddExpenseView(viewModel: viewModel, isAddingNewExpense: $isAddingNewExpense), isActive: $isAddingNewExpense){
                EmptyView() //Using EmptyView to hide the navigation link text
            }
        }
        .navigationTitle("Expense") //Set navigation title
    }
   
    //Function to calculate totalexpense
    private func totalExpense() -> Double {
        return viewModel.expenseSources.reduce(0) { $0 + $1.amount }
    }
}

//ExpenseDetail struct representing the view for displaying and modifying details of an expense source
struct ExpenseDetail: View {
    @ObservedObject var viewModel: ExpenseViewModel //ObservedObject for managing expense view model
    @State private var updatedAdditionalInfo: String //State variable to store updated additional info
    let expenseSource: ExpenseSource //Expense source to display details for
    
    //Initialize ExpenseDetail view with expense source and view model
    init(expenseSource: ExpenseSource, viewModel: ExpenseViewModel) {
        self.expenseSource = expenseSource
        self.viewModel = viewModel
        //Set initial value for updatedAdditionalInfo using expense source's additional info
        _updatedAdditionalInfo = State(initialValue: expenseSource.additionalInfo)
    }
   
    var body: some View {
        VStack {
            Text("\(expenseSource.name)") //Display expense source name
                .font(.title)
            Text("Amount: $\(String(format: "%.2f", expenseSource.amount))") //Display expense source amount
            TextField("Additional Info", text: $updatedAdditionalInfo) //Textfield to edit additional info
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Save") { //Button to save changes to additional info
                updateAdditionalInfo() //Call function to update additional info
            }
            .padding()
        }
        .padding()
        .navigationTitle(expenseSource.name) //Set navigation title to expense source
    }
    //Function to update additional info for the expense source
    private func updateAdditionalInfo() {
        //Find index of expense source in view model
        if let index = viewModel.expenseSources.firstIndex(where: { $0.id == expenseSource.id }) {
            //Update additional info for the expense source
            viewModel.expenseSources[index].additionalInfo = updatedAdditionalInfo
        }
    }
}

//AddExpenseView struct representing the view for adding a new expense source
struct AddExpenseView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @Binding var isAddingNewExpense: Bool
    @State private var newSourceName = ""
    @State private var newSourceAmount = ""
    @State private var additionalInfo = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Expense Source Name", text: $newSourceName) //Textfield for entering new expense source name
                TextField("Amount", text: $newSourceAmount)//Textfield for entering new expense source amount
                    .keyboardType(.decimalPad)
                TextField("Additional Info", text: $additionalInfo) //Textfield for entering new expense source additional info
            }
            .navigationTitle("Add New Expense") //Set navigation title
            .navigationBarItems(
                leading: Button("Cancel") { //Button to cancel adding new expense source
                    presentationMode.wrappedValue.dismiss() //Dismiss AddExpenseView
                },
                trailing: Button("Save") { //Button to save new expense source
                    saveNewExpense() //Call function to save new expense source
                }
            )
        }
    }
    //function to save new expense source
    private func saveNewExpense() {
        guard let amount = Double(newSourceAmount) else { return }
        //Create new expense source object
        let newExpenseSource = ExpenseSource(name: newSourceName, amount: amount, additionalInfo: additionalInfo)
        //Append new expense source to view model
        viewModel.expenseSources.append(newExpenseSource)
        //Set isAddingNewExpense to false to dismiss AddExpenseView
        isAddingNewExpense = false
        //Dismiss AddExpenseView
        presentationMode.wrappedValue.dismiss()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantApp()
    }
}
 
//AsyncImageView struct to display images asynchronously
struct AsyncImageView: View {
    @StateObject private var imageLoader: ImageLoader
    //Initializing with url
    init(url: URL?) {
        _imageLoader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)//Display loaded image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {//Display progress view while loading
            ProgressView("Loading...")
        }
    }
}





// Image loader class for asynchronous image loading
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
        //Initializing the url
        init(url: URL?) {
            guard let url = url else { return }
            
            // Perform async image loading
            self.cancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map { UIImage(data: $0.data) } // Convert received data to UIImage
                .replaceError(with: nil) // Replace error with nil image
                .receive(on: DispatchQueue.main) // Receive on main thread
                .assign(to: \.image, on: self)//Assign to image property
    }
}

