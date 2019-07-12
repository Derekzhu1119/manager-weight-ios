//
//  UIViewController+BaseAction.m
//
//

#import "UIViewController+BaseAction.h"
#import <objc/runtime.h>
#import <MBProgressHUD.h>
#import "UIView+Utils.h"

static void *PKey = &PKey;
static void *PBlockKey = &PBlockKey;
static void *PParamBlockKey = &PParamBlockKey;

@implementation UIViewController (BaseAction)

+ (void)load{
    Method originalMethod = class_getInstanceMethod(self, @selector(viewDidLoad));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(tg_viewDidLoad));
    method_exchangeImplementations(originalMethod, swizzledMethod);
    
    Method originalMethod2 = class_getInstanceMethod(self, @selector(viewWillAppear:));
    Method swizzledMethod2 = class_getInstanceMethod(self, @selector(tg_viewWillAppear:));
    method_exchangeImplementations(originalMethod2, swizzledMethod2);
    
    Method originalMethod3 = class_getInstanceMethod(self, @selector(viewWillDisappear:));
    Method swizzledMethod3 = class_getInstanceMethod(self, @selector(tg_viewWillDisappear:));
    method_exchangeImplementations(originalMethod3, swizzledMethod3);
    
    Method originalMethod4 = class_getInstanceMethod(self, @selector(viewDidAppear:));
    Method swizzledMethod4 = class_getInstanceMethod(self, @selector(tg_viewDidAppear:));
    method_exchangeImplementations(originalMethod4, swizzledMethod4);
    
}

