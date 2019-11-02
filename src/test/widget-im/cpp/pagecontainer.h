#ifndef PAGECONTAINER_H
#define PAGECONTAINER_H

#include <QWidget>

QT_BEGIN_NAMESPACE
class QTabBar;
class QStackedWidget;
QT_END_NAMESPACE

class PageContainer : public QWidget
{
    Q_OBJECT
signals:
    void currentPageChanged(const QUrl &url);
public:
    explicit PageContainer(QWidget *parent = nullptr);

    void openPage(const QUrl &url);
    void closePage(const QUrl &url);

    QUrl currentPage() const;

private slots:
    void onTabCloseRequested(int idx);
    void onTabCurrentChanged(int idx);

private:
    bool openChatPage(const QUrl &url);
    bool openSettingsPage(const QUrl &url);

private:
    QTabBar *mTabBar {nullptr};
    QStackedWidget *mPageStack {nullptr};
};

#endif // PAGECONTAINER_H
