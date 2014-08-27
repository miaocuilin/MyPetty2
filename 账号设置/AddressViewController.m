//
//  AddressViewController.m
//  MyPetty
//
//  Created by zhangjr on 14-8-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "AddressViewController.h"
#import "IQKeyboardManager.h"
//static NSString *receiveName;
//static NSString *telphone;
//static NSString *codeNumber;
//static NSString *area;
//static NSString *detailarea;
@interface AddressViewController ()

@property(nonatomic,retain)UIImageView * bgImageView;

@end

@implementation AddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    [self getCityData];
    [self createIQ];
    [self createBg];
    [self createBody];
    [self performSelector:@selector(createNavgation) withObject:nil afterDelay:0.1f];
//    [self createNavgation];

}

- (void)createIQ
{
    //Enabling keyboard manager
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:20];
	//Enabling autoToolbar behaviour. If It is set to NO. You have to manually create UIToolbar for keyboard.
	[[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
	//Setting toolbar behavious to IQAutoToolbarBySubviews. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order.
	[[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    //Resign textField if touched outside of UITextField/UITextView.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
}
- (void)createNavgation
{
    UIView *nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    nav.backgroundColor = BGCOLOR;
    nav.layer.opacity = 0.85;
    [self.view addSubview:nav];
    [nav release];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 30, 20, 20) ImageName:@"7-7.png"];
    [nav addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(comeBackAction) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [nav addSubview:backBtn];
    
//    UIButton *comeBack = [MyControl createButtonWithFrame:CGRectMake(5, 25, 25, 25) ImageName:@"7-7.png" Target:self Action:@selector(comeBackAction) Title:nil];
//    [nav addSubview:comeBack];
    
    
    UIButton *changeButton = [MyControl createButtonWithFrame:CGRectMake(320-50-10, 32, 50, 20) ImageName:@"greenBtnBg.png" Target:self Action:@selector(buttonAction:) Title:@"保存"];
    changeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [nav addSubview:changeButton];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"设置"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [nav addSubview:titleLabel];
}

- (void)createBody
{
    //增加两个键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    UIView * keyboardBgView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 40)];
    keyboardBgView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    UIButton * finishButton = [MyControl createButtonWithFrame:CGRectMake(320-70, 5, 50, 30) ImageName:@"" Target:self Action:@selector(keyBoardFinishButtonClick) Title:@"完成"];
    [keyboardBgView addSubview:finishButton];
    
    bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+20, self.view.bounds.size.width, 215)];
    bodyView.backgroundColor = [UIColor whiteColor];
    bodyView.layer.opacity = 0.6;
    [self.view addSubview:bodyView];
    NSArray *arrayContent = @[@"收货人姓名:",@"手机号码:",@"邮政编码:",@"所在地区:",@"详细地址:"];
    NSArray *arrayInput = @[@"姓名",@"手机号码",@"邮政编码",@"省市直辖市",@"详细地址"];
    for (int i = 0; i<5; i++) {
        UILabel *label = [MyControl createLabelWithFrame:CGRectMake(10, i*(bodyView.bounds.size.height/5), 100, bodyView.bounds.size.height/5) Font:15 Text:arrayContent[i]];
        label.textColor = [UIColor blackColor];
        [bodyView addSubview:label];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, (i+1)*(bodyView.bounds.size.height/5), bodyView.bounds.size.width, 1)];
        lineView.backgroundColor = [UIColor grayColor];
        lineView.alpha = 0.8;
        [bodyView addSubview:lineView];
        
        UITextField *textFieldContent = [MyControl createTextFieldWithFrame:CGRectMake(label.bounds.origin.x+label.bounds.size.width+10, i*(bodyView.bounds.size.height/5)+3, 200, bodyView.bounds.size.height/5-3) placeholder:arrayInput[i] passWord:NO leftImageView:nil rightImageView:nil Font:15];
        textFieldContent.borderStyle = UITextBorderStyleNone;
        textFieldContent.textColor=BGCOLOR;
        textFieldContent.delegate = self;
        textFieldContent.tag = 100+i;
        if (textFieldContent.tag == 101 ||textFieldContent.tag == 102) {
            textFieldContent.keyboardType = UIKeyboardTypeNumberPad;
            textFieldContent.inputAccessoryView = keyboardBgView;
        }
        [bodyView addSubview:textFieldContent];
    }
    
    /*****城市地区选择器*****/
    pickerBgView2 = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 200)];
    //    pickerBgView.alpha = 0.9;
    [self.view addSubview:pickerBgView2];
    pickerBgView2.hidden = YES;
    
    //pickerView
    picker2 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    picker2.delegate = self;
    picker2.dataSource = self;
    [picker2 selectRow: 0 inComponent: 0 animated: YES];
    [pickerBgView2 addSubview:picker2];
    
    UIButton * confirmButton2 = [MyControl createButtonWithFrame:CGRectMake(320-80, 150, 50, 30) ImageName:@"" Target:self Action:@selector(confirmButtonClick2) Title:@"确认"];
    [confirmButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pickerBgView2 addSubview:confirmButton2];
}
- (void)keyBoardFinishButtonClick
{
    UITextField *keyBoardFinish = (UITextField *)[bodyView viewWithTag:101];
    [keyBoardFinish resignFirstResponder];
    UITextField *keyBoardFinish1 = (UITextField *)[bodyView viewWithTag:102];
    [keyBoardFinish1 resignFirstResponder];
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    
}
#pragma mark - 获取省市直辖市的plist文件信息
-(void)getCityData
{
    //获取本地plist文件
    NSBundle *bundle = [NSBundle mainBundle];
	NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
	areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    //将所有key取出进行排序
    NSArray *components = [areaDic allKeys];
    //    NSLog(@"%@", components);
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
	NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        //        NSLog(@"%@", sortedArray[i]);
        NSString *index = [sortedArray objectAtIndex:i];
        //        NSLog(@"%@", index);
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        //        NSLog(@"%@", tmp);
        //省份，就一个，所以取第0个元素
        [provinceTmp addObject: [tmp objectAtIndex:0]];
        
    }
    //province中含有各个省的名称，供picker第一列用
    province = [[NSArray alloc] initWithArray: provinceTmp];
    [provinceTmp release];
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
    
    //取出所有市区的键值
    NSArray * cityArray = [dic allKeys];
    //城市key值排序
    NSArray *sortedArray2 = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;//递减
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;//上升
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    //从排序后的key值，取出相应value
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray2 count]; i++) {
        NSString *index = [sortedArray2 objectAtIndex:i];
        NSArray *temp = [[dic objectForKey: index] allKeys];
        [array addObject: [temp objectAtIndex:0]];
    }
    
    [city release];
    city = [[NSArray alloc] initWithArray: array];
    [array release];
    selectedProvince = [province objectAtIndex: 0];
}
-(void)confirmButtonClick2
{
    //点击获取当前省，市，地区
    NSInteger provinceIndex = [picker2 selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [picker2 selectedRowInComponent: CITY_COMPONENT];
    //    NSInteger districtIndex = [picker2 selectedRowInComponent: DISTRICT_COMPONENT];
    
    NSString *provinceStr = [province objectAtIndex: provinceIndex];
    NSString *cityStr = [city objectAtIndex: cityIndex];
    //    NSString *districtStr = [district objectAtIndex:districtIndex];
    
    //特别行政区的判断
    if ([provinceStr isEqualToString: cityStr]) {
        cityStr = @"";
        //        districtStr = @"";
        //    }
        //    else if ([cityStr isEqualToString: districtStr]) {
        //        districtStr = @"";
    }else if([provinceStr isEqualToString: cityStr]){
        cityStr = @"";
    }
    
    NSString *showMsg = [NSString stringWithFormat: @"%@%@", provinceStr, cityStr];
    UITextField *tfCity = (UITextField *)[bodyView viewWithTag:103];
    tfCity.text = showMsg;
    
    pickerBgView2.hidden = YES;
}
#pragma mark - TextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 103) {
        pickerBgView2.hidden = NO;
        [textField resignFirstResponder];
        return NO;
    }
    pickerBgView2.hidden = YES;
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -PickerViewDataSourceAndDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province count];
    }
    else if (component == CITY_COMPONENT) {
        return [city count];
    }
    else {
        return [district count];
    }
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //picker2
    if (component == PROVINCE_COMPONENT) {
        selectedProvince = [province objectAtIndex: row];
        //取出省
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%d", row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        //取出城市
        NSArray *cityArray = [dic allKeys];
        //城市key值排序
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        //从排序后的key值，取出相应value
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        
        [city release];
        city = [[NSArray alloc] initWithArray: array];
        [array release];
        //刷新2，3列
        [picker2 reloadComponent: CITY_COMPONENT];
        
        //市和地区归零显示
        [picker2 selectRow:0 inComponent:CITY_COMPONENT animated:YES];
        //刷新2，3列
        [picker2 reloadComponent: CITY_COMPONENT];
        
    }
    else if (component == CITY_COMPONENT) {
    }
    
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province objectAtIndex: row];
    }
    else if (component == CITY_COMPONENT) {
        return [city objectAtIndex: row];
    }
    else {
        return [district objectAtIndex: row];
    }
    
    
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    if (component == PROVINCE_COMPONENT) {
        return 150;
    }else{
        return 150;
    }
    
}

