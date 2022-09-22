//
//  MainView.swift
//  RandomArt_APIPractice
//
//  Created by David Chester on 9/17/22.
//

import UIKit



class MainView: UIView {

    //TODO: Add in properties to update a label for the artist and the other artmodel property
    var artInfo: ArtModel? {
        didSet {
            heroImageView.image = artInfo?.heroImage
            artistLabel.text = artInfo?.artistName
            titleLabel.text = artInfo?.titleOfPiece
        }
    }
    
    let heroImageView: UIImageView = {
        let imgView =  UIImageView()
        //imgView.backgroundColor = .blue
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFit
        imgView.layer.cornerRadius = 20
        imgView.layer.masksToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false

        return imgView
    }()

    let artistLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.font = UIFont(name: "futura", size: 12)
        lbl.translatesAutoresizingMaskIntoConstraints = false

        return lbl
    }()

    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.font = UIFont(name: "futura", size: 14)
        lbl.translatesAutoresizingMaskIntoConstraints = false

        return lbl
    }()

    let pickerView: UIPickerView = {
        let picker = UIPickerView()

        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .clear
        return picker
    }()

    var randomBttn: UIButton = {
        let bttn = UIButton(type: .custom)
        let config = UIImage.SymbolConfiguration(pointSize: 40)

        bttn.clipsToBounds = true
        bttn.contentMode = .scaleAspectFill
        bttn.setImage(UIImage(systemName: "play.square.fill", withConfiguration: config), for: .normal)


        bttn.translatesAutoresizingMaskIntoConstraints = false
        bttn.setTitle("Random", for: .normal)
        return bttn
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(){
        self.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(heroImageView)
        self.addSubview(pickerView)
        self.addSubview(randomBttn)
        self.addSubview(artistLabel)
        self.addSubview(titleLabel)

        NSLayoutConstraint.activate([

            heroImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            heroImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            heroImageView.heightAnchor.constraint(equalTo: heroImageView.widthAnchor),
            heroImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),

            titleLabel.trailingAnchor.constraint(equalTo: heroImageView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 10),
            titleLabel.widthAnchor.constraint(equalTo: heroImageView.widthAnchor),

            artistLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            artistLabel.widthAnchor.constraint(equalTo: titleLabel.widthAnchor),

            pickerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pickerView.widthAnchor.constraint(equalTo: self.widthAnchor),
            pickerView.heightAnchor.constraint(equalToConstant: 200),
            pickerView.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 50),

            randomBttn.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            randomBttn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40)
        ])
   }
}

extension UIImage {
    func load(urlString : String) -> UIImage? {
        guard let url = URL(string: urlString)else {
            return nil
        }

        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                     return image
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}

