//
//  BaseSwift.swift
//  DYZB
//
//  Created by hairong chen on 2019/12/14.
//  Copyright @huse.cn  All rights reserved.

// 代码行数数统计 (wc:word count)
// find . -name ".swift" | xargs wc -l
// --no-repo-update

// block->vc->tools->block

// option + click xib-class switch
// command +=
// cmd+L:跳到指定的行
// ctrl + 6 ：列出MARK列表
// cmd +shift +o :打开文件
// cmd + shift+j: 快速定位文件
// ctrl+ cmd +e :全局修改关键字
// cmd + option +enter:助理编辑器(option+点击)
// cmd +shift + f:全局查找

/*
 as:转换
 1.String as NSString
 2.NSArray as [array]
 3.NSDictionary as [String:AnyObjec]
 
其他类型
 tmp是?.!, 后转换也as?,as!
 var tmp:String? ==> uid as? String
 
 guard let as后用? :as?
 guard let dict = result as? [String:AnyObject] else {}
 
 *.设置了预估行高，当前显示的行高方法会调用3次（可以每个版本的Xcode调用次数可能不同）
 why:预估行高如果不同，计算的次数不同?(
     a.根据预估行高，计算出预估的contentSize;
     b.根据预估行高，判断计算次数，顺序计算每一行的行高，更新contentSize
     c.如果预估行高过大,超出预估范围，顺序计算后续行高，一直到填满屏幕退出，同时更新contentSize)
     d.使用预估行高，每个cell的显示前需要计算，单个cell的效率是低的,从整体效率高
        行数->每个cell->行高
 *.没有设置预估行高：计算所有的行高，再计算显示的高度
 why:为什么要高所有行方法?
     提高流畅度，需要提前计算出contentSize
     行数->行高->cell
 
 苹果官方文档有指出：如果行高是固定值，就不要实现行高代理方法
*/

import UIKit
 //////////////////////////////////////////////
 //it
 //////////////////////////////////////////////
class Person__:NSObject {
    var name :String?
    var height :Float = 0
    // read only
    var sex:Int?  {
        get {
            return 1
        }
    }
    //只读属性的简写方法,只提供getter,那么get{}可以省略,
    //计算属性
    var grade:Int? {
        return 1;
    }
    
    //lazy
    lazy var title:String? = {
       return "title"
    }()
    
    override init() {
        name = "william"
        super.init()
    }
    
    convenience init?(name:String,height:Float) {
        if(height<0 && height>300) {
            return nil
        }
        self.init(dict:["name":"william","height":"100"])
    }
    
    init(dict:[String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    deinit {
        print("person deinit")
    }
}


class Student__:Person__ {
    var age:Int?
    override init() {
        age = 10
        super.init()
    }
    
    init(name:String,age:Int) {
        self.age = age
        super.init()
        self.name = name
    }
    deinit {
        print("Student deinit")
    }
}


class ItHemaView:UIView {
    var obj:UIView
    override init(frame: CGRect) {
        obj = UIView(frame: frame)
        super.init(frame: frame);
        setupview()
    }
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented") }
    
    // MARK:-11 JSON反序列化
    func jsonTest() {
        //http://www.weather.com.cn/data/sk/101010100.html
        let urlString:String = "http://www.weather.com.cn/data/sk/101010100.html"
        let newUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let config = URLSessionConfiguration.default
        let url = URL(string: newUrlString!)
        let request = URLRequest(url: url!)
        //进行请求头的设置
        //request.setValue(Any?, forKey: String)
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data,response,error) in
            print(String(data: data! , encoding: .utf8) as Any)
            //将json数据解析成字典
            guard let result = try? JSONSerialization.jsonObject(with: data!, options:[.mutableLeaves,.mutableContainers]) else {
                print("failure.")
                return
            }
            print(result)

//            let jsonStr = "[\"hello\",\"world\"]"
//            let data = jsonStr.data(using: .utf8)
//            do {
//                let result = try JSONSerialization.jsonObject(with: data!, options:[])
//                print(result)
//            }catch {
//                print(error)
//            }
        }
        task.resume()
    }
    
    
    // MARK:-10. get/set/private keyword
    // getter& setter 方法在swift中极少用
    // 如果不希望暴露的方法或属性，都要用private保护起来
    // read-only:只需要getter方法
    // 只读属性的简写方法：如果属性的修饰方法，只提供getter,那么get{}可以省略,另一种叫法，叫计算属性
    
