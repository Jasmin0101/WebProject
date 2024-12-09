import 'dart:math';

import 'package:flutter/material.dart';

class ResultWidget extends StatelessWidget {
  final int summerCount;
  final int autumnCount;
  final int winterCount;
  final int springCount;

  const ResultWidget({
    super.key,
    required this.summerCount,
    required this.autumnCount,
    required this.winterCount,
    required this.springCount,
  });

  @override
  Widget build(BuildContext context) {
    int maxValue =
        max(autumnCount, max(springCount, max(winterCount, summerCount)));

    Widget descriptionText(String text) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      );
    }

    Widget adaptiveImage(String assetPath) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (summerCount == maxValue) ...[
              adaptiveImage('assets/img/summer.png'),
              descriptionText(
                'Вы — человек лета, полон света и энергии. 🌞🌞 \n Свободолюбивый и активный, вы всегда готовы к приключениям и новым впечатлениям. \n 🍉 Ваш энтузиазм заряжает окружающих, а ваша любовь к жизни подобна солнечным дням, которые хочется наслаждаться в полной мере. \n Вы дарите людям тепло и позитив, словно летний солнечный день. 😎😎',
              ),
            ] else if (autumnCount == maxValue) ...[
              adaptiveImage('assets/img/fall.png'),
              descriptionText(
                'Вы — настоящий ценитель уюта и тёплых моментов, романтик, который видит красоту в каждом листопаде 🍂🍁. \n Ваша душа отзывается на мягкие оттенки и тишину осени, наполняя вас теплом даже в прохладные дни 😸. \n Вы умеете наслаждаться простыми радостями и привносить в мир вокруг атмосферу уюта и покоя. 🎃',
              ),
            ] else if (winterCount == maxValue) ...[
              adaptiveImage('assets/img/winter.png'),
              descriptionText(
                'Ваше сердце принадлежит зиме — времени волшебства и праздников.☃️❄️ \n Вы любите уютный дом и радость зимних встреч, цените традиции и моменты, которые сближают.😊\n В вас чувствуется сила и теплота, как у сияющего огонька среди снегов. Вы приносите с собой ощущение спокойствия и веру в чудеса.🎆🎇',
              ),
            ] else if (springCount == maxValue) ...[
              adaptiveImage('assets/img/spring.png'),
              descriptionText(
                'Вы — человек весны, обновления и новых возможностей. 🌸🌼\n Открытый миру и всему, что он может предложить, вы заряжаете окружающих энергией и верой в лучшее. 😸\n Ваша душа, как весенний росток, всегда стремится к новым начинаниям и процветанию. Вы приносите людям чувство радости и свежести, как весенний ветер.🍃',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
