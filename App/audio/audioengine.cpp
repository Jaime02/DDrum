#include "audioengine.h"

#include <iostream>
#include <QAudioOutput>

AudioEngine::AudioEngine(QObject *parent)
    : QObject(parent)
    , m_effect(this)
{
    auto checkSoundEffectStatus = [this]() {
        if (m_effect.status() == QSoundEffect::Error)
            qCritical() << "AudioEngine error";
    };

    connect(&m_effect, &QSoundEffect::statusChanged, this, checkSoundEffectStatus);
}

QUrl AudioEngine::file() const
{
    return m_file;
}

void AudioEngine::setFile(const QUrl &url)
{
    // qDebug() << "CPP: AudioEngine::setFile() " << url;
    if (m_effect.source() == url)
        return;

    m_file = url;
    m_effect.setSource(url);
    emit fileChanged();
}

double AudioEngine::volume() const
{
    // qDebug() << "CPP: AudioEngine::volume()";
    return m_effect.volume();
}

void AudioEngine::setVolume(double volume)
{
    // qDebug() << "CPP: AudioEngine::setVolume() " << volume;
    m_effect.setVolume(volume);
    emit volumeChanged();
}

void AudioEngine::play()
{
    // qDebug() << "CPP: AudioEngine::play()";
    m_effect.play();
}
