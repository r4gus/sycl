#ifndef SUGAR_TIMER
#define SUGAR_TIMER

#include <QObject>
#include <QTimer>
#include <QTime>
#include <QString>
#include <cstdint>

enum TimerState { Idle, Work, Rest, Pause };

class Timer : public QObject
{
  Q_OBJECT

  Q_PROPERTY(QString display READ display WRITE setDisplay NOTIFY displayChanged)
  Q_PROPERTY(QString buttonText READ buttonText NOTIFY displayChanged)

public:
  Timer(QObject *parent = nullptr);
  ~Timer();

signals:
  void displayChanged();

public slots:
  void toggle();
  void reset();

private slots:
  void update();

private:
  QTimer *_timer = nullptr;
  QTime _time;
  uint16_t _rounds = 8;
  uint16_t _work = 10;
  uint16_t _pause = 5;
  QString _display;
  bool _paused = true;
  TimerState _state = Idle;
  TimerState _saved_state = Idle;

  QString _button_text[4] = {"start", "pause", "pause", "continue"};

  QString display();
  void setDisplay(QString value);

  QString buttonText();

  void time2Display();
  void toggleState();
};

#endif
