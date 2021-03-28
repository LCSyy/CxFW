#ifndef CAMERACONTROLLER_H
#define CAMERACONTROLLER_H

#include <Qt3DCore/QEntity>
#include <QVector3D>

QT_BEGIN_NAMESPACE
namespace Qt3DInput {
    class QLogicalDevice;
    class QKeyboardHandler;
    class QKeyboardDevice;
    class QMouseDevice;
    class QKeyEvent;
    class QAxis;
    class QAction;
    class QButtonAxisInput;
    class QActionInput;
    class QAnalogAxisInput;
}
namespace Qt3DLogic {
    class QFrameAction;
}
namespace Qt3DRender {
    class QCamera;
}
QT_END_NAMESPACE

class CameraController : public Qt3DCore::QEntity
{
    Q_OBJECT
public:
    explicit CameraController(Qt3DCore::QNode *parent = nullptr);
    ~CameraController();

    void setCamera(Qt3DRender::QCamera *cam);

    void setVelocity(float vx, float vy, float vz);
    void setAcceleration(float a);
    void setDeceleration(float a);

private slots:
    void onFrameActionTriggered(float dt);

private:
    float m_acc;
    float m_dec;
    QVector3D m_translateVelocity;
    Qt3DRender::QCamera *m_camera;
    Qt3DLogic::QFrameAction *m_frameAction;
    Qt3DInput::QLogicalDevice *m_logicalDevice;
    Qt3DInput::QKeyboardDevice *m_keyboardDevice;
    Qt3DInput::QMouseDevice *m_mouseDevice;
    Qt3DInput::QAxis *m_xAxis;
    Qt3DInput::QAxis *m_yAxis;
    Qt3DInput::QAxis *m_zAxis;
    Qt3DInput::QAxis *m_rxAxis;
    Qt3DInput::QAxis *m_ryAxis;
    Qt3DInput::QAction *m_leftBtnAction;
    Qt3DInput::QAction *m_middleBtnAction;
    Qt3DInput::QAction *m_rightBtnAction;
    Qt3DInput::QAction *m_shfitKeyAction;

    Qt3DInput::QButtonAxisInput *m_aInput;
    Qt3DInput::QButtonAxisInput *m_dInput;
    Qt3DInput::QButtonAxisInput *m_wInput;
    Qt3DInput::QButtonAxisInput *m_sInput;
    Qt3DInput::QActionInput *m_leftBtnInput;
    Qt3DInput::QActionInput *m_rightBtnInput;
    Qt3DInput::QActionInput *m_middleBtnInput;
    Qt3DInput::QAnalogAxisInput *m_rxInput;
    Qt3DInput::QAnalogAxisInput *m_ryInput;
    Qt3DInput::QActionInput *m_shfitInput;


    // Qt3DInput::QKeyboardHandler *m_keyboardHandler;
    // Qt3DInput::QLogicalDevice *m_logicalDevice;
};

#endif // CAMERACONTROLLER_H
