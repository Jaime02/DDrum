#include "waveformitem.h"


#include <QAudioDevice>
#include <QMediaDevices>
#include <QFile>
#include <QAudioSource>
#include <QAudioSink>
#include <QFileInfo>
#include <QDir>

using namespace Qt::Literals;

WaveformItem::WaveformItem(QQuickItem *parent)
    : QQuickPaintedItem(parent)
    , m_name("CPP Waveform")
    , m_color(Qt::green)
    , m_url("qrc:/qt/qml/Sounds/Blow.wav")
    , m_file(std::make_unique< QFile >(":/qt/qml/Sounds/Blow.wav"))
    , m_decoder(new QAudioDecoder(this))
{
    QAudioFormat format;
    format.setChannelCount(1);
    format.setSampleRate(44100);
    format.setSampleFormat(QAudioFormat::Float);

    m_decoder->setAudioFormat(format);
    m_decoder->setSourceDevice(m_file.get());

    // Noooo, setSource does not work when the file is in the resource system.
    // m_decoder->setSource(m_url);

    auto onBufferReady = [this, format]() {
        QAudioBuffer buffer = m_decoder->read();
        const float *data = buffer.constData<float>();
        if(!data) { qDebug() << "Error (WaveformItem): Buffer is empty"; return; }
        for (int i = 0; i < buffer.frameCount(); ++i)
            m_waveformData.append(static_cast<qreal>(data[i]));
        update();
    };

    connect(m_decoder, &QAudioDecoder::bufferReady, onBufferReady);
    connect(m_decoder, QOverload<QAudioDecoder::Error>::of(&QAudioDecoder::error),
        [=](QAudioDecoder::Error error){ qDebug() << "Error (WaveformItem): " << error; } );

    m_decoder->start();
}

QString WaveformItem::name() const
{
    return m_name;
}

QColor WaveformItem::color() const
{
    return m_color;
}

QUrl WaveformItem::file() const
{
    return m_file->fileName();
}

void WaveformItem::setFile(const QUrl &url)
{
    qDebug() << "CPP: WaveformItem::setFile() " << url;

    if (m_url == url)
        return;

    // Nooooo, see above.
    // m_decoder->setSource(url);

    m_url = url;
    m_file.reset();
    m_file = std::make_unique< QFile >(':' + m_url.toString(QUrl::RemoveScheme));

    m_decoder->setSourceDevice(m_file.get());
    m_decoder->start();
    emit fileChanged();
}

void WaveformItem::paint(QPainter *painter)
{
    painter->fillRect(boundingRect(), m_color);

    if (m_waveformData.isEmpty()) {
        painter->setPen(Qt::black);
        painter->drawText(boundingRect(), Qt::AlignCenter, m_name);
        return;
    }

    painter->setRenderHint(QPainter::Antialiasing);

    QPen pen(Qt::blue);
    pen.setWidth(1.0);
    painter->setPen(pen);

    int width = static_cast<int>(boundingRect().width());
    int height = static_cast<int>(boundingRect().height());
    int dataSize = m_waveformData.size();

    qreal xStep = static_cast<qreal>(width) / static_cast<qreal>(dataSize);
    qreal centerY = height / 2.0;

    for (int i = 1; i < dataSize; ++i) {
        qreal x1 = (i - 1) * xStep;
        qreal y1 = centerY - m_waveformData[i - 1] * centerY;
        qreal x2 = i * xStep;
        qreal y2 = centerY - m_waveformData[i] * centerY;

        painter->drawLine(QPointF(x1, y1), QPointF(x2, y2));
    }
}
