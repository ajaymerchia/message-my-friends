//
//  ConfigUserVC-initUI.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/3/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension ConfigUserVC {
    func initUI() {
        initNav()
        initTitle()
        initPicker()
        initFields()
        addKeyboardDismiss()
    }

    // UI Initialization Helpers
    func initNav() {
        
        navbar = UINavigationBar(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.maxY, width: view.frame.width, height: 40))
        
        let item = UINavigationItem()
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(updateUser))
        doneButton.isEnabled = false
        item.rightBarButtonItem = doneButton
        
        
        navbar.items = [item]
        
        view.addSubview(navbar)
        
        let statusBarFiller = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: UIApplication.shared.statusBarFrame.height))
        statusBarFiller.backgroundColor = UIColor.colorWithRGB(rgbValue: 0xf9f9f9)
        
        view.addSubview(statusBarFiller)
        
    }
    
    func initTitle() {
        prompt = UILabel(frame: LayoutManager.belowCentered(elementAbove: navbar, padding: .PADDING * 1.5, width: view.frame.width - 2 * .PADDING, height: 50))
        prompt.text = "Let's get to know you!"
        prompt.font = UIFont.subtitle
        prompt.textColor = .theme_green
        prompt.textAlignment = .center
        prompt.adjustsFontSizeToFitWidth = true
        
        view.addSubview(prompt)
    }
    
    func initPicker() {
        selectProfilePhoto = UIButton(frame: LayoutManager.belowCentered(elementAbove: prompt, padding: .PADDING, width: view.frame.width/2.5, height: view.frame.width/2.5))
        
        selectProfilePhoto.imageView?.contentMode = .scaleAspectFit
        selectProfilePhoto.setImage(UIImage.avatar.withRenderingMode(.alwaysTemplate), for: .normal)
        selectProfilePhoto.tintColor = .theme_green
        selectProfilePhoto.addTarget(self, action: #selector(askForPhotoSource(_:)), for: .touchUpInside)
        
        selectProfilePhoto.clipsToBounds = true
        selectProfilePhoto.layer.cornerRadius = selectProfilePhoto.frame.width/2
        selectProfilePhoto.layer.borderColor = UIColor.theme_green.cgColor
        selectProfilePhoto.layer.borderWidth = 1
        
        view.addSubview(selectProfilePhoto)
        
    }
    
    func initFields() {
        firstNameField = UITextField(frame: LayoutManager.belowCentered(elementAbove: selectProfilePhoto, padding: .PADDING, width: view.frame.width - 2 * .PADDING, height: 40))
        firstNameField.attributedPlaceholder = NSAttributedString(string: "First", attributes: [NSAttributedString.Key.font: UIFont.title])
        
        firstNameField.textColor = .theme_green
        firstNameField.font = UIFont.title
        
        firstNameField.textAlignment = .center
        firstNameField.addTarget(self, action: #selector(checkForValidConfig), for: .editingChanged)
        
        view.addSubview(firstNameField)
        
        lastNameField = UITextField(frame: LayoutManager.belowCentered(elementAbove: firstNameField, padding: 0, width: view.frame.width - 2 * .PADDING, height: 40))
        lastNameField.attributedPlaceholder = NSAttributedString(string: "Last", attributes: [NSAttributedString.Key.font: UIFont.header])
        
        lastNameField.textColor = UIColor.theme_green.darken(byPercentage: 0.5)
        lastNameField.font = UIFont.header
        
        lastNameField.textAlignment = .center
        lastNameField.addTarget(self, action: #selector(checkForValidConfig), for: .editingChanged)
        
        view.addSubview(firstNameField)
        view.addSubview(lastNameField)
    }

    
    func addKeyboardDismiss() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        self.firstNameField.resignFirstResponder()
        self.lastNameField.resignFirstResponder()
    }
    
    func addNewUserPhoto(img: UIImage) {
        self.selectedImage = img
        self.selectProfilePhoto.imageView?.contentMode = .scaleAspectFill
        self.selectProfilePhoto.setImage(self.selectedImage, for: .normal)
    }
    
    func addUserDetails() {
        if self.user.first != nil {
            firstNameField.text = self.user.first
        }
        if self.user.last != nil {
            lastNameField.text = self.user.last
        }
        if let img = self.user.photo {
            addNewUserPhoto(img: img)
        }
        
    }
    
}
