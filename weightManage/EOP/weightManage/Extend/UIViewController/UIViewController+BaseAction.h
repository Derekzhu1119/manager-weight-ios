//
//  UIViewController+BaseAction.h
//
//

#import <UIKit/UIKit.h>


@protocol BackButtonHookProtocol <NSObject>
@optional
// 重写下面的方法以拦截导航栏返回按钮点击事件
- (void)shouldBack;
@end


@interface UIViewController (BaseAction)<BackButtonHookProtocol>

/**
 *  初始化data (比initUI先调用)
 */
- (void)initData;

/**
 *  初始化UI
 */
- (void)initUI;

@property (nonatomic, strong) id param;
typedef void(^BackBlock)(void);
typedef void(^BackBlockWithParam)(NSDictionary *dic);

@property (nonatomic, copy) BackBlock backBlock;
@property (nonatomic, copy) BackBlockWithParam backBlockWithParam;

//push
- (void)pushVC:(NSString *)vcName;
- (void)pushVC:(NSString *)vcName animated:(BOOL)animated;
- (void)pushVC:(NSString *)vcName param:(id)param;
- (void)pushVC:(NSString *)vcName param:(id)param backBlock:(void (^)(void))backBlock;
- (void)pushVC:(NSString *)vcName param:(id)param backBlockWithParam:(void(^)(NSDictionary *dic))backBlock;

//pop
/*vcName为nil 直接 pop上级*/
- (void)popVC:(NSString *)vcName;



//present
- (void)presentVC:(NSString *)vcName;
- (void)presentVC:(NSString *)vcName param:(id)param;
- (void)presentVC:(NSString *)vcName param:(id)param completion:(void (^)(void))completion;

//重写返回按钮
- (void)reSetLeftBarbuttonItem;
//清楚返回按钮
- (void)clearLeftBarButtonItem;

//返回首页
- (void)reSetLeftBarbuttonItemPopToRoot;
//dissmiss消失
- (void)reSetLeftBarbuttonItemToDismiss;

//网络加载提示框 window 默认text 为 加载中...
- (void)showHud:(NSString *)text;
//网络加载提示框 view 默认text 为 加载中...
- (void)showHud:(NSString *)text onView:(UIView *)view;
//隐藏网络加载提示框 window
- (void)hideHud;
//隐藏网络加载提示框 view
- (void)hideHudOnView:(UIView *)view;
//自动消失的hud
- (void)showToastHudWithText:(NSString *)text;
//自动消失的提示框hud
-(void)showTextViewWithStatus:(NSString *)status;

//配置导航右侧的按钮
-(void)configNavigationBarRightItemWithTitle:(NSString *)title withImage:(NSString *)imageStr WithAction:(SEL)action;

//获取栈中最后一个vc
+(UIViewController *)currentViewController;
+(UIViewController *)currentViewControllerFrom:(UIViewController *)viewController;

@end