- (void)tg_viewDidLoad{
    [self tg_viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //不是相册的根视图
    if (![NSStringFromClass(self.class) isEqualToString:@"MyPickerHostViewController"]) {
        if (![self.navigationController.viewControllers[0] isEqual:self]) {
            [self reSetLeftBarbuttonItem];
        }
    }
    [self initData];
    [self initUI];
}

- (void)tg_viewWillAppear:(BOOL)animated{
    [self tg_viewWillAppear:animated];
}


- (void)tg_viewWillDisappear:(BOOL)animated{
    [self tg_viewWillDisappear:animated];
}

- (void)tg_viewDidAppear:(BOOL )animated{
    [self tg_viewDidAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)initUI{
    
}

- (void)initData{
    
}

- (id)param{
    return objc_getAssociatedObject(self, &PKey);
}

- (void)setParam:(id)param{
    objc_setAssociatedObject(self, &PKey, param, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BackBlock)backBlock{
    return objc_getAssociatedObject(self, &PBlockKey);
}

- (void)setBackBlock:(BackBlock)backBlock{
    objc_setAssociatedObject(self, &PBlockKey, backBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BackBlockWithParam)backBlockWithParam{
    return objc_getAssociatedObject(self, &PParamBlockKey);
}

- (void)setBackBlockWithParam:(BackBlockWithParam)backBlockWithParam{
    objc_setAssociatedObject(self, &PParamBlockKey, backBlockWithParam, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (void)pushVC:(NSString *)vcName{
    [self pushVC:vcName param:nil];
}

- (void)pushVC:(NSString *)vcName animated:(BOOL)animated{
    [self pushVC:vcName param:nil  animated:animated];
}

- (void)pushVC:(NSString *)vcName param:(id)param  animated:(BOOL)animated{
    [self pushVC:vcName param:param backBlock:nil animated:animated];
}

- (void)pushVC:(NSString *)vcName param:(id)param backBlock:(void (^)(void))backBlock animated:(BOOL)animated{
    Class class = NSClassFromString(vcName);
    NSAssert(class != nil, @"Class不存在");
    UIViewController *vc = [class new];
    vc.param = param;
    if (backBlock) {
        vc.backBlock = backBlock;
    }
    [self.navigationController pushViewController:vc animated:animated];
}

- (void)pushVC:(NSString *)vcName param:(id)param{
    [self pushVC:vcName param:param backBlock:nil];
}

- (void)pushVC:(NSString *)vcName param:(id)param backBlock:(void (^)(void))backBlock{
    Class class = NSClassFromString(vcName);
    NSAssert(class != nil, @"Class不存在");
    UIViewController *vc = [class new];
    vc.param = param;
    if (backBlock) {
        vc.backBlock = backBlock;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushVC:(NSString *)vcName param:(id)param backBlockWithParam:(void(^)(NSDictionary *dic))backBlock
{
    Class class = NSClassFromString(vcName);
    NSAssert(class != nil, @"Class不存在");
    UIViewController *vc = [class new];
    vc.param = param;
    if (backBlock) {
        vc.backBlockWithParam = backBlock;
    }
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)presentVC:(NSString *)vcName{
    [self presentVC:vcName param:nil];
}

- (void)presentVC:(NSString *)vcName param:(id)param{
    [self presentVC:vcName param:param completion:nil];
}

- (void)presentVC:(NSString *)vcName param:(id)param completion:(void (^)(void))completion{
    
    Class class = NSClassFromString(vcName);
    NSAssert(class != nil, @"Class不存在");
    
    UIViewController *vc = [class new];
    vc.param = param;
    [self presentViewController:vc animated:YES completion:completion];
    
}

- (void)popVC:(NSString *)vcName{
    if (!vcName){
        if (self.backBlock) {
            self.backBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    Class class = NSClassFromString(vcName);
    NSAssert(class != nil, @"Class不存在");
    
    if (self.backBlock) {
        self.backBlock();
    }
    
    
    UIViewController *vc = [self getViewControllerWithControllerName:class];
    [self.navigationController popToViewController:vc animated:YES];
}

- (UIViewController *)getViewControllerWithControllerName:(Class)class{
    NSArray *arr = self.navigationController.viewControllers;
    for (UIViewController *viewController in arr) {
        if ([viewController isKindOfClass:class]) {
            return viewController;
        }
    }
    return nil;
}

- (void)reSetLeftBarbuttonItem{
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [button setImage:[UIImage imageNamed:@"back_black"] forState:(UIControlStateNormal)];
//    [button setTintColor:[UIColor colorWithHexString:@"#57575c"]];
    WS(weakSelf);
    [button setTapActionWithBlock:^{
        if (weakSelf.backBlock) {
            weakSelf.backBlock();
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = bar;
}

- (void)reSetLeftBarbuttonItemToDismiss{
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [button setImage:[UIImage imageNamed:@"back_black"] forState:(UIControlStateNormal)];
//    [button setTintColor:[UIColor colorWithHexString:@"#57575c"]];
    WS(weakSelf);
    [button setTapActionWithBlock:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = bar;
}


- (void)reSetLeftBarbuttonItemPopToRoot{
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [button setImage:[UIImage imageNamed:@"back_black"] forState:(UIControlStateNormal)];
    [button setTintColor:[UIColor colorWithHexString:@"#57575c"]];
    WS(weakSelf);
    [button setTapActionWithBlock:^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = bar;
}

//配置导航右侧的按钮
-(void)configNavigationBarRightItemWithTitle:(NSString *)title withImage:(NSString *)imageStr WithAction:(SEL)action
{
    UIBarButtonItem *rightItem = nil;
    if (title)
    {
        rightItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
    }
    else
    {
        rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:imageStr] style:UIBarButtonItemStylePlain target:self action:action];
    }
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)clearLeftBarButtonItem{
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)showHud:(NSString *)text{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self showHud:text onView:window];
}

- (void)showHud:(NSString *)text onView:(UIView *)view{
    MBProgressHUD * hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud =[MBProgressHUD showHUDAddedTo:view animated:YES];
    }else{
        [hud showAnimated:YES];
    }
    hud.minSize = CGSizeMake(100, 100);
    hud.label.text= text.length ? text:@"加载中...";
    hud.label.font=[UIFont systemFontOfSize:15];
    hud.label.textColor= [UIColor whiteColor];
    hud.label.numberOfLines = 0;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.9];
    hud.removeFromSuperViewOnHide = YES;
    [hud setContentColor:[UIColor whiteColor]];
}

- (void)hideHud{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self hideHudOnView:window];
}

- (void)hideHudOnView:(UIView *)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

- (void)showToastHudWithText:(NSString *)text{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self showHud:text onView:window];
    [self performSelector:@selector(hideHud) withObject:nil afterDelay:1.5f];
}

-(void)showTextViewWithStatus:(NSString *)status{
    
    MBProgressHUD *hud = [self createDefaultHUD];
    if ([status rangeOfString:@"\n"].location != NSNotFound) {
        NSArray *arry = [status componentsSeparatedByString:@"\n"];
        if ([[arry firstObject] isKindOfClass:[NSString class]]) {
            hud.label.text = [arry firstObject];
        }
        if ([[arry lastObject] isKindOfClass:[NSString class]]) {
            hud.detailsLabel.text = [arry lastObject];
        }
    }else{
        if ([status isKindOfClass:[NSString class]]) {
            hud.label.text = status;
        }
    }
    
    hud.mode = MBProgressHUDModeText;
    hud.graceTime = 0;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

-(MBProgressHUD *)createDefaultHUD{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 取消之前的loading
    while([MBProgressHUD HUDForView:window] != nil){
        [MBProgressHUD hideHUDForView:window animated:NO];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    hud.graceTime = 0.75;
    hud.contentColor = [UIColor whiteColor];
    hud.margin = 10.0;
    return  hud;
}



//获取栈中最后一个vc
+(UIViewController *)currentViewController{
    
    UIViewController * Rootvc = [UIApplication sharedApplication].delegate.window.rootViewController ;
    
    return [self currentViewControllerFrom:Rootvc];
}

+ (UIViewController *)currentViewControllerFrom:(UIViewController*)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController * nav = (UINavigationController *)viewController;
        UIViewController * v = [nav.viewControllers lastObject];
        return [self currentViewControllerFrom:v];
    }else if([viewController isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabVC = (UITabBarController *)viewController;
        return [self currentViewControllerFrom:[tabVC.viewControllers objectAtIndex:tabVC.selectedIndex]];
    }else if(viewController.presentedViewController != nil) {
        return [self currentViewControllerFrom:viewController.presentedViewController];
    }
    else {
        return viewController;
    }
}





@end

@interface UINavigationController (ShouldPopOnBackButton)

@end


@implementation UINavigationController (ShouldPopOnBackButton)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(shouldBack)]) {
        [vc shouldBack];
        return NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self popViewControllerAnimated:YES];
    });
    return YES;
}

@end




