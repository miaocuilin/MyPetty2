//
//  PermitViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/4.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PermitViewController.h"
@interface PermitViewController ()
{
    UIWebView * permitWebView;
}
@end

@implementation PermitViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView * bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@"blurBg.png"];
    [self.view addSubview:bgImageView];
    
    [self createWebView];
//    [self createScrollView];
    [self createFakeNavigation];
}
- (void)createWebView
{
    permitWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    [self.view addSubview:permitWebView];
    [permitWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:AGREEMENTAPI]]];
    [permitWebView release];
}

//-(void)createScrollView
//{
//    UIImageView * bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@"blurBg.png"];
//    [self.view addSubview:bgImageView];
//    
//    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
//    sv.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:sv];
//    
//    NSString * str = @"    在使用宠物星球服务前，请务必仔细阅读并理解本协议。如果您选择使用宠物星球，您的使用行为将被视为对本协议全部内容的认可及接受，若对本协议有任何异议，请停止使用宠物星球所提供的全部服务。\n1. 特别提示\n1.1 北京市爱迪通信有限责任公司（以下简称“爱迪公司”）同意按照本协议的规定及其不时发布的操作规则提供基于互联网以及移动网的宠物星球分享应当基于了解本协议全部内容，在独立思考的基础上认可、同意本协议的全部条款并按照页面上的提示完成全部的注册程序。用户在进行注册程序过程中点击“同意”按钮即表示用户完全接受《宠物星球使用协议》以及公式的各项规则、规范。\n1.2 用户注册成功后，爱迪公司将为用户基于宠物星球服务使用的客观需要而在申请、注册宠物星球服务时，按照注册要求提供的账号开通宠物星球服务，用户有权在爱迪公司为其开通、并同意向其提供服务的基础上使用宠物星球服务。该用户账号和密码由用户负责保管；用户使用宠物星球服务过程中，须对自身使用宠物星球的行为，对任何由用户通过宠物星球发布、公开的信息，以及对由此产生的任何后果承担全部责任。用户提交、发布或显示的信息将对其他宠物星球用户及第三方服务及网站可见（用户通过设置功能自行控制、把握可查阅其信息的账号类型）。\n1.3 为提高用户的宠物星球使用感受和满意感，用户同意爱迪公司将基于用户的操作行为对用户数据进行调查研究和分析，从而进一步优化宠物星球服务。\n2. 服务内容\n2.1 宠物星球服务的具体内容由爱迪公司根据实际情况提供，包括但不限于授权用户通过其账号，使用宠物星球服务发布观点、评论、图片、转发链接等，爱迪公司有权对其提供的服务或产品形象进行升级或其他调整，并将及时更新页面/告知用户。\n2.2 用户理解，爱迪公司仅提供与宠物星球服务相关的技术服务等，除此之外与相关网络服务有关的设备（如个人电脑、手机、及其他与接入互联网或移动网有关的装置）及所需的费用（如为接入互联网而支付的电话费及上网费、为使用移动网而支付的手机费）均由用户自行负担。\n3. 服务变更、中断或终止\n3.1 鉴于网络服务的特殊性（包括但不限于服务器的稳定性问题、恶意的网络攻击等行为的存在及其他爱迪公司无法控制的情形），用户同意爱迪公司有权随时中断或终止宠物星球部分或全部的宠物星球服务，若发生该等中断或终止宠物星球服务的情形，爱迪公司将尽可能及时通过网页广告、系统通知、私信、短信提醒或其他合理方式通知受到影响的用户。\n3.2 用户理解，爱迪公司需要定期或不定期地对提供宠物星球服务的平台(如互联网网站、 移动网络等)或相关的设备进行检修或者维护，如因此类情况而造成服务在合理时间内的中断，爱迪公司无需为此承担任何责任，但爱迪公司应尽可能事先进行通告。\n3.3 如发生下列任何一种情形，爱迪公司有权随时中断或终止向用户提供本协议项下的宠物星球服务而无需对用户或任何第三万承担任何责任：\n3.3.1 用户提供的个人资料不真实；\n3.3.2 用户违反法律法规国家政策或本协议中规定的使用规则。\n3.4 用户选择将宠物星球帐号与宠物星球合作的第三方帐号进行绑定的，除用户自行解除绑定关系外，如发生下列任何一种情形，用户已绑定的第三方帐号也有可能被解除绑定而爱迪公司无需对用户或任何第三方承担任何责任：\n3.4.1 用户违反法律法规国家政策、本协议或《宠物星球网络服务使用协议》的；\n3.4.2 用户违反第三方账户用户协议或其相关规定的；\n3.4.3 其他需要解除绑定的。\n4. 使用规则\n4.1 用户注册宠物星球账号，制作、发布、传播信息内容的，应当使用真实身份信息，不得以虚假、冒用的居民身份证信息、企业注册信息、组织机构代码信息进行注册。\n4.2 若用户违反前述4.1条之约定，依据相关法律、法规及国家政策要求，爱迪公司有权随时终止用户对宠物星球服务的使用且不承担违约责任。\n4.3 爱迪公司将建立健全用户信息安全管理制度、落实技术安全防控措施。爱迪公司将对用户使用宠物星球服务过程中涉及的用户隐私内容加以保护。\n4.4 用户在使用宠物星球服务时，爱迪公司有权基于安全运营、社会公共安全的需要或国家政策的要求，要求用户提供准确的个人资料，如用户提供的个人资料有任何变动，导致用户的实际情况与用户提交给爱迪公司的信息不一致的，用户应及时更新。\n4.5 由于宠物星球服务的存在前提是用户在申请开通宠物星球服务的过程中所提供的帐号，则用户不应将其账号、密码转让或出借予他人使用。如用户发现其帐号或宠物星球服务遭他人非法使用，应立即通知爱迪公司。因黑客行为或用户的保管疏忽导致帐号、密码及宠物星球服务遭他人非法使用，爱迪公司有权拒绝承担任何责任。\n4.6 对于用户通过宠物星球服务公开发布的任何内容，用户同意爱迪公司在全世界范围内具有免费的、永久性的、不可撤销的、非独家的和完全再许可的权利和许可，以使用、复制、修改、改编、出版、翻译、据以创作衍生作品、传播、表演和展示此等内容 (整体或部分)，和/或将此等内容编入当前已知的或以后开发的其他任何形式的作品、媒体或技术中。\n4.7 用户在使用宠物星球服务过程中，必须遵循以下原则：\n4.7.1 遵守中国有关的法律和法规；\n4.7.2 遵守所有与网络服务、宠物星球服务有关的网络协议、规定和程序；\n4.7.3 不得为任何非法目的而使用宠物星球服务系统；\n4.7.4 不得以任何形式使用宠物星球服务侵犯爱迪公司的权利和/或利益；\n4.7.5 不得利用宠物星球服务系统进行任何可能对互联网或移动网正常运转造成不利影响的行为；\n4.7.6 不得利用爱迪公司提供的阿猫阿后服务上传、展示或传播任何虚假的、骚扰性的、中伤他人的、种族歧视性的、辱骂性的、恐吓性的、成人色情的或其他任何非法的信息资料；\n4.7.7 不得以任何方式侵犯其他任何人依法享有的专利权、著作权、商标权、名誉权或其他任何合法权益；\n4.7.8 不得利用宠物星球服务系统进行任何不利于爱迪公司的行为。\n4.8 用户在使用宠物星球服务的过程中应文明发言，并依法尊重其他用户的人格权与个人隐私，共同建立和谐、文明、礼貌的网络社交环境。\n4.9 如用户在使用宠物星球服务的过程中遇到其他用户上传违法、侵权、侮辱、诽谤等内容，可直接点击“举报”按键进行举报，相关人员会尽快核实并进行处理。如用户认为所举报的内容侵犯了用户合法权利，请用户尽快向司法机关寻求帮助，爱迪公司将依法配合司法机关的调查取证工作。\n5. 知识产权\n5.1 爱迪公司提供的网络服务中包含的任何文本、图片、图形、商标和/或其它财产所有权法律的保护，未经相关权利人同意，上述资料均不得在任何媒体直接或间接发布、播放、出于播放或发布目的而改写或再发行，或者被用于其他任何商业目的。所有这些资料或资料的任何部分仅可作为私人和非商业用途而保存在某台计算机内。爱迪公司不就由上述资料产生或在传送或递交全部或部分上述资料过程中产生的延误、不准确、错误和遗漏或从中产生或由此产生的任何损害赔偿，以任问形式，向用户或任何第三方负责\n6. 隐私保护\n6.1 本协议所指的“隐私”包括《电信和互联网用户个人信息保护规定》第4条规定的用户个人信息的内容以及未来不时制定或修订的法律中明确规定的隐私应包括的内容。\n6.2 保护用户隐私是爱迪公司的一项基本政策，爱迪公司保证不会将单个用户的注册资料及用户在使用宠物星球服务时存储在爱迪公司的非公开内容用于任何非法的用途，且保证将单个用户的注册资料进行商业上的利用时应事先获得用户的同意，但下列情况除外：\n6.2.1 事先获得用户的明确授权；\n6.2.2 根据有关的法律法规要求；\n6.2.3 按照相关政府主管部门的要求；\n6.2.4 为维护社会公众的利益；\n6.2.5 用户侵害本协议项下爱迪公司的护法权益的情况下而为维护爱迪公司的合法权益所必须。\n7. 免责声明\n7.1 用户在使用宠物星球服务的过程中应遵守国家法律法规及政策规定，因其使用宠物星球服务而产生的行为后果由用户自行承担。\n7.2 通过宠物星球发布的任何信息，及通过宠物星球传递的任何观点不代表爱迪公司之立场，爱迪公司亦不对其完整性、真实性、准确性或可靠性负责。用户对于可能会接触到的非法的、非道德的、错误的或存在其他失宜之处的信息，及被错误归类或是带有欺骗性的发布内容，应自行作出判断。在任何情况下，对于任何信息，包括但不仅限于其发生的任何错误或遗漏；或是由于使用通过宠物星球服务发布、私信、传达、其他方式所释放出的或在别处传播的信息，而造成的任何损失或伤害，应由相关行为主体承担全部责任。\n7.3 鉴于外部链接指向的网页内容非爱迪公司实际控制的，因此爱迪公司无法保证为向用户提供便利而设置的外部链接的准确性和完整性。\n8. 违约赔偿\n8.1 如因爱迪公司违反有关法律、法规或本协议项下的任何条款而给用户造成损失，爱迪公司同意承担由此造成的损害赔偿责任。\n8.2 用户同意保障和维护爱迪公司级其他用户的利益，如因用户违反有关法律、法规或本协议项下的任何条款而给爱迪公司或任何其他第三方造成损失，用户同意承担由此造成的损害赔偿责任。\n9. 协议修改\n9.1 爱迪公司有权随时修改本协议的任何条款，一旦本协议的内容发生变动，爱迪公司将会在宠物星球网站上公布修改之后的协议内容，若用户不同意上述修改，则可以选择停止使用宠物星球服务。爱迪公司也可选择通过其他适当的方式（比如系统通知）向用户通知修改内容。\n9.2 如果不同意爱迪公司对本协议相关条款所做的修改，用户有权停止使用宠物星球服务。如果用户继续使用宠物星球服务，则视为用户接受爱迪公司对本协议相关条款所做的修改。\n10. 通知送达\n10.1 本协议项下爱迪公司对与用户所有的通知均可通过网页公告、系统通知、宠物星球管理账号主动联系、私信等方式进行；该等通知于发送之日视为已送达收件人。\n10.2 用户对于爱迪公司的通知应当通过爱迪公司对外正式公布的通信地址、传真号码、电子邮件地址等联系信息进行送达。\n11. 法律适用\n11.1 宠物星球依据并贯彻中华人民共和国法律法规、政策规章及司法解释之要求，包括但不限于《全国人民代表大会常务委员会关于加强网络信息保护的决定》、《最高人民法院最高人民检察院适用法律若干问题的解释》等文件精神，制定《宠物星球服务使用协议》\n11.2 本协议的订立、执行和解释及争议的解决均应适用中国法律并受中国法院管辖。\n11.3 如双方就本协议内容或其执行发生任何争议，双方应尽量友好协商解决；协商不成时，任何一方均可向爱迪公司所在地的人民法院提起诉讼。\n12. 其他规定\n12.1 本协议构成双方对本协议之约定事项及其他有关事宜的完整协议，除本协议规定的之外，未赋予本协议各方其他权利。\n12.2 如本协议中的任何条款无论因何种原因完全或部分无效或不具有执行力，本协议的其余条款仍应有效并且有约束力。\n12.3 本协议中的标题仅为方便而设，在解释本协议时应被忽略。";
//
//    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(self.view.frame.size.width-20, 5000) lineBreakMode:1];
//    sv.contentSize = CGSizeMake(self.view.frame.size.width, 30+size.height+10);
//    UILabel * label = [MyControl createLabelWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, size.height) Font:12 Text:str];
//    label.textColor = [UIColor blackColor];
//    [sv addSubview:label];
//}
-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    alphaView.alpha = 0.2;
    alphaView.backgroundColor = BGCOLOR;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [navView addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-12, 200, 20) Font:17 Text:@"用户协议"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    //    titleLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [navView addSubview:titleLabel];
}
-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
