//
//  ViewControllerViewGridImg.swift
//  EasySketch
//
//  Created by 中尾 空 on 2017/06/26.
//  Copyright © 2017年 中尾 空. All rights reserved.
//

import UIKit
import CoreImage

class ViewControllerViewGridImg: UIViewController {
    
    @IBOutlet weak var imgViewGridImg: UIImageView!
    
    @IBOutlet weak var labelNowGrid: UILabel!
    @IBOutlet weak var labelTotalGrid: UILabel!
    
    //表示画像
    var imgClass = "Original"
    
    //表示用イメージ
    var fullImage: UIImage?
    
    //オリジナルイメージ
    var originalImage: UIImage?
    
    //CMYKイメージ
    var cyanImage: UIImage?
    var magentaImage: UIImage?
    var yellowImage: UIImage?
    var keyPlateImage: UIImage?
    
    //短辺，長辺の分割数
    var splitShortN: Int?
    var splitLongN: Int?
    
    //縦，横の分割数
    var splitWidthN: Int?
    var splitHeightN: Int?
    
    //分割総数
    var splitN: Int?
    //現在のグリッド
    var nowGrid: Int?
    //現在の行，列
    var nowRow: Int?
    var nowCol: Int?
    
    //短辺の方向（w：横，h：縦）
    var shortDirection = "w"
    
    //長辺と短辺の長さ
    var longLength:CGFloat?
    var shortLength:CGFloat?
    
    //グリッドの1辺の長さ
    var gridLength:CGFloat?
    
    //画像サイズなど
    var width:CGFloat = 0.0
    var height:CGFloat = 0.0
    var scale:CGFloat = 1.0
    var widthView:CGFloat = 0.0
    var heightView:CGFloat = 0.0

    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonGuide: UIButton!
    @IBOutlet weak var buttonColor: UIButton!
    
    @IBOutlet weak var labelRow: UILabel!
    @IBOutlet weak var labelCol: UILabel!
    
    
    @IBOutlet weak var imgViewGridView: UIImageView!
    @IBOutlet weak var imgViewGuide: UIImageView!
    @IBOutlet weak var imgViewFull: UIImageView!
    
    
    @IBAction func buttonColor(_ sender: Any) {
        if imgClass == "Original" {
            imgClass = "Mono"
            //ボタンタイトルの変更
            self.buttonColor.setTitle("Original", for: .normal)
            //表示用イメージの設定
            fullImage = keyPlateImage
        }else if imgClass == "Mono" {
            imgClass = "Original"
            //ボタンタイトルの変更
            self.buttonColor.setTitle("Mono", for: .normal)
            //表示用イメージの設定
            fullImage = originalImage
        }
        //グリッド画像の更新
        setGridImg(nowGridID: nowGrid)
        //Fullイメージの設定
        self.imgViewFull.image = fullImage
        self.imgViewFull.setNeedsDisplay()
        //ボタンの再描画
        self.buttonColor.setNeedsDisplay()
    }
    
    @IBAction func buttonFullTD(_ sender: Any) {
        //Fullイメージの表示
        self.imgViewFull.isHidden = false
        //グリッド画像を半透明に設定
        self.imgViewGridView.alpha = 0.5
        self.imgViewGuide.alpha = 0.6
        self.imgViewFull.setNeedsDisplay()
        self.imgViewGridView.setNeedsDisplay()
        self.imgViewGuide.setNeedsDisplay()
    }
    
    @IBAction func buttonFullTUI(_ sender: Any) {
        //Fullイメージの非表示
        self.imgViewFull.isHidden = true
        //グリッド画像の半透明化を解除
        self.imgViewGridView.alpha = 1.0
        self.imgViewGuide.alpha = 1.0
        self.imgViewFull.setNeedsDisplay()
        self.imgViewGridView.setNeedsDisplay()
        self.imgViewGuide.setNeedsDisplay()
    }
    
    @IBAction func buttonFullTUO(_ sender: Any) {
        //Fullイメージの非表示
        self.imgViewFull.isHidden = true
        //グリッド画像の半透明化を解除
        self.imgViewGridView.alpha = 1.0
        self.imgViewGuide.alpha = 1.0
        self.imgViewFull.setNeedsDisplay()
        self.imgViewGridView.setNeedsDisplay()
        self.imgViewGuide.setNeedsDisplay()
    }
    
