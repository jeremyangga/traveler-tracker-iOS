import Foundation

class UserData{
    var id : String
    var user : String
    var jam : String
    var kota : String
    var latitude : String
    var longtitude : String
    var provinsi : String
    var tanggal : String
    
    init(id : String, user : String, jam : String, kota : String, latitude : String, longtitude : String, provinsi : String, tanggal : String){
        self.id = id
        self.user = user
        self.jam = jam
        self.kota = kota
        self.latitude = latitude
        self.longtitude = longtitude
        self.provinsi = provinsi
        self.tanggal = tanggal
    }
}