    // 计算属性：每一次都要计算，浪费性能，如果计算量很小，可以使用,不需要开辟额外的空间
    // 懒加载：只需要计算一次，需要开辟额外的空间保存计算结果
    
   // MARK:-9. Lazy loading
   // 第一次访问属性时，会执行后面闭包代码，将闭包的结果保存在属性中，下次再访问，不会再执行闭包
   // 如果没有lazy,会在initWithCoder方法中被调用，当二进制的storyboard被还原成视图控制器对象之后，就会被调用
    lazy var lazyPerson1 : Person__ = {
        return Person__()
    }()
    
    lazy var lazyPerson2 :Person__ = Person__()
    
    let personFunc = {()->(Person__) in return Person__()}
    lazy var lazyPerson3:Person__ = self.personFunc()
    
    func lazyTest() {
        print(lazyPerson1)
        print(lazyPerson2)
        print(lazyPerson3)
    }
    
    
    // MARK:-8. structor function
    // 1.先要对自己初始化，再初始化父类
    // Student__ 中注掉super.init(),也会调用父类的构造函数，隐式的
    // 2. 重载：函数名相同，函数参数的个数,参数名,参数类型不同
    //    重写: 子类需要在父类拥有方法的基础上进行扩展，需要override关键字
    //    !!!?? 重写的构造函数，只要是构造函数，就需要给属性置初始值
    // 3.如果重写了构造函数，系统默认提供的构造函数init()就不能再被访问
    // 4.kVC的构造函数
    // 5.便得构造函数，如果构造函数中出现？，表示这个构造函数不一定会创建出对象
        // 能够提供条件检测，能够充许返回nil,
        // 默认(指定)的构造函数，必须要创建对象
        // 如果子类没有实现便利构造函数，调用方同样可以使用父类的便得构造函数，实例化子类对象
        // 便得构造函数，不能被继承，也不能被重写
    // 6. 析构函数:不能重载,不带参,不能直接调用（系统内部自动调用的）
    /*
    7.错误:`self`used before super.init call
        在 init 中 有四个阶段的安全检查, 这里违背了第四个检查
        1. 在调用父类初始化之前必须给子类特有的属性设置初始值,只有在类的所有存储属性状态都明确后,这个对象才能被初始化
        2. 先调用父类的初始化方法,再给从父类那继承来的属性初始化值,不然这些属性值会被父类的初始化方法覆盖
        3. convenience必须先调用designated初始化方法,再给属性初始值.不然设置的属性初始值会被designated初始化方法覆盖
        4. 在第一阶段完成之前,不能调用实类方法,不能读取属性值,不能引用self
    */
    func classObjTest() {
        // var std = Student__()
         var std1 = Student__(name: "william", age: 10)
        // var per = Person__(dict:["name":"wi","age":"19","title":"oo"])
        // let per0 = Person__(name:"w", height:300)
        // let per0 = Student__(name:"w", height:300)//去掉所有构造函数
        //print(per0?.name)
    }
  
    
    
