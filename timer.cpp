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

#include "timer.h"

Timer::Timer(QObject *parent)
  : QObject(parent)
{
  _timer = new QTimer(this);
  connect(_timer, &QTimer::timeout, this, &Timer::update);

  _time = QTime(0, 0, _work, 0);
  time2Display();
}

Timer::~Timer()
{
  delete _timer;
  _timer = nullptr;
}

void Timer::update()
{
  if (_time <= QTime(0, 0, 0, 0)) {
    toggleState();
  } else {
    _time = _time.addSecs(-1);
    _seconds_up += 1;
    time2Display();
  }
}

QString Timer::display()
{
  return _display;
}

void Timer::setDisplay(QString value)
{
  _display = value;
}

QString Timer::buttonText()
{
  return _button_text[_state];
}

QString Timer::laps()
{
  return QString("%1 / %2").arg(QString::number(_rounds_up), QString::number(_rounds));
}

// Progress value between 0.0 (0%) and 360.0 (100%)
float Timer::progress() {
  return static_cast<float>(_rounds_up * (_work + _pause) + _seconds_up) / static_cast<float>(_rounds * (_work + _pause)) * 360.0;
}

/// Set the given _time as _display text.
void Timer::time2Display()
{
  _display = _time.toString("mm:ss");
  emit displayChanged();
}

void Timer::toggleState()
{
  if (_state == Work) {
    _state = Rest;
    _time = QTime(0, 0, _pause, 0);
  } else if (_state == Rest) {
    _rounds_up += 1;
    _seconds_up = 0;

    if (_rounds_up == _rounds) { // workout complete
      _state = Idle;
      _rounds_up = 0;
      _timer->stop();
    } else { // next round
      _state = Work;
    }

    _time = QTime(0, 0, _work, 0);
  }

  time2Display();
}

void Timer::toggle()
{
  if (_state == Idle) {
    _state = Work; // start
    _timer->start(1000); // set 1s interval
  } else if (_state == Pause) {
    _state = _saved_state; // continue
    _timer->start();
  } else { // Work or Rest
    _timer->stop();
    _saved_state = _state; // pause
    _state = Pause;
  }

  emit displayChanged();
}

void Timer::reset()
{

}
