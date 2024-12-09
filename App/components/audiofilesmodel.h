#include <QObject>
#include <QtQml>
#include <QStringList>

class AudioFilesModel : public QObject
{
    Q_OBJECT
    QML_ELEMENT

public:
    Q_INVOKABLE QStringList getModel();
};