    // MARK:-7. Closure
    /*
     func 没有返回值:1.什么都不写，2.Void, 3.()
     3种类型，在闭包中会使用
     在swift中，函数本身就可以当作参数传递
    */
    func cn1(){}
    func cn2()->Void{}
    func cn3()->(){}
    func funcTest(){let sum = cn1;sum() }
    /*
     1.闭包的所有代码【参数，返回值，执行代码】都放在{}中
     2.in 是用来区分函数定义和执行代码
     //!!!error->3.外部参数在定义 闭包的时候非常重要，能够有智能提示
     3.简单的闭包，如果没有参数和返回值，参数/返回值/in 都可能省略
     4.尾随闭包：
        闭包参数是函数的最后一个参数，
        函数的）结束可以前置,最后一个逗号省略
     5.[weak self] 表示闭包中的self都是弱引用,与__weak类似，如果self·被释放，什么也不做，更安全
       [unowned self] 表示闭包中的self都是assign,如果self被释放，闭包中的self 的地址不会修改
       与__unsafe_unretained类似，如果self被释放，同样会出现野指针
     */
    func closureTest( finished:@escaping()->()) {
        let ec = {
            (x:Int,y:Int)->Int
            in return x + y
        }
        //print(ec(num1:1,num2:1))
        print(ec(1,1))
        
        //简单的闭包
        let noparaters = {print("noparaters")}
        noparaters()
        
        DispatchQueue.global().async {
            ()->Void in print("loading...")

            DispatchQueue.main.async {
                ()->Void in print("finished.")
               finished()
            }
        }
    }
    
    
    func closureTestparams( finished:@escaping(_ html:String)->()) {
        DispatchQueue.global().async {
            ()->Void in print("loading...")

            DispatchQueue.main.async {
                ()->Void in print("finished.")
                finished("htms")
            }
        }
    }

    //MARK:- 6. array & dictionary
    //数字不需要包装成NSNumber,结构体需要包装成NSValue
    func arrayAnddictTest() {
        let array1 = ["zhange",18,NSValue(cgPoint: CGPoint(x: 10, y: 10))] as [Any]
        print(array1)
        
        //MARK:-可变
        var array2:[Any] = ["william"]
        array2.append("jack")
        array2.append(8)
        print(array2)
        
        for d in array2 {
            print(d)
        }
        
        // add modify remove
        array2.append("app")
        array2[0] = "3"
        array2.removeFirst()//removeLast()
        // 删除所有元素，并保留容量
        array2.removeAll(keepingCapacity: true)
        
        // init
        var array3:[String] = [String]()
        array3.append("william")
        print(array3[0] + "\(array3.capacity)")
        //array3 += array2 //合并
        print(array3)
        
        //dict
        var dict = ["name":"willaim","age":11] as [String : Any]
        dict["name"] = "jack"
        dict["title"] = "title" // key不存在，新增
        for(key,value)in dict {
           print("key:\(key) value:\(value)")
        }
        
        // 合并
        let dict1 = ["a":"b"]
        for(k,v)in dict1 {
            dict[k] = v
        }
        print(dict)
        
    }
    
    //MARK:- 5. The for loop traverse
    func loopTest(){
        for i in 0..<9{print(i)}//0-8
        for i in 0...9{print(i)}// 0-9
        print(0..<9)//0..<9
        print(0...9)//0...9
    }
    
    
    //MARK:-4.String是结构体
    // 量级更轻，支持直接遍历
    // 子串时，不是特别好写，建议使用NSString
    func stringTest() {
        let string:String = "构体"
        for c in string {
            print(c)
        }
        print(string.lengthOfBytes(using:String.Encoding.utf8))
        print(string.count)
        
        let h=9,m=5,s=12
        print("\(h):\(m):\(s)")
        let datesting = String(format:"%02d:%02d:%02d",arguments:[h,m,s])
        let datestrings = String(format: "%02d:%02d:%02d", h,m,s)
        print(datesting+datestrings)
        
        
        // substring
        let str = "hello world"
        var range = (str as NSString).substring(with: NSMakeRange(2, 4))
        print(range)
        let s2 = (str as NSString).substring(from:1)
       //  let s3 = str.substring(from: "1234".endIndex)
        
        print(s2)
        
        let startIndex = str.startIndex
        let endIndex = str.endIndex
        let ranges = startIndex..<endIndex
        let s3 = str.substring(with: ranges)
        print(s3)
    }
    
    
    
