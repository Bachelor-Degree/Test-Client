# clients

A new Flutter project.

一个简单的小玩具还要写 README ？晕~



## 这只是一个测试！请勿用于实际生产！！！

这种小玩具不可用于生产！

加密函数已经移除！！！



## 一. Getting Started（客户端）

项目地址：[Bachelor-Degree/Test-Client](https://github.com/Bachelor-Degree/Test-Client)



### 1.1 使用

通过左侧设置按钮，点击“我的主页”进行登录。

注意：运行时可能需要更改 网络设置（左侧设置按钮 -> 网络设置 -> 输入 Host 和 Post -> 确定），看到 “成功设置：域名:端口” 即可。



### 1.2 全平台支持

#### 1.2.1 Android 

测试功能正常。

自行从 GitHub 的 Release 中下载应用，安装运行。最新版见 GitHub Action。

#### 1.2.2 Linux

测试功能正常。

下载请移步 GitHub Action。

#### 1.2.3 Windows

测试功能正常（未测试全部功能）。

下载请移步 GitHub Action。

#### 1.2.4 Mac OS/iOS

限于经济原因，并未测试 Mac OS 和 iOS 平台。可能需要自行编译网络权限等模块。

下载请移步 GitHub Action。

#### 1.2.5 Web 

似乎有部分问题，未通过测试。



## 二. 服务端支持 

### 2.1 生成数据库和测试数据

第一次运行 sqliteOpt.py 创建数据库并生成测试文件。

数据库默认 test.db 



### 2.2 启动服务端 

而后运行 NetS2.py 挂起后台。请根据实际情况自行更新域名、端口。



## 三. 客户端自行编译 



### 3.1 Action 自动编译 

直接用 Action，还下载什么啊！
文件见 Test-Client/.github/workflows/main.yml/



### 3.2 手动编译（VScode）

- 按照 Flutter 平台要求 安装依赖
- 下载源码
- 选择对应平台  
- 编译 main.dart 
- 生成应用文件 



### 3.3 手动编译（Flutter CLI）

- 按照 Flutter 平台要求 安装依赖 
- 将 Flutter 加入 环境变量 
- 下载源码
- 运行 `flutter pub get` 获取依赖
- 运行 `flutter run --release -d windows/linux/macos` 等命令



## 可以了！不想写了！

