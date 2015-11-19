//
//  ViewController.m
//  Test3
//
//  Created by Victor on 15/11/11.
//  Copyright © 2015年 Victor. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
#import "PBImageStorage.h"
#import "SIAlertView.h"
#import "TableVC.h"
#import "Test.h"
@interface ViewController ()
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self testPBIS];
    //[self testFMDB];
    //[self insert];
    //[self testURLCache];
    //[self testforin];
    [self testPredicate];
    //[self testGetAllDir];
    //[self testDescription];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //TableVC *table = [TableVC new];
    //[self presentViewController:table animated:YES completion:nil];
    //[self insert];
    //[self delete];
    //[self addColumn];
    
    //[self testSIAlertView];
    [self testAlertController];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)testPBIS {
    self.img = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    [self.view addSubview:self.img];
    
    UIImage *jpg = [UIImage imageNamed:@"a.jpg"];
    
    PBImageStorage *storage = [[PBImageStorage alloc] initWithNamespace:@"myStorage"];
    [storage setImage:jpg forKey:@"first" diskOnly:NO completion:^{
        NSLog(@"Image has been saved to disk");
    }];
    
    
    [storage imageForKey:@"first" completion:^(UIImage *image) {
        self.img.image = image;
        NSLog(@"Image %p with size %@ has been retrieved from storage.", image, NSStringFromCGSize(image.size));
    }];
    NSString *sandBox = [NSSearchPathForDirectoriesInDomains(13, 1, 1) lastObject];
    NSLog(@"%@",sandBox);
    
    /*
    //可获得原图缩放一定倍数的image
    [storage imageForKey:@"first" scaledToFit:CGSizeMake(500, 500) completion:^(BOOL cached, UIImage *image) {
        self.img.image = image;
    }];
     */
    
}

- (void)testFMDB {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 1, 1) lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"student.sqlite"];
    NSLog(@"%@",fileName);
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    
    if ([db open]) {
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
        if (result) {
            NSLog(@"success");
        }else {
            NSLog(@"failed");
        }
    }
    self.db = db;
    [db close];
}

- (void)insert {
    for (int i = 0; i < 10; i++) {
        NSString *name = [NSString stringWithFormat:@"student-%i",i];
        [self.db executeUpdate:@"INSERT INTO student (id,name,age) VALUES (?,?,?);",@(i),name,@(i)];
        NSLog(@"exe insert");
    }
}

- (void)delete {
    bool result = [self.db open];
    if (result){
       [self.db executeUpdate:@"delete from student"];
    }
    
    [self.db close];
}

- (void)addColumn {
    BOOL res = [self.db open];
    if (res){
        NSString *sql = @"alter table student,add sex char";
        [self.db executeStatements:sql];
    }
    [self.db close];
}
- (void)testURLCache {
    //NSURL *url = [NSURL URLWithString:@"http://pic14.nipic.com/20110522/7411759_164157418126_2.jpg"];
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    NSURLCache *cache = [NSURLCache sharedURLCache];
    NSLog(@"%@",cache);
    [cache removeCachedResponseForRequest:request];
    
    }


- (void)testforin{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 10; i++){
        Test *test = [[Test alloc] init];
        [arr addObject:test];
    }
    NSLog(@"%i",(int)arr.count);
    
    for (UIView *obj in arr) {
        NSLog(@"%@",obj.description);
    }
}

- (void)testPredicate{
    //本地文件名数组
    NSArray *arr1 = [NSArray arrayWithObjects:@"a",@"b",@"c",@"e", nil];
    
    //网络文件名数组
    NSArray *arr2 = [NSArray arrayWithObjects:@"a",@"b",@"d",@"f",nil];
    
    //创建predicate 进行判断
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",arr1];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"not (self in %@)",arr1];
    NSArray *res = [arr2 filteredArrayUsingPredicate:predicate];
    NSLog(@"结果是: %@",res);
    
    Test *test1 = [Test new];
    test1.name = @"adam";
    test1.age = 10;
    
    Test *test2 = [Test new];
    test2.name = @"bob";
    test2.age = 20;
    NSArray *arrayForTest = [NSArray arrayWithObjects:test1,test2,nil];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name != 'bob'"];
    NSArray *result1 = [arrayForTest filteredArrayUsingPredicate:pre];
    NSLog(@"result: %@",result1);
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        NSString *str = [NSString stringWithFormat:@"%i",i];
        [arr addObject:str];
    }
    //NSPredicate *pre1 = [NSPredicate predicateWithFormat:@""];
}

- (void)testGetAllDir {
    //NSMutableArray *array = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //获取沙盒路径
    NSString *applicationSupport = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    NSString *PBIstorage = [[fileManager contentsOfDirectoryAtPath:applicationSupport error:nil] firstObject];
    NSString *storage = [[fileManager contentsOfDirectoryAtPath:PBIstorage error:nil] firstObject];
    NSArray *storageArray = [fileManager contentsOfDirectoryAtPath:storage error:nil];
    for (NSString *path in storageArray) {
        NSLog(@"++%@",path);
    }
}

- (void)testDescription{
    Test *test = [[Test alloc] init];
    NSLog(@"%@",test);
}

- (void)testSIAlertView{
    SIAlertView *testSIAlertView = [[SIAlertView alloc] initWithTitle:@"测试SIAlertView" andMessage:@"测试Demo"];
    [testSIAlertView addButtonWithTitle:@"btn 1" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
        NSLog(@"按钮一");
    }];
    testSIAlertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    testSIAlertView.layer.borderWidth = 2;
    testSIAlertView.layer.borderColor = [UIColor whiteColor].CGColor;
    testSIAlertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [testSIAlertView show];
}

- (void)testAlertController {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"测试" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {}];
//    
//    [ac addAction:defaultAction];
//    ac.view.backgroundColor = [UIColor blackColor];

    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"密码";
        textField.secureTextEntry = YES;
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Ok %@",ac.textFields.firstObject.text);
    }];
    [ac addAction:okAction];
    [self presentViewController:ac animated:YES completion:nil];
}
@end
