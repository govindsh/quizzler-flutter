import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'quiz_brain.dart';

void main() => runApp(Quizzler());

QuizBrain quizBrain = new QuizBrain();

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade900,
          title: Text('World\'s Toughest Quiz'),
        ),
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Flexible> scoreKeeper = [];
  int correctAnswers = 0;
  int wrongAnswers = 0;

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getCorrectAnswer();

    setState(() {
      if (quizBrain.isFinished()) {
        trackScore(userPickedAnswer, correctAnswer);
        Alert(
          context: context,
          type: returnAlertType(),
          title: "QUIZ OVER",
          desc: displayMessage(returnAlertType()),
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();

        quizBrain.reset();
        scoreKeeper.clear();
        correctAnswers = 0;
        wrongAnswers = 0;
      } else {
        trackScore(userPickedAnswer, correctAnswer);
        quizBrain.nextQuestion();
      }
    });
  }

  AlertType returnAlertType() {
    double percent = (correctAnswers / quizBrain.getTotalQuestionsCount()) * 100;
    if(percent > 90) {
      return AlertType.success;
    } else {
      return AlertType.error;
    }
  }

  String displayMessage(AlertType alert) {
    double percent = (correctAnswers / quizBrain.getTotalQuestionsCount()) * 100;
    if (alert == AlertType.error) {
      return "Fail. You may try again.\nTotal Questions - "+
          (quizBrain.getTotalQuestionsCount()).toString() +
          "\nWrong Answers - $wrongAnswers\nPercentage - " + percent.toStringAsFixed(2);
    } else if (alert == AlertType.success) {
      return "You passed\nTotal Questions - "+
          (quizBrain.getTotalQuestionsCount()).toString() +
          "\nWrong Answers - $wrongAnswers\nPercentage - " + percent.toStringAsFixed(2);
    }
  }

  void trackScore(bool userPickedAnswer, bool correctAnswer) {
    if (userPickedAnswer == correctAnswer) {
      scoreKeeper.add(Flexible(
        fit: FlexFit.loose,
        child: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ));
      correctAnswers++;
      print('Bingo, its correct');
    } else {
      scoreKeeper.add(Flexible(
        fit: FlexFit.loose,
        child: Icon(
          Icons.close,
          color: Colors.red,
        ),
      ));
      wrongAnswers++;
      print('Wrong answer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                //The user picked true.
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                checkAnswer(false);
              },
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        )
      ],
    );
  }
}