//
//  OCSearchResultM.h
//  QiangGuoPlugs
//
//  Created by 张贺 on 2021/3/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCSearchResultWordsM : NSObject

@property (nonatomic, strong) NSString *words;

@end

@interface OCSearchResultM : NSObject

@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSMutableArray<OCSearchResultWordsM *> *words_result;

@end

NS_ASSUME_NONNULL_END
