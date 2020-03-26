//
//  ViewControllerSelectGrid.swift
//  EasySketch
//
//  Created by 中尾 空 on 2017/06/25.
//  Copyright © 2017年 中尾 空. All rights reserved.
//

import UIKit

class ViewControllerSelectGrid: UIViewController {

    
    @IBOutlet weak var pickerViewSelectGrid: UIPickerView!
    
    @IBOutlet weak var imgViewSelectImg: UIImageView!
    
    var sizeList = ["Small","Medium","Large"]
    
    //グリッド分割数
    var splitShortN = 4
    
    //選択されたイメージを保持
    var pickedImage: UIImage?
    
    //画像サイズなど
    var width:CGFloat = 0
    var height:CGFloat = 0
    var scale:CGFloat = 1.0
    var screenWidth:CGFloat = 0
    var screenHeight:CGFloat = 0
    
    //OKボタン
    @IBAction func buttonOK(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueViewGridImg", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewSelectGrid.dataSource = self
        pickerViewSelectGrid.delegate = self
        
        //UIImageViewへの画像貼り付け
        self.imgViewSelectImg.image = pickedImage

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //画面遷移実行前の呼び出しメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //遷移先のビューコントローラーを取得し、インスタンス変数に受け渡すデータを設定する。
        if segue.identifier == "segueViewGridImg" {
            let nextSegue:ViewControllerViewGridImg = (segue.destination as? ViewControllerViewGridImg)!
            nextSegue.originalImage = self.pickedImage!
            nextSegue.splitShortN = self.splitShortN
        }
    }
}

extension ViewControllerSelectGrid:  UIPickerViewDataSource, UIPickerViewDelegate {
    //pickerに表示する列数を返すデータソースメソッド.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //pickerに表示する行数を返すデータソースメソッド.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sizeList.count
    }
    //pickerに表示する値を返すデリゲートメソッド.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String? {
        return sizeList[row]
    }
    
    //pickerの文字色設定
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        // 表示するラベルを生成する
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        label.textAlignment = .center
        label.text = sizeList[row]
        //label.font = UIFont(name:"Zapfino",size:16) //フォントはここで設定できる
        label.textColor = UIColor(red: 246/255, green: 229/255, blue: 141/255, alpha: 1);
        return label
    }
    //pickerが選択された際に呼ばれるデリゲートメソッド.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if sizeList[row] == "Small"{
            splitShortN = 8
        }else if sizeList[row] == "Medium"{
            splitShortN = 4
        }else if sizeList[row] == "Large"{
            splitShortN = 2
        }
    }
}
