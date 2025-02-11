/**********************************************************************************************
    Copyright (C) 2014-2015 Oliver Eichler <oliver.eichler@gmx.de>
    Copyright (C) 2018 Norbert Truchsess <norbert.truchsess@t-online.de>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

**********************************************************************************************/

#ifndef CLINEOPADDPOINT_H
#define CLINEOPADDPOINT_H

#include "mouse/line/ILineOp.h"

class CLineOpAddPoint : public ILineOp {
 public:
  CLineOpAddPoint(SGisLine& points, CGisDraw* gis, CCanvas* canvas, IMouseEditLine* parent);
  virtual ~CLineOpAddPoint();

  void leftClick(const QPoint& pos) override;
  void mouseMove(const QPoint& pos) override;
  void rightButtonDown(const QPoint& pos) override;

  void drawFg(QPainter& p) override;

  void append();

  bool abortStep() override;

 private:
  bool addPoint = false;
  bool isPoint = false;
};

#endif  // CLINEOPADDPOINT_H
