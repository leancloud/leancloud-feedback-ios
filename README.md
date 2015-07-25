# leancloud-feedback-ios

LeanCloud Feedback 模块是 [LeanCloud](https://leancloud.cn) 开源的一个用户反馈组件，反馈内容存储在 LeanCloud 云端，开发者可以通过 LeanCloud 提供的统计分析客户端 [LeanAnalytics](https://itunes.apple.com/IE/app/id854896336) 来实时查看和回复用户反馈。

用户反馈界面如下：

![image](images/Screen.png)


## 如何贡献
你可以通过提 issue 或者发 pull request 的方式，来贡献代码。开源世界因你我参与而更加美好。

## 项目结构
为了便于测试，我们将 feedback 模块的代码和 demo 都放在了一起，整个 repo 结构如下：

```
.
├── AVOSCloud.framework  <---- 这是依赖的 AVOSCloud.framework，请保持最新
├── LeanCloudFeedback    <---- feedback 主要代码
├── LeanCloudFeedbackTests
├── LeanCloudFeedbackDemo    <---- feedback demo 主要代码
│   ├── LeanCloudFeedbackDemo
│   ├── LeanCloudFeedbackDemo.xcodeproj
│   └── LeanCloudFeedbackDemoTests
└── README.md
```
## 核心概念
### LCFeedbackReply
FeedbackReply 代表了反馈系统中间，用户或者开发者的每一次回复。不同的类型可以通过 ReplyType 属性来指定。FeedbackReply 内部主要记录有如下信息：

* content，反馈的文本内容
* replyType，类型标识，表明是用户提交的，还是开发者回复的
* attachment，反馈对应的附件信息

### LCFeedbackThread
代表了用户与开发者的整个交流过程，与用户一一对应。一个用户只有一个 FeedbackThread，一个 FeedbackThread 内含有多个 FeedbackReply。FeedbackThread 内部主要记录有如下信息：

* contact，用户联系方式
* content，用户第一次反馈的文本
* status，当前状态：open 还是 close
* remarks，预留字段，开发者可以用来标记的一些其他信息


## 如何编译
### Xcode 编译
在 Xcode 中选择 UniversalFramework Target，设备选为 iOS Device，在 Product 菜单中选择 Archive 即可开始编译。编译完成之后会在当前 build 目录下

```
.
├── LeanCloudFeedback.build
│   ├── Release-iphoneos
│   │   └── LeanCloudFeedback.build
│   └── Release-iphonesimulator
│       └── LeanCloudFeedback.build
└── Release-iphoneuniversal
    └── LeanCloudFeedback.framework <------ 这里就是编译出来的 framework
```

### 命令行编译
在项目根目录下执行如下语句，即可开始编译

```
xcodebuild -target UniversalFramework -config Release
```

编译之后的结果文件目录和上面示例一致。


## 如何运行 demo
在 LeanCloudFeedbackDemo 目录下，直接用 xcode 打开 LeanCloudFeedbackDemo.xcodeproj 工程。LeanChatFeedback Framework 是一个动态库，需要在 Demo 中的 Embeded Libraries 引入进来。设置如下，之后便可在真机和模拟器运行。

![image](https://cloud.githubusercontent.com/assets/5022872/8520619/7ea1b9f8-240e-11e5-8b15-9f775f526d8f.png)

## 在我的项目中如何使用这一组件
为了调试方便，我们推荐大家直接把本项目的源代码加入自己工程来使用 feedback 组件。
要进入默认的反馈界面，开发者可以在当前 UIViewController 中加入如下代码即可（记得将标题和联系方式改一下）：

```
    LCUserFeedbackAgent *agent = [LCUserFeedbackAgent sharedInstance];
    [agent showConversations:self title:@"提点意见" contact:@"热心用户"];
```

也可通过 pod 方式安装，在 podfile 中加入以下声明，

```
  pod 'LeanCloudFeedback'
```

## 其他问题
### 我要增加额外的数据，该怎么做？
可以扩展 LCUserFeedbackReply 的属性值，从而保存更多的内容。譬如允许用户截图来反馈问题的话，可以在应用中先把图片存储到 LeanCloud 云端（使用 AVFile），然后把 AVFile 的 url 保存到 LCUserFeedbackReply(attachment 属性)。

## ChangeLog

0.0.4	
修复发送的反馈没有显示时间戳的问题、更改 AVOSCloud 依赖至 ~> 3.1 ，使得主项目引用时没有收到此库的限制

0.0.3	
增加图片上传功能，让用户可以上传图片来反映问题

0.0.2	
增加了导航栏、联系人表头、字体的定制		
去掉了 LeftCell 类 和 RightCell 类，统一为 FeedbackCell，因为左右Cell 大部分代码都是相同可复用的。

0.0.1	
发布
