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
        }
    }
    
    let heroImageView: UIImageView = {
        let imgView =  UIImageView()
        imgView.backgroundColor = .blue
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false

        return imgView
    }()

    let dateLabel: UILabel = {
        let lbl = UILabel()

        return lbl
    }()

    let pickerView: UIPickerView = {
        let picker = UIPickerView()

        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .clear
        return picker
    }()

    let heroImageLabel: UILabel = {
        let lbl = UILabel()

        return lbl
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


        NSLayoutConstraint.activate([

            heroImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            heroImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            heroImageView.heightAnchor.constraint(equalTo: heroImageView.widthAnchor),
            heroImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 70),

            pickerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pickerView.widthAnchor.constraint(equalTo: self.widthAnchor),
            pickerView.heightAnchor.constraint(equalToConstant: 200),
            pickerView.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 50),

            randomBttn.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            randomBttn.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 220)
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

