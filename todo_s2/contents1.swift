//
//  contents1.swift
//  todo_s2
//
//  Created by Soichiro Kuroyanagi on 2020/05/21.
//  Copyright © 2020 kute. All rights reserved.
//

import SwiftUI
import CoreData

struct contents1: View {
    
    @State var showingDetail = false
    @State private var taskName: String = ""
    @State private var testName: String = ""
    @Environment(\.managedObjectContext) var context
    @State private var selectionDate = Date()
    @State private var selection1 = 1
    @State private var task_num = 1
    @State private var naiyou = "d"
    @State var newTaskname = "nil"
 
    
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
                
            
            
               
                
                List {
                    ForEach(notCompletedTasks, id: \.self.id) { task in
                        
                
                    //self.newTaskname  = task.name ?? "No name given"
                      
                        HStack{
                            Text(task.name   ?? "No name given")
                     
                            /*
                             */
                              Button(action: {
                                     
                                      self.updateTask(task)
                                     
                                     
                                 }) {
                                     
                                     Text("")
                             
                                 }
                             /*
                             */
                    }
                        
                    }
                    
                }
                
  
                
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

struct contents1_Previews: PreviewProvider {
    static var previews: some View {

       let context = (UIApplication.shared.delegate as! AppDelegate)
           .persistentContainer.viewContext
       return contents1().environment(\.managedObjectContext, context)
    }
}





