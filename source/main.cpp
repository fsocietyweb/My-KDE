#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QProcess>
#include <QSurfaceFormat>
#include <QQuickWindow>
#include <QStorageInfo>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <KLocalizedString>
#include <KAboutData>

class MyKdeCore : public QObject {
    Q_OBJECT
public:
    explicit MyKdeCore(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE QString getDiskSpace() {
        QStorageInfo storage = QStorageInfo::root();
        double free = storage.bytesAvailable() / (1024.0 * 1024.0 * 1024.0);
        double total = storage.bytesTotal() / (1024.0 * 1024.0 * 1024.0);
        return QString::number(free, 'f', 1) + " GB frei von " + QString::number(total, 'f', 1) + " GB";
    }

    Q_INVOKABLE void runCommand(const QString &cmd, const QStringList &args = {}) {
        QProcess::startDetached(cmd, args);
    }

    Q_INVOKABLE void cleanBloatware() {
        QProcess::startDetached("flatpak", QStringList() << "uninstall" << "--unused" << "-y");
    }

    Q_INVOKABLE void checkPing() {
        QProcess *pingProc = new QProcess(this);
        pingProc->start("ping", QStringList() << "-c" << "1" << "kde.org");
        connect(pingProc, &QProcess::finished, this, [this, pingProc]() {
            QString output = pingProc->readAllStandardOutput();
            int index = output.indexOf("time=");
            if (index != -1) {
                QString timeStr = output.mid(index + 5);
                int spaceIndex = timeStr.indexOf(" ");
                int ms = timeStr.left(spaceIndex).toDouble();
                Q_EMIT pingUpdated(ms);
            }
            pingProc->deleteLater();
        });
    }

    Q_INVOKABLE void fetchWeather() {
        QNetworkAccessManager *manager = new QNetworkAccessManager(this);
        QNetworkRequest request(QUrl("https://wttr.in"));
        connect(manager, &QNetworkAccessManager::finished, this, [this, manager](QNetworkReply *reply) {
            if (reply->error() == QNetworkReply::NoError) {
                QJsonObject jsonObj = QJsonDocument::fromJson(reply->readAll()).object();
                QString temp = jsonObj["current_condition"].toArray().at(0).toObject()["temp_C"].toString();
                Q_EMIT weatherReady(temp + " Grad Celsius");
            }
            reply->deleteLater();
            manager->deleteLater();
        });
        manager->get(request);
    }

Q_SIGNALS:
    void weatherReady(QString weatherInfo);
    void pingUpdated(int ms);
};

int main(int argc, char *argv[])
{
    // Alpha-Buffer für 3px Transluzenz reservieren
    QSurfaceFormat format;
    format.setAlphaBufferSize(8);
    QSurfaceFormat::setDefaultFormat(format);

    QGuiApplication app(argc, argv);
    KLocalizedString::setApplicationDomain("mykde");

    KAboutData aboutData(QStringLiteral("mykde"), QStringLiteral("My KDE"), QStringLiteral("1.0"),
                         QStringLiteral("Die neue Tuning-Zentrale."), KAboutLicense::GPL, QStringLiteral("(c) 2026"));
    KAboutData::setApplicationData(aboutData);

    QQmlApplicationEngine engine;

    MyKdeCore core;
    engine.rootContext()->setContextProperty(QStringLiteral("myCore"), &core);

    QObject::connect(&core, &MyKdeCore::weatherReady, [&](const QString &info){
        if(!engine.rootObjects().isEmpty()) engine.rootObjects().first()->setProperty("weatherText", info);
    });

        engine.load(QUrl(QStringLiteral("qrc:/qt/qml/mykde/main.qml")));
        return app.exec();
}

#include "main.moc"
