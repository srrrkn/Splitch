//
//  ViewController.swift
//  EasySketch
//
//  Created by 中尾 空 on 2017/06/19.
//  Copyright © 2017年 中尾 空. All rights reserved.
//

import UIKit
import AssetsLibrary
import Photos

class ViewController: UIViewController{
    
    //選択されたイメージを保存するためのインスタンス変数
    var pickedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //startボタンを押した時
    @IBAction func start(_ sender: UIButton) {
        
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
    
        // フォトライブラリを使用できるか確認
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            // フォトライブラリの画像・写真選択画面を表示
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
            
        } else {
            print("フォトライブラリが使えません")
        }
        
    }
    
    //画面遷移実行前の呼び出しメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //遷移先のビューコントローラーを取得し、インスタンス変数に受け渡すデータを設定する。
        let nextSegue:ViewControllerSelectGrid = (segue.destination as? ViewControllerSelectGrid)!
        nextSegue.pickedImage = self.pickedImage!
    }
    
    //画面戻る用
    @IBAction func backToFirst(segue: UIStoryboardSegue) {
    }

}

extension ViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    //画像選択メソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        // 選択された画像
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            //取得したイメージを描画し直す(CGRectがimageOrientationを無視するのを防ぐため)
            // 指定された画像の大きさのコンテキストを用意.
            UIGraphicsBeginImageContext(CGSize(width: image.size.width, height: image.size.height))
            // コンテキストにグリッド画像を描画する.
            image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            // コンテキストからUIImageを作る.
            let outputImage = UIGraphicsGetImageFromCurrentImageContext()
            // コンテキストを閉じる.
            UIGraphicsEndImageContext()
            self.pickedImage = outputImage
            //写真選択画面を閉じて，グリッド選択画面へ移動
            self.dismiss(animated: true){
                self.performSegue(withIdentifier: "segueSelectGrid", sender: nil)
            }
        }else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
