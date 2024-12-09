
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
    Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY isPlayingChanged)

signals:
    void volumeChanged();
    void fileChanged();
    void isPlayingChanged();
    void decodingStatusChanged(QSoundEffect::Status status, QString error);

public:
    AudioEngine(QObject *parent = nullptr);

    bool isPlaying() const;
    QUrl file() const;
    void setFile(const QUrl &file);

    double volume() const;
    void setVolume(double volume);

    Q_INVOKABLE void play();

private:
    QUrl m_file;
    QSoundEffect m_soundEffect;
};
