/**********************************************************************************************
    Copyright (C) 2017 Norbert Truchsess <norbert.truchsess@t-online.de>

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

#include "CRouterBRouterToolShell.h"

#include <QDebug>
#include <QTimer>

CRouterBRouterToolShell::CRouterBRouterToolShell(QTextBrowser* textBrowser, QWidget* parent) : IToolShell(parent) {
  setTextBrowser(textBrowser);
  connect(&cmd, &QProcess::stateChanged, this, &CRouterBRouterToolShell::slotStateChanged);
  connect(&cmd, &QProcess::errorOccurred, this, &CRouterBRouterToolShell::slotError);
}

CRouterBRouterToolShell::~CRouterBRouterToolShell() {}

void CRouterBRouterToolShell::start(const QString& dir, const QString& command, const QStringList& args) {
  isBeingKilled = false;
  isBeingStopped = false;
  stdOut("cd " + dir);
  stdOut(command + " " + args.join(" ") + "\n");
  cmd.setWorkingDirectory(dir);
  
  qDebug() << "dir:" << dir;
  qDebug() << "args:" << args;
  qDebug() << "command:" << command;

  cmd.start(command, args);
  
    qDebug() << "after cmd.start";
    
  cmd.waitForStarted();
    qDebug() << "after waitforstarted" ;
}

void CRouterBRouterToolShell::stop() {
    qDebug() << "shell::stop" << cmd.state();  
  if (cmd.state() != QProcess::NotRunning) {
    isBeingStopped = true;
#ifdef USE_KILL_FOR_SHUTDOWN
    isBeingKilled = true;
    cmd.kill();
#else
    cmd.terminate();
#endif
    cmd.waitForFinished();
  }
}

void CRouterBRouterToolShell::slotStateChanged(const QProcess::ProcessState newState) {

    qDebug() << "shell:slotstatechanged" << newState; 

  if (newState == QProcess::NotRunning && !isBeingStopped) {
    emit sigProcessError(QProcess::FailedToStart, text->toPlainText());
  }
  emit sigProcessStateChanged(newState);
}

void CRouterBRouterToolShell::slotError(const QProcess::ProcessError error) {
    
qDebug() << "shell::sloterror" << isBeingKilled << "  " << cmd.errorString();     
  if (isBeingKilled) {
    return;
  }
  emit sigProcessError(error, cmd.errorString());
}

void CRouterBRouterToolShell::finished(const int exitCode, const QProcess::ExitStatus status) {
    
qDebug() << "shell::finished:" << status;     
  if (status == QProcess::ExitStatus::NormalExit) {
    text->setTextColor(Qt::darkGreen);
    text->append(tr("!!! done !!!\n"));
  } else {
    text->setTextColor(Qt::darkRed);
    text->append(tr("!!! failed !!!\n"));
  }
}