    //MARK:-3.switch
    func switchTest(){
        let number = "11"
        /**
         1，不在局限在对int的分支，可以对作意数据类型进行检测
         2. 各个case之间，不会穿透，如果有多个值，使用，分隔
         3.定义变量，不需要使用{}分隔使用域
         */
        switch number {
        case "10","9":
            let name = "willam"
            print("better"+name)
        case "8":print("good")
        default:print("bad")
        }
    }
    
    @objc func click(){}
    //MARK:-2. Frame
    func setupview() {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200));
        v.backgroundColor = .red
        obj = v
        let btn = UIButton(type: .contactAdd)
        btn.center = self.center
        btn.addTarget(self, action: #selector(click), for: UIControl.Event.touchUpInside)
    }
    
    //MARK:-1.let & guard
    func test() {
        // let guard
        let urlString :String? = "http://www.baidu.com/"
        let age:Int? = 20
        if let urlString = urlString,let age = age {
            let url = NSURL(string: urlString)
            if let url = url {
                let request = NSURLRequest(url:url as URL)
                print(request)
            }
            print(urlString + String(age))
        }
        
        guard let tmpAge = age else {
            print("guard = nil")
            return
        }
         guard let tmpUrlString = urlString else {
            print("tmpUrlString = nil")
            return
        }
        print(String(tmpAge) + tmpUrlString);
        
        let name :String?  = "jack"
        print((name ?? "") + "william")// result:jackwilliam
        
        //1. +优先级高, ??优先级低. 相当于name ?? ("" + "william")
        //2. var 的可选项默认值是nil,let的可选项没有默认值，必须要设置初始值
        print( name ?? "" + "william") //result:jack
    }
}



// MARK:- Test Data
class Student: NSObject {
    // 存储属性
    var name:String = "" {
        //属性监听器，开发中选中其中之一即可
        willSet(newName) {print(name,newName)}
        didSet(oldName) {print(name,oldName)}//didSet {print(name,oldValue)}
        
    }
    var age:Int = 0
    var mathScore :Double = 0.0
    var chineaseScrore :Double = 0.0
    var friend:Friends?
    // 计算属性
    var avarageScore :Double {
        return (chineaseScrore + mathScore) * 0.5 //get {}  set {}
    }
    // 类属性
    static var scouseCount :Int = 0;
    override init(){super.init()}
    init(name:String,age:Int) {self.name = name;self.age = age}
//    init(dict:[String:Any]){
//        if let name = dict["name"] as? String { self.name = name;}
//        if let age = dict["age"] as? Int {self.age = age;}
//    }
    
