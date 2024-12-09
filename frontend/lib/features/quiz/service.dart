final class QuizService {
  static List<Question> generateQuiz() {
    return [
      Question(
        title: 'Что бы вы предпочли ?',
        answers: [
          Answer(
              text: 'Прогуляться по лесу, собирая яркие осенние листья.',
              types: [AnswerType.autumn]),
          Answer(
              text: ' Кататься на санках или коньках на замёрзшем озере.',
              types: [AnswerType.winter]),
          Answer(
              text: 'Прогуляться в парке, наслаждаясь цветением деревьев.',
              types: [AnswerType.spring]),
          Answer(
              text: ' Провести день на пляже, загорая и купаясь в море.',
              types: [AnswerType.summer]),
        ],
      ),
      Question(
        title: "Какое время препровождение вам больше по душе?",
        answers: [
          Answer(
              text:
                  'Завернуться в плед с чашкой горячего чая и хорошей книгой.',
              types: [AnswerType.autumn]),
          Answer(
              text: 'Печь имбирное печенье и украшать его глазурью.',
              types: [AnswerType.winter]),
          Answer(
              text: ' Ухаживать за садом, сажать цветы и зелень.',
              types: [AnswerType.spring]),
          Answer(
              text: 'Путешествовать и открывать новые места.',
              types: [AnswerType.summer]),
        ],
      ),
      Question(
        title: "Вы больше?",
        answers: [
          Answer(
              text: 'Человек, который любит солнце, море и свободу.',
              types: [AnswerType.summer]),
          Answer(
              text: 'Любитель пробуждения природы и новых начинаний.',
              types: [AnswerType.spring]),
          Answer(
              text: 'Человек, который любит зимние праздники и снег.',
              types: [AnswerType.winter]),
          Answer(
              text: ' Любитель тёплых уютных вечеров.',
              types: [AnswerType.autumn]),
        ],
      ),
      Question(
        title: "Ваш любимый праздник?",
        answers: [
          Answer(
              text: 'Хэллоуин: свечи, тыквы, мистическая атмосфера.',
              types: [AnswerType.autumn]),
          Answer(
              text: 'Новый год: фейерверки, елка и атмосфера волшебства.',
              types: [AnswerType.winter]),
          Answer(
              text:
                  'Пасха: светлый праздник, свежие краски и атмосфера обновления.',
              types: [AnswerType.spring]),
          Answer(
              text: 'День Ивана Купалы: яркие костры и веселье на природе.',
              types: [AnswerType.summer]),
        ],
      ),
      Question(
        title: "Выберете цвет",
        answers: [
          Answer(
              text: ' Терракотовый, напоминающий осенние листья.',
              types: [AnswerType.autumn]),
          Answer(text: 'Белый, как первый снег', types: [AnswerType.winter]),
          Answer(
              text: 'Нежно-зелёный, как свежая листва.',
              types: [AnswerType.spring]),
          Answer(text: 'Ярко-синий, как море.', types: [AnswerType.summer]),
        ],
      ),
      Question(
        title:
            "Планы отменились и у вас неожиданно появилось много свободного времени, ваши действия?",
        answers: [
          Answer(
              text:
                  'Устрою вечер кино с любимыми фильмами и горячим шоколадом.',
              types: [AnswerType.autumn]),
          Answer(
              text:
                  'Устрою день для себя: тёплый плед, чай с корицей и почитаю захватывающую книгу.',
              types: [AnswerType.winter]),
          Answer(
              text: 'Выйду на свежий воздух и устрою пикник на траве.',
              types: [AnswerType.spring]),
          Answer(
              text:
                  'Устрою активный отдых: поездка на природу или велосипедная прогулка.',
              types: [AnswerType.summer]),
        ],
      ),
      Question(
        title: "Какую погоду вы предпочитаете?",
        answers: [
          Answer(
            text: ' Жаркий, солнечный день',
            types: [AnswerType.summer],
          ),
          Answer(
            text: ' Тёплый солнечный день',
            types: [AnswerType.spring],
          ),
          Answer(
            text: ' Снежный день, когда на улице всё белое и искрится.',
            types: [AnswerType.winter],
          ),
          Answer(
            text:
                'Прохладный, но солнечный день, когда можно накинуть любимый свитер.',
            types: [AnswerType.autumn],
          ),
        ],
      )
    ];
  }
}

class Question {
  final String title;
  final List<Answer> answers;

  Question({
    required this.title,
    required this.answers,
  });
}

class Answer {
  final String text;
  final List<AnswerType> types;

  Answer({
    required this.text,
    required this.types,
  });
}

enum AnswerType {
  winter,
  summer,
  autumn,
  spring;
}
