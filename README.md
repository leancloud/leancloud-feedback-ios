# leancloud-feedback-ios

LeanCloud Feedback 模块是 [LeanCloud](https://leancloud.cn) 开源的一个用户反馈组件，反馈内容存储在 LeanCloud 云端，开发者可以通过 LeanCloud 提供的统计分析客户端 [LeanAnalytics](https://itunes.apple.com/IE/app/id854896336) 来实时查看和回复用户反馈。

用户反馈界面如下：

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
### LCUserFeedback
表示一个用户提交过来的所有反馈信息，与用户一一对应。一个用户只有一个 LCUserFeedback，LCUserFeedback 内部主要记录有如下信息：

* contact，用户联系方式
* content，用户反馈的主题
* status，状态
* remarks，开发者可以添加的其他内容

### LCUserFeedbackThread
表示用户提交的一条反馈意见。一个用户可以提交多条反馈意见，并且就一个功能或者问题，可能会和开发者有多次反馈沟通（每一次沟通会对应一个 LCUserFeedbackThread）。所以 LCUserFeedbackThread 和 LCUserFeedback 存在多对一的关系。LCUserFeedbackThread 内部主要记录有如下信息：

* feedback，所属的 LCUserFeedback
* content，反馈的文本内容
* type，状态


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
在 LeanCloudFeedbackDemo 目录下，直接用 xcode 打开 LeanCloudFeedbackDemo.xcodeproj 工程即可。


## 在我的项目中如何使用这一组件
为了调试方便，我们推荐大家直接把本项目的源代码加入自己工程来使用 feedback 组件。
要进入默认的反馈界面，开发者可以在当前 UIViewController 中加入如下代码即可（记得将标题和联系方式改一下）：

```
    LCUserFeedbackAgent *agent = [LCUserFeedbackAgent sharedInstance];
    [agent showConversations:self title:@"提点意见" contact:@"热心用户"];
```

当然，开发者也可以自己实现反馈界面
这时候需要使用 LCUserFeedbackAgent 提供的另外两个 API 来完成用户反馈功能：

```
/**
 *  从服务端同步反馈回复
 *  @param title 反馈标题, 当用户没有创建过用户反馈时，需要传入这个参数用于创建用户反馈。
 *  @param contact 联系方式，邮箱或qq。
 *  @param block 结果回调
 *  @discussion 可以在 block 中处理反馈数据 (AVUserFeedbackThread 数组)，然后将其传入自定义用户反馈界面。
 */
- (void)syncFeedbackThreadsWithBlock:(NSString *)title contact:(NSString *)contact block:(AVArrayResultBlock)block;

/**
 *  发送用户反馈
 *  @param content 同上，用户反馈内容。
 *  @param block 结果回调
 */
- (void)postFeedbackThread:(NSString *)content block:(AVIdResultBlock)block;
```


## 其他问题
### 我要增加额外的数据，该怎么做？
可以扩展 LCUserFeedbackThread 的属性值，从而保存更多的内容。譬如允许用户截图来反馈问题的话，可以在应用中先把图片存储到 LeanCloud 云端（使用 AVFile），然后把 AVFile 的 url 保存到 LCUserFeedbackThread。

