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
    @State private var selection1 = 1
    @State private var task_num = 1
    @State private var naiyou = "d"

    
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.dateAdded, ascending: true)],
        predicate: NSPredicate(format: "isComplete == %@", NSNumber(value: false))
    )
    
    var notCompletedTasks: FetchedResults<Task>

    var body: some View {
        NavigationView{
    
        VStack {
        
           
            HStack {
                TextField("Task Name", text: $taskName)
       

                Button(action: {
                    if self.task_num == 1 {
                        self.naiyou = "申し込み期限"}else{
                        self.naiyou = "イベント"}
                    self.addTask()
                    self.taskName = ""
           
                }) {
                    Text("Add Task")
                }
            }.padding()
            

            List {
                
Text("Content")
                Picker(selection: $task_num, label: Text("内容").hidden()){
                    Text("申し込み期限").tag(1)
                    Text("イベント").tag(2)
                    
                           }
                    

                    Text("Date and time")
                DatePicker("Date", selection: $selectionDate).labelsHidden()
                
                /*
                ForEach(notCompletedTasks, id: \.self.id) { task in
                    Button(action: {
                      
                        self.updateTask(task)
                      
                    }) {
                        Text(task.name   ?? "No name given")
                        
                    }
                }*/
            }
             NavigationLink(destination: contents1()) {
                 Text("Confirm task")
                }                   .navigationBarTitle("To Do List")
                
               
             }
            }
  
    }
    
    
    func addTask() {
        let newTask = Task(context: context)
        let newdate = DateUtils.stringFromDate(date:selectionDate, format: "yyyy年MM月dd日 HH時mm分")
        
        newTask.id = UUID()
        newTask.name = taskName + "\n・" + naiyou + "\n・" + newdate
        
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

