Rating
======

Rating ANE for IOS and Android

* 在程序启动时间添加:

	Rating.daysUntilPrompt=0;
	Rating.usesUntilPrompt=5;
	Rating.applicationLaunched();
	
* 在需要评论的时候添加，例如玩家通过关卡时:

	if( Rating.shouldPromptForRating() ) {
	//RateViewUtil.getInstance().promptIfNetworkAvailable();
	RateViewUtil.getInstance().promptForRating();
	}
