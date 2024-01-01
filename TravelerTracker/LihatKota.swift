
import UIKit
import Firebase

class LihatKota: UIViewController {
    var ref: DatabaseReference!
    @IBOutlet weak var lblKasusPositif: UILabel!
    @IBOutlet weak var LblMeninggal: UILabel!
    @IBOutlet weak var LblProvinsi: UILabel!
    @IBOutlet weak var LblSembuh: UILabel!
    @IBOutlet weak var LblKeterangan: UILabel!
    var KasusPositif : Int = 0
    var KasusSembuh : Int = 0
    var KasusMeninggal : Int = 0
    var ProvinsiData :String?
    var NamaKota : String?
    var useremail : String?
    var latitude : String?
    var longtitude : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        LblProvinsi.text = ProvinsiData!
        print(ProvinsiData!)
        APIcallVirus()
        print("User email: ",useremail!)
        
    }

    @IBAction func btnBatalkan(_ sender: UIButton) {
        performSegue(withIdentifier: "backToMenu", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if(segue.identifier == "backToMenu"){
            let displayVC = segue.destination as! InputKotaController
            displayVC.useremail = useremail
        }
    }
   
    @IBAction func btnLanjutkan(_ sender: UIButton) {
        print(KasusPositif)
        //date
        let date = Date()
        let calendar = Calendar.current
        let tanggal = calendar.component(.day, from: date)
        let bulan = calendar.component(.month, from: date)
        let tahun = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        
        print("\(tanggal)-\(bulan)-\(tahun) \(hour):\(minute):\(second)")
        print(useremail!)
        let val = ["user":useremail!, "tanggal":"\(tanggal)-\(bulan)-\(tahun)", "jam":"\(hour):\(minute):\(second)" ,"latitude":latitude!, "longtitude":longtitude!, "kota":NamaKota!, "provinsi":ProvinsiData!]
        ref.child("tracker").childByAutoId().setValue(val){ (error, ref) in
                  if error != nil {
                      print(error?.localizedDescription ?? "Failed to update value")
                    self.showAlert(title_message: "Gagal Update", alert_message: "Silahkan diulangi kembali",status:false)
                  } else {
                      print("Success update newValue to database")
                    self.showAlert(title_message: "Berhasil Update. Tetap ikuti protokol kesehatan!", alert_message: "",status:true)
            }
        }
    }
    func showAlert(title_message:String, alert_message:String, status:Bool){
      let alertView = UIAlertController(title: title_message, message: alert_message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_) in
           print(title_message)
            if status == true {
                self.performSegue(withIdentifier: "backToMenu", sender: self)
            }
        }))
        self.present(alertView,animated: true,completion: nil)
    }
    @IBAction func btnLihatKeterangan(_ sender: UIButton) {
        APIcallVirus()
        
    }
    func APIcallVirus(){
            let request = NSMutableURLRequest(url: NSURL(string: "https://indonesia-covid-19.mathdro.id/api/provinsi/")! as URL,
                cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    self.showAlertCity()
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse ?? "")
                    if let safeData = data {
                        let dataString = String(data: safeData, encoding: .utf8)
                        print(dataString ?? "")
                        self.parseJSONVirus(virusData: safeData)
                    }
                }
            })

            dataTask.resume()
        }
        
        func handle(data: Data?, response: URLResponse?, error: Error?) {
            if error != nil {
                print(error ?? "")
            }
            let httpResponse = response as? HTTPURLResponse
            print(httpResponse ?? "")
            if let safeData = data {
                let dataString = String(data: safeData, encoding: .utf8)
                print(dataString ?? "")
                self.parseJSONVirus(virusData: safeData)
            }
        }
        func parseJSONVirus(virusData: Data){
            let decoder = JSONDecoder()
            do {
                let decodeData =  try decoder.decode(VirusData.self, from:virusData)
//                KasusPositif = decodeData.data[0].kasusPosi
//                KasusSembuh = decodeData.data[0].kasusSemb
//                KasusMeninggal = decodeData.data[0].kasusSemb
                print("Provinsi Data : \(ProvinsiData!)")
                DispatchQueue.main.async {
                      for i in 0...33{
                                    //print(decodeData.data[i].kasusPosi)
                        if  self.ProvinsiData! == decodeData.data[i].provinsi  {
                            print(decodeData.data[i].provinsi)
                            print(decodeData.data[i].kasusPosi)
                            print(decodeData.data[i].kasusMeni)
                            self.KasusPositif = decodeData.data[i].kasusPosi
                            self.KasusSembuh = decodeData.data[i].kasusSemb
                            self.KasusMeninggal = decodeData.data[i].kasusSemb
                            self.lblKasusPositif.text = "Kasus Positif sebanyak \(self.KasusPositif)."
                            self.LblSembuh.text = "Sebanyak \(self.KasusSembuh) pasien sudah sembuh."
                            self.LblMeninggal.text = "Sebanyak \(self.KasusMeninggal) pasien meninggal akibat Covid-19."
                            self.LblKeterangan.text = "Patuhilah Protokol Kesehatan!"
                            break
                        }
                        else{
                            //self.showAlertVirusNotFound()
                            //break
                        }
                    }
                }
              
                
            }
            catch{
                print("Error",error)
                showAlertVirusNotFound()
            }
        }
        func showAlertVirusNotFound(){
            let alertView = UIAlertController(title: "Data Tidak Ditemukan", message: "", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_) in
               print("Data Tidak Ditemukan")
                //exit(0)
            }))
            self.present(alertView,animated: true,completion: nil)
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
