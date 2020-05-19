//
//  ContentView.swift
//  todo_s2
//
//  Created by Soichiro Kuroyanagi on 2020/05/18.
//  Copyright © 2020 kute. All rights reserved.
//


import SwiftUI
import CoreData

struct ContentView: View {
    
    @State var showingDetail = false
    @State private var taskName: String = ""
    @State private var testName: String = ""
    @Environment(\.managedObjectContext) var context
    @State private var selectionDate = Date()
    
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.dateAdded, ascending: true)],
        predicate: NSPredicate(format: "isComplete == %@", NSNumber(value: false))
    )
    
    var notCompletedTasks: FetchedResults<Task>

    var body: some View {
        VStack {
            /*
            Button(action: {self.showingDetail.toggle()} ) {
                Text("+details")
            }
            .sheet(isPresented: $showingDetail){
                set_details()
            }*/

            
            HStack {
                TextField("Task Name", text: $taskName)
                

                Button(action: {
                    self.addTask()
                    self.taskName = ""
                }) {
                    Text("Add Task")
                }
            }.padding()
            Form {
                DatePicker("日時を選択", selection: $selectionDate)
            }
            /*
            HStack {
                  TextField("Test", text: $testName)
           

           
              }.padding()
            */
            
            List {
                ForEach(notCompletedTasks, id: \.self.id) { task in
                    Button(action: {
                        self.updateTask(task)
                    }) {
                        Text(task.name   ?? "No name given")
                        
                    }
                }
            }
        }
    }
    
    
    func addTask() {
        let newTask = Task(context: context)
        let newdate = DateUtils.stringFromDate(date:selectionDate, format: "yyyy年MM月dd日 HH時mm分")
        
        newTask.id = UUID()
        newTask.name = taskName + "\n" + newdate
        
        newTask.isComplete = false
        newTask.dateAdded = Date()
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func updateTask(_ task: Task){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id! as NSUUID as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let taskUpdate = try context.fetch(fetchRequest)[0] as! NSManagedObject
            taskUpdate.setValue(true, forKey: "isComplete")
            try context.save()
        } catch {
            print(error)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}


class DateUtils {
    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }

    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
