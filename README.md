
## 蒲公英

* [安装链接](http://www.pgyer.com/yh-i)
* 扫码安装

	![QR Code](http://static.pgyer.com/app/qrcode/yh-i)
	
* 应用切换

	```
	bundle install
	echo 'yonghui' > .current_app
	bundle exec ruby app_keeper.rb {yonghui|shengyiplus}
	```
* 上传ipa至蒲公英

	```	
	bundle install
	bundle exec ruby pgyer_upload.rb
	```

## TODO

* [] upgrade WebViewJavascriptBridge(pod 'WebViewJavascriptBridge', '~> 5.0')
* [] upgrade [MBProgressHUD](https://github.com/jdg/MBProgressHUD) to 0.9.2


## 更新日志

* 16/04/08

	* add: ruby script to automatic modifiy configure when switch app

* 16/04/05

	* optimized: support pdf scale and mobile ui v2

* 16/03/17

	* optimized: 网络信号不好时，js<=>oc交互失败
	
		原因: 网络信号差，服务器访问慢，用户会误以为没反应而连续点击，导致UIWebView Multi Lock错误
		解决: 点击后，禁用按钮，加载完成后，再解禁按钮
		
* 16/03/16

	* optimized: 静态资源 app<=>server 流程优化

* 16/03/15

	* optimized: 静态资源分fonts/images/stylesheets/javascripts分别下载
	* optimzied: 网络环境不好时，显示UI 重新加载

* 16/02/22

	* Add: assets.zip文件，服务器维护
	
* 16/02/17

	* Add: 用户行为记录添加字段: 应用版本

* 16/02/13

	* Add: 主题页面横屏时，隐藏标题栏
	
		除主题页面外，其他页面只允许竖屏；
	
	* Fixd: 记录浏览器刷新日志时，同时提交浏览器链接

* 16/02/04

	* Fixed: 永辉IOS客户端 设置页面scroll view, 不可滑动
	* Fixed: 永辉IOS客户端 解屏，不使用TouchID
	* Add: IOS 解屏，也验证用户信息，以免服务器用户权限有变
	* Fixed: IOS 用户行为记录使用异步；取消同步[返回]行为
	
* 16/02/03

	* Add: 客户端 JS 异常，本地提交至服务器
	* Fixed: 网络环境验证、用户设备是否禁用功能合一
	
* 16/01/31

	* Fixed: 人为码误
	
		头脑不清醒，傻傻分不清楚
		
			self.assetsPath 
			self.sharedPath
		
* 16/01/30
	
	* Fixed: 解屏进入主界面，检测版本升级
	
		通过登录界面，进入主界面，则不再测试
		
	* Fixed: 静态文件优化
	
		统一压缩文件名大小写
	
	* Add: 用户行为日志同步至服务器
	* Add: 设置 -> 检测版本升级
		
		判断版本号是否为偶数, 以便内测
		
	* Add: 设置 -> 校正
	
		安装时，可能由于用户空间不足，导致静态压缩文件解压失败，该功能会重新解压静态文件
	
	* Fixed: UIWebView#NSURLErrorDomain
			
		进入界面时，异步访问服务器，这时显示加载中..。
		
			NSString *loadingPath = [FileUtils loadingPath:isLogin];
			NSString *loadingContent = [NSString stringWithContentsOfFile:loadingPath encoding:NSUTF8StringEncoding error:nil];
			[self.browser loadHTMLString:loadingContent baseURL:[NSURL fileURLWithPath:loadingPath]];
			
			
		异步访问服务器成功后，加载服务器响应信息
		
			dispatch_async(dispatch_get_main_queue(), ^{
				NSString *htmlContent = [self stringWithContentsOfFile:htmlPath];
				[self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:self.sharedPath]];
			});
	
		这里`UIWebView`回调函数就会报错:
			
			- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
			    /**
			     *  忽略 NSURLErrorDomain 错误 - 999
			     */
			    if([error code] == NSURLErrorCancelled) return;
			    
			    NSLog(@"dvc: %@", error.description);
			}
			
		其实第二次UIWebView#loadHTMLString是对第一次的取消，按上述过滤一下就可以清静了。