//
//  File.swift
//  
//
//  Created by Анастасия Горячевская on 01.07.2023.
//

import Foundation

extension TodoItem {
    
    public var json: Any {
        var data: [String: Any] = [Constants.id: id,
                                   Constants.text: text,
                                   Constants.done: done,
                                   Constants.creationDate: creationDate.timeIntervalSince1970]
        data[Constants.taskImportance] = taskImportance != .usual ? taskImportance.rawValue : nil
        data[Constants.deadlineDate] = deadlineDate?.timeIntervalSince1970 ?? nil
        data[Constants.changeDate] = changeDate?.timeIntervalSince1970 ?? nil
        data[Constants.color] = hexColor
        return data
    }
    
    public static func parse(json: Any) -> TodoItem? {
        guard let data = json as? [String: Any] else { return nil }
        guard let id = data[Constants.id] as? String,
              let text = data[Constants.text] as? String,
              let done = data[Constants.done] as? Bool,
              let creationDate = getDateFromTimeInterval(data[Constants.creationDate] as? TimeInterval),
              let taskImportance = TaskImportance(rawValue: data[Constants.taskImportance] as? String ?? "usual"),
              data[Constants.deadlineDate] == nil || (data[Constants.deadlineDate] as? TimeInterval) != nil,
              data[Constants.changeDate] == nil || (data[Constants.changeDate] as? TimeInterval) != nil
        else { return nil }
        
        let deadlineDate = getDateFromTimeInterval(data[Constants.deadlineDate] as? TimeInterval)
        let changeDate = getDateFromTimeInterval(data[Constants.changeDate] as? TimeInterval)
        let textColor =  data[Constants.color] as? String
        
        return TodoItem(id: id,
                        text: text,
                        taskImportance: taskImportance,
                        deadlineDate: deadlineDate,
                        done: done,
                        creationDate: creationDate,
                        changeDate: changeDate,
                        textColor: textColor)
    }
    
    private static func getDateFromTimeInterval(_ timeInterval: TimeInterval?) -> Date? {
        guard let timeInterval = timeInterval else { return nil }
        return Date(timeIntervalSince1970: timeInterval)
    }
}
