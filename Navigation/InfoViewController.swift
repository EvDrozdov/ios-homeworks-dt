//
//  InfoViewController.swift
//  Navigation
//
//  Created by Евгений Дроздов on 30.08.2022.
//

import UIKit

class InfoViewController: UIViewController {

//    private lazy var termsOfUseButton: UIButton = {
//            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
//            button.backgroundColor = .green
//            button.setTitle("Правила", for: .normal)
//            button.addTarget(self, action: #selector(self.didTapTermsOfUseButton), for: .touchUpInside)
//            return button
//        }()
    
    private lazy var labelForAPIFieldTitle: UILabel = {
            let label = UILabel()
            label.text = "Загружаю текст ..."
            label.numberOfLines = 0
            label.textAlignment = .center
            label.textColor = .gray
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        private lazy var labelForAPIFieldOrbitalPeriod: UILabel = {
            let label = UILabel()
            label.text = "Загружаю текст ..."
            label.numberOfLines = 0
            label.textAlignment = .center
            label.textColor = .gray
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupView()
            setupLabelForAPIFieldTitle()
            setupLabelForAPIFieldOrbitalPeriod()
            
            
            //            self.view.addSubview(self.termsOfUseButton)
            //            self.termsOfUseButton.center = self.view.center
        }
    
    private func setupView(){
            
            view.backgroundColor = .white
            view.addSubview(labelForAPIFieldTitle)
            view.addSubview(labelForAPIFieldOrbitalPeriod)
            NSLayoutConstraint.activate([
                labelForAPIFieldTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                labelForAPIFieldTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                labelForAPIFieldTitle.widthAnchor.constraint(equalToConstant: view.bounds.width/2),
                labelForAPIFieldTitle.heightAnchor.constraint(equalToConstant: view.bounds.height/10),
                
                labelForAPIFieldOrbitalPeriod.topAnchor.constraint(equalTo: labelForAPIFieldTitle.bottomAnchor, constant: 10),
                labelForAPIFieldOrbitalPeriod.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                labelForAPIFieldOrbitalPeriod.widthAnchor.constraint(equalToConstant: view.bounds.width/2),
                labelForAPIFieldOrbitalPeriod.heightAnchor.constraint(equalToConstant: view.bounds.height/10)
            ])
            
        }
    
    private func setupLabelForAPIFieldTitle(){
            
            // Вызываем обращение к API, задача 1 , Домашнее задание 2
            NetworkService.requestAnotherAPI(for: "https://jsonplaceholder.typicode.com/todos/10") { titleValue in
                DispatchQueue.main.async {
                    self.labelForAPIFieldTitle.text = "Значение поля - \(titleValue!)"
                    self.labelForAPIFieldTitle.textColor = .black
                }
            }
            
        }
        
        private func setupLabelForAPIFieldOrbitalPeriod(){
            
            // Вызываем обращение к API, задача 2 , Домашнее задание 2
            NetworkService.requestPlanetAPI(for: "https://swapi.dev/api/planets/1") { orbitalPeriod in
                
                DispatchQueue.main.async {
                    self.labelForAPIFieldOrbitalPeriod.text = "Период обращения планеты Татуин вокруг своей звезды \(orbitalPeriod!)"
                    self.labelForAPIFieldOrbitalPeriod.textColor = .black
                }
            }
        }
    
        
        @objc private func didTapTermsOfUseButton() {
            
            let alertController = UIAlertController(title: "Правила пользования", message: "Никуда нельзя нажимать", preferredStyle: .actionSheet)
            let firstAction = UIAlertAction(title: "Принимаю", style: .default) { _ in
                print("Принимаю")
            }
            let secondAction = UIAlertAction(title: "Не принимаю", style: .destructive) { _ in
                print("Не принимаю")
            }
           
            alertController.addAction(firstAction)
            alertController.addAction(secondAction)
            self.present(alertController, animated: true)

        }
}
