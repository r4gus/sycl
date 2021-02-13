/*
 * Copyright (C) 2021  David P. Sugar
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * sycl is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef SUGAR_TIMER
#define SUGAR_TIMER

#include <QObject>
#include <QTimer>
#include <QTime>
#include <QString>
#include <QVariant>
#include <cstdint>

enum TimerState { Idle, Work, Rest, Pause };

class Timer : public QObject
{
  Q_OBJECT

  Q_PROPERTY(QString display READ display WRITE setDisplay NOTIFY displayChanged)
  Q_PROPERTY(QString buttonText READ buttonText NOTIFY displayChanged)
  Q_PROPERTY(QString laps READ laps NOTIFY displayChanged)
  Q_PROPERTY(float progress READ progress NOTIFY displayChanged)

public:
  Timer(QObject *parent = nullptr);
  ~Timer();
  Q_INVOKABLE void set_on_time(qint32 minutes, qint32 seconds);
  Q_INVOKABLE void set_off_time(qint32 minutes, qint32 seconds);

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
  uint16_t _rounds_up = 0;
  uint32_t _work = 10;
  uint32_t _pause = 5;
  QString _display;
  TimerState _state = Idle;
  TimerState _saved_state = Idle;
  uint16_t _seconds_up = 0;

  QString _button_text[4] = {"start", "pause", "pause", "continue"};

  QString display();
  void setDisplay(QString value);
  QString buttonText();
  QString laps();
  float progress();

  void time2Display();
  void toggleState();
  QTime parse_seconds(uint32_t t);
};

#endif
