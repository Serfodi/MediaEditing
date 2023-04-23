//
//  ColorGridView.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 11.02.2023.
//

import UIKit

class ColorGridCollectionView: UIView {

    private let colomns = 12
    private let rows = 10
    
    var delegate: ColorObserver?
    
    open  var colorSelected: UIColor!
    private var currectCell: UICollectionViewCell!
    private var currentIndex: Int = 0
    
    private lazy var selectedShape: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.cornerRadius = 3
        layer.borderWidth = 3
        layer.borderColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    private var colors:[UIColor] = [
        #colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 1), #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1), #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1), #colorLiteral(red: 0.7607843137, green: 0.7607843137, blue: 0.7607843137, alpha: 1), #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1), #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1), #colorLiteral(red: 0.5215686275, green: 0.5215686275, blue: 0.5215686275, alpha: 1), #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1), #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1), #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
        #colorLiteral(red: 0, green: 0.2156862745, blue: 0.2901960784, alpha: 1), #colorLiteral(red: 0.003921568627, green: 0.1137254902, blue: 0.3411764706, alpha: 1), #colorLiteral(red: 0.06666666667, green: 0.01960784314, blue: 0.231372549, alpha: 1), #colorLiteral(red: 0.1803921569, green: 0.02352941176, blue: 0.2392156863, alpha: 1), #colorLiteral(red: 0.2352941176, green: 0.02745098039, blue: 0.1058823529, alpha: 1), #colorLiteral(red: 0.3292624354, green: 0.06439865381, blue: 0.02518202178, alpha: 1), #colorLiteral(red: 0.3212789893, green: 0.1268104315, blue: 0.0379873924, alpha: 1), #colorLiteral(red: 0.3261604905, green: 0.2079723477, blue: 0.04811631888, alpha: 1), #colorLiteral(red: 0.337254902, green: 0.2392156863, blue: 0, alpha: 1), #colorLiteral(red: 0.4, green: 0.3803921569, blue: 0, alpha: 1), #colorLiteral(red: 0.3098039216, green: 0.3333333333, blue: 0.01568627451, alpha: 1), #colorLiteral(red: 0.1490196078, green: 0.2431372549, blue: 0.05882352941, alpha: 1),
        #colorLiteral(red: 0.03529411765, green: 0.3019607843, blue: 0.3960784314, alpha: 1), #colorLiteral(red: 0.003921568627, green: 0.1843137255, blue: 0.4823529412, alpha: 1), #colorLiteral(red: 0.1019607843, green: 0.03921568627, blue: 0.3215686275, alpha: 1), #colorLiteral(red: 0.2705882353, green: 0.05098039216, blue: 0.3490196078, alpha: 1), #colorLiteral(red: 0.3657478094, green: 0.0203652028, blue: 0.160736382, alpha: 1), #colorLiteral(red: 0.4724475145, green: 0.1169847921, blue: 0.05323061347, alpha: 1), #colorLiteral(red: 0.4383948445, green: 0.182257086, blue: 0.06508079916, alpha: 1), #colorLiteral(red: 0.4485075474, green: 0.2972510457, blue: 0.08463353664, alpha: 1), #colorLiteral(red: 0.4705882353, green: 0.3450980392, blue: 0, alpha: 1), #colorLiteral(red: 0.5529411765, green: 0.5254901961, blue: 0.007843137255, alpha: 1), #colorLiteral(red: 0.4352941176, green: 0.462745098, blue: 0.03921568627, alpha: 1), #colorLiteral(red: 0.2196078431, green: 0.3411764706, blue: 0.1019607843, alpha: 1),
        #colorLiteral(red: 0.003921568627, green: 0.431372549, blue: 0.5607843137, alpha: 1), #colorLiteral(red: 0, green: 0.2588235294, blue: 0.662745098, alpha: 1), #colorLiteral(red: 0.1725490196, green: 0.03529411765, blue: 0.4666666667, alpha: 1), #colorLiteral(red: 0.3803921569, green: 0.09411764706, blue: 0.4862745098, alpha: 1), #colorLiteral(red: 0.4745098039, green: 0.1019607843, blue: 0.2392156863, alpha: 1), #colorLiteral(red: 0.6496662498, green: 0.1740418971, blue: 0.08905411512, alpha: 1), #colorLiteral(red: 0.622621119, green: 0.2668551803, blue: 0.1010958329, alpha: 1), #colorLiteral(red: 0.612551868, green: 0.4092473388, blue: 0.1351820827, alpha: 1), #colorLiteral(red: 0.6509803922, green: 0.4823529412, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.768627451, green: 0.737254902, blue: 0, alpha: 1), #colorLiteral(red: 0.6078431373, green: 0.6470588235, blue: 0.05490196078, alpha: 1), #colorLiteral(red: 0.3058823529, green: 0.4784313725, blue: 0.1529411765, alpha: 1),
        #colorLiteral(red: 0, green: 0.5490196078, blue: 0.7058823529, alpha: 1), #colorLiteral(red: 0, green: 0.337254902, blue: 0.8392156863, alpha: 1), #colorLiteral(red: 0.2156862745, green: 0.1019607843, blue: 0.5803921569, alpha: 1), #colorLiteral(red: 0.4784313725, green: 0.1294117647, blue: 0.6196078431, alpha: 1), #colorLiteral(red: 0.6, green: 0.1411764706, blue: 0.3098039216, alpha: 1), #colorLiteral(red: 0.8141828179, green: 0.2280823588, blue: 0.1274922788, alpha: 1), #colorLiteral(red: 0.7813404202, green: 0.3449985683, blue: 0.13587749, alpha: 1), #colorLiteral(red: 0.756283462, green: 0.5056830645, blue: 0.1735594273, alpha: 1), #colorLiteral(red: 0.8196078431, green: 0.6156862745, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.9607843137, green: 0.9254901961, blue: 0, alpha: 1), #colorLiteral(red: 0.7647058824, green: 0.8196078431, blue: 0.09019607843, alpha: 1), #colorLiteral(red: 0.4, green: 0.6156862745, blue: 0.2039215686, alpha: 1),
        #colorLiteral(red: 0, green: 0.631372549, blue: 0.8470588235, alpha: 1), #colorLiteral(red: 0, green: 0.3803921569, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0.3019607843, green: 0.1333333333, blue: 0.6980392157, alpha: 1), #colorLiteral(red: 0.5960784314, green: 0.1647058824, blue: 0.737254902, alpha: 1), #colorLiteral(red: 0.7254901961, green: 0.1764705882, blue: 0.3647058824, alpha: 1), #colorLiteral(red: 0.9213342071, green: 0.3150518239, blue: 0.1814081669, alpha: 1), #colorLiteral(red: 0.9163795114, green: 0.4473246932, blue: 0.1747939885, alpha: 1), #colorLiteral(red: 1, green: 0.6517165303, blue: 0, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.7803921569, blue: 0, alpha: 1), #colorLiteral(red: 0.9960784314, green: 0.9843137255, blue: 0.2549019608, alpha: 1), #colorLiteral(red: 0.8509803922, green: 0.9254901961, blue: 0.2156862745, alpha: 1), #colorLiteral(red: 0.462745098, green: 0.7333333333, blue: 0.2509803922, alpha: 1),
        #colorLiteral(red: 0.003921568627, green: 0.7803921569, blue: 0.9882352941, alpha: 1), #colorLiteral(red: 0.2274509804, green: 0.5294117647, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0.368627451, green: 0.1882352941, blue: 0.9254901961, alpha: 1), #colorLiteral(red: 0.7450980392, green: 0.2196078431, blue: 0.9529411765, alpha: 1), #colorLiteral(red: 0.9019607843, green: 0.231372549, blue: 0.4784313725, alpha: 1), #colorLiteral(red: 0.9273056388, green: 0.4229363203, blue: 0.3504679799, alpha: 1), #colorLiteral(red: 0.9166810513, green: 0.5370097756, blue: 0.3275729418, alpha: 1), #colorLiteral(red: 0.9960784314, green: 0.7058823529, blue: 0.2470588235, alpha: 1), #colorLiteral(red: 0.9960784314, green: 0.7960784314, blue: 0.2431372549, alpha: 1), #colorLiteral(red: 1, green: 0.968627451, blue: 0.4196078431, alpha: 1), #colorLiteral(red: 0.8941176471, green: 0.937254902, blue: 0.3960784314, alpha: 1), #colorLiteral(red: 0.5882352941, green: 0.8274509804, blue: 0.3725490196, alpha: 1),
        #colorLiteral(red: 0.3215686275, green: 0.8392156863, blue: 0.9882352941, alpha: 1), #colorLiteral(red: 0.4549019608, green: 0.6549019608, blue: 1, alpha: 1), #colorLiteral(red: 0.5254901961, green: 0.3098039216, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0.8274509804, green: 0.3411764706, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0.9333333333, green: 0.4431372549, blue: 0.6196078431, alpha: 1), #colorLiteral(red: 0.9397694468, green: 0.5718345642, blue: 0.5271473527, alpha: 1), #colorLiteral(red: 0.9178009629, green: 0.6410546303, blue: 0.498691678, alpha: 1), #colorLiteral(red: 1, green: 0.7803921569, blue: 0.4666666667, alpha: 1), #colorLiteral(red: 1, green: 0.8509803922, blue: 0.4666666667, alpha: 1), #colorLiteral(red: 1, green: 0.9764705882, blue: 0.5803921569, alpha: 1), #colorLiteral(red: 0.9176470588, green: 0.9490196078, blue: 0.5607843137, alpha: 1), #colorLiteral(red: 0.6941176471, green: 0.8666666667, blue: 0.5450980392, alpha: 1),
        #colorLiteral(red: 0.5764705882, green: 0.8901960784, blue: 0.9921568627, alpha: 1), #colorLiteral(red: 0.6549019608, green: 0.7764705882, blue: 1, alpha: 1), #colorLiteral(red: 0.6941176471, green: 0.5490196078, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0.8862745098, green: 0.5725490196, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0.9568627451, green: 0.6431372549, blue: 0.7529411765, alpha: 1), #colorLiteral(red: 0.9566883445, green: 0.7204198837, blue: 0.6944581866, alpha: 1), #colorLiteral(red: 0.9533202052, green: 0.7707510591, blue: 0.6769109368, alpha: 1), #colorLiteral(red: 1, green: 0.8509803922, blue: 0.6588235294, alpha: 1), #colorLiteral(red: 0.9960784314, green: 0.8941176471, blue: 0.6588235294, alpha: 1), #colorLiteral(red: 1, green: 0.9843137255, blue: 0.7254901961, alpha: 1), #colorLiteral(red: 0.9490196078, green: 0.968627451, blue: 0.7176470588, alpha: 1), #colorLiteral(red: 0.8039215686, green: 0.9098039216, blue: 0.7098039216, alpha: 1),
        #colorLiteral(red: 0.7960784314, green: 0.9411764706, blue: 1, alpha: 1), #colorLiteral(red: 0.8274509804, green: 0.8862745098, blue: 1, alpha: 1), #colorLiteral(red: 0.8509803922, green: 0.7882352941, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0.937254902, green: 0.7921568627, blue: 1, alpha: 1), #colorLiteral(red: 0.9764705882, green: 0.8274509804, blue: 0.8784313725, alpha: 1), #colorLiteral(red: 0.974947989, green: 0.8628550172, blue: 0.8517926335, alpha: 1), #colorLiteral(red: 0.9748728871, green: 0.8877756, blue: 0.841044724, alpha: 1), #colorLiteral(red: 1, green: 0.9254901961, blue: 0.831372549, alpha: 1), #colorLiteral(red: 1, green: 0.9490196078, blue: 0.8352941176, alpha: 1), #colorLiteral(red: 0.9960784314, green: 0.9882352941, blue: 0.8666666667, alpha: 1), #colorLiteral(red: 0.968627451, green: 0.9803921569, blue: 0.8588235294, alpha: 1), #colorLiteral(red: 0.8745098039, green: 0.9333333333, blue: 0.831372549, alpha: 1)
    ]
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK:  draw
    
