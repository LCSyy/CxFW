#include "cameracontroller.h"
#include <Qt3DRender/QCamera>
#include <Qt3DLogic/QFrameAction>
#include <Qt3DInput/QLogicalDevice>
#include <Qt3DInput/QKeyboardDevice>
#include <Qt3DInput/QMouseDevice>
#include <Qt3DInput/QAxis>
#include <Qt3DInput/QAction>

#include <Qt3DInput/QButtonAxisInput>
#include <Qt3DInput/QActionInput>
#include <Qt3DInput/QAnalogAxisInput>

#include <QDebug>

CameraController::CameraController(Qt3DCore::QNode *parent)
    :Qt3DCore::QEntity(parent)
    , m_camera(nullptr)
    , m_frameAction(new Qt3DLogic::QFrameAction(this))
    , m_logicalDevice(new Qt3DInput::QLogicalDevice(this))
    , m_keyboardDevice(new Qt3DInput::QKeyboardDevice(this))
    , m_mouseDevice(new Qt3DInput::QMouseDevice(this))
    , m_xAxis(new Qt3DInput::QAxis(this))
    , m_yAxis(new Qt3DInput::QAxis(this))
    , m_zAxis(new Qt3DInput::QAxis(this))
    , m_rxAxis(new Qt3DInput::QAxis(this))
    , m_ryAxis(new Qt3DInput::QAxis(this))
    , m_leftBtnAction(new Qt3DInput::QAction(this))
    , m_middleBtnAction(new Qt3DInput::QAction(this))
    , m_rightBtnAction(new Qt3DInput::QAction(this))
    , m_shfitKeyAction(new Qt3DInput::QAction(this))
    , m_aInput(new Qt3DInput::QButtonAxisInput(this))
    , m_dInput(new Qt3DInput::QButtonAxisInput(this))
    , m_wInput(new Qt3DInput::QButtonAxisInput(this))
    , m_sInput(new Qt3DInput::QButtonAxisInput(this))
    , m_leftBtnInput(new Qt3DInput::QActionInput(this))
    , m_rightBtnInput(new Qt3DInput::QActionInput(this))
    , m_middleBtnInput(new Qt3DInput::QActionInput(this))
    , m_rxInput(new Qt3DInput::QAnalogAxisInput(this))
    , m_ryInput(new Qt3DInput::QAnalogAxisInput(this))
    , m_shfitInput(new Qt3DInput::QActionInput(this))
{
    m_aInput->setButtons(QVector<int>{Qt::Key_A});
    m_aInput->setScale(-1);
    m_aInput->setSourceDevice(m_keyboardDevice);
    m_xAxis->addInput(m_aInput);

    m_dInput->setButtons(QVector<int>{Qt::Key_D});
    m_dInput->setScale(1);
    m_dInput->setSourceDevice(m_keyboardDevice);
    m_xAxis->addInput(m_dInput);

    m_leftBtnInput->setButtons(QVector<int>{Qt::LeftButton});
    m_leftBtnInput->setSourceDevice(m_mouseDevice);
    m_leftBtnAction->addInput(m_leftBtnInput);

    m_rightBtnInput->setButtons(QVector<int>{Qt::RightButton});
    m_rightBtnInput->setSourceDevice(m_mouseDevice);
    m_rightBtnAction->addInput(m_rightBtnInput);

    m_middleBtnInput->setButtons(QVector<int>{Qt::MiddleButton});
    m_middleBtnInput->setSourceDevice(m_mouseDevice);
    m_middleBtnAction->addInput(m_middleBtnInput);

    // m_rightBtnInput->setButtons(QVector<int>{Qt::RightButton});
    // m_rightBtnInput->setSourceDevice(m_keyboardDevice);
    // m_yAxis->addInput(m_rightBtnInput);

    m_wInput->setButtons(QVector<int>{Qt::Key_W});
    m_wInput->setScale(1);
    m_wInput->setSourceDevice(m_keyboardDevice);
    m_zAxis->addInput(m_wInput);

    m_sInput->setButtons(QVector<int>{Qt::Key_S});
    m_sInput->setScale(-1);
    m_sInput->setSourceDevice(m_keyboardDevice);
    m_zAxis->addInput(m_sInput);

    m_rxInput->setAxis(Qt3DInput::QMouseDevice::X);
    m_rxInput->setSourceDevice(m_mouseDevice);
    m_rxAxis->addInput(m_rxInput);

    m_ryInput->setAxis(Qt3DInput::QMouseDevice::Y);
    m_ryInput->setSourceDevice(m_mouseDevice);
    m_ryAxis->addInput(m_ryInput);

    m_shfitInput->setButtons(QVector<int>{Qt::Key_Shift});
    m_shfitInput->setSourceDevice(m_keyboardDevice);
    m_shfitKeyAction->addInput(m_shfitInput);

    m_logicalDevice->addAxis(m_xAxis);
    m_logicalDevice->addAxis(m_yAxis);
    m_logicalDevice->addAxis(m_zAxis);
    m_logicalDevice->addAxis(m_rxAxis);
    m_logicalDevice->addAxis(m_ryAxis);
    m_logicalDevice->addAction(m_leftBtnAction);
    m_logicalDevice->addAction(m_middleBtnAction);
    m_logicalDevice->addAction(m_rightBtnAction);
    m_logicalDevice->addAction(m_shfitKeyAction);

    connect(m_frameAction,SIGNAL(triggered(float)),
            this,SLOT(onFrameActionTriggered(float)));

    addComponent(m_frameAction);
    addComponent(m_logicalDevice);
}

CameraController::~CameraController()
{

}

void CameraController::setCamera(Qt3DRender::QCamera *cam)
{
    m_camera = cam;
}

void CameraController::setVelocity(float vx, float vy, float vz)
{
    m_translateVelocity.setX(vx);
    m_translateVelocity.setY(vy);
    m_translateVelocity.setZ(vz);
}

void CameraController::setAcceleration(float a)
{
    m_wInput->setAcceleration(a);
    m_sInput->setAcceleration(a);
    m_aInput->setAcceleration(a);
    m_dInput->setAcceleration(a);
}

void CameraController::setDeceleration(float a)
{
    m_wInput->setAcceleration(a);
    m_sInput->setAcceleration(a);
    m_aInput->setAcceleration(a);
    m_dInput->setAcceleration(a);
}

void CameraController::onFrameActionTriggered(float dt)
{
    if (!m_camera) { return; }

    float vscale = 1.0;
    if (m_shfitKeyAction->isActive()) {
        vscale = 0.2;
    }

    const float x = m_xAxis->value() * m_translateVelocity.x() * vscale;
//    const float y = m_yAxis->value() * m_translateVelocity.y() * vscale;
    const float z = m_zAxis->value() * m_translateVelocity.z() * vscale;
    const float rx = m_rxAxis->value() * m_translateVelocity.x();
    const float ry = m_ryAxis->value() * m_translateVelocity.y();

    m_camera->translate(QVector3D(x,0,z)*dt);

    const QVector3D upVector(0.0f, 1.0f, 0.0f);

    if (m_rightBtnAction->isActive()) {
        m_camera->pan(rx * dt, upVector);
        m_camera->tilt(ry * dt);
    } else if(m_leftBtnAction->isActive()) {
        m_camera->translate(QVector3D(rx, ry, 0) * dt * vscale);
    }
}
