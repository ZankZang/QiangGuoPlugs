//
//  OCQuestionM.h
//  QiangGuoPlugs
//
//  Created by 张贺 on 2021/3/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCQuestionM : NSObject

@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *originalQuestion;
@property (nonatomic, strong) NSString *checkQuestion;
@property (nonatomic, strong) NSString *answer;
@property (nonatomic, strong) NSString *firstImgStr;
@property (nonatomic, strong) NSString *secondImgStr;
@property (nonatomic, strong) NSString *thirdImgStr;

//    var checkQuestion: String = ""
//    var originalQuestion: String = ""
//    var firstImgStr: String = ""
//    var secondImgStr: String = ""
//    var thirdImgStr: String = ""
//    var itemId: String = ""

@end

NS_ASSUME_NONNULL_END
