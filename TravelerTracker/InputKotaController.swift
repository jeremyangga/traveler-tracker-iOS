import UIKit

class InputKotaController: UIViewController {

    @IBOutlet weak var txtNamaKota: UITextField!
    @IBOutlet weak var LblKeterangan: UILabel!
    @IBOutlet weak var txtProvinsi: UITextField!
    var arrCity : String = ""
    var arrLat : String = ""
    var arrLng : String = ""
    var arrProvince : String = ""
    var ProvinsiData :String=""
    var useremail : String?
    
    var arrProvinceVirus : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        LblKeterangan.isHidden = true
        print("User email: ",useremail)
    
    }
    @IBAction func btnCari(_ sender: UIButton) {
        FetchingCity()
        
        //APIcallVirus()
    }
    
    @IBAction func btnKeluar(_ sender: UIButton) {
        performSegue(withIdentifier: "backToHome", sender: self)
    }
    @IBAction func btnRiwayat(_ sender: UIButton) {
        print("Riwayat")
        performSegue(withIdentifier: "keRiwayat", sender: self)
    }
    //    @IBAction func btnLihatKota(_ sender: UIButton) {
//        print("Lihat Kota")
//        performSegue(withIdentifier: "keLihatKota", sender: self)
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "keLihatKota"){
                let displayVC = segue.destination as! LihatKota
            displayVC.ProvinsiData = ProvinsiData
            displayVC.NamaKota = txtNamaKota.text!
            displayVC.useremail = useremail
            displayVC.latitude = arrLat
            displayVC.longtitude = arrLng
            //displayVC.keterangan = "Kota tujuan anda adalah \(txtNamaKota.text!) berada pada provinsi \(ProvinsiData), untuk saat ini tingkat positif provinsi yang anda tuju sekitar \(KasusPositif), kasus meninggal sekitar \(KasusMeninggal) dan kasus kesembuhannya \(KasusSembuh). Anda wajib untuk mengikuti protokol kesehatan yang sudah ada."
        }
        else if segue.identifier == "keRiwayat"{
            let displayVC = segue.destination as! RiwayatController
            displayVC.useremail = useremail
        }
    }
    
    func FetchingCity(){
        guard let path = Bundle.main.path(forResource: "city", ofType: "json") else {return}
        
        let url = URL(fileURLWithPath: path)
        
        do{
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            guard let arraycity = json as? [Any] else{return}
            for citydata in arraycity{
                guard let cityDict = citydata as? [String: Any] else {return}
                guard let city = cityDict["city"] as? String else{return}
                guard let lat = cityDict["lat"] as? String else{return}
                guard let lng = cityDict["lng"] as? String else{return}
                guard let admin_name = cityDict["admin_name"] as? String else{return}
                
                if txtNamaKota.text!.contains(city) && txtProvinsi.text!.contains(admin_name){
                    print("city : \(city), lat : \(lat), lng : \(lng), admin = \(admin_name)")
                    arrCity = city
                    arrLat = lat
                    arrLng = lng
                    arrProvince = admin_name
                    if(arrProvince == "Jakarta"){
                        ProvinsiData = "DKI Jakarta"
                    }
                    else{
                        ProvinsiData = arrProvince
                    }
                }
                else{

//                    break
              //      print("Tidak Ditemukan")
                }
            }
            if arrCity==txtNamaKota.text! && arrProvince==txtProvinsi.text! {
                LblKeterangan.isHidden = false
                LblKeterangan.text! = "Kota yang anda cari adalah \(arrCity) berada pada provinsi \(ProvinsiData)"
                performSegue(withIdentifier: "keLihatKota", sender: self)
            }
            else{
                //LblKeterangan.isHidden = true
                showAlertCity()
                txtNamaKota.text? = ""
                txtProvinsi.text? = ""
            }
        }catch{
            print(error)
        }
    }
    
    func showAlertCity(){
        let alertView = UIAlertController(title: "Kota Tidak Ditemukan", message: "Cek nama kota dan provinsi anda!", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_) in
           print("Kota Tidak Ditemukan")
            //exit(0)
        }))
        self.present(alertView,animated: true,completion: nil)
    }
    
}
