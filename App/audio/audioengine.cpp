#include "audioengine.h"

#include <iostream>
#include <QAudioOutput>

AudioEngine::AudioEngine(QObject *parent)
    : QObject(parent)
    , m_effect(this)
{
    QUrl initUrl(":/Sounds/Blow.wav");
    m_effect.setSource(initUrl);
}

QUrl AudioEngine::file() const
{
    qDebug() << "CPP: AudioEngine::file()";
    return m_effect.source();
}

void AudioEngine::setFile(const QUrl &url)
{
    qDebug() << "CPP: AudioEngine::setFile() " << url;
    if (m_effect.source() == url)
        return;

    m_effect.setSource(url);
    emit fileChanged();
}

double AudioEngine::volume() const
{
    qDebug() << "CPP: AudioEngine::volume()";
    return m_effect.volume();
}

void AudioEngine::setVolume(double volume)
{
    qDebug() << "CPP: AudioEngine::setVolume() " << volume;
    m_effect.setVolume(volume);
    emit volumeChanged();
}

void AudioEngine::play()
{
    qDebug() << "CPP: AudioEngine::play()";
    m_effect.play();
}
