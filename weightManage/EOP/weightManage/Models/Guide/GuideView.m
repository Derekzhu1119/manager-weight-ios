//
//  GuideView.m
//  
//
//  Created by iss on 2019/6/20.
//

#import "GuideView.h"
#import "TabbarViewController.h"

#define K_Screen_width [UIScreen mainScreen].bounds.size.width
#define K_Screen_height [UIScreen mainScreen].bounds.size.height

@interface GuideView ()<UIScrollViewDelegate>

/**
 滚动视图
 */
@property (nonatomic,strong)UIScrollView *imageScrollView;
/**
 圆点
 */
@property (nonatomic,strong) UIPageControl *pageControl;

/**
 跳过按钮
 */
@property (nonatomic,strong)UIButton *cancelButton;

/**
 跟控制器
 */
@property (nonatomic,strong)UIViewController *rootController;

@end

@implementation GuideView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showGuideViewWithImageArray:@[@"guide01",@"guide02"] WindowRootController:[[TabbarViewController alloc]init]];
    [self createScrollView];
    [self createPageControl];
//    [self createCancelButton];
}

- (void)createScrollView
{
    _imageScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _imageScrollView.delegate = self;
    _imageScrollView.bounces = YES;
    _imageScrollView.pagingEnabled = YES;
    _imageScrollView.showsVerticalScrollIndicator = NO;
    _imageScrollView.showsHorizontalScrollIndicator = NO;
    _imageScrollView.backgroundColor = [UIColor whiteColor];
    _imageScrollView.contentSize = CGSizeMake(K_Screen_width *self.imageArray.count, K_Screen_height);
    [self.view addSubview:_imageScrollView];
    for (int i = 0; i < self.imageArray.count; i++) {
        NSString *imageName = self.imageArray[i];
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor purpleColor];
        imageView.frame = CGRectMake(K_Screen_width * i, 0, K_Screen_width, K_Screen_height);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_imageScrollView addSubview:imageView];
        imageView.image = [UIImage imageNamed:imageName];
        if (i == self.imageArray.count - 1) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelButtonAction:)];
            [imageView addGestureRecognizer:tap];
        }
    }
}

- (void)createPageControl
{
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, K_Screen_height - 80, K_Screen_width, 30)];
    _pageControl.hidden = _pageControlShow;
    _pageControl.pageIndicatorTintColor = _pageIndicatorColor;
    _pageControl.currentPageIndicatorTintColor = _currentPageIndicatorColor;
    _pageControl.numberOfPages = self.imageArray.count;
    [self.view addSubview:_pageControl];
}

- (void)createCancelButton
{
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.layer.cornerRadius = 2;
    _cancelButton.hidden = _cancelButtonShow;
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _cancelButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    _cancelButton.frame = CGRectMake(K_Screen_width - 70, 20, 60, 20);
    [_cancelButton setTitle:@"跳过" forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
}
// 倒计时
- (void)startTimer
{
    __block NSInteger second = 10;
    //全局队列    默认优先级
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //定时器模式  事件源
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    //NSEC_PER_SEC是秒，＊1是每秒
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 1, 0);
    WS(weakSelf);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(timer, ^{
        //回调主线程，在主线程中操作UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second >= 0) {
                [weakSelf.cancelButton setTitle:[NSString stringWithFormat:@"%lds跳过",second] forState:UIControlStateNormal];
                second--;
            }
            else
            {
                //这句话必须写否则会出问题
                dispatch_source_cancel(timer);
                [weakSelf.cancelButton setTitle:@"跳过" forState:UIControlStateNormal];
                weakSelf.view.window.rootViewController = weakSelf.rootController;
            }
        });
    });
    //启动源
    dispatch_resume(timer);
}

- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
}

- (void)setCancelButtonShow:(BOOL)cancelButtonShow
{
    _cancelButtonShow = cancelButtonShow;
    if (_cancelButtonShow){
        // 加载完毕开始倒计时
        [self startTimer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // pageControl 与 scrollView 联动
    CGFloat offsetWidth = scrollView.contentOffset.x;
    int pageNum = offsetWidth / [[UIScreen mainScreen] bounds].size.width;
    self.pageControl.currentPage = pageNum;
    if (scrollView.contentOffset.x >= scrollView.contentSize.width - K_Screen_width + 40) {
        self.view.window.rootViewController = _rootController;
    }
}

- (void)showGuideViewWithImageArray:(NSArray *)imageArray WindowRootController:(UIViewController *)rootController
{
    _imageArray = imageArray;
    _rootController = rootController;
}

- (void)cancelButtonAction:(UIButton *)sender
{
    self.view.window.rootViewController = _rootController;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
