//
//  LJMainVC.swift
//  LejunChatSdk
//
//  Created by lejun on 2023/2/10.
//

import UIKit
import IQKeyboardManagerSwift
import HyphenateChat

public class LJMainVC: LJSDKBaseVC{
    let window = UIApplication.shared.currentWindow

    public override func viewDidLoad() {
        super.viewDidLoad()
        //首次安装请求rsa公钥秘钥
        if((UserDefaults.standard.object(forKey: "rsaPublicKey")) == nil){
            LJNetworkManager.request(.getRsaKey, completion: { [self]result in
                guard let dataDic = result["data"] as? [String : Any] else { return }
                guard let customNum = dataDic["customNum"] as? Int else { return }
                guard let content = dataDic["content"] as? String else { return }
                guard let content2 = dataDic["content2"] as? String else { return }
                
                let index1 = content.index(content.startIndex, offsetBy: 0)
                let index2 = content.index(content.startIndex, offsetBy: 50)
                let index3 = content.index(content.startIndex, offsetBy: 50+customNum)
                let index4 = content.index(content.startIndex, offsetBy: content.count-customNum)
                let index5 = content2.index(content2.startIndex, offsetBy: 0)
                let index6 = content2.index(content2.startIndex, offsetBy: 50)
                let index7 = content2.index(content2.startIndex, offsetBy: 50+customNum)
                let index8 = content2.index(content2.startIndex, offsetBy: content2.count-customNum-50)
                let index9 = content2.index(content2.startIndex, offsetBy: content2.count-50)
                let index10 = content2.index(content2.startIndex, offsetBy: content2.count)
                let indexRange1 = index1..<index2
                let indexRange2 = index3..<index4
                let indexRange3 = index5..<index6
                let indexRange4 = index7..<index8
                let indexRange5 = index9..<index10
                let puk = content[indexRange1] + content[indexRange2]
                let prk = content2[indexRange3] + content2[indexRange4] + content2[indexRange5]
                UserDefaults.standard.setValue(puk, forKey: "rsaPublicKey")
                UserDefaults.standard.setValue(prk, forKey: "rsaPrivacyKey")
                LJSDKTools.shared.rsaPrivacyKey = "\(prk)"
                LJSDKTools.shared.rsaPublicKey = "\(puk)"

                self.requestConfigInfo()
            })
        }else{
            LJSDKTools.shared.rsaPublicKey = UserDefaults.standard.object(forKey: "rsaPublicKey") as? String
            LJSDKTools.shared.rsaPrivacyKey = UserDefaults.standard.object(forKey: "rsaPrivacyKey") as? String

            requestConfigInfo()
        }

        //输入设置
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    /**
     初始化sdk参数接口
     urlStr 接口域名
     pkgName 包名
     appversion 版本号
     privacyUrl 隐私链接
     terms 用户协议
     */
    public func initBaseInfo(urlStr:String,pkgName:String,appversion:String,privacyUrlStr:String,terms:String){
        urlBase = urlStr
       packageName = pkgName
        appVer = appversion
        privacyUrl = privacyUrlStr
        termUrl = terms
    }
    func requestConfigInfo() {
        //获取声网环信等配置
        LJNetworkManager.request(.getCToken) { dic in
            LJSDKTools.saveConfig(data: dic)
            //环信初始化
            let options = EMOptions(appkey: LJSDKTools.shared.tokenCon.emKey)
            let error = EMClient.shared().initializeSDK(with: options)
            if error == nil {
                print("环信初始化成功")
                //登录环信
                EMClient.shared().login(withUsername:String(format: "%d", LJSDKUserTool.shared.data.id), password: String(format: "%d", LJSDKUserTool.shared.data.id)) { str, erroe in
                    if erroe == nil {
                        print("环信登录成功")
                    }
                }
            }
        }
        //请求config信息
        LJNetworkManager.request(.getConfigInfo) { result in
            //保存config信息
            configInfo = configData.deserialize(from: result) ?? configData()
            self.selectGo()
        }
    }
    func selectGo() {
        if UserDefaults.standard.value(forKey: "UserData") == nil {
            //跳转登录
            let navigationController = LJBaseNC(rootViewController: LoginVC())
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }else{
            LJSDKTools.shared.tokenCon = LJSDKTools.getTokenConfig()
            //初始化用户信息
            LJSDKUserTool.shared.data = LJSDKUserTool.shared.userInfo()

            //跳转主页
            let tabbarContraller = LJTabbarVC()
            window?.rootViewController = tabbarContraller
            window?.makeKeyAndVisible()
        }
    }
}
