
#include <QObject>
#include <QSoundEffect>
#include <QtQml>
#include <QFile>
#include <QMediaPlayer>

class AudioEngine : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(double volume READ volume WRITE setVolume NOTIFY volumeChanged)
    Q_PROPERTY(QUrl file READ file WRITE setFile NOTIFY fileChanged)

signals:
    void volumeChanged();
    void fileChanged();

public:
    AudioEngine(QObject *parent = nullptr);

    QUrl file() const;
    void setFile(const QUrl &file);

    double volume() const;
    void setVolume(double volume);

    Q_INVOKABLE void play();

private:
    QSoundEffect m_effect;
};