    @IBAction func buttonGuide(_ sender: UIButton) {
        if self.imgViewGuide.isHidden == true {
            //ガイドを表示
            self.imgViewGuide.isHidden = false
            //グリッド画像を半透明に設定
            self.imgViewGridView.alpha = 0.7
            //ボタンタイトルの変更
            self.buttonGuide.setTitle("OFF", for: .normal)
        }else {
            //ガイドを非表示
            self.imgViewGuide.isHidden = true
            //グリッド画像の半透明化を解除
            self.imgViewGridView.alpha = 1.0
            //ボタンタイトルの変更
            self.buttonGuide.setTitle("ON", for: .normal)
        }
        // UIImageView再描画.
        self.imgViewGuide.setNeedsDisplay()
        self.imgViewGridView.setNeedsDisplay()
        //ボタンの再描画
        self.buttonGuide.setNeedsDisplay()
        
    }
    
    @IBAction func buttonBack(_ sender: UIButton) {
        self.nowGrid = self.nowGrid! - 1
        
        //現在の行列設定
        nowRow = Int((self.nowGrid!-1)/splitWidthN!) + 1
        nowCol = (self.nowGrid!-1) % splitWidthN! + 1
        labelRow.text = String(nowRow!)
        labelCol.text = String(nowCol!)
        
        //ボタンの表示・非表示設定
        if self.nowGrid! >= self.splitN! {
            self.buttonNext.isHidden = true
        }else{
            self.buttonNext.isHidden = false
        }
        self.buttonNext.setNeedsDisplay()
        if self.nowGrid! <= 1 {
            self.buttonBack.isHidden = true
        }else{
            self.buttonBack.isHidden = false
        }
        self.buttonBack.setNeedsDisplay()
        
        //ラベルへの現在のグリッド位置の反映
        self.labelNowGrid.text = String(nowGrid!)
        // ラベル再描画.
        self.labelNowGrid.setNeedsDisplay()
        //グリッド画像の表示
        self.setGridImg(nowGridID: nowGrid)
    }
    
