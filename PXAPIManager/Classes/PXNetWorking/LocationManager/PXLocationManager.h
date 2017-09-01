//
//  PXLocationManager.h
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/6/26.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSUInteger, PXLocationManagerLocationServiceStatus) {
    PXLocationManagerLocationServiceStatusDefault,               //默认状态
    PXLocationManagerLocationServiceStatusOK,                    //定位功能正常
    PXLocationManagerLocationServiceStatusUnknownError,          //未知错误
    PXLocationManagerLocationServiceStatusUnAvailable,           //定位功能关掉了
    PXLocationManagerLocationServiceStatusNoAuthorization,       //定位功能打开，但是用户不允许使用定位
    PXLocationManagerLocationServiceStatusNoNetwork,             //没有网络
    PXLocationManagerLocationServiceStatusNotDetermined          //用户还没做出是否要允许应用使用定位功能的决定，第一次安装应用的时候会提示用户做出是否允许使用定位功能的决定
};

typedef NS_ENUM(NSUInteger, PXLocationManagerLocationResult) {
    PXLocationManagerLocationResultDefault,              //默认状态
    PXLocationManagerLocationResultLocating,             //定位中
    PXLocationManagerLocationResultSuccess,              //定位成功
    PXLocationManagerLocationResultFail,                 //定位失败
    PXLocationManagerLocationResultParamsError,          //调用API的参数错了
    PXLocationManagerLocationResultTimeout,              //超时
    PXLocationManagerLocationResultNoNetwork,            //没有网络
    PXLocationManagerLocationResultNoContent             //API没返回数据或返回数据是错的
};




@interface PXLocationManager : NSObject

@property (nonatomic, assign, readonly) PXLocationManagerLocationResult locationResult;
@property (nonatomic, assign,readonly) PXLocationManagerLocationServiceStatus locationStatus;
@property (nonatomic, copy, readonly) CLLocation *currentLocation;

+ (instancetype)shareInstance;

- (void)startLocation;
- (void)stopLocation;
- (void)restartLocation;

@end
