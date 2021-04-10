//
//  PostList.swift
//  MyCryptoPortfolio
//
//  Created by Connor Boothe on 12/25/20.
//

import SwiftUI
import URLImage
import NavigationKit
struct PostList: View {
    @Binding public var assets:KeyValuePairs<String, Double>
    @Binding public var assetsArray:Array<Coin>;
    @Binding public var portfolio_value:Double;
    @Binding public var user:User;
    @Binding public var login:Bool;
    @State public var value_string:String = "";

    var body: some View {
        
       
            VStack {
                HStack{
                    Text(String(self.user.first_name) + " " + String(self.user.last_name))
                        .font(.system(size: 15)).padding(20)
                    Button(action: {
                        // What to perform
                        self.login = false;
                        self.user = User(first_name: "", last_name:"", email: "",
                                         password: "")
                    }) {
                           Text("Logout")
                    }.font(.system(size: 15))
                    .frame(width: 60, height: 20)
                    .foregroundColor(Color.white)
                    .background(Color.red)
                    .cornerRadius(3)
                }
                Text("$"+(self.value_string))
                    .font(.system(size: 30)).padding(0)
                Spacer()
                Text("Portfolio value")
                    .font(.system(size: 13))
                    .foregroundColor(Color.gray)
                
                Spacer()
                Spacer()
                Button(action: {
                    // What to perform
                    var _: () = API().getAssets(assets: self.assets) { coinArray in ()
                        self.portfolio_value = 0;
                        self.assetsArray = coinArray;
                        for (coin) in self.assetsArray {
                            self.portfolio_value += (coin.price * coin.amount)
                            
                        }
                        self.value_string = API().formatPrice(price: String(self.portfolio_value))
                        
                    };
                    API().getAllUsers() { user in ()
                        self.user = user;
                    }
                }) {
                    // How the button looks like
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 20))
                        .foregroundColor(Color.gray)
                        .padding(5)
                }
                List {
                    ForEach (0..<self.assetsArray.count, id: \.self)  {i in
                        NavigationLink(destination: SingleCoinView(coin: self.$assetsArray[i],
                                    assets: self.$assets, portfolio_value: self.$portfolio_value)){
                        HStack{
                            URLImage(url: self.assetsArray[i].image) { image in
                                image
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .aspectRatio(1, contentMode: .fit)
                                    
                            }
                            VStack(alignment: .leading) {
                                Text(String(self.assetsArray[i].name))
                                    .font(.system(size: 16))
                                Text(String(self.assetsArray[i].ticker)).font(.system(size: 13))
                                    .foregroundColor(Color.gray)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("$"+API().formatPrice(price:String(self.assetsArray[i].price)))
                                .font(.system(size: 15))
                                Text(String(self.assetsArray[i].amount)).foregroundColor(Color.gray)
                                    .font(.system(size: 13))
                            }
                           
                        }
                        .padding(20)
                        .padding(.trailing, 30)
                    }
                    }
                    NavigationLink(destination: AddCoin(portfolio_value: self.$portfolio_value,
                                                assetsArray: self.$assetsArray, assets: self.$assets)){
                        Text("Add Asset")
                    }.buttonStyle(PlainButtonStyle())

                  
                }.onAppear{
                    var _: () = API().getAssets(assets: self.assets) { coinArray in ()
                        self.portfolio_value = 0;
                        self.assetsArray = coinArray;
                        for (coin) in self.assetsArray {
                            self.portfolio_value += (coin.price * coin.amount)
                        }
                    self.value_string = API().formatPrice(price: String(self.portfolio_value))
                        
                    };
                }
                Spacer()
               
            }   .navigationBarTitle("Back")
            .navigationBarHidden(true)
     
       
        }

    
}

