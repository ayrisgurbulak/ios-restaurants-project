/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import Contacts

class Friend {
  let firstName: String
  let lastName: String
  let picture: UIImage?
  var identifier: String?
  let phoneNumber: CNLabeledValue<CNPhoneNumber>?
  
    init(firstName: String, lastName: String,picture: UIImage?,phoneNumber: CNLabeledValue<CNPhoneNumber>?){
    self.firstName = firstName
    self.lastName = lastName
    self.picture = picture
    self.phoneNumber = phoneNumber
  }
  
}

extension Friend: Equatable {
  static func ==(lhs: Friend, rhs: Friend) -> Bool{
    return lhs.firstName == rhs.firstName &&
      lhs.lastName == rhs.lastName
  }
}

extension Friend {
  
  convenience init?(contact: CNContact) {
    let firstName = contact.givenName
    let lastName = contact.familyName
    var picture: UIImage?
    if let imageData = contact.imageData {
        picture = UIImage(data: imageData)
    }
    var phoneNumber: CNLabeledValue<CNPhoneNumber>?
    if let contactPhone = contact.phoneNumbers.first {
          phoneNumber = contactPhone
    }
      self.init(firstName: firstName, lastName: lastName, picture: picture, phoneNumber: phoneNumber)
      
  }
}
