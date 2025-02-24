//
//  LotteryViewController.swift
//  Lottery
//
//  Created by 조우현 on 2/24/25.
//

import UIKit
import SnapKit

final class LotteryViewController: UIViewController {
    
    let pickerTextField = UITextField()
    let pickerView = UIPickerView()
    let infoLabel = UILabel()
    let dateLabel = UILabel()
    let dividerView = UIView()
    let resultLabel = UILabel()
    let ObservableNetworkingButton = UIButton()
    let SingleNetworkingButton = UIButton()
    let plusLabel = UILabel()
    let bonusLabel = UILabel()
    var pickerItems: [Int] = Array(1...1154)
    
    let firstNumLabel = UILabel()
    let secondNumLabel = UILabel()
    let thirdNumLabel = UILabel()
    let fourthNumLabel = UILabel()
    let fifthNumLabel = UILabel()
    let sixthNumLabel = UILabel()
    let bonusNumLabel = UILabel()
    
    lazy var labelList = [firstNumLabel, secondNumLabel, thirdNumLabel, fourthNumLabel, fifthNumLabel, sixthNumLabel, bonusNumLabel]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        
        pickerTextFieldConfig()
    }

    func configureHierarchy() {
        view.addSubview(pickerTextField)
        view.addSubview(infoLabel)
        view.addSubview(dateLabel)
        view.addSubview(dividerView)
        view.addSubview(resultLabel)
        view.addSubview(ObservableNetworkingButton)
        view.addSubview(SingleNetworkingButton)
        [firstNumLabel, secondNumLabel, thirdNumLabel, fourthNumLabel, fifthNumLabel, sixthNumLabel, bonusNumLabel, plusLabel, bonusLabel].forEach {
            view.addSubview($0)
        }
    }
    
    func configureLayout() {
        pickerTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view).inset(24)
            make.height.equalTo(44)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(pickerTextField.snp.bottom).offset(24)
            make.leading.equalTo(view).offset(24)
            make.height.equalTo(17)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(pickerTextField.snp.bottom).offset(24)
            make.trailing.equalTo(view).offset(-24)
            make.height.equalTo(17)
        }
        
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view).inset(24)
            make.height.equalTo(1)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        firstNumLabel.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(24)
            make.leading.equalTo(view).offset(24)
            make.size.equalTo(40)
        }
        
        numberLayout(secondNumLabel, from: firstNumLabel)
        numberLayout(thirdNumLabel, from: secondNumLabel)
        numberLayout(fourthNumLabel, from: thirdNumLabel)
        numberLayout(fifthNumLabel, from: fourthNumLabel)
        numberLayout(sixthNumLabel, from: fifthNumLabel)
        
        bonusNumLabel.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(24)
            make.trailing.equalTo(view).offset(-24)
            make.size.equalTo(40)
        }
        
        plusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bonusNumLabel.snp.centerY)
            make.trailing.equalTo(bonusNumLabel.snp.leading).offset(-10)
        }
        
        bonusLabel.snp.makeConstraints { make in
            make.top.equalTo(bonusNumLabel.snp.bottom).offset(4)
            make.centerX.equalTo(bonusNumLabel.snp.centerX)
        }
        
        ObservableNetworkingButton.snp.makeConstraints { make in
            make.top.equalTo(bonusLabel.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        SingleNetworkingButton.snp.makeConstraints { make in
            make.top.equalTo(bonusLabel.snp.bottom).offset(50)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        pickerTextField.textAlignment = .center
        pickerTextField.borderStyle = .roundedRect
        pickerTextField.placeholder = "원하는 회차를 선택하세요"
        pickerTextField.tintColor = .clear
        
        infoLabel.text = "당첨번호 안내"
        infoLabel.font = .systemFont(ofSize: 14)
        
        dateLabel.text = "- 추첨"
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .gray
        
        dividerView.backgroundColor = .systemGray5
        
        resultLabel.text = "000회 당첨결과"
        resultLabel.font = .systemFont(ofSize: 25, weight: .bold)
        resultLabel.textColor = .orange
        resultLabel.attributedText = resultLabel.text?.resultLabelTextAttribute()
        
        for item in labelList {
            numberDesign(item, number: 0)
        }
        
        plusLabel.text = "+"
        plusLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        bonusLabel.text = "보너스"
        bonusLabel.font = .systemFont(ofSize: 12)
        bonusLabel.textColor = .gray
        
        ObservableNetworkingButton.setTitle("Observable", for: .normal)
        ObservableNetworkingButton.setTitleColor(.systemBlue, for: .normal)
        ObservableNetworkingButton.addTarget(self, action: #selector(observableNetworkingButtonTapped), for: .touchUpInside)
        
        SingleNetworkingButton.setTitle("Single", for: .normal)
        SingleNetworkingButton.setTitleColor(.systemBlue, for: .normal)
        SingleNetworkingButton.addTarget(self, action: #selector(singleNetworkingButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func observableNetworkingButtonTapped() {
        // Observable로 네트워킹
        print(#function)
    }
    
    @objc
    func singleNetworkingButtonTapped() {
        // Single로 네트워킹
        print(#function)
    }
    
    func numberBackground(_ number: Int) -> UIColor {
        switch number {
        case 1...10:
            return .lotteryYellow
        case 11...20:
            return .lotteryBlue
        case 21...30:
            return .lotteryRed
        default:
            return .lotteryGray
        }
    }
    
    func numberLayout(_ currentLabel: UILabel, from: UILabel) {
        currentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(from.snp.centerY)
            make.leading.equalTo(from.snp.trailing).offset(8)
            make.size.equalTo(40)
        }
    }
    
    func numberDesign(_ label: UILabel, number: Int) {
        label.text = "\(number)"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = numberBackground(number)
        DispatchQueue.main.async {
            label.layer.cornerRadius = label.frame.height / 2
            label.clipsToBounds = true
        }
    }
    
    func pickerTextFieldConfig() {
        pickerTextField.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
    }
}

extension LotteryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerItems.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let rowItem = pickerItems.reversed()[row]
        return String(rowItem)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let rowItem = pickerItems.reversed()[row]
        pickerTextField.text = "\(rowItem)회"
        
//        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(rowItem)"
//        AF.request(url, method: .get).responseDecodable(of: Lottery.self) { [self] response in
//            switch response.result {
//            case .success(let value):
//                // dateLabel, resultLabel, numberLabel
//                let labelList = [firstNumLabel: value.drwtNo1, secondNumLabel: value.drwtNo2, thirdNumLabel: value.drwtNo3, fourthNumLabel: value.drwtNo4, fifthNumLabel: value.drwtNo5, sixthNumLabel: value.drwtNo6, bonusNumLabel: value.bnusNo]
//                
//                self.dateLabel.text = "\(value.drwNoDate) 추첨"
//                self.resultLabel.text = "\(value.drwNo)회 당첨결과"
//                self.resultLabel.attributedText = resultLabel.text?.resultLabelTextAttribute()
//                for item in labelList {
//                    numberDesign(item.key, number: item.value)
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
}