    @IBAction func buttonNext(_ sender: UIButton) {
        self.nowGrid = self.nowGrid! + 1
        
        //現在の行列設定
        nowRow = Int((self.nowGrid!-1)/splitWidthN!) + 1
        nowCol = (self.nowGrid!-1) % splitWidthN! + 1
        labelRow.text = String(nowRow!)
        labelCol.text = String(nowCol!)
        
        //ボタンの表示・非表示設定
        if self.nowGrid! >= self.splitN! {
            self.buttonNext.isHidden = true
        }else{
            self.buttonNext.isHidden = false
        }
        self.buttonNext.setNeedsDisplay()
        if self.nowGrid! <= 1 {
            self.buttonBack.isHidden = true
        }else{
            self.buttonBack.isHidden = false
        }
        self.buttonBack.setNeedsDisplay()
        
        //ラベルへの現在のグリッド位置の反映
        self.labelNowGrid.text = String(nowGrid!)
        // ラベル再描画.
        self.labelNowGrid.setNeedsDisplay()
        //グリッド画像の表示
        self.setGridImg(nowGridID: nowGrid)
    }
    
    
    //指定したIDのグリッド画像をUIImageに設定する
    func setGridImg(nowGridID: Int?){
        
        //画像のトリミング
        let civec:CIVector = CIVector(x: CGFloat((nowGridID!-1) % splitWidthN!) * gridLength!, y: height - CGFloat(Int((nowGridID!-1)/splitWidthN!))*gridLength!-gridLength!, z: gridLength!, w: gridLength!)

        // 背景を用意
        let backImage = UIImage.image(color: .black, size: CGSize(width: gridLength!, height: gridLength!))
        //全体からグリッド画像の切り取り
        let gridImage = clipImage(inputImage: fullImage, vec: civec)
        
        // 指定された画像の大きさのコンテキストを用意.
        UIGraphicsBeginImageContext(CGSize(width: gridLength!, height: gridLength!))
        
        // コンテキストに背景画像を描画する.
        backImage.draw(in: CGRect(x: 0, y: 0, width: backImage.size.width, height: backImage.size.height))
        
        // コンテキストにグリッド画像を描画する.
        gridImage?.draw(in: CGRect(x: 0, y: 0, width: (gridImage?.size.width)!, height: (gridImage?.size.height)!))
        
        // コンテキストからUIImageを作る.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // コンテキストを閉じる.
        UIGraphicsEndImageContext()
        
        //UIImageViewへの画像の貼り付け
        self.imgViewGridImg.image = outputImage
        
        // 再描画.
        self.imgViewGridImg.setNeedsDisplay()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //表示用イメージを設定
        fullImage = originalImage
        
        //CMYKイメージを設定
        createCMYKImage()
        
        //初期画面でのbackボタンの非表示設定
        self.buttonBack.isHidden = true
        
        //ガイドの非表示
        self.imgViewGuide.isHidden = true
        
        //Fullイメージの非表示
        self.imgViewFull.isHidden = true
        //Fullイメージの設定
        self.imgViewFull.image = fullImage
        
        
        //画像サイズの取得
        width = (fullImage?.size.width)!
        height = (fullImage?.size.height)!
        
        //短辺の決定
        if width <= height {
            shortLength = width
            longLength = height
            shortDirection = "w"
        }else{
            shortLength = height
            longLength = width
            shortDirection = "h"
        }
        
        //グリッドの1辺の長さ計算
        gridLength = shortLength! / CGFloat(splitShortN!)
        
        //長辺の分割数計算
        if  CGFloat(Int(longLength! / gridLength!)) < (longLength! / gridLength!){
            splitLongN = Int(longLength! / gridLength!) + 1
        }else {
            splitLongN = Int(longLength! / gridLength!)
        }

        //縦，横の分割数を設定
        if shortDirection == "w" {
            splitWidthN = splitShortN
            splitHeightN = splitLongN
        }else{
            splitWidthN = splitLongN
            splitHeightN = splitShortN
        }
        
        //グリッド総数の計算
        splitN = splitShortN!*splitLongN!
        //ラベルへのグリッド総数の反映
        labelTotalGrid.text = String(splitN!)
        
        //現在のグリッド設定
        nowGrid = 1
        labelNowGrid.text = String(nowGrid!)
        
        //現在の行列設定
        nowRow = Int((self.nowGrid!-1)/splitWidthN!) + 1
        nowCol = (self.nowGrid!-1) % splitWidthN! + 1
        labelRow.text = String(nowRow!)
        labelCol.text = String(nowCol!)
        
        //画像の表示
        setGridImg(nowGridID: nowGrid)
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //CMYKイメージの生成
    func createCMYKImage() {
        //let invertImage = convertColorInvert(inputImage: originalImage)
        //Cyan
        //cyanImage = convertColorImage(inputImage: invertImage, r: 1.0, g: 0.0, b: 0.0, a: 1.0)
        //cyanImage = convertColorInvert(inputImage: cyanImage)
        //Magenta
        //magentaImage = convertColorImage(inputImage: invertImage,  r: 0.0, g: 1.0, b: 0.0, a: 1.0)
        //magentaImage = convertColorInvert(inputImage: magentaImage)
        //Yellow
        //yellowImage = convertColorImage(inputImage: invertImage, r: 0.0, g: 0.0, b: 1.0, a: 1.0)
        //yellowImage = convertColorInvert(inputImage: yellowImage)
        //KeyPlate
        keyPlateImage = convertMono(inputImage: originalImage)
    }
    
    //色反転画像を生成
    func convertColorInvert(inputImage: UIImage?) -> UIImage?{
        //UIImageをCIImageに変換
        let filteredImage = CIImage(image: inputImage!)
        
        //使用するフィルターを設定
        let myCIColorInvertFilter = CIFilter(name: "CIColorInvert")
        
        //フィルターのパラメーターを設定
        myCIColorInvertFilter?.setDefaults()
        myCIColorInvertFilter?.setValue(filteredImage, forKey: kCIInputImageKey)
        //画像をアウトプット
        let myCIColorInvertImage : CIImage = myCIColorInvertFilter!.outputImage!
        
        let outputUIImage: UIImage = UIImage(ciImage: myCIColorInvertImage)
        
        //イメージを描画し直す(そのままだとAspectFitが動作しないため)
        // 指定された画像の大きさのコンテキストを用意.
        UIGraphicsBeginImageContext(CGSize(width: outputUIImage.size.width, height: outputUIImage.size.height))
        // コンテキストにグリッド画像を描画する.
        outputUIImage.draw(in: CGRect(x: 0, y: 0, width: outputUIImage.size.width, height: outputUIImage.size.height))
        // コンテキストからUIImageを作る.
        let resultUIImage = UIGraphicsGetImageFromCurrentImageContext()
        // コンテキストを閉じる.
        UIGraphicsEndImageContext()
        
        return resultUIImage
    }
    
    //白黒写真を生成
    func convertMono(inputImage: UIImage?) -> UIImage?{
        //UIImageをCIImageに変換
        let filteredImage = CIImage(image: inputImage!)
        
        //使用するフィルターを設定
        let myCIPhotoEffectMonoFilter = CIFilter(name: "CIPhotoEffectMono")
        
        
        //フィルターのパラメーターを設定
        myCIPhotoEffectMonoFilter?.setDefaults()
        myCIPhotoEffectMonoFilter?.setValue(filteredImage, forKey: kCIInputImageKey)
        //画像をアウトプット
        let myCIPhotoEffectMonoImage : CIImage = myCIPhotoEffectMonoFilter!.outputImage!

        let outputUIImage: UIImage = UIImage(ciImage: myCIPhotoEffectMonoImage)
        
        //イメージを描画し直す(そのままだとAspectFitが動作しないため)
        // 指定された画像の大きさのコンテキストを用意.
        UIGraphicsBeginImageContext(CGSize(width: outputUIImage.size.width, height: outputUIImage.size.height))
        // コンテキストにグリッド画像を描画する.
        outputUIImage.draw(in: CGRect(x: 0, y: 0, width: outputUIImage.size.width, height: outputUIImage.size.height))
        // コンテキストからUIImageを作る.
        let resultUIImage = UIGraphicsGetImageFromCurrentImageContext()
        // コンテキストを閉じる.
        UIGraphicsEndImageContext()
        
        return resultUIImage
    }
    
    //指定した色だけで構成される画像を生成
    func convertColorImage(inputImage: UIImage?, r: CGFloat,g: CGFloat,b: CGFloat, a: CGFloat) -> UIImage? {
        //UIImageをCIImageに変換
        let filteredImage = CIImage(image: inputImage!)
        
        //使用するフィルターを設定
        let myCIColorMatrixFilter = CIFilter(name: "CIColorMatrix")
        
        //フィルターのパラメーターを設定
        myCIColorMatrixFilter?.setDefaults()
        myCIColorMatrixFilter?.setValue(filteredImage, forKey: kCIInputImageKey)
        myCIColorMatrixFilter?.setValue(CIVector(x:r, y:0, z:0, w:0), forKey:"inputRVector")
        myCIColorMatrixFilter?.setValue(CIVector(x:0, y:g, z:0, w:0), forKey:"inputGVector")
        myCIColorMatrixFilter?.setValue(CIVector(x:0, y:0, z:b, w:0), forKey:"inputBVector")
        myCIColorMatrixFilter?.setValue(CIVector(x:0, y:0, z:0, w:a), forKey:"inputAVector")
        myCIColorMatrixFilter?.setValue(CIVector(x:0, y:0, z:0, w:0), forKey:"inputBiasVector")

        //画像をアウトプット
        let myCIColorMatrixImage : CIImage = myCIColorMatrixFilter!.outputImage!
        
        let outputUIImage: UIImage = UIImage(ciImage: myCIColorMatrixImage)
        
        //イメージを描画し直す(そのままだとAspectFitが動作しないため)
        // 指定された画像の大きさのコンテキストを用意.
        UIGraphicsBeginImageContext(CGSize(width: outputUIImage.size.width, height: outputUIImage.size.height))
        // コンテキストにグリッド画像を描画する.
        outputUIImage.draw(in: CGRect(x: 0, y: 0, width: outputUIImage.size.width, height: outputUIImage.size.height))
        // コンテキストからUIImageを作る.
        let resultUIImage = UIGraphicsGetImageFromCurrentImageContext()
        // コンテキストを閉じる.
        UIGraphicsEndImageContext()
        
        return resultUIImage
    }
    
    
    /**
     UIImageを切り取る
     
     - parameter inputImage:切り取り対象(UIImage)
     - parameter civec:切り取る大きさと座標位置(CGRect)
     - returns: 切り取り結果(UIImage)
     */
    func clipImage(inputImage: UIImage?, vec: CIVector?) -> UIImage? {
        
        //UIImageをCIImageに変換
        let filteredImage = CIImage(image: inputImage!)
        
        // CIFilterを生成。nameにどんなを処理するのか記入.
        let myCropFilter = CIFilter(name: "CICrop")
        
        // myScaleFilterに必要なパラメータを渡していく.
        // filteredImageをInputImageとして渡す.
        myCropFilter!.setValue(filteredImage, forKey: kCIInputImageKey)
        
        // 画像のトリミングする部分の座標とサイズを渡す.
        myCropFilter!.setValue(vec, forKey: "inputRectangle")
        
        // フィルターを通した画像をアウトプット.
        let myOutputImage : CIImage = myCropFilter!.outputImage!
        
        let outputUIImage: UIImage = UIImage(ciImage: myOutputImage)
        
        //イメージを描画し直す(そのままだとAspectFitが動作しないため)
        // 指定された画像の大きさのコンテキストを用意.
        UIGraphicsBeginImageContext(CGSize(width: outputUIImage.size.width, height: outputUIImage.size.height))
        // コンテキストにグリッド画像を描画する.
        outputUIImage.draw(in: CGRect(x: 0, y: 0, width: outputUIImage.size.width, height: outputUIImage.size.height))
        // コンテキストからUIImageを作る.
        let resultUIImage = UIGraphicsGetImageFromCurrentImageContext()
        // コンテキストを閉じる.
        UIGraphicsEndImageContext()
        
        return resultUIImage
        
    }

}

extension UIImage {
    //単色画像を生成するメソッド
    static func image(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
