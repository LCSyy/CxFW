# CxFW
基于Qt的CxFrameworks。


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
------------------------------------
| base      | qml | quick | charts |
------—-                           |
| core |                           |
------------------------------------
| 3rdparty | ...                   |
------------------------------------
```