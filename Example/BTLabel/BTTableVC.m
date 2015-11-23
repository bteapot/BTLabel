//
//  BTTableVC.m
//  BTLabel
//
//  Created by Денис Либит on 22.11.2015.
//  Copyright © 2015 Денис Либит. All rights reserved.
//

#import "BTTableVC.h"


@interface BTTableVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *settings;
@property (nonatomic, strong) NSDictionary *texts;
@property (nonatomic, strong) NSMutableArray *tables;

@end


@implementation BTTableVC

#pragma mark - Constants

static NSString * const kCellID				= @"kCellID";
static NSString * const kFont				= @"kFont";
static NSString * const kTextAlignment		= @"kTextAlignment";
static NSString * const kVerticalAlignment	= @"kVerticalAlignment";
static NSString * const kInsets				= @"kInsets";
static NSString * const kHasImage			= @"kHasImage";
static NSString * const kImageSize			= @"kImageSize";
static NSString * const kImageInsets		= @"kImageInsets";
static NSString * const kImagePosition		= @"kImagePosition";
static NSString * const kImageAlignment		= @"kImageAlignment";
static NSString * const kImageContentMode	= @"kImageContentMode";


#pragma mark - Initialization

//
// -----------------------------------------------------------------------------
- (instancetype)init
{
	self = [super init];
	
	if (self) {
		self.title = @"Tables";
		self.edgesForExtendedLayout = UIRectEdgeNone;
		self.tabBarItem.image = [UIImage imageNamed:@"icon-table"];
	}
	
	return self;
}


//
// -----------------------------------------------------------------------------
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// data source
	self.texts = @{
		@"Маикоп": @"В червленом щите узкий золотой столб, заканчивающийся в главе трилистником, в окончании фрагментом орнамента. Столб сопровождается по сторонам золотыми же стилизованными головами волов. В вершине щита название города, золото.\rУтвержден исполнительным комитетом Майкопского городского Совета депутатов трудящихся в 1970 г.\rАвторы герба художники А.Паршин и А.Винс.",
		@"Барнаул": @"В лазоревом щите среди контуром обозначенных черных гор стилизованная черная же доменная печь с червленым пламенем. В зеленой главе щита бегущая серебряная лошадь.\rУтвержден 5 августа 1846 г.",
		@"Камень-на-Оби": @"В зеленом щите три золотых колоса в столб, сопровождаемые вверху черной шестеренкой, внизу — черным железнодорожным мостом.\rГерб утвержден исполнительным комитетом Каменского городского Совета народных депутатов 8 июня 1976 г., № 99.\rАвтор герба Юрий Игнатьевич Петров.",
		@"Благовещенск": @"В зеленом щите серебряный волнообразный пояс, сопровождаемый во главе щита тремя золотыми восьмилучевыми звездами.\rУтвержден 5 июля 1878 г. как областной (Амурской обл..).",
		@"Архангельск": @"В золотом щите летящий Архангел Михаил в лазоревых доспехах с червлеными щитом и мечом, повергающий черною дьявола.\rУтвержден решением одиннадцатой сессии Архангельского городского Совета 10 октября 1989 г. исторический герб города (ранее утвержден 2 октября 1780 г.).",
		@"Коряжма": @"Щит скошен правой серебряной перевязью, обремененной лазоревой перевязью же. В верхнем зеленом поле серебряный храм. В нижнем червленом поле натурального цвета ель, сопровождаемая слева серебряным бумажным барабаном.\rУтвержден исполнительным комитетом Коряжемского городского Совета народных депутатов 29 января 1988 г., № 33.\rАвтор герба Алексей Григорьевич Баскаков.",
		@"Астрахань": @"В лазоревом щите золотая корона на зеленой подкладке с пятью дугами и крестом сопровождается внизу серебряным мечом острием вправо с золотой рукояткой.\rУтвержден Астраханским городским Советом народных депутатов 24 июня 1993 г. исторический герб города (ранее утвержден 8 декабря 1856 г.).",
		@"Уфа": @"Щит рассечен: пробое поле лазоревое, левое червленое. Бегущая серебряная куница вправо. Глаза и язык червленые.\rУтвержден седьмой сессией двадцать первого созыва городского Совета народных депутатов 14 февраля 1991 г.\rАвтор герба архитектор Юрий Мухтарович Еремеев.",
		@"Нефтекамск": @"В червленом щите золотая стилизованная нефтяная вышка, обрамленная золотыми же стилизованными шестерней, рулоном, линией электросети. В черной вершине название города золотом. Оконечность волнистая лазоревая.\rУтвержден исполнительным комитетом Нефтекамскою городского Совета народных, депутатов 10 апреля 1980 г, № 123.\rАвторы герба архитектор Юрий Константинович Коц и преподаватель художественной школы Назиб Табдулхаевич Садиков.",
		@"Сибаи": @"В червленом щите золотой ковш с золотой же стилизованной породой, обрамленный двумя золотыми колосьями. Колосья соединены стилизованным фрагментом национального башкирского орнамента. В вершине щита золотые контуры гор. На ковше цифры: 1955.\rУтвержден Сибайским горисполкомом в августе 1980 г.\rАвтор герба художник А.Набиев",
		@"Стерлитамак": @"Щит пересеченный. В верхнем серебряном поле бегущая куница натурального цвета вправо. В нижнем лазоревом поле три серебряных, гуся.\rУтвержден 8 июня 1782 г.",
		@"Белгород": @"В серебряном щите малый центральный лазоревый щиток с парящим орлом и лежащим в зеленой оконечности золотым львом. Щиток обрамлен дубовыми ветвями, перевитыми гвардейской лентой. Вокруг них — полушестерня, рассеченная лазурью и червленью, продолженная золотыми колосьями. Щиток увенчан золотой юродской короной о трех зубцах.\rУтвержден Белгородским городским Советом 20 мая 1970г.\rАвтор герба А.А.Гребенюк",
		@"Граиворон": @"Щит пересеченный, в верхнем серебряном, поле лазоревая перевязь справа, обремененная тремя серебряными летящими куропатками. В нижнем золотом поле летящий черный ворон влево.\rУтвержден 25 октября 1841 г.",
		@"Старыи Оскол": @"Щит пересеченный. В верхнем серебряном поле лазоревая перевязь справа, обремененная тремя серебряными летящими куропатками. Нижнее поле скошено слева. В верхней червленой части охотничье ружье натурального цвета. В нижней зеленой части золотая соха.\rУтвержден 8 января 1780 г",
		@"Шебекино": @"В серебряном щите стилизованные серебряная же колба и лазоревая раскрытая книга на фоне расходящихся золотых лучей, обрамленные черной шестерней и золотым колосом. В червленой вершине название города серебром. Оконечность рассечена лазурью и червленью.\rУтвержден исполнительным комитетом Шебекинского городского Совета народных депутатов 23 мая 1986 г., № 162.\rАвторы герба архитекторы Талина Викторовна Полухина и Татьяна Николаевна Сережникова.",
		@"Брянск": @"В червленом щите золотая мортира, сопровождаемая по сторонам пирамидами ядер натурального цвета.\rУтвержден 16 августа 1781 г",
		@"Мглин": @"Щит пересеченный, В верхнем червленом поле золотая мортира, сопровождаемая по сторонам пирамидами ядер натурального цвета. В нижнем зеленом поле лазоревый круг с золотой стилизованной колбой, обрамленные золотыми стилизованными фрагментами дисковой пилы, шестерни и колоса. В зеленой вершине название города золотом.\rУтвержден исполнительным комитетом Мглинского районного Совета народных депутатов 8 декабря 1983 г., № 362.",
		@"Почеп": @"Щит пересеченный. В верхнем червленом поле золотая мортира, сопровождаемая по сторонам пирамидами ядер натурального цвета. Нижнее поле рассечено. В правой лазоревой части стилизованная серебряная колба, сопровождаемая внизу сегментом золотой шестерни. В левой зеленой части стилизованный серебряный цветок картофеля. В зеленой вершине название города золотом. Подножие трижды пересечено: цвета ленты — зеленый, червленый, зеленый.\rУтвержден исполнительным комитетом районного Совета народных, депутатов 9 августа 1984 г., № 398.\rАвторы герба художники И.К.Скворцов и А.В.Сапегин",
		@"Стародуб": @"В серебряном щите с зеленою оконечностью дуб натурального цвета с зелеными, листьями слева.\rУтвержден исполнительным комитетом Стародубского городского Совета народных депутатов 28 декабря 1991 г., № 239 исторический герб города (ранее утвержден 4 июня 1782 г.).",
		@"Унеча": @"Щит пересеченный. В верхнем червленом поле золотая мортира, сопровождаемая по сторонам пирамидами ядер натурального цвета. В нижнем червленом же поле зеленый круг со стилизованным золотым тепловозом в обрамлении золотых колоса и шестерни. В зеленой вершине название города золотом.\rУтвержден исполнительным комитетом Унечского городского Совета народных депутатов 26 ноября 1986 г., № 444.\rАвтор герба архитектор Алла Петровна Гришанова",
		@"Фокино": @"Щит пересеченный. В верхнем червленом поле золотая мортира, сопровождаемая по бокам пирамидами ядер натурального цвета. В нижнем зеленом поле стилизованное изображение цементного завода, сопровождаемое по сторонам узкими червлеными столбами. В вершине щита серого цвета наименование города золотом.\rУтвержден 17 февраля 1984 г",
		@"Владимир": @"В червленом щите стоящий золотой коронованный лев в фас держит длинный серебряный крест. Корона железная.\rУтвержден Малым советом Владимирского городского Совета народных депутатов 17 марта 1992 г., № 50/7 исторический герб города (ранее утвержден 16 августа 1781 г.).\rРисунок герба выполнен членом Союза художников России Сергеем Васильевичем Вохминым.",
		@"Александров": @"Щит пересечен. В верхнем червленом поле стоящий золотой лев в железной короне держит длинный серебряный крест. В нижнем червленом поле черные слесарные тиски, сопровождаемые по сторонам черными же наковальнями.\rУтвержден 16 августа 1781 г.",
		@"Суздаль": @"В пересеченном с лазоревым и червленым полями щите сокол натурального цвета в великокняжеской короне.\rУтвержден тринадцатой сессией двадцать первого созыва Суздальского городского Совета народных депутатов 27 марта 1992 г. исторический герб города (ранее утвержден 16 августа 1781 г.).",
		@"Волгоград": @"Щит пересечен зеленым поясом, обремененным узким червленым поясом же. Е верхнем червленом поле знак «Золотая Звезда» натуральною цвета. Край червленого поля стилизован под городскую стену с золотыми амбразурами. В нижнем лазоревом пале золотая шестерня с выходящим из нее золотым же пшеничным снопом.\rУтвержден пятой сессией одиннадцатого созыва Волгоградского городского Совета депутатов трудящихся 4 марта 1968 г.\rАвторы герба члены Союза художников СССР Алексей Георгиевич Бровка, Геннадий Александрович Ханов, Владимир Германович Ли.",
		@"Камышин": @"В серебряном щите с лазоревой каймой, оборванной поверху, три зеленых стебля камыша. Щит обременяет червленая перевязь слева, обремененная же серебряной шестерней с серебряным челноком.\rУтвержден седьмой сессией Камышинского городского Совета депутатов трудящихся 15 марта 1968 г.\rАвторы герба комиссия, во главе с архитектором Н.М.Каповым",
		@"Котельниково": @"В червленом щите золотое зубчатое колесо, внутри которого на зеленом поле золотые два скрещенных и одно в столб стилизованные колосья. Сопровождается внизу названием города, золото. Оконечность волнистая лазоревая с золотом.\rУтвержден двенадцатой сессией десятого созыва Котельнического городского Совета депутатов трудящихся 25 января 1967 г.\rАвтор герба Анатолий Павлович Сергеев.",
		@"Фролово": @"В червленом щите стилизованная нефтяная золотая вышка, обрамленная золотыми же полушестерней и колосом. В лазоревой вершине название города золотом.\rУтвержден исполнительным комитетом Фроловского городского Совета народных депутатов 16 марта 1988 г., № 393.\rАвторы герба Владимир Иванович Шеметов и Юрий Федорович Бочаров",
		@"Вологда": @"В червленом щите выходящая из серебряного облака слева в золотом одеянии рука, держащая золотую державу и серебряный меч.\rУтвержден городской Думой 7 июля 1994 г., № 38 исторический герб города (ранее утвержден 2 октября 1780 г.).",
		@"Белозерск": @"Щит пересеченный. В верхнем лазоревом поле ладья натурального цвета с серебряным парусом, сопровождаемая двумя пониженными узкими волнообразными серебряным и лазоревым поясами. В нижнем повышенном лазоревом поле две перекрещенные золотые стерляди, сопровождаемые вверху золотыми же цифрами 862.\rУтвержден исполнительным комитетом Белозерского городскою Совета депутатов трудящихся 22 мая 1970г., №8.\rАвтор герба П.Горячев",
		@"Кадников": @"Щит пересеченный. В верхнем червленом поле выходящая из серебряного облака слева в золотом одеянии рука, держащая золотую державу и серебряный меч. В нижнем серебряном поле кадка со смолой натуральных, гнетов.\rУтвержден 2 октября 1780 г.",
		@"Кириллов": @"Щит пересечен золотым поясом, мурованным остриями. В верхнем лазоревом поле круг из золотых шестерни и кокоса обременен якорем золотым же, сопровождаемым по сторонам двумя серебряными рыбами, плывущими навстречу друг другу. В нижнем серебряном поле с зеленым подножием черное клепало, подвешенное на цепи к треножнику черному же, сопровождаемое внизу двумя перекрещенными молотками, натурального цвета.\rУтвержден Кирилловским городским Советом депутатов трудящихся в 1971 г.",
		@"Никольск": @"Щит пересечен золотым поясом, обремененным пятью серебряными восьмилучевыми звездами. В верхнем лазоревом поле золотые ржаной и льняной снопы, сопровождаемые названием города. В верхнем правом углу щита цифры 1780. В нижнем зеленом поле серебряные контуры трелевочного трактора, который справа сопровождают две серебряные же ели.\rУтвержден (городскими властями) 2 марта 1970 г.\rАвтор герба В.В. Мокиевский",
		@"Череповец": @"Щит пересечен и полурассечен. В верхней части серебряный щит с лазоревой оконечностью. В серебряном поле два черные медведя поддерживают золотое с трехсвечником на спинке кресло с червленым сиденьем, на котором крестообразно поставлены золотые же скипетр и крест. В лазоревой оконечности четыре плывущие серебряные рыбы в пояс: 2+2. В нижней части в правом червленом поле стилизованная каменная гора. В левом лазуревом поле серебряное солнце, испускающее серебряные же лучи, сопровождаемое слева стилизованным черным рулем.\rРанее утвержден 29 марта 1811 г.",
		@"Воронеж": @"В червленом щите справа золотая гора с опрокинутым серебряным сосудом, из которого вытекает серебряная же вода.\rУтвержден постановлением главы администрации Воронежа 19 июля 1994 г., № 550",
		@"Богучар": @"В золотом щите хорек черного цвета вправо с червлеными глазами и червленым же высунутым языком. В правой вольной части герб Воронежа. Вершина: серебряно-лазурево-червленая. Щит увенчан башенной короной о трех зубцах, обрамлен золотыми колосьями, перевитыми Александровской лентой.\rУтвержден девятой сессией городского Совета народных депутатов Воронежской области 14 июля 1992 г.",
		@"Новохоперск": @"В лазоревом щите с зубчатым верхним краем серебряный круг с червлеными цифрами 1/10 и зеленым кленовым листом, обрамленные черным сегментом шестерни и золотыми колосьями. На червленой волнистой оконечности щита, окаймленной серебром, положенные накрест золотые шашки, покрытые золотой же буденовкой.\rУтвержден исполнительным комитетом городского Совета в 1972 г.\rАвтор герба Михаил Федорович Трубников.",
		@"Иваново": @"В лазоревом щите сидящая женская фигура в серебряно-червленом одеянии с золотыми каймами, червленом кокошнике, окаймленном золотом, и серебряном платке. Ее сопровождают: справа золотая гребенка с серебряной куделью, слева золотая прялка.\rУтвержден Ивановской городской думой 22 мая 1996 г, № 33-3.\rАвтор герба архитектор В.В. Алмаев.",
		@"Гаврилов Посад": @"В зеленом щите серебряный вздыбленный конь. В золотой главе щита черный факел с червленым пламенем, сопровождаемый по сторонам червлеными же челноками.\rУтвержден исполнительным комитетом городского Совета народных депутатов 21 февраля 1989 г., № 35.\rАвторы герба Константин и Юрий Моченовы.",
		@"Кинешма": @"Щит пересечен волнообразным лазуревым поясом. В верхнем лазоревом же поле галерная корма натурального цвета. В нижнем зеленом поле два серебряных свитка полотна.\rУтвержден 29 мая 1779 г.",
	};
	
	self.keys = [self.texts.allKeys sortedArrayUsingSelector:@selector(compare:)];
	
	self.settings = @[
		@{ // top-left
			kFont:				[UIFont systemFontOfSize:10],
			kTextAlignment:		@(NSTextAlignmentLeft),
			kVerticalAlignment:	@(BTVerticalAlignmentCenter),
			kInsets:			[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)],
			kHasImage:			@NO,
			kImageSize:			[NSValue valueWithCGSize:CGSizeZero],
			kImageInsets:		[NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero],
			kImagePosition:		@(UIRectEdgeLeft),
			kImageAlignment:	@(NSTextAlignmentLeft),
			kImageContentMode:	@(UIViewContentModeTop),
		},
		@{ // top-center
			kFont:				[UIFont systemFontOfSize:10],
			kTextAlignment:		@(NSTextAlignmentCenter),
			kVerticalAlignment:	@(BTVerticalAlignmentCenter),
			kInsets:			[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)],
			kHasImage:			@YES,
			kImageSize:			[NSValue valueWithCGSize:CGSizeMake(0, 64)],
			kImageInsets:		[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(10, 10, 0, 10)],
			kImagePosition:		@(UIRectEdgeTop),
			kImageAlignment:	@(NSTextAlignmentCenter),
			kImageContentMode:	@(UIViewContentModeScaleAspectFit),
		},
		@{ // top-right
			kFont:				[UIFont systemFontOfSize:10],
			kTextAlignment:		@(NSTextAlignmentRight),
			kVerticalAlignment:	@(BTVerticalAlignmentTop),
			kInsets:			[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)],
			kHasImage:			@YES,
			kImageSize:			[NSValue valueWithCGSize:CGSizeMake(50, 0)],
			kImageInsets:		[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(13, 0, 10, 10)],
			kImagePosition:		@(UIRectEdgeRight),
			kImageAlignment:	@(NSTextAlignmentRight),
			kImageContentMode:	@(UIViewContentModeTop),
		},
		@{ // middle-left
			kFont:				[UIFont systemFontOfSize:10],
			kTextAlignment:		@(NSTextAlignmentLeft),
			kVerticalAlignment:	@(BTVerticalAlignmentCenter),
			kInsets:			[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)],
			kHasImage:			@YES,
			kImageSize:			[NSValue valueWithCGSize:CGSizeMake(32, 0)],
			kImageInsets:		[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 0)],
			kImagePosition:		@(UIRectEdgeLeft),
			kImageAlignment:	@(NSTextAlignmentLeft),
			kImageContentMode:	@(UIViewContentModeScaleAspectFit),
		},
		@{ // middle-center
			kFont:				[UIFont systemFontOfSize:10],
			kTextAlignment:		@(NSTextAlignmentLeft),
			kVerticalAlignment:	@(BTVerticalAlignmentTop),
			kInsets:			[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)],
			kHasImage:			@YES,
			kImageSize:			[NSValue valueWithCGSize:CGSizeMake(50, 0)],
			kImageInsets:		[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 0)],
			kImagePosition:		@(UIRectEdgeLeft),
			kImageAlignment:	@(NSTextAlignmentLeft),
			kImageContentMode:	@(UIViewContentModeTop),
		},
		@{ // middle-right
			kFont:				[UIFont systemFontOfSize:10],
			kTextAlignment:		@(NSTextAlignmentLeft),
			kVerticalAlignment:	@(BTVerticalAlignmentCenter),
			kInsets:			[NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero],
			kHasImage:			@YES,
			kImageSize:			[NSValue valueWithCGSize:CGSizeMake(0, 64)],
			kImageInsets:		[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(10, 10, 0, 10)],
			kImagePosition:		@(UIRectEdgeTop),
			kImageAlignment:	@(NSTextAlignmentLeft),
			kImageContentMode:	@(UIViewContentModeCenter),
		},
		@{ // bottom-left
			kFont:				[UIFont systemFontOfSize:8],
			kTextAlignment:		@(NSTextAlignmentLeft),
			kVerticalAlignment:	@(BTVerticalAlignmentTop),
			kInsets:			[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)],
			kHasImage:			@YES,
			kImageSize:			[NSValue valueWithCGSize:CGSizeMake(40, 60)],
			kImageInsets:		[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 0)],
			kImagePosition:		@(UIRectEdgeLeft),
			kImageAlignment:	@(NSTextAlignmentLeft),
			kImageContentMode:	@(UIViewContentModeScaleAspectFit),
		},
		@{ // bottom-center
			kFont:				[UIFont systemFontOfSize:10],
			kTextAlignment:		@(NSTextAlignmentLeft),
			kVerticalAlignment:	@(BTVerticalAlignmentCenter),
			kInsets:			[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)],
			kHasImage:			@YES,
			kImageSize:			[NSValue valueWithCGSize:CGSizeMake(32, 32)],
			kImageInsets:		[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 10, 10, 10)],
			kImagePosition:		@(UIRectEdgeBottom),
			kImageAlignment:	@(NSTextAlignmentCenter),
			kImageContentMode:	@(UIViewContentModeScaleAspectFit),
		},
		@{ // bottom-right
			kFont:				[UIFont systemFontOfSize:10],
			kTextAlignment:		@(NSTextAlignmentLeft),
			kVerticalAlignment:	@(BTVerticalAlignmentCenter),
			kInsets:			[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)],
			kHasImage:			@YES,
			kImageSize:			[NSValue valueWithCGSize:CGSizeMake(32, 0)],
			kImageInsets:		[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 0)],
			kImagePosition:		@(UIRectEdgeLeft),
			kImageAlignment:	@(NSTextAlignmentLeft),
			kImageContentMode:	@(UIViewContentModeScaleAspectFill),
		},
	];
	
	// tables
	self.tables = [NSMutableArray arrayWithCapacity:9];
	
	CGColorRef color = [UIColor colorWithHue:0 saturation:0 brightness:0.8 alpha:1].CGColor;
	
	for (NSUInteger index = 0; index < 9; index++) {
		UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
		tableView.dataSource = self;
		tableView.delegate = self;
		tableView.tag = index;
		tableView.tableFooterView = [[UIView alloc] init];
		tableView.layer.borderWidth = 1;
		tableView.layer.borderColor = color;
		
		tableView.separatorInset = UIEdgeInsetsZero;
		
		if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
			tableView.layoutMargins = UIEdgeInsetsZero;
		}
		
		if ([tableView respondsToSelector:@selector(cellLayoutMarginsFollowReadableWidth)]) {
			tableView.cellLayoutMarginsFollowReadableWidth = NO;
		}
		
		[self.view addSubview:tableView];
		[self.tables addObject:tableView];
	}
}

//
// -----------------------------------------------------------------------------
- (void)viewWillLayoutSubviews
{
	CGRect bounds		= self.view.bounds;
	CGFloat topMargin	= 20;
	CGFloat inset		= 10;
	
	NSUInteger sideCount = ceil(sqrt(self.tables.count));
	
	CGFloat labelWidth = (bounds.size.width - inset) / sideCount - inset;
	CGFloat labelHeight = (bounds.size.height - topMargin - inset) / sideCount - inset;
	
	NSUInteger index = 0;
	
	for (UITableView *tableView in self.tables) {
		tableView.frame = CGRectMake(inset + (labelWidth + inset) * (index % sideCount),
									 topMargin + inset + (labelHeight + inset) * (index / sideCount),
									 labelWidth,
									 labelHeight);
		index++;
	}
}


#pragma mark - Custom text

//
// -----------------------------------------------------------------------------
- (NSAttributedString *)textForTag:(NSUInteger)tag text:(NSString *)text
{
	switch (tag) {
		case 4: {
			NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
			paragraph.alignment = NSTextAlignmentJustified;
			paragraph.hyphenationFactor = 1;
			paragraph.paragraphSpacing = 10;
			
			return [[NSAttributedString alloc] initWithString:text attributes:@{
				NSFontAttributeName: [UIFont fontWithName:@"Palatino-Italic" size:12],
				NSParagraphStyleAttributeName: paragraph,
			}];
			break;
		}
		case 5: {
			return [[NSAttributedString alloc] initWithString:@"" attributes:@{
				NSFontAttributeName: [[UIFont preferredFontForTextStyle:UIFontTextStyleBody] fontWithSize:10],
			}];
		}
		default: {
			return nil;
		}
	}
}


#pragma mark - UITableView datasource

//
// -----------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

//
// -----------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.keys.count;
}

//
// -----------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// try to dequeue cell
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	
	// create cell?
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
		cell.separatorInset = UIEdgeInsetsZero;
		cell.layoutMargins = UIEdgeInsetsZero;
		
		// create BTLabel
		BTLabel *label = [[BTLabel alloc] initWithFrame:cell.bounds];
		label.tag = 100;
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		// configure for specific table
		NSDictionary *settings = self.settings[tableView.tag];
		
		label.font				= settings[kFont];
		label.textAlignment		= [settings[kTextAlignment] unsignedIntegerValue];
		label.verticalAlignment	= [settings[kVerticalAlignment] unsignedIntegerValue];
		label.edgeInsets		= [settings[kInsets] UIEdgeInsetsValue];
		label.hasImage			= [settings[kHasImage] boolValue];
		label.imageSize			= [settings[kImageSize] CGSizeValue];
		label.imageEdgeInsets	= [settings[kImageInsets] UIEdgeInsetsValue];
		label.imagePosition		= [settings[kImagePosition] unsignedIntegerValue];
		label.imageAlignment	= [settings[kImageAlignment] unsignedIntegerValue];
		label.imageContentMode	= [settings[kImageContentMode] unsignedIntegerValue];
		
		[cell.contentView addSubview:label];
	}
	
	// fill cell fith data
	NSString *key = self.keys[indexPath.row];
	NSString *text = self.texts[key];
	
	BTLabel *label = [cell viewWithTag:100];
	
	switch (tableView.tag) {
		case 4:
		case 5: {
			label.attributedText = [self textForTag:tableView.tag text:text];
			break;
		}
		default: {
			label.text = text;
			break;
		}
	}
	
	label.image = [UIImage imageNamed:key];
	
	return cell;
}

#pragma mark - UITableView delegate

//
// -----------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat separatorHeight			= 1;
	CGFloat width					= tableView.bounds.size.width;
	
	NSString *key					= self.keys[indexPath.row];
	NSString *text					= self.texts[key];
	NSDictionary *settings			= self.settings[tableView.tag];
	
	UIFont *font					= settings[kFont];
	UIEdgeInsets edgeInsets			= [settings[kInsets] UIEdgeInsetsValue];
	BOOL hasImage					= [settings[kHasImage] boolValue];
	CGSize imageSize				= [settings[kImageSize] CGSizeValue];
	UIEdgeInsets imageEdgeInsets	= [settings[kImageInsets] UIEdgeInsetsValue];
	UIRectEdge imagePosition		= [settings[kImagePosition] integerValue];
	
	if (!hasImage) {
		imageSize = CGSizeZero;
		imageEdgeInsets = UIEdgeInsetsZero;
	}
	
	switch (tableView.tag) {
		case 4:
		case 5:
			return [BTLabel heightForWidth:width text:[self textForTag:tableView.tag text:text] font:nil edgeInsets:edgeInsets numberOfLines:0 imageSize:imageSize imagePosition:imagePosition imageEdgeInsets:imageEdgeInsets] + separatorHeight;
		default:
			return [BTLabel heightForWidth:width text:text font:font edgeInsets:edgeInsets numberOfLines:0 imageSize:imageSize imagePosition:imagePosition imageEdgeInsets:imageEdgeInsets] + separatorHeight;
	}
}

@end
