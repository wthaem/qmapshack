/**********************************************************************************************
    Copyright (C) 2014 Oliver Eichler <oliver.eichler@gmx.de>

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

#ifndef CSELECTCOPYACTION_H
#define CSELECTCOPYACTION_H

#include <QDialog>

#include "ui_ISelectCopyAction.h"

class IGisItem;
class IGisProject;

class CSelectCopyAction : public QDialog, private Ui::ISelectCopyAction {
  Q_OBJECT
 public:
  CSelectCopyAction(const IGisItem* src, const IGisItem* tar, QWidget* parent);
  CSelectCopyAction(const IGisProject* src, const IGisProject* tar, QWidget* parent);
  virtual ~CSelectCopyAction();

  enum result_e { eResultNone, eResultCopy, eResultSkip, eResultClone };

  result_e getResult() { return result; }
  bool allOthersToo();

 private slots:
  void slotSelectResult(CSelectCopyAction::result_e r);

 private:
  result_e result = eResultNone;
};

#endif  // CSELECTCOPYACTION_H
