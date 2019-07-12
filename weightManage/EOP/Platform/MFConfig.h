//
//  MFConfig.h
//  linju
//
//  Created by Pill.Gong on 10/20/15.
//

#ifndef MFConfig_h
#define MFConfig_h

#ifdef PROD
#define MFConfigFilePath ([[NSBundle mainBundle] pathForResource:@"MFConfig_prod" ofType:@"plist"])
#elif UAT
#define MFConfigFilePath ([[NSBundle mainBundle] pathForResource:@"MFConfig_uat" ofType:@"plist"])
#elif QA
#define MFConfigFilePath ([[NSBundle mainBundle] pathForResource:@"MFConfig_qa" ofType:@"plist"])
#else
#define MFConfigFilePath ([[NSBundle mainBundle] pathForResource:@"MFConfig" ofType:@"plist"])
#endif


/*** For Log Start ***/

//#define ShowLvlOne
//#define ShowLvlTwo
#define ShowLvlThree

#ifdef DEBUG
//#define MFLog(...) printf("\nMF: %d %s\n", __LINE__, [__VA_ARGS__ UTF8String])
#define MFLog(...) printf("\nMF:%s line:%d \n%s\n",__FUNCTION__, __LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
//
#ifdef ShowLvlOne
#define MFLogOne(...) printf("\nMF1:%s line:%d \n%s\n",__FUNCTION__, __LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#define MFLogTwo(...);
#define MFLogThree(...);
#endif

#ifdef ShowLvlTwo
#define MFLogOne(...) printf("\nMF1:%s line:%d \n%s\n",__FUNCTION__, __LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#define MFLogTwo(...) printf("\nMF2:%s line:%d \n%s\n",__FUNCTION__, __LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#define MFLogThree(...);
#endif

#ifdef ShowLvlThree
#define MFLogOne(...) printf("\nMF1:%s line:%d \n%s\n",__FUNCTION__, __LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#define MFLogTwo(...) printf("\nMF2:%s line:%d \n%s\n",__FUNCTION__, __LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#define MFLogThree(...) printf("\nMF3:%s line:%d \n%s\n",__FUNCTION__, __LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#endif

#else
#define MFLog(...);
#define MFLogOne(...);
#define MFLogTwo(...);
#define MFLogThree(...);
#endif

/*** For Log End ***/

#endif /* MFConfig_h */