    override func draw(_ rect: CGRect) {
        setupView()
        layer.addSublayer(selectedShape)
    }
    
    
    // MARK:  - setup
    
    private func setup() {
//        colorsSurse()
        
        if let color = colorSelected {
            colorSelected = color
        } else {
            colorSelected = colors[0]
        }
    }
    
    
    // MARK:  - setup Veiw
    
    private func setupView() {
        backgroundColor = .clear
        layer.cornerRadius = 10
        
//        translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            topAnchor.constraint(equalTo: superview!.topAnchor,  constant: 16),
//            bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: -12),
//            leadingAnchor.constraint(equalTo: superview!.leadingAnchor,  constant: 0),
//            rightAnchor.constraint(equalTo: superview!.rightAnchor),
//        ])
        
        let layout = UICollectionViewFlowLayout()
        let width = (frame.width / CGFloat(colomns)).rounded()
        let height = (frame.height / CGFloat(rows)).rounded()
        layout.itemSize = CGSize(width: width, height: height)
        
        let newSize = CGSize(width: width * CGFloat(colomns), height: height * CGFloat(rows))
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: CGRect(origin: .zero, size: newSize), collectionViewLayout: layout)
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        
        collection.layer.cornerRadius = 10
        collection.backgroundColor = .clear
        
