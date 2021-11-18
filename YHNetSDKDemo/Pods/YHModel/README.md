# YHModel

使用方法
==============

### 简单的 Model 与 JSON 相互转换
```objc
// JSON:
{
    "uid":123456,
    "name":"Harry",
    "created":"1965-07-31T00:00:00+0000"
}

// Model:
@interface User : NSObject
@property UInt64 uid;
@property NSString *name;
@property NSDate *created;
@end
@implementation User
@end

    
// 将 JSON (NSData,NSString,NSDictionary) 转换为 Model:
User *user = [User yh_modelWithJSON:json];
    
// 将 Model 转换为 JSON 对象:
NSDictionary *json = [user yh_modelToJSONObject];
```

当 JSON/Dictionary 中的对象类型与 Model 属性不一致时，YHModel 将会进行如下自动转换。自动转换不支持的值将会被忽略，以避免各种潜在的崩溃问题。
<table>
  <thead>
    <tr>
      <th>JSON/Dictionary</th>
      <th>Model</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>NSString</td>
      <td>NSNumber,NSURL,SEL,Class</td>
    </tr>
    <tr>
      <td>NSNumber</td>
      <td>NSString</td>
    </tr>
    <tr>
      <td>NSString/NSNumber</td>
      <td>基础类型 (BOOL,int,float,NSUInteger,UInt64,...)<br/>
      NaN 和 Inf 会被忽略</td>
    </tr>
    <tr>
      <td>NSString</td>
      <td>NSDate 以下列格式解析:<br/>
      yyyy-MM-dd<br/>
yyyy-MM-dd HH:mm:ss<br/>
yyyy-MM-dd'T'HH:mm:ss<br/>
yyyy-MM-dd'T'HH:mm:ssZ<br/>
EEE MMM dd HH:mm:ss Z yyyy
      </td>
    </tr>
    <tr>
      <td>NSDate</td>
      <td>NSString 格式化为 ISO8601:<br/>
      "YYYY-MM-dd'T'HH:mm:ssZ"</td>
    </tr>
    <tr>
      <td>NSValue</td>
      <td>struct (CGRect,CGSize,...)</td>
    </tr>
    <tr>
      <td>NSNull</td>
      <td>nil,0</td>
    </tr>
    <tr>
      <td>"no","false",...</td>
      <td>@(NO),0</td>
    </tr>
    <tr>
      <td>"yes","true",...</td>
      <td>@(YES),1</td>
    </tr>
  </tbody>
</table>


### Model 属性名和 JSON 中的 Key 不相同
```objc
// JSON:
{
    "n":"Harry Pottery",
    "p": 256,
    "ext" : {
        "desc" : "A book written by J.K.Rowing."
    },
    "ID" : 100010
}

// Model:
@interface Book : NSObject
@property NSString *name;
@property NSInteger page;
@property NSString *desc;
@property NSString *bookID;
@end
@implementation Book
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name" : @"n",
             @"page" : @"p",
             @"desc" : @"ext.desc",
             @"bookID" : @[@"id",@"ID",@"book_id"]};
}
@end
```
    
你可以把一个或一组 json key (key path) 映射到一个或多个属性。如果一个属性没有映射关系，那默认会使用相同属性名作为映射。

在 json->model 的过程中：如果一个属性对应了多个 json key，那么转换过程会按顺序查找，并使用第一个不为空的值。
    
在 model->json 的过程中：如果一个属性对应了多个 json key (key path)，那么转换过程仅会处理第一个 json key (key path)；如果多个属性对应了同一个 json key，则转换过过程会使用其中任意一个不为空的值。

### Model 包含其他 Model
```objc
// JSON
{
    "author":{
        "name":"J.K.Rowling",
        "birthday":"1965-07-31T00:00:00+0000"
    },
    "name":"Harry Potter",
    "pages":256
}

// Model: 什么都不用做，转换会自动完成
@interface Author : NSObject
@property NSString *name;
@property NSDate *birthday;
@end
@implementation Author
@end
    
@interface Book : NSObject
@property NSString *name;
@property NSUInteger pages;
@property Author *author; //Book 包含 Author 属性
@end
@implementation Book
@end
```    

### 容器类属性
```objc
@class Shadow, Border, Attachment;

@interface Attributes
@property NSString *name;
@property NSArray *shadows; //Array<Shadow>
@property NSSet *borders; //Set<Border>
@property NSMutableDictionary *attachments; //Dict<NSString,Attachment>
@end

@implementation Attributes
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"shadows" : [Shadow class],
             @"borders" : Border.class,
             @"attachments" : @"Attachment" };
}
@end
```

### 黑名单与白名单
```objc
@interface User
@property NSString *name;
@property NSUInteger age;
@end
    
@implementation Attributes
// 如果实现了该方法，则处理过程中会忽略该列表内的所有属性
+ (NSArray *)modelPropertyBlacklist {
    return @[@"test1", @"test2"];
}
// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return @[@"name"];
}
@end
```

### 数据校验与自定义转换
```objc    
// JSON:
{
    "name":"Harry",
    "timestamp" : 1445534567
}
    
// Model:
@interface User
@property NSString *name;
@property NSDate *createdAt;
@end

@implementation User
// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSNumber *timestamp = dic[@"timestamp"];
    if (![timestamp isKindOfClass:[NSNumber class]]) return NO;
    _createdAt = [NSDate dateWithTimeIntervalSince1970:timestamp.floatValue];
    return YES;
}
    
// 当 Model 转为 JSON 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    if (!_createdAt) return NO;
    dic[@"timestamp"] = @(n.timeIntervalSince1970);
    return YES;
}
@end
```

### Coding/Copying/hash/equal/description
```objc
@interface YYShadow :NSObject <NSCoding, NSCopying>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGSize size;
@end

@implementation YYShadow
// 直接添加以下代码即可自动完成
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yh_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yh_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yh_modelCopy]; }
- (NSUInteger)hash { return [self yh_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yh_modelIsEqual:object]; }
- (NSString *)description { return [self yh_modelDescription]; }
@end
```

安装
==============

### CocoaPods

1. 在 Podfile 中添加 `pod 'YHModel'`。
2. 执行 `pod install` 或 `pod update`。
3. 导入 \<YHModel/YHModel.h\>。


### 手动安装

1. 下载 YHModel 文件夹内的所有内容。
2. 将 YHModel 内的源文件添加(拖放)到你的工程。
3. 导入 `YHModel.h`。


文档
==============
你可以在 [CocoaDocs](http://cocoadocs.org/docsets/YYModel/) 查看在线 API 文档，也可以用 [appledoc](https://github.com/tomaz/appledoc) 本地生成文档。


# 版本记录
## V1.0.1

2020年04月20日

```
1、deployment target设为 iOS 8.0
```
