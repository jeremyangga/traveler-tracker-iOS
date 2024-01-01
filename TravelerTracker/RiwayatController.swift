import UIKit
import Firebase

class RiwayatController: UIViewController {
    var ref: DatabaseReference!
    @IBOutlet weak var travelList: UITableView!{
        didSet{
            travelList.dataSource = self
        }
    }
    var useremail:String?
    var userdata = [UserData]()
    var userreaddata = [UserData]()
    var test = ["Halo", "HAI"]
    var count :Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference().child("tracker")
        ref.observe(.childAdded){ [weak self](snapshot) in
            let key = snapshot.key
            guard let value = snapshot.value as? [String:Any] else{return}
            if let user = value["user"] as? String, let jam = value["jam"] as? String, let kota = value["kota"] as? String, let latitude = value["latitude"] as? String, let longtitude = value["longtitude"] as? String, let provinsi = value["provinsi"] as? String, let tanggal = value["tanggal"] as? String{
                    let usergetdata = UserData(id: key, user: user, jam: jam, kota: kota, latitude: latitude, longtitude: longtitude, provinsi: provinsi, tanggal: tanggal)
                self?.userdata.append(usergetdata)
                if usergetdata.user == self?.useremail{
                    self?.count+=1
                    print("Userget data:",usergetdata.user)
                    self?.userreaddata.append(usergetdata)
                }
                print("Hitung: ",self?.count as! Int)
                print("Hitung user read data : ", self?.userreaddata.count)
                if let row = self?.userdata.count {
                    let indexPath = IndexPath(row: row-1, section: 0)
                    self?.travelList.insertRows(at: [indexPath], with: .automatic)
                    }
                }
            //print("Key is \(key) value is \(value)")
            }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if(segue.identifier == "backToMenu"){
                let displayVC = segue.destination as! InputKotaController
                displayVC.useremail = useremail
                }
    }
    @IBAction func btnKembali(_ sender: UIButton) {
        print("kembali")
       performSegue(withIdentifier: "backToMenu", sender: self)
//        let query = ref.queryOrdered(byChild: "user").queryEqual(toValue: useremail!)
//        query.observe(.value, with: { (snapshot) in
//            for childSnapshot in snapshot.children {
//                print(childSnapshot)
//            }
//        })
//        ref.child("tracker").observe(.value, with: { (snapshot) in
//                         let v = snapshot.value as! NSDictionary
//                         //print(v as Any)
//                         for (_,j) in v {
//                             print("j ",j)
//                             for (a,b) in j as! NSDictionary {
//                                let str_b = b as? String
//
//                                if str_b! == self.useremail! {
//                                     print("\(a) : \(b)")
//                                }
////                                 print("m ",m)
////                                 print("n ",n)
//                             }
//                         }
//                       }) { (error) in
//                         print(error.localizedDescription)
//                     }
    }
    

}

extension RiwayatController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let usergetdata2 = userdata[indexPath.row]
        let cell = travelList.dequeueReusableCell(withIdentifier: "traveldata", for: indexPath)
        if usergetdata2.user == useremail!{
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12.0)
            cell.textLabel?.text = "Kota Tujuan: \(usergetdata2.kota) - Tanggal Pergi: \(usergetdata2.tanggal)"
        }
        
        return cell
    }
    
}
