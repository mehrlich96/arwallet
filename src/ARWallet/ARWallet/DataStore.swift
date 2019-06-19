//
//  DataStore.swift
//  ARWallet
//
//  Created by Ehrlich, Mark on 6/18/19.
//  Copyright © 2019 Ehrlich, Mark. All rights reserved.
//

import Foundation
import UIKit

struct ViewData {
    var passwords: [Password]
}

struct Password {
    var password: String
    var userName: String?
    var site: String
}

class DataStore: NSObject, NSCoding {
    
    var userPasswordViews: [UIView] = [UIView]()
    
    var userReferenceImages: [UIImage] = [UIImage]()
    
    var userPData: [ViewData] = [ViewData]()
    
    var ReferenceDict: [String: (UIImage, ViewData)] = [String: (UIImage, ViewData)]()
    
    
    
    override init() {
        super.init()
    }
    
    func encode(with coder: NSCoder) {
//        coder.encode(self.userTemplateArray, forKey:"userTemplates")
//        //        coder.encode(self.selectedTemplate, forKey:"selectedTemplate")
//        coder.encode(self.simpleTemplate, forKey:"simpleTemplate")
//        //        coder.encode(self.templateNames, forKey:"templateNames")
//        //        coder.encode(self.templateIndex, forKey:"templateIndex")
//        coder.encode(self.isEditingInternal, forKey:"isEditingInternal")
//        //        coder.encode(self.altContact, forKey:"altContact")
//        //coder.encode(self.externalSwitch, forKey:"externalSwitch")
//        //coder.encode(self.returnDate, forKey:"returnDate")
//        //coder.encode(self.endDate, forKey:"endDate")
//        //coder.encode(self.allDay, forKey:"allDay")
//        coder.encode(self.advancedSettings, forKey:"advancedSettings")
//        coder.encode(self.simpleMessage, forKey:"simpleMessage")
//        coder.encode(self.advancedInternalMessage, forKey:"advancedInternalMessage")
//        coder.encode(self.advancedExternalMessage, forKey:"advancedExternalMessage")
//        coder.encode(self.oAuth2, forKey:"oAuth2")
//        coder.encode(self.suggestSiri, forKey:"suggestSiri")
        
        coder.encode(self.userReferenceImages, forKey: "ReferenceImages")
        coder.encode(self.userPasswordViews, forKey: "PasswordViews")
        coder.encode(self.userPData, forKey: "PData")
        coder.encode(self.ReferenceDict, forKey: "ReferenceDict")
    }
    
    required init?(coder decoder: NSCoder) {
        super.init()
        
//        self.userTemplateArray = decoder.decodeObject(forKey:"userTemplates") as! [UserTemplate]
//        //        self.selectedTemplate = decoder.decodeInteger(forKey:"selectedTemplate")
//        self.isEditingInternal = decoder.decodeBool(forKey: "isEditingInternal")
//        if let simpleDecodedTemplate = decoder.decodeObject(forKey:"simpleTemplate") as? UserTemplate {
//            self.simpleTemplate = simpleDecodedTemplate
//        }
//        if let oAuth2decode = decoder.decodeObject(forKey:"oAuth2") as? Bool {
//            self.oAuth2 = oAuth2decode
//        }
//        if let suggestSiridecode = decoder.decodeObject(forKey: "suggestSiri") as? Bool {
//            self.suggestSiri = suggestSiridecode
//        }
        
        if let images = decoder.decodeObject(forKey: "ReferenceImages") as? [UIImage] {
            self.userReferenceImages = images
        }
        
        if let views = decoder.decodeObject(forKey: "PasswordViews") as? [UIView] {
            self.userPasswordViews = views
        }
        
        if let data = decoder.decodeObject(forKey: "PData") as? [ViewData] {
            self.userPData = data
        }
        if let dictionary = decoder.decodeObject(forKey: "ReferenceDict") as? [String: (UIImage, ViewData)] {
            self.ReferenceDict = dictionary
        }
        
    }
    
    
    
    
    //    class func shared() -> DataStore {
    //        return sharedDataStore
    //    }
    
}

