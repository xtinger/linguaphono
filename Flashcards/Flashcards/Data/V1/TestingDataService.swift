//
//  DataService.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class TestingDataService : IDataService{
    
    var cards: [CardModel] = []
    var currentCardIndex :Int = 0
    
    required init() {
    }
    
    func prepare(completion: PrepareCompletion?) {
        cards = [
            CardModel(id: 1, textEng: "Thank you very much", textRu: "Большое спасибо", corrects: 0, incorrects: 0),
            CardModel(id: 2, textEng: "Nice to meet you", textRu: "Приятно познакомиться", corrects: 0, incorrects: 0),
            CardModel(id: 3, textEng: "I'm glad to see you again", textRu: "Рад Вас снова видеть", corrects: 0, incorrects: 0),
            CardModel(id: 4, textEng: "I am married", textRu: "Я женат (замужем)", corrects: 0, incorrects: 0),
            CardModel(id: 5, textEng: "Let me introduce you to my husband (wife)", textRu: "Позвольте представить Вас моему мужу (моей жене)", corrects: 0, incorrects: 0),
            CardModel(id: 6, textEng: "Please give my kind regards to your mother", textRu: "Передавайте наилучшие пожелания от меня Вашей матери", corrects: 0, incorrects: 0),
            CardModel(id: 7, textEng: "See you soon", textRu: "До скорой встречи", corrects: 0, incorrects: 0),
            CardModel(id: 8, textEng: "See you later", textRu: "До встречи", corrects: 0, incorrects: 0),
            CardModel(id: 9, textEng: "I'm looking forward to seeing you again", textRu: "С нетерпением жду нашей следующей встречи", corrects: 0, incorrects: 0),
            CardModel(id: 10, textEng: "Will you be free tomorrow?", textRu: "Вы завтра свободны?", corrects: 0, incorrects: 0),
            CardModel(id: 11, textEng: "Would you like to come with me?", textRu: "Хотите пойти со мной?", corrects: 0, incorrects: 0),
            CardModel(id: 12, textEng: "Let me be your guide.", textRu: "Позвольте мне быть Вашим гидом.", corrects: 0, incorrects: 0),
            CardModel(id: 13, textEng: "Won't you go shopping with me?", textRu: "Пойдете со мной за покупками?", corrects: 0, incorrects: 0),
            CardModel(id: 14, textEng: "Let's go swimming.", textRu: "Пойдемте купаться.", corrects: 0, incorrects: 0),
            CardModel(id: 15, textEng: "Would you care for something to eat?", textRu: "Не хотите чего-нибудь поесть?", corrects: 0, incorrects: 0),
            CardModel(id: 16, textEng: "That sounds good", textRu: "Звучит неплохо", corrects: 0, incorrects: 0),
            CardModel(id: 17, textEng: "May I offer you a drink?", textRu: "Позвольте предложить вам что-нибудь выпить", corrects: 0, incorrects: 0),
            CardModel(id: 18, textEng: "How about a drink?", textRu: "Хотите чего-нибудь выпить?", corrects: 0, incorrects: 0),
            CardModel(id: 19, textEng: "Cheers!", textRu: "Ваше здоровье!", corrects: 0, incorrects: 0),
            CardModel(id: 20, textEng: "Let's take a coffee break.", textRu: "Не пора ли попить кофейку?", corrects: 0, incorrects: 0),
            CardModel(id: 21, textEng: "I'd like another cup of coffee.", textRu: "Еще чашечку кофе, пожалуйста.", corrects: 0, incorrects: 0),
            CardModel(id: 22, textEng: "Make yourself at home.", textRu: "Чувствуйте себя как дома", corrects: 0, incorrects: 0),
            CardModel(id: 23, textEng: "Let's go fifty-fifty on the bill", textRu: "Давайте платить пополам", corrects: 0, incorrects: 0),
            CardModel(id: 24, textEng: "You have wonderful taste in clothes", textRu: "У Вас великолепный вкус в одежде", corrects: 0, incorrects: 0),
            CardModel(id: 25, textEng: "What a charming girl you are!", textRu: "Какая ты очаровательная девушка!", corrects: 0, incorrects: 0),
            CardModel(id: 26, textEng: "Thank you for your compliment", textRu: "Спасибо за комплимент", corrects: 0, incorrects: 0),
            CardModel(id: 27, textEng: "Thank you for a nice day", textRu: "Спасибо за прекрасный день", corrects: 0, incorrects: 0),
            CardModel(id: 28, textEng: "Thank you for picking me up", textRu: "Спасибо, что встретили меня (зашли за мной)", corrects: 0, incorrects: 0),
            CardModel(id: 29, textEng: "That's very kind of you", textRu: "Очень любезно с Вашей стороны", corrects: 0, incorrects: 0),
            CardModel(id: 30, textEng: "You're very generous", textRu: "Вы очень добры", corrects: 0, incorrects: 0),
            CardModel(id: 31, textEng: "I'm really grateful to you", textRu: "Я очень Вам благодарен", corrects: 0, incorrects: 0),
            CardModel(id: 32, textEng: "Much obliged", textRu: "Весьма признателен", corrects: 0, incorrects: 0),
            CardModel(id: 33, textEng: "I'm very much obliged to you", textRu: "Я очень Вам обязан", corrects: 0, incorrects: 0),
            CardModel(id: 34, textEng: "Just a minute please", textRu: "Подождите минуту, пожалуйста", corrects: 0, incorrects: 0),
            CardModel(id: 35, textEng: "That's my fault", textRu: "Это моя вина", corrects: 0, incorrects: 0),
            CardModel(id: 36, textEng: "It was careless of me", textRu: "Я был неосторожен", corrects: 0, incorrects: 0),
            CardModel(id: 37, textEng: "I didn't mean that", textRu: "Я не хотел Вас обидеть", corrects: 0, incorrects: 0),
            CardModel(id: 38, textEng: "Next time I'll get it right", textRu: "В следующий раз постараюсь", corrects: 0, incorrects: 0),
            CardModel(id: 39, textEng: "I'm sorry for being late", textRu: "Извините за опоздание", corrects: 0, incorrects: 0),
            CardModel(id: 40, textEng: "Am I disturbing you?", textRu: "Я не помешаю?", corrects: 0, incorrects: 0),
            CardModel(id: 41, textEng: "Never mind", textRu: "Ничего (Не беспокойтесь, не беда, неважно)", corrects: 0, incorrects: 0),
            CardModel(id: 42, textEng: "Say it once more please", textRu: "Повторите, пожалуйста", corrects: 0, incorrects: 0),
            CardModel(id: 43, textEng: "Please speak more slowly", textRu: "Пожалуйста, говорите немного медленнее.", corrects: 0, incorrects: 0),
            CardModel(id: 44, textEng: "Please hurry up", textRu: "Пожалуйста, поторопитесь", corrects: 0, incorrects: 0),
            CardModel(id: 45, textEng: "Come with me!", textRu: "Пойдемте со мной!", corrects: 0, incorrects: 0),
            CardModel(id: 46, textEng: "Please call a doctor", textRu: "Пожалуйста, вызовите врача", corrects: 0, incorrects: 0),
            CardModel(id: 47, textEng: "Can you lend me...?", textRu: "Не одолжите...?", corrects: 0, incorrects: 0),
            CardModel(id: 48, textEng: "Will you do me a favor?", textRu: "Сделайте одолжение.", corrects: 0, incorrects: 0),
            CardModel(id: 49, textEng: "May I take a look at it?", textRu: "Можно взглянуть?", corrects: 0, incorrects: 0),
            CardModel(id: 50, textEng: "Can I borrow your pen?", textRu: "Можно одолжить Вашу ручку?", corrects: 0, incorrects: 0),
            CardModel(id: 51, textEng: "Would you please help me carry this?", textRu: "Помогите донести, пожалуйста.", corrects: 0, incorrects: 0),
            CardModel(id: 52, textEng: "Could you give me a hand with these parcels?", textRu: "Пожалуйста, помогите мне с этими пакетами.", corrects: 0, incorrects: 0),
            CardModel(id: 53, textEng: "Will you please mail this letter for me?", textRu: "Не отправите ли за меня письмо?", corrects: 0, incorrects: 0),
            CardModel(id: 54, textEng: "Will you help me with this problem?", textRu: "Помогите мне с этой проблемой", corrects: 0, incorrects: 0),
            CardModel(id: 55, textEng: "May I have your address?", textRu: "Можно узнать Ваш адрес?", corrects: 0, incorrects: 0),
            CardModel(id: 56, textEng: "Could you drop me downtown, please?", textRu: "Не подбросите до центра?", corrects: 0, incorrects: 0),
            CardModel(id: 57, textEng: "What's this?", textRu: "Что это?", corrects: 0, incorrects: 0),
            CardModel(id: 58, textEng: "Where is the restroom?", textRu: "Где туалет?", corrects: 0, incorrects: 0),
            CardModel(id: 59, textEng: "The sooner the better", textRu: "Чем скорее, тем лучше", corrects: 0, incorrects: 0),
            CardModel(id: 60, textEng: "I'm not sure", textRu: "Я не уверен", corrects: 0, incorrects: 0),
            CardModel(id: 61, textEng: "I don't think so", textRu: "Не думаю", corrects: 0, incorrects: 0),
            CardModel(id: 62, textEng: "I'm afraid not", textRu: "Боюсь, что нет", corrects: 0, incorrects: 0),
            CardModel(id: 63, textEng: "You must be kidding", textRu: "Вы, должно быть, шутите!", corrects: 0, incorrects: 0),
            CardModel(id: 64, textEng: "How long will it take to walk over there?", textRu: "Сколько времени идти туда пешком?", corrects: 0, incorrects: 0),
            CardModel(id: 65, textEng: "It's getting foggy", textRu: "Опускается туман", corrects: 0, incorrects: 0),
            CardModel(id: 66, textEng: "The sky is clearing up", textRu: "Небо расчищается", corrects: 0, incorrects: 0),
            CardModel(id: 67, textEng: "What a nasty day!", textRu: "Какой ужасный день!", corrects: 0, incorrects: 0),
            CardModel(id: 68, textEng: "I wonder if there will be a storm?", textRu: "Интересно, будет гроза?", corrects: 0, incorrects: 0),
            CardModel(id: 69, textEng: "Are there any good restaurants around here?", textRu: "Здесь есть поблизости хороший ресторан?    ", corrects: 0, incorrects: 0),
            CardModel(id: 70, textEng: "Can you recommend a good place to eat?", textRu: "Вы можете порекомендовать хороший ресторан?", corrects: 0, incorrects: 0),
            CardModel(id: 71, textEng: "Some place not too expensive.", textRu: "Что-нибудь, где не слишком дорого.", corrects: 0, incorrects: 0),
            CardModel(id: 72, textEng: "I would like a table for two", textRu: "Мне нужен стол на двоих", corrects: 0, incorrects: 0),
            CardModel(id: 73, textEng: "Do you have a table by the window?", textRu: "У вас есть столик у окна?", corrects: 0, incorrects: 0),
            CardModel(id: 74, textEng: "Please show me the wine list.", textRu: "Карту вин, пожалуйста", corrects: 0, incorrects: 0),
            CardModel(id: 75, textEng: "I would like a cup of coffee (tea)", textRu: "Я бы хотел чашку кофе (чая)", corrects: 0, incorrects: 0),
            CardModel(id: 76, textEng: "May I have a glass of water?", textRu: "Можно попросить стакан воды?", corrects: 0, incorrects: 0),
            CardModel(id: 77, textEng: "Would you please pass the salt?", textRu: "Передайте, пожалуйста, соль.", corrects: 0, incorrects: 0),
            CardModel(id: 78, textEng: "How does it taste?", textRu: "Это вкусно?", corrects: 0, incorrects: 0),
            CardModel(id: 79, textEng: "It was delicious.", textRu: "Было очень вкусно.", corrects: 0, incorrects: 0),
            CardModel(id: 80, textEng: "Would you please hurry?", textRu: "Поторопитесь, пожалуйста.", corrects: 0, incorrects: 0),
            CardModel(id: 81, textEng: "My order hasn't come yet.", textRu: "Мой заказ еще не принесли.", corrects: 0, incorrects: 0),
            CardModel(id: 82, textEng: "It is too spicy", textRu: "Слишком много специй", corrects: 0, incorrects: 0),
            CardModel(id: 83, textEng: "Bill, please", textRu: "Счет, пожалуйста", corrects: 0, incorrects: 0),
            CardModel(id: 84, textEng: "Check, please", textRu: "Чек, пожалуйста", corrects: 0, incorrects: 0),
            CardModel(id: 85, textEng: "How much do I owe you?", textRu: "Сколько я Вам должен?", corrects: 0, incorrects: 0),
            CardModel(id: 86, textEng: "Does the bill include the service charge?", textRu: "Плата за обслуживание включена в счет?", corrects: 0, incorrects: 0),
            CardModel(id: 87, textEng: "Let's split the bill.", textRu: "Давайте заплатим поровну", corrects: 0, incorrects: 0),
            CardModel(id: 88, textEng: "We are paying separately", textRu: "Мы платим отдельно", corrects: 0, incorrects: 0),
            CardModel(id: 89, textEng: "Let me pay my share", textRu: "Позвольте мне заплатить мою долю.", corrects: 0, incorrects: 0),
            CardModel(id: 90, textEng: "Keep the change, please.", textRu: "Сдачи не надо.", corrects: 0, incorrects: 0),
            CardModel(id: 91, textEng: "What is the exchange rate for dollars?", textRu: "Какой обменный курс доллара?", corrects: 0, incorrects: 0),
            CardModel(id: 92, textEng: "The price is not reasonable", textRu: "Цена неоправданно велика", corrects: 0, incorrects: 0),
            CardModel(id: 93, textEng: "Where is the nearest exchange office?", textRu: "Где находится ближайший обменный пункт?", corrects: 0, incorrects: 0),
            CardModel(id: 94, textEng: "Can you give me a cash discount?", textRu: "Вы можете дать мне скидку за расчет наличными?", corrects: 0, incorrects: 0),
            CardModel(id: 95, textEng: "You gave me the wrong change", textRu: "Вы неправильно дали мне сдачу.", corrects: 0, incorrects: 0),
            CardModel(id: 96, textEng: "Can I try on this dress?", textRu: "Могу я примерить это платье?", corrects: 0, incorrects: 0),
            CardModel(id: 97, textEng: "Can I get a discount?", textRu: "Могу я получить скидку?", corrects: 0, incorrects: 0),
            CardModel(id: 98, textEng: "Can I buy it on installment?", textRu: "Можно купить это в рассрочку?", corrects: 0, incorrects: 0),
            CardModel(id: 99, textEng: "We need an interpreter", textRu: "Нам нужен переводчик", corrects: 0, incorrects: 0),
            CardModel(id: 100, textEng: "I quite understand you", textRu: "Я вполне понимаю Вас", corrects: 0, incorrects: 0)
        ]
        
        completion?()
    }
}

