Rating
======

Rating ANE for IOS and Android

* 在XXX-app.xml添加扩展依赖
 
```xml
<extensions>
	...
	<extensionID>com.alanogames.ane.Rating</extensionID>
</extensions>
```

* 在程序启动时间添加:

```actionscript
Rating.daysUntilPrompt=0;
Rating.usesUntilPrompt=5;
Rating.applicationLaunched();
```
	
* 在需要评论的时候添加，例如玩家通过关卡时:

```actionscript
if( Rating.shouldPromptForRating() ) {
	//RateViewUtil.getInstance().promptIfNetworkAvailable();
	RateViewUtil.getInstance().promptForRating();
}
```

* 详细用法参考：

```
https://github.com/nicklockwood/iRate
README.md
```

* 感谢

> **ANE-Wizard**

> https://github.com/freshplanet/ANE-Wizard

> **Rating-ANE**

> https://github.com/digicrafts/Rating-ANE

> **iRate**

> https://github.com/nicklockwood/iRate

Rating 修改了 Rating-ANE 的一个bug：

```
ld: file not found: %ADT_ENV_VAR_XX%
Compilation failed while executing : ld64
```
https://github.com/digicrafts/Rating-ANE/issues/2
