#include "waveformitem.h"

#include <QAudioDevice>
#include <QAudioSink>
#include <QAudioSource>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QMediaDevices>


using namespace Qt::Literals;

WaveformItem::WaveformItem(QQuickItem *parent)
    : QQuickPaintedItem(parent)
    , m_name("CPP Waveform")
    , m_color(Qt::green)
    , m_decoder(new QAudioDecoder(this))
{
    QAudioFormat format;
    format.setChannelCount(2);
    format.setSampleRate(44100);
    format.setSampleFormat(QAudioFormat::Float);

    m_decoder->setAudioFormat(format);

    auto onBufferReady = [this]() {
        QAudioBuffer buffer = m_decoder->read();
        const float *data = buffer.constData<float>();
        if (!data) {
            qCritical() << "Error (WaveformItem): Buffer is empty";
            return;
        }
        for (int i = 0; i < buffer.frameCount(); ++i)
            m_waveformData.append(static_cast<qreal>(data[i]));
        update();
    };

    connect(m_decoder, &QAudioDecoder::bufferReady, onBufferReady);
    connect(m_decoder, QOverload<QAudioDecoder::Error>::of(&QAudioDecoder::error), [this]() {
        qCritical() << "WaveformItem error: " << m_decoder->error() << "\n"
                    << m_decoder->errorString();
    });
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

    m_waveformData.clear();
    m_url = url;
    if (m_file != nullptr)
        m_file->close();

    m_file = new QFile(m_url.toString().replace("qrc:/", ":/"));
    m_file->open(QFile::ReadOnly);
    m_decoder->setSourceDevice(m_file);
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
