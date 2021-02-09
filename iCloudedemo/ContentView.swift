//
//  ContentView.swift
//  iCloudedemo
//
//  Created by Knoxpo MacBook Pro on 09/02/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var listelement: ListElements
   @State private var NewItem = ListElement(text: "")
    @State private var EditItem = ListElement(text: "")
    @State private var ShowTextFeild = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 5) {
                    
                    TextField("Add new item(element)", text: $NewItem.text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                    
                    Button("Add") {
                        if !self.NewItem.text.isEmpty {
                            
                            let  newItem = ListElement(text: self.NewItem.text)
                            
                            CloudkitHelper.SaveRecord(item: newItem)
                                { (result) in
                                
                                switch result {
                                
                                case .success(let newItem):
                                    self.listelement.listarr.insert(newItem, at: 0)
                                
                                case .failure(let err):
                                    
                                    
                                    print("\(err.localizedDescription)")
                                
                                
                                
                                
                                
                                }
                                
                                
                                self.NewItem =
                                
                            ListElement(text: "")
                            
                            }
                            
                       
                            
                        }
                    
                    }
                   
                    
                    HStack {
                        TextField("Enter item to edit",text: $EditItem.text)
                        
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        
                        Button("Edit") {
                            
                        
                            CloudkitHelper.ModifyRecord(item:self.EditItem)
                                { (result) in
                                switch(result){
                                case .success(let item):
                                    for i in 0..<self.listelement.listarr.count {
                                    let currentItem = self.listelement.listarr[i]
                                        if currentItem.recordId == item.recordId {
                                            self.listelement.listarr[i] = item
                                        }}
                                    self.ShowTextFeild = false
                                 
                                 print("success")
                                    
                                            
                                case .failure(let err):
                                    print("\(err.localizedDescription)")
                                }
                                
                                }
                                
                              
                                }
                                
                            }
                    .frame(height: ShowTextFeild ? 60 : 1)
                    .opacity(ShowTextFeild ?  1 : 0)
                    .animation(.easeInOut)
                            
                            
                        }
                        
                .padding(20)
                Text("Double tab to delete")
                
                    .frame(height: ShowTextFeild ? 1 : 40 )
                    .opacity(ShowTextFeild ? 0 : 1)
                    .animation(.easeInOut)
                
                List(listelement.listarr) { item in
                    
                    HStack( spacing: 12) {
                        
                        Text(item.text)
                        
                        
                        
                    }
                    .onTapGesture(count: 2, perform: {
                     if !self.ShowTextFeild
                        {
                            self.ShowTextFeild = true
                            self.EditItem = item
                            
                        }
                        
                        
                        
                    })
                
                
                    .onLongPressGesture {
                        
                        if
                            !self.ShowTextFeild{
                            
                            guard let recordID = item.recordId else {
                                return
                            }
                            CloudkitHelper.DeleteRecord(recordID: recordID) { (result) in
                                switch result {
                                case .success(let recordID): self.listelement.listarr.removeAll { (listelement) -> Bool in return
                                    listelement.recordId == recordID
                                    
                                    
                                    
                                }
                                
                                print("successfuly  delete")
                                case .failure(let err):
                                
                                    print("\(err.localizedDescription)")
                                
                                
                                
                           
                            }
                            
                         
                            
                        }
                        
                     
                    }
                 
                    
                }
                   
        }
                    
            .animation(.easeInOut)
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
            .navigationBarTitle(Text("Tutorial"))
                
                
                
                
                
            }
        .onAppear {
            
            
            CloudkitHelper.fetchRecord { result in
                
                switch result {
                
                case .success(let newItem):
                    self.listelement.listarr.append(newItem)
                
                print("success")
                case .failure(let error):
                    
                    print("\(error.localizedDescription)")
                
                }
                
                
                
                
                
                
            }
            
            
            
            
        }
            
            
            
            
            
        }
        
        
        
        
        
}
        



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