    //使用KVC
    //1 必须继承NSObject
    //2 必须在构造函数中，先调用super.init()
    //3.调用setValuesForkeys
    init(dict:[String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {}
    
    deinit{ print("deinit");}
}

class Friends: NSObject {var age:Int = 0;var toy :Toy?}
class Toy: NSObject {var price :Double = 0.0; func flying(){print("flying") }}

// MARK:-协议在代理设计模型中的使用
//19 协议在代理设计模型中的使用:
/*
 定义协议时，协议后面最好跟上:class
 deletegate的属性最好用weak,用于防止产生循环引用
 */
//optional 属于OC特性，如果有可选方法，那么要前加@objc,也要在optional前加上@objc

protocol SportProtocol{func playBasketball();func playFootball();}
protocol BuyTIcketDelegate:class {func buyTicket()}
@objc protocol OpProtocol {@objc optional func opTest()}

class Teacher0:SportProtocol {func playBasketball(){};func playFootball(){}; }
class Teacher1:NSObject,SportProtocol {func playBasketball(){};func playFootball(){}; }
class Teacher2:NSObject {
    weak var delegate:BuyTIcketDelegate?;
    func GoplayBasketball(){delegate?.buyTicket()}
}
class Teacher3:OpProtocol{func opTest(){}};
    
class ttLazy {
    lazy var names1:[String] = ["r","h"]
    lazy var names2:[String] = {
        let names = ["r","h"]
        return names
    }()
    lazy var btn:UIButton = {
        let btn = UIButton()
        btn.setTitle("btn", for: .normal)
        btn.setImage(UIImage(named: ""), for: .normal)
        return btn
    }()
    
    fileprivate lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
}

// MARK:DY Project
func KeyTest() {
    //23

    //MARK: 22 访问权限
    /*
    1>internal:内部的
         1.默认情况下所有的类&属性&方法访问权限都是internal
         2.在本模块（项目/包/target)中可以访问
    2> private:私有的
         1.只有在本类中可以访问
    3>open:公开的
         1.可以跨模块（项目/包/target)中可以访问
    4> fileprivate:Swift3.0
        1.只要在本文件中都是可以进行访问
    */
    
    
    
    //MARK: 21 懒加载
    //lazy只能用在结构体或类中
    //error: lazy is only valid for members of a struct or class
    //lazy var exampl = SomeExpensiveClass(id: 2)
//    lazy var names1:[String] = ["r","h"]
//    lazy var names2:[String] = {
//        let names = ["r","h"]
//        return names
//    }()
//    lazy var btn:UIButton = {
//        let btn = UIButton()
//        btn.setTitle("btn", for: .normal)
//        btn.setImage(UIImage(named: ""), for: .normal)
//    }()
    
    
    //MARK:20 闭包
    let httpTools = HttpTools()
    //weak var weakSelf :ViewController ? = self
    
    httpTools.loadData({_ in print("loadDat")})
//    httpTools.loadData ({[weak self] (jsonData:String) in
//        print("jsonData")
//            self.view?.backColor = UIColor.red
//    })
//    httpTools.loadData ({[unowned self](jsonData:String) in
//         print("jsonData")
//     })
    
    //MARK: 尾随闭包
    // 1.如果在函数中，闭包是最后一个参数，那么可以写成尾随闭包
    // 2.如果是唯一的参数，也可以将前的（）省田略掉
    httpTools.loadData(){(jsonData:String) in
        print("jsonData")
    }
    
    httpTools.loadData {(jsonData:String) in
        print("jsonData")
    }
    
    
    //MARK:19 协议
    //MARK:18 可选链
    let ost = Student();ost.name = "r"
    let fds = Friends(); fds.age = 19
    let toy = Toy();toy.price = 100
    
   // let price = ost.friend?.toy?.price
    if let price = ost.friend?.toy?.price {print(price)}
    ost.friend?.toy?.flying()
  
    
    
    //MARK: 17 循环引用
    //OC __weak/__unsafe_unretained(会产生野指针错误)
    //swift weak/unowned(会产生野指针错误,不能用于修饰可选类型)
    
    
    //MARK: 16 类的构造函数
    let p = Student(dict:["name":"r","age":18,"phoneNo":"1111"])
    print(p.age,p.name)
    // 类的 deinit
    var model:Student? = Student()
    model = nil;
    
    
    //MARK: 15 监听类的属性改变
    let sc = Student()
    sc.name = "r"
    
    //MARK: 14 class
    let student = Student()
    student.mathScore = 99
    student.chineaseScrore = 98
    print(student.avarageScore)
    Student.scouseCount = 2;
    
    
    //MARK: 13 struct
    struct Location {
        var x:Double
        var y: Double
        
        mutating func moveH(dis:Double)  {
            self.x += dis
        }
        init(x:Double,y:Double){self.x = x;self.y = y}
        
        init(xyStr:String) {
            let array = xyStr.components(separatedBy: ",")
            let item0 = array[0]
            let item1 = array[1]
            
            // ?? 判断前面的可选是否有值，有值，则解包，没有值，则使用后面的值
            self.x = Double(item0) ?? 0
            self.y = Double(item1) ?? 0
            /*
             if let x = Double(item0) {self.x = x} else {self.x = 0}
             if let y = Double(item1) {self.y = y} else {self.y = 0}
             */
        }
    }
    //MARK: 创建方式
    let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
    let size = CGSize(width: 20, height: 20)
    let point = CGPoint(x: 0, y: 0)
    let range_loc = NSRange(location:0, length: 3)
    var cr = Location(x:10, y: 10);
    // 结构体构造方法
    cr.moveH(dis:20)
    // 结构扩充构造函数
    //系统有一个默认构造函数；构造函数结束时，必须保证所有的成员属性有被初始化
    var sxy = Location(xyStr: "30,20")
    print(sxy)
    
    
    
    //MARK:12 enum类型
    enum MethodType : String {
        case get = "get"
        case post = "post"
        case put = "put"
        case delete = "delete"
    }
    enum Type : Int {case get = 0 , post , put ,delete}
    
    let t1 :MethodType = .get
    let t2 = MethodType.post
    let t3 = MethodType(rawValue: "put")// value / nil
    let hast3 = t3?.rawValue
    
    
    //MARK: 11 类型转化
    //1.as
    let typeas = "hello"
    (typeas as NSString).substring(to:5)
    //2. as?  as!
    /* as?: 转成的类型是一个可选类型，系统会自动判断tempName是否可以转成String,
     如果可以转成，那么获取字符串，如果转化不成功则返回nil
     as!:将类型转成具体的类型。 转化不成功，则程序会直接崩溃，如果确定转化成功，再用as!，平时不建议
    */
    let asDict:[String:Any] = ["name":"r"]
    //--------------as?---------------//
    let asName = asDict["name"]
    let asCoverName = asName as? String
    if let asCoverName = asCoverName {print(asCoverName)}
    //--------上面三句用一句即可----------//
    if let asName = asDict["name"] as? String {print(asName)}
    //--------------as!---------------//
    let tmpFor = asDict["name"]
    let nameFor = tmpFor as! String
    
    
    
    
    //MARK:10 可选类型(只要一个类型有可能为nil，那么这个标识符的类型一定是一个可选类型)
    var oName:Optional<String> = nil // 1.define 1
    var oName1:String? = nil         // 2.define 2
    oName = Optional("r")            // 可选类型赋值1
    oName = "r"                      // 可选类型赋值2
    print(oName)                     // Optional("r")
    print(oName!)                    // 对Optional("r")强制解包，结果: "r"
    // 强制解包危险，如果为nil,崩溃
    if oName != nil {print(oName!)}
    // 可选绑定
    /*如果没有值，则直接不执行{},如果有值，系统自动对可选类型解包，并将解包后的结果赋给前面的tmpName*/
    if let tmpName = oName { print(tmpName) }
    
    //MARK:-可选类型应用
    //1.String -> Int
    let a :Double = 2.11
    let b = Int(a)
    let str:String = "123"  //"123q"
   // let num = Int(str)    // 123 or  nil
    let c:Int? = Int(str)
    //2. file Path
    let path :String? = Bundle.main.path(forResource: "12.plist", ofType: nil)// string / nil
    //3. sting->NSURL
    // 如果字符串中有中文，那么是转化不成功的，返回nil
    //let url:NSURL? = NSURL(string: "www.baiduc.com") // URL / nil
    let url = URL(string: "www.baiduc.com") // URL / nil
    //4. dictiont -> element
    let tmpDic :[String:Any] = ["name":"r"]
    let tmpName:Any? = tmpDic["name"]
    
    
    //MARK:9 元组
    // 使用数组保存信息
    let infoArray :[Any] = ["r",18,1.88]
    let arrayName = infoArray[0] as! String // error:let arrayName = infoArray[1] as! String
    print(arrayName.count)
    // 使用字典保存信息
    let infoDict :[String:Any] = ["name":"r","age:":18]
    let dictName = infoDict["name"] as! String // error:let dictName = infoArray[1] as! String
    print(dictName.count)
    // 1.使用元组保存信息
    let infoTuple = ("r",18,1.88)
    let tupleName = infoTuple.0
    let tupleage = infoTuple.1
    print(tupleName.count)
    
    // 2.使用元组保存信息 一般这样写
    let infoTuple1 = (name:"r",age:18,height:1.88)
    infoTuple1.age
    infoTuple1.name
    infoTuple1.height
    
    // 3.使用元组保存信息
    let (name,age,height) = ("r",18,1.88)
    name
    age
    height
    
    //MARK: 8 dictionary
    //let dict:Dictionary<String,Any> = ["name":"r","age":11,"height":170.0]
    //let dict:[String,Any] = ["name":"r","age":11,"height":170.0] // 一般这样写
    let dict = ["name":"r","age":11,"height":170.0] as [String:Any]// const dic 值类型不确定时，要转换 [String:Any]
    let dict1 = ["name":"r","age":"11","height":"170.0"]
    var dictM = [String:Any]();// mutalbe dic
    // add元素
    dictM["name"] = "r"
    dictM["age"] = 11
    // 修改元素
    dictM["name"] = "m"
    dictM.updateValue("lnj", forKey: "name")
    // remove元素
    dictM.removeValue(forKey: "name")
    // 遍历
    for value in dict.values {print(value)}
    for key in dict.keys {print(key)}
    for (key,value) in dict {print(key,value)}
    // 合并
    var dict2 :[String:Any] = ["name":"r"]
    let dict3:[String:Any] = ["heitht":180]
    for(key,value) in dict3 {dict2[key] = value}
        
    //MARK: 7 array
    let array = ["w"]// const
    var ardata:[String] = [String]()
    var arrayM  = [String]() //var arrayM = Array<String>() // mutable array
    arrayM.append("w")
    arrayM[0]="y"
    arrayM.remove(at: 0)
    
    for i in 0..<array.count{print(array[i])}
    for item in array {print(item)}
    for(index,item) in array.enumerated(){print(index);print(item)}
    // merge
    let array1 = ["array1"],array2 = ["array2"],array3 = [11]
    let res = array1 + array2 //let res = array1 + array3 error 类型要相同
    
    //MARK:6 sting:length,format,substring
    var strM = "hello";strM = "hello swift"
    let len = strM.count ;print(len)
    let min = 3,second = 14
    let timestr = String(format:"%02d:%02d",min,second);print(timestr)//03:14
    //6.1
    let urls = "hello swift"
    let header = (urls as NSString).substring(to: 5)//header = "hello"
    let range = NSMakeRange(5, 1)
    let middle = (urls as NSString).substring(with:range) //middle = " "
    let footer = (urls as NSString).substring(from:6)//footer = "swift"
    //6.2
    let stratIndex = urls.index(urls.startIndex,offsetBy: 5)
    let endIndex = urls.index(urls.startIndex,offsetBy: 6)
    let range1 :Range = stratIndex..<endIndex //let range1 = Range(stratIndex..<endIndex)
    let middle1 = urls.substring(with:range1)
    let footerIndex = urls.index(urls.endIndex,offsetBy: -5)
    let footer2 = urls.substring(from:footerIndex)
    
    //MARK:5----
    for i in 0..<10 {//for i in 0...9{} 只支持区间
        print(i)
    }
    //MARK: while 后（）可以省略，没有非0即真
    var t = 0
    while t<10 { t += 1 /* t ++ error*/}
    repeat {t-=1;} while t>0
        
    //1
    let n:Int = 3
    let m:CGFloat = 3.14
    _ = CGFloat(n) + m
    
    //2
    if n>0 {}
    
    //3
    guard n>18 else {
         print("go home")
         return;
     }
    
    //MARK: 4 fallthrough
    switch m {
    case 0,1:
        print("0,1")
        fallthrough
    case 2,3:
        print("2,3")
    case 3.14:
        print("float")
        
    case 0...59:
        print("0...59.")
        case 60..<80:
        print("60...<80")
//    case "+":
//        print("+")
    default:
        print("default")
    }
}

