//
//  set_details.swift
//  todo_s2
//
//  Created by Soichiro Kuroyanagi on 2020/05/19.
//  Copyright © 2020 kute. All rights reserved.
//

import SwiftUI

struct set_details: View {
    
    @State var task_num = 1
    
    var body: some View {
        VStack{
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Picker(selection: $task_num, label: Text("内容")){
                Text("申し込み期限")
                Text("イベント")
            }
            DatePicker(selection: /*@START_MENU_TOKEN@*/.constant(Date())/*@END_MENU_TOKEN@*/, label: { /*@START_MENU_TOKEN@*/Text("Date")/*@END_MENU_TOKEN@*/ })

            
        }
    }
}

struct set_details_Previews: PreviewProvider {
    static var previews: some View {
        set_details()
    }
}
