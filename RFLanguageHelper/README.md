###### README.

1. Info.plist文件不可以本地化；
因为本地化之后，Info.plist文件被移动至本地化语言文件夹中，项目根目录下不存在Info.plist文件，
系统读取不到元数据，程序无法加载。
2. 利用InfoPlist.strings文件和CFBundleDisplayName，实现应用名称的本地化显示;
但是，该本地化显示仅支持跟随系统语言设定。
3.同样的，通过在2中的文件中设置相应的权限的Key，也可以实现权限提示内容的本地化。

4.Warning 2018.3.30.最近的开发过程中发现，不同的手机版本，语言码对应的语言竟然会不一样，故针对这个问题，
增加了一个方法+ (NSInteger)LanguageCodeViaKey:(NSString *)key，以及调用时候的特别处理方式，
详见AppDelegete文件中的方法- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions的变动
