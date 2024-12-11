#include <QStringList>
#include <QDirIterator>

#include "audiofilesmodel.h"


QStringList AudioFilesModel::getModel() {
    QStringList files;
    auto iterator = QDirIterator(":/qt/qml/Sounds", QDirIterator::Subdirectories);
    while (iterator.hasNext()) {
        auto next = iterator.next();
        files.append(next.split(":/qt/qml/Sounds/").last());
    }
    qDebug() << "Files: " << files;
    return files;
}