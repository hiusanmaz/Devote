//
//  ContentView.swift
//  Devote
//
//  Created by Halil Usanmaz on 20.07.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - PROPERTY
    
    @State var task: String = "";
    @State private var showNewTaskItem: Bool = false;
    
    
  
    
    // FETCHING DATA
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>

    // MARK: - FUNCTION
    
 

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
        
            ZStack {
                // MARK: - MAIN VIEW
                VStack {
                    // MARK: - HEADER
                    Spacer(minLength: 80)
                    
                    // MARK: - NEW TASK BUTTON
                    Button(action: {
                        showNewTaskItem = true;
                        
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 32,weight: .bold,design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24,weight: .bold,design: .rounded))
                            
                    })
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.pink]), startPoint: .leading, endPoint: .trailing).clipShape(Capsule()))
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.5), radius: 12)
                    // MARK: - TASKS
                    
               
               
                    List {
                            ForEach(items) { item in
                                VStack{
                                    Text(item.task ?? "")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    
                                    Text("Item at \(item.timestamp!,formatter: itemFormatter)")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                        
                                    
                                }//:VSTACK
                            }
                            .onDelete(perform: deleteItems)
                            //: LIST
                            .listStyle(InsetGroupedListStyle())
                            .shadow(color: Color(red: 0, green: 0, blue: 0,opacity: 0.4), radius: 12)
                            .padding(.vertical,0)
                            .frame(maxWidth: 640)
                        }
                        
                }//: VSTACK
                .navigationBarTitle("Daily Tasks", displayMode: .large)
                .toolbar {
                    #if os(iOS)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                   
                    }
                    #endif
                   
            }//: TOOLBAR
                .background(BackgroundImageView())
                .background(backgroundGradient.ignoresSafeArea(.all))
                
                // MARK: - NEW TASK ITEM
                
            }//: ZSTACK
            .onAppear(){
                UITableView.appearance().backgroundColor = UIColor.clear
            }
        } //: NAVIGATION VIEW
        .navigationViewStyle(StackNavigationViewStyle())
        
    }

 
}


// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
