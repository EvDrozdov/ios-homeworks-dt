//
//  NetworkService.swift
//  Navigation
//
//  Created by Евгений Дроздов on 06.04.2023.
//

import UIKit

// Для обращения в сеть по адресу
struct NetworkService {

    static func request(for configuration: AppConfiguration) {

        // создаем сессию по умолчанию
        let session = URLSession(configuration: .default)

        // создаем строку подключения
        let url = URL(string: configuration.rawValue)

        // создаем задание
        let task = session.dataTask(with: url!) { data, response, error in

            // Обрабатываем ошибку
            if let error = error {
                print(error.localizedDescription)
            }

            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if statusCode != 200 {
                print("There's error with data, error code is \(String(describing: statusCode))")
            } else {
                print("Current status is \(String(describing: statusCode!))")
                if let httpField = (response as? HTTPURLResponse)?.allHeaderFields["HTTP"] as? String {
                    print("Current fileds for HTTP is", httpField )
                } else {
                    print("Current fileds for HTTP is nil")
                }

                if let contentTypeAnswer = (response as? HTTPURLResponse)?.allHeaderFields["Content-Type"] as? String {
                    print("Current fileds for Content-Type is", contentTypeAnswer)
                } else {
                    print("Current fileds for Content-Type is nil")
                }

                if let varyAnswer = (response as? HTTPURLResponse)?.allHeaderFields["Vary"] as? String {
                    print("Current fileds for Vary is", varyAnswer)
                } else {
                    print("Current fileds for Vary is nil")
                }

                if let allowAnswer = (response as? HTTPURLResponse)?.allHeaderFields["Allow"] as? String {
                    print("Current fileds for Allow is", allowAnswer)
                } else {
                    print("Current fileds for Allow is nil")
                }
            }

            if data == nil {
                print("There's nothing to show")
                return
            } else {
                print(data!.description)
            }

            do {
                if let answer = try JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                    // ловим ответ и парсим
                    // для примера распарсил первое поле тк оно есть у всех трех ссылок
                    // по сути в задании это не требуется
                    let name = answer["name"] as? String ?? ""
                    print("Name is ", name)
                }
            } catch {
                print("Поймана ошибка при попытке парса данных", error.localizedDescription)
            }

        }

        task.resume()

    }

}

// Перечисление делаем для значений URL
// Чтобы можно было выбрать рандомно кейс из него
// Добавим протокол CaseIterable
enum AppConfiguration: String, CaseIterable {

    case people = "https://swapi.dev/api/people/8"
    case starship = "https://swapi.dev/api/starships/3"
    case planets = "https://swapi.dev/api/planets/5"

}
