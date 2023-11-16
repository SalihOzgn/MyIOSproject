//
//  ContentView.swift
//  firstProject
//
//  Created by Salih Özgen on 8.11.2023.
//

import SwiftUI
import Firebase
import FirebaseAuth

class FirebaseManager: NSObject {

    let auth: Auth

    static let shared = FirebaseManager()

    override init() {
        FirebaseApp.configure()

        self.auth = Auth.auth()

        super.init()
    }

}


struct ContentView: View {
    
    @State var girisSekmesi = false
    @State var eposta = ""
    @State var sifre = ""
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(spacing: 16){
                    Picker(selection: $girisSekmesi,
                        label: Text("")){
                        Text("Giriş Yap")
                            .tag(true)
                        Text("Kayıt Ol")
                            .tag(false)
                    }
                        .pickerStyle(SegmentedPickerStyle())
                    
                    if !girisSekmesi {
                        Button{
                            
                            
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                        }
                    }
                    
                    Group{
                        TextField("E-Posta", text: $eposta)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Şifre", text: $sifre)
                            .autocapitalization(.none)
                        
                    }.padding(12)
                    .background(Color.white)
                    
                    Button{
                        handleAction()
                    } label: {
                        HStack{
                            Spacer()
                            Text(girisSekmesi ? "Giriş Yap" : "Kayıt Ol")
                                .foregroundColor(.white)
                                .padding(.vertical,12)
                                .font(.system(size: 15, weight: .semibold))
                            Spacer()
                            
                        }
                        .background(Color.blue)
                        
                    }
                    Text(self.loginStatusMessage)
                        .foregroundColor(.red)

                    
                }
                .padding()
                
            }
            
            .navigationTitle(girisSekmesi ? "Giriş Yap" : "Kayıt Ol")
            .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
        }
    }
    
    private func handleAction() {
            if girisSekmesi {
                girisKullanici()
            } else {
                yeniKayit()
            }
        }
    @State var loginStatusMessage = ""
    
    private func girisKullanici() {
            FirebaseManager.shared.auth.signIn(withEmail: eposta, password: sifre) { result, err in
                if let err = err {
                    print("Kullanıcı oturum açamadı:", err)
                    self.loginStatusMessage = "Kullanıcı oturum açamadı: \(err)"
                    return
                }
                
                print("Kullanıcı olarak başarıyla oturum açıldı: \(result?.user.uid ?? "")")
                
                self.loginStatusMessage = "Kullanıcı olarak başarıyla oturum açıldı:"
            }
        }
    
   
        
        private func yeniKayit() {
            FirebaseManager.shared.auth.createUser(withEmail: eposta, password: sifre) { result, err in
                if let err = err {
                    print("kullanıcı oluşturulamadı:", err)
                    self.loginStatusMessage = "kullanıcı oluşturulamadı: \(err)"
                    return
                }
                
                print("Kullanıcı başarıyla oluşturuldu: \(result?.user.uid ?? "")")
                
                self.loginStatusMessage = "Kullanıcı başarıyla oluşturuldu:"
            }
        }
    
}



#Preview {
    ContentView()
}