- (void)comeBackAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)buttonAction:(UIButton *)sender
{
    NSLog(@"%@",sender.currentTitle);
//    if ([sender.currentTitle isEqualToString:@"保存"]) {
//        for (int i = 0; i < 5; i++) {
//            UITextField *textField = (UITextField *)[bodyView viewWithTag:100+i];
//            textField.enabled = NO;
//        }
//        [sender setTitle:@"修改" forState:UIControlStateNormal];
//    }else{
//        for (int i = 0; i < 5; i++) {
//            UITextField *textField = (UITextField *)[bodyView viewWithTag:100+i];
//            textField.enabled = YES;
//        }
//        [sender setTitle:@"保存" forState:UIControlStateNormal];
//    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createBg
{
    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:self.bgImageView];
    //    self.bgImageView.backgroundColor = [UIColor redColor];
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"blurBg.png"]];
    NSLog(@"%@", filePath);
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    //    NSLog(@"%@", data);
    UIImage * image = [UIImage imageWithData:data];
    self.bgImageView.image = image;
    //    self.bgImageView.image = [UIImage imageNamed:@"Default-568h@2x.png"];
    
    //毛玻璃化，需要先设置图片再设置其他
//    [self.bgImageView setFramesCount:20];
//    [self.bgImageView setBlurAmount:1];
    
    //这里必须延时执行，否则会变白
    //注意，由于图片较大，这里需要的时间必须在2秒以上
//    [self performSelector:@selector(blurImage) withObject:nil afterDelay:0.25f];
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.view addSubview:tempView];
}



@end
