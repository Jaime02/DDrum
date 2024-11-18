#include <QColor>
#include <QPainter>
#include <QString>
#include <QtQuick/QQuickPaintedItem>
#include <QFile>

#include <QAudioDecoder>

class WaveformItem : public QQuickPaintedItem
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString name READ name FINAL)
    Q_PROPERTY(QColor color READ color FINAL)
    Q_PROPERTY(QUrl file READ file WRITE setFile NOTIFY fileChanged)

signals:
    void fileChanged();

public:
    WaveformItem(QQuickItem *parent = nullptr);

    QString name() const;
    QColor color() const;

    QUrl file() const;
    void setFile(const QUrl &file);

    void paint(QPainter *painter) override;

private:
    QString m_name;
    QColor m_color;

    QUrl m_url;

    // Using QFile to trick the non functional audiodecoder->setSource
    // Works with Qt6.7 but not with 6.8
    std::unique_ptr< QFile > m_file;
    QAudioDecoder* m_decoder;
    QVector<qreal> m_waveformData;
};
