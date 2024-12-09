#include "audioengine.h"

#include <iostream>
#include <QAudioOutput>
#include <QString>

AudioEngine::AudioEngine(QObject *parent)
    : QObject(parent)
    , m_soundEffect(this)
{

    connect(&m_soundEffect, &QSoundEffect::playingChanged, this, [this]() {
        emit isPlayingChanged();
    });

    connect(&m_soundEffect, &QSoundEffect::statusChanged, this, [this]() {
        if (m_soundEffect.status() == QSoundEffect::Error)
            emit decodingStatusChanged(QSoundEffect::Error, "AudioEngine error");
        else
            emit decodingStatusChanged(m_soundEffect.status(), "");
    });
}

QUrl AudioEngine::file() const
{
    return m_file;
}

void AudioEngine::setFile(const QUrl &url)
{
    if (m_soundEffect.source() == url)
        return;

    auto resourceUrl = QUrl("qrc:/qt/qml/").resolved(url);
    qDebug() << "AudioEngine::setFile() " << resourceUrl;
    m_file = resourceUrl;
    m_soundEffect.setSource(resourceUrl);
    emit fileChanged();
}

double AudioEngine::volume() const
{
    return m_soundEffect.volume();
}

void AudioEngine::setVolume(double volume)
{
    m_soundEffect.setVolume(volume);
    emit volumeChanged();
}

void AudioEngine::play()
{
    m_soundEffect.play();
}

bool AudioEngine::isPlaying() const
{
    return m_soundEffect.isPlaying();
}
