//
//  Slots.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 20/08/22.
//

import Foundation

import Foundation
import UIKit

struct Slots{
    let startTime: String?
    let endTime: String?
   

    init(startTime:String,endTime:String){
        self.startTime = startTime
        self.endTime = endTime
       
    }
    static func getStaticSlots(docAvilArr:[DocAvailSlot]) -> [Slots] {
        let slots = [Slots(startTime: "00:00:00", endTime: "00:30:00"),
                     Slots(startTime: "00:30:00", endTime: "01:00:00"),
                     Slots(startTime: "01:00:00", endTime: "01:30:00"),
                     Slots(startTime: "01:30:00", endTime: "02:00:00"),
                     Slots(startTime: "02:00:00", endTime: "02:30:00"),
                     Slots(startTime: "02:30:00", endTime: "03:00:00"),
                     Slots(startTime: "03:00:00", endTime: "03:30:00"),
                     Slots(startTime: "03:30:00", endTime: "04:00:00"),
                     Slots(startTime: "04:00:00", endTime: "04:30:00"),
                     Slots(startTime: "04:30:00", endTime: "05:00:00"),
                     Slots(startTime: "05:00:00", endTime: "05:30:00"),
                     Slots(startTime: "05:30:00", endTime: "06:00:00"),
                     Slots(startTime: "06:00:00", endTime: "06:30:00"),
                     Slots(startTime: "06:30:00", endTime: "07:00:00"),
                     Slots(startTime: "07:00:00", endTime: "07:30:00"),
                     Slots(startTime: "07:30:00", endTime: "08:00:00"),
                     Slots(startTime: "08:00:00", endTime: "08:30:00"),
                     Slots(startTime: "08:30:00", endTime: "09:00:00"),
                     Slots(startTime: "09:00:00", endTime: "09:30:00"),
                     Slots(startTime: "09:30:00", endTime: "10:00:00"),
                     Slots(startTime: "10:00:00", endTime: "10:30:00"),
                     Slots(startTime: "10:30:00", endTime: "11:00:00"),
                     Slots(startTime: "11:00:00", endTime: "11:30:00"),
                     Slots(startTime: "11:30:00", endTime: "12:00:00"),
                     Slots(startTime: "12:00:00", endTime: "12:30:00"),
                     Slots(startTime: "12:30:00", endTime: "13:00:00"),
                     Slots(startTime: "13:00:00", endTime: "13:30:00"),
                     Slots(startTime: "13:30:00", endTime: "14:00:00"),
                     Slots(startTime: "14:00:00", endTime: "14:30:00"),
                     Slots(startTime: "14:30:00", endTime: "15:00:00"),
                     Slots(startTime: "15:00:00", endTime: "15:30:00"),
                     Slots(startTime: "15:30:00", endTime: "16:00:00"),
                     Slots(startTime: "16:00:00", endTime: "16:30:00"),
                     Slots(startTime: "16:30:00", endTime: "17:00:00"),
                     Slots(startTime: "17:00:00", endTime: "17:30:00"),
                     Slots(startTime: "17:30:00", endTime: "18:00:00"),
                     Slots(startTime: "18:00:00", endTime: "18:30:00"),
                     Slots(startTime: "18:30:00", endTime: "19:00:00"),
                     Slots(startTime: "19:00:00", endTime: "19:30:00"),
                     Slots(startTime: "19:30:00", endTime: "20:00:00"),
                     Slots(startTime: "20:00:00", endTime: "20:30:00"),
                     Slots(startTime: "20:30:00", endTime: "21:00:00"),
                     Slots(startTime: "21:00:00", endTime: "21:30:00"),
                     Slots(startTime: "21:30:00", endTime: "22:00:00"),
                     Slots(startTime: "22:00:00", endTime: "22:30:00"),
                     Slots(startTime: "22:30:00", endTime: "23:00:00"),
                     Slots(startTime: "23:00:00", endTime: "23:30:00"),
                     Slots(startTime: "23:30:00", endTime: "24:00:00")]
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let dateArray = slots.map { Calendar.current.dateComponents([.hour, .minute], from:formatter.date(from:$0.startTime!)!) }
        print(dateArray)
        let filterdSlot = [Slots]()
//        for arr in docAvilArr{
//        for slot in slots {
//            print(formatter.date(from:slot.endTime ?? "")!)
//            if   formatter.date(from:slot.endTime ?? "")! <= formatter.date(from:arr.endTime ?? "")! {
//                filterdSlot.append(slot)
//                print(filterdSlot)
//            }
//          }
//        }
      return filterdSlot
        }
  
           
       }
    
    
