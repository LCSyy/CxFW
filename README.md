# CxFW

CxFW是基于Qt的应用开发框架。

## 结构

```
CxFW/
|- CxFW.toml
|- README.md
|- commit.template
|- .gitignore
|- src/
|  |- lib/
|  |  |- base/
|  |  |  |- embed/                       # 直接将源码嵌入项目的第三方库
|  |  |  |- thirdparty/
|  |  |     |- src/                      # 其他需要构建的第三方库
|  |  |     |- bin,lib,include/          # 构建过程中生成的目录
|  |  |- qml/
|  |  |- quick/
|  |  |- charts/
|  |- tool/
|  |- util/
|- dist/                                 # 完全内容输出目录
   |- qt-<version>-<platform>-<compiler>/
      |- bin/
      |- include/
```

## 依赖结构

```
------------------------------------
| APP                              |
-------------                      |
| plugin    |                      |
------------------------------------
| base      | qml | quick | charts |
------—-                           |
| core |                           |
------------------------------------
| 3rdparty | ...                   |
------------------------------------
```

## 使用CxFW

### 源码编译

通过Qt直接编译。添加系统环境变量`CXFW_DIR`。

### 获取二进制包

直接运行安装，安装程序将自动添加`CXFW_DIR`环境变量。

## cxfw

cxfw是CxFW的管理工具，可用于创建工程、获取依赖包、打包、发布等等。


