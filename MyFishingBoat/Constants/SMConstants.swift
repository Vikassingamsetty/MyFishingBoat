//
//  SMConstants.swift
//  MyFishingBoat
//
//  Created by Appcare on 17/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//


import Foundation
import UIKit

//MARK:- Base URL

let Base_URL = "https://myfishingboat.in/betafish/index.php/live/" //client server
//let Base_URL = "http://159.65.145.170/betafish/index.php/live/"

//key and contenttype
struct APIKEY {
    public static var key = "API-KEY"
    public static var value = "827ccb0eea8a706c4c34a16891f84e7b"
    public static var contentType = "Content-Type"
    public static var type = "application/json"
}

//MARK:-API's

//login
let register_URL = Base_URL+"Services/register"
let loginpswd_URL = Base_URL+"Services/login"
let forgotpswd_URL = Base_URL+"Services/Forget_password"
let sendOTP_URL = Base_URL+"Services/send_otp"
let checkOTP_URL = Base_URL+"Services/check_otp"
//addresses
let addrList_URL = Base_URL+"Services/getUserAddress"
let newaddr_URL = Base_URL+"Services/addressAdd"
let deleteaddr_URL = Base_URL+"Services/userAddressDelete"
let editaddr_URL = Base_URL+"Services/addressEdit"
let deleveryDistanceAvailability_URL = Base_URL+"Services/distance"
let deliveryAreas_URL = Base_URL+"Services/DeliveryAreas"
//profile
let updateProfile_URL = Base_URL+"Services/profile_update"
let changePswd_URL = Base_URL+"Services/change_password"
//wishlist
let listWishlist_URL = Base_URL+"Products/getWishlist"
let addWishlist_URL = Base_URL+"Products/wishList"
let deleteWishlist_URL = Base_URL+"Products/deletewishList"
//Search
let searchList_URL = Base_URL+"Products/getSearchProducts"
//Home screen
let imageSlidesAuto_URL = Base_URL+"Orders/getSliders"
let staticCategoryList_URL = Base_URL+"Products/getStaticFishCategories"
let categorylist_URL = Base_URL+"Products/getFishCategories"
let bestseller_URL = Base_URL+"Products/getTopSaleProducts"
//individual category products list
let singleCtgryProList_URL = Base_URL+"Products/getProducts"
let singleProductDetails_URL = Base_URL+"Products/getProduct_Details"
let addToCartSingle_URL = Base_URL+"Products/addtoCart"
let addRecipie_URL = Base_URL+"Services/addReceipe"
//cutting preferences
let cuttingPref_URL = Base_URL+"Products/getCuttingPreferences"
let cuttingPreference_URL = Base_URL+"Products/getCuttingPreferences_with_id"
//Cartlist
let cartList_URL = Base_URL+"Products/getCartProducts"
let timeSlots_URL = Base_URL+"Services/slots"
let datePicked_URL = Base_URL+"Services/dates"
let deleteCart_URL = Base_URL+"Products/deleteCart"
let charges_URL = Base_URL+"Orders/Charges"
let coupons_URL = Base_URL+"Orders/getCoupns"
let couponApply_URL = Base_URL+"Coupns/checkCoupan"
let getDeliveryType_URL = Base_URL+"Orders/getDelivertyTypes"


//Myorders
let orderStatus_URL = Base_URL+"Orders/getOrderStatuses"
let myorders_URL = Base_URL+"Orders/getUserOrders"
let viewOrderDetails_URL = Base_URL+"Orders/viewOrders"

//create order
let createOrder_URL = Base_URL+"Orders/OrderCreate"

//StoreLocationList
let storeLocations_URL = Base_URL+"Services/StoreLocations"
//ContactUs
let contactus_URL = Base_URL+"Services/contactus"
//Aboutus
let aboutus_URL = Base_URL+"Services/about_us"
//T&C
let termsCond_URL = Base_URL+"Services/terms_and_conditions"
//privacy policies
let privacy_URL = Base_URL+"Services/privicypolicy"
//FAQ's
let faq_URL = Base_URL+"Services/faqs"
//Availability store (serviceable or non serviceable)
let storeAvail_URL = Base_URL+"Services/checkDelivery"
//PaymentStatus
let paymentStatus_URL = Base_URL+"Orders/PaymentStatus"
let orderDetails_URL = Base_URL+"Orders/getOrderDeatils"

//Rating or Feedback status
let feedbackStatus_URL = Base_URL+"Services/getOrderRateStatus"
//Rating or feedback
let feedback_URL = Base_URL+"Services/rate_us"

//CHeck address and store based on user location
let picDelNearAddr_URL = Base_URL+"Services/checkDeliveryPickup"
var cartValue = ""
var homeScreenValue = ""
var cartScreenValue = ""
var cartStaticValue = ""

//Alert for network issue
struct Network {
    static var title: String = "Network"
    static var message: String = "It seems you are offline. Please check your Internet connection!"
}

struct WebPage {
    static var aboutUs: String = "AboutUs"
    static var termsAndConditions: String = "TermsAndConditions"
}

struct APPUSerDefault
{
    static var userId: String = "userId"
    static var deviceToken = "DeviceToken"
    static var registerId = "registrationId"
    static var userIdValue = "D9856325855"
}

struct AppConstants
{
    static var hardCodedBaseURL: String = "http://13.234.112.159/hcc/index.php/api/"
}

struct AlertMessages
{
    static var emailOrPhone = "Please enter Email id or Phone number"
    static var password = "Please enter Password"
}

struct RegisPageAlertMsg
{
    static var firstName = "Please enter first name"
    static var lastName = "Please enter last name"
    static var dob = "Please enter dob"
    static var genderSelection = "Please select Gender"
    static var password = "Please enter password"
    static var passwordMsg = "Your password must be 6-24 characters long and contain atleast oe uppercase, one lowercase, one number and a special character."
    static var acceptTANdC = "Please accept Terms & Conditions"
    static var registerNumber = "Please enter Registration Number"
}

struct ProfilePageAlertMsg
{
    static var bloodgroup = "Please enter BloodGroup"
    static var allergies = "Please enter Allergies"
    static var hormonalImbalance = "Please enter Hormonal Imbalance"
    static var diabeties = "Please enter Diabeties"
    static var pastSurgical = "Please enter Past surgical"
    static var hyperTension = "Please enter Hypertension"
}

struct LocationPageMsg {
    static var selectCountry = "Please select Country"
    static var selectState = "Please select State"
    static var countryAlertMsg = "Please enter Country Name"
    static var stateAlertMsg = "Please enter State Name"
    static var cityAlertMsg = "Please enter City Name"
    static var streetAlertMsg = "Please enter Street Name"
    static var pincodeAlertMsg = "Please enter Pincode"
    static var phoneNumber = "Please enter Phone number"
    static var validPhoneNumber = "Enter Mobile with '+ Country Code'  followed by number. Example : +911234599999"
}

struct appColor
{
    static var appBlue  = UIColor(named: "#001D9C")
    static var appGary  = UIColor(named: "#77797C")
    
}

