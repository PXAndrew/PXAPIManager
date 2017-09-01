//
//  PXLocationManager.m
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/6/26.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import "PXLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface PXLocationManager () <CLLocationManagerDelegate>

@property (assign, nonatomic, readwrite) PXLocationManagerLocationServiceStatus locationStatus;

@property (assign, nonatomic, readwrite) PXLocationManagerLocationResult locationResult;

@property (copy, nonatomic, readwrite) CLLocation *currentLocation;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation PXLocationManager

#pragma mark - Public Method
+ (instancetype)shareInstance {
    static PXLocationManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PXLocationManager alloc] init];
    });
    return instance;
}

- (void)startLocation {
    if ([self checkLocationStatus]) {
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            NSLog(@"requestAlwaysAuthorization");
            [self.locationManager requestAlwaysAuthorization];
        }
        self.locationStatus = PXLocationManagerLocationResultLocating;    // 定位中
        [self.locationManager startUpdatingLocation];
    } else {
        [self failedLocationWithResultType:PXLocationManagerLocationResultFail statusType:self.locationStatus];
    }
}

- (void)stopLocation {
    if ([self checkLocationStatus]) {
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)restartLocation {
    [self stopLocation];
    [self startLocation];
}

#pragma mark - Private Method
- (void)failedLocationWithResultType:(PXLocationManagerLocationResult)result statusType:(PXLocationManagerLocationServiceStatus)status {
    self.locationResult = result;
    self.locationStatus = status;
}

- (BOOL)checkLocationStatus {
    BOOL result = NO;
    BOOL serviceEnable = [self locationServiceEnabled];
    PXLocationManagerLocationServiceStatus authorizationStatus = [self locationServiceStatus];
    if (authorizationStatus == PXLocationManagerLocationServiceStatusOK && serviceEnable) {
        result = YES;
    } else if (authorizationStatus == PXLocationManagerLocationServiceStatusNotDetermined) {
        result = YES;
    } else {
        result = NO;
    }
    
    if (serviceEnable && result) {
        result = YES;
    } else {
        result = NO;
    }
    
    if (result == NO) {
        [self failedLocationWithResultType:PXLocationManagerLocationResultFail statusType:self.locationStatus];
    }
    
    return result;
}

- (PXLocationManagerLocationServiceStatus)locationServiceStatus {
    self.locationStatus = PXLocationManagerLocationServiceStatusUnknownError;
    BOOL serviceEnable = [CLLocationManager locationServicesEnabled];
    if (serviceEnable) {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        switch (authorizationStatus) {
            case kCLAuthorizationStatusNotDetermined:
                self.locationStatus = PXLocationManagerLocationServiceStatusNotDetermined;    // 用户还没做出选择是否允许定位
                break;
                
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                self.locationStatus = PXLocationManagerLocationServiceStatusOK;   // 定位功能正常
                break;
                
            case kCLAuthorizationStatusDenied:
                self.locationStatus = PXLocationManagerLocationServiceStatusNoAuthorization;  // 定位功能打开，但是用户不允许使用定位
                break;
                
            default:
                break;
        }
    } else {
        self.locationStatus = PXLocationManagerLocationServiceStatusUnAvailable;  // 定位功能关掉了
    }
    return self.locationStatus;
}


/**
 检测定位功能是否开启

 @return 定位功能是否正常
 */
- (BOOL)locationServiceEnabled {
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationStatus = PXLocationManagerLocationServiceStatusOK;   // 定位功能正常
        return YES;
    } else {
        self.locationStatus = PXLocationManagerLocationServiceStatusUnknownError; // 位置错误
        return NO;
    }
}


#pragma mark - <CLLocationManagerDelegate>
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.currentLocation = [manager.location copy];
    NSLog(@"Current location is %@", self.currentLocation);
    [self stopLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //如果用户还没选择是否允许定位，则不认为是定位失败
    if (self.locationStatus == PXLocationManagerLocationServiceStatusNotDetermined) {
        return;
    }
    
    //如果正在定位中，那么也不会通知到外面
    if (self.locationResult == PXLocationManagerLocationResultLocating) {
        return;
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.locationStatus = PXLocationManagerLocationServiceStatusOK;
        [self restartLocation];
    } else {
        if (self.locationStatus != PXLocationManagerLocationServiceStatusNotDetermined) {
            [self failedLocationWithResultType:PXLocationManagerLocationResultDefault statusType:PXLocationManagerLocationServiceStatusNoAuthorization];
        } else {
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager startUpdatingLocation];
        }
    }
}

#pragma mark - getters and setters
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

@end