        collection.dataSource = self
        collection.delegate = self
        
        addSubview(collection)
        
        collection.clipsToBounds = true
    }
    
    
    
    // MARK: color arrray
    
//    private func colorsSurse() {
//        for row in 0..<rows {
//            for colomn in 0..<colomns {
//                switch row {
//                case 0:
//                    let brightness = 1.0 / Double(colomns - 1) * CGFloat(colomn)
//                    let color = UIColor(hue: 0, saturation: 0, brightness: 1 - brightness, alpha: 1)
//                    colors.append(color)
//                case 2:
//                    let step = 9.0
//
//                case 1..<rows:
//                    let step = 360.0 / CGFloat(colomns)
//                    let hue = (4.0 + step * CGFloat(colomn)) / 360
//                    let saturation = 0.95
//                    let lightness = 1.0 / CGFloat(rows) * CGFloat(row)
//                    let color = UIColor(hue: hue, saturation: saturation, lightness: lightness, alpha: 1)
//                    colors.append(color)
//                default: return
//                }
//
//            }
//        }
//    }
    
}


// MARK: - UICollectionViewDataSource

extension ColorGridCollectionView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if indexPath.row == currentIndex { selectedShape.frame = cell.frame }
        cell.backgroundColor = colors[indexPath.row]
        
        return cell
    }
    
}


// MARK: - UICollectionViewDelegate

extension ColorGridCollectionView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        selectedShape.frame = cell!.frame
        currectCell = cell
        colorSelected = colors[indexPath.row]
        delegate?.colorChanged(colorSelected)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
