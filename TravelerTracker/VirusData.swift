import Foundation

struct VirusData : Decodable{
    let data : [Index]
}

struct Index : Decodable{
    let provinsi : String
    let kasusPosi : Int
    let kasusSemb : Int
    let kasusMeni : Int
}

//struct DataCity : Decodable{
//       let city : String
//       let region : String
//       let latitude : Double
//       let longtitude : Double
//}
//
////struct Index_City : Decodable{
////    let city : String
////    let region : String
////    let latitude : Double
////    let longtitude : Double
////}
