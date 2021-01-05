package {
	import flash.events.*;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.Graphics;
	import flash.display.StageScaleMode;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.text.TextFormat
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilter;
    import flash.filters.BitmapFilterQuality;
	/*   presented by yukon12345  (http://hi.baidu.com/yukon_kanzaki/blog/item/b500fd1f77d808f8e1fe0b88.html) 
	/*   
	/*   generate from BAIDU
	/*   注意：软件遵循MIT使用许可协议（http://zh.wikipedia.org/zh-cn/MIT许可证）
	/*   可自由转载,修改和用于商业用途，但使用时必须保留此注释段所有信息 2010-6-14                                                                                     
	*/
	public class YItem extends Sprite {
		private var _statusTex:TextField;         //状态提示文本
		private var _loader;                    //缩略图载入器
		private var _urlRequest;              //上传的URLRquest实例
		private var _cSize:uint=95;            //整个缩略图显示框大小
		private var _size:uint=85;            //整个缩略图大小
		private var container;          
		private var okIcon;                    //上传完成标志小图标
		private var delIcon;                   //删除小图标
		public var index                      //在图片组容器里的索引值
		
		private var leftIcon                //左旋图标
		private var rightIcon               //右旋图标
		private var loadOver=false    		//读入内存完毕
		private var r:Sprite   			 //帮助旋转的父容器
		private var sizeLimit=5*1024*1024 //5M上传限制
		private var typeError=false     //是否后缀错误
		private var sizeError=false    //是否0字节或者超过允许大小
		private var codeError=false    //是否编码错误（非允许图片格式编码）
		private var loadingBar:Sprite        
		private var isUploading=false  //是否在上传中
		public  var filterArray =new Array(".gif",".jpg",".jpeg",".png") //默认允许的后缀
		public  var uploadOver=false  //上传发送完毕
		public  var fileR             //缩略图的文件引用
		private var  _border:Sprite;  //被选中框         
		public var isSelected         //被选中标量

		public function YItem(_fr,_upURL="up.php",_sizeLimit=2*1024*1024) {
			sizeLimit=_sizeLimit
			fileR=_fr as FileReference
			_urlRequest=new URLRequest();
			_urlRequest.url=_upURL;//文件上传路径
			
            _border=new Sprite //绿色的被选中框
			_border.graphics.lineStyle(3, 0x00ff00);
			_border.graphics.moveTo(0,0);
			_border.graphics.lineTo(0,_cSize);
			_border.graphics.lineTo(_cSize,_cSize);
			_border.graphics.lineTo(_cSize,0);
			_border.graphics.lineTo(0,0);
			_border.alpha=0
		    addChild(_border)
			
		    container=new Sprite();//容器。用来装载一个图片预览用的各种东西.
			//画一条灰色小边框。并用渐变填充。让它更像百度上传界面。具体不用深究
			container.graphics.lineStyle(1, 0xb4b4b4);
			container.graphics.moveTo(4,4);
			container.graphics.lineTo(4,_cSize-4);
			container.graphics.lineTo(_cSize-4,_cSize-4);
			container.graphics.lineTo(_cSize-4,4);
			container.graphics.lineTo(4,4);
			container.graphics.lineStyle();
			var matrix:* = new Matrix();//变换矩阵
			matrix.createGradientBox(_size, _size, 2 * Math.PI / 5);
			//渐变填充
			container.graphics.beginGradientFill(GradientType.LINEAR, [15198183, 16777215], [0.8, 0], [0, 250], matrix);
			container.graphics.drawRect(4, 4, _size+3, _size);
			container.graphics.endFill();
			container.addEventListener(MouseEvent.ROLL_OVER,onOverCon)  //侦听移入。移入时显示左右旋转和删除按钮，还有绿色的选中框
			container.addEventListener(MouseEvent.ROLL_OUT,onOutCon)   //侦听移出。移出不显示那些按钮
			container.addEventListener(MouseEvent.MOUSE_DOWN,onDownCon) //侦听鼠标点击。点击后显示选择框。并设置被选中标志isSelected。
		    addChild(container);
			
			_statusTex=new TextField();//状态输出文本域
			_statusTex.x=10;
			_statusTex.y=_cSize-30;
			_statusTex.width=80;
			_statusTex.height=18;
			_statusTex.selectable=false
			var _tmp_tf=new TextFormat    //字体格式
			_tmp_tf.color=0xffffff;
			var _tmp_gf =new GlowFilter(0xFF002F)  //发光滤镜
			var _tmp_filterA =new Array(_tmp_gf);
			_statusTex.filters=_tmp_filterA
			_statusTex.defaultTextFormat=_tmp_tf
			container.addChild(_statusTex);
			
			okIcon=new UpOkIcon  ;//上传成功小箭头
			okIcon.x=80;
			okIcon.y=80
			
			delIcon=new DelIcon  ;//删除小叉叉
			delIcon.x=73;
			delIcon.y=10;
			delIcon.addEventListener(MouseEvent.MOUSE_DOWN,onDelIcon);//侦听删除
	
		    leftIcon=new SmallLeft
			leftIcon.x=10
			leftIcon.y=10
			leftIcon.addEventListener(MouseEvent.MOUSE_DOWN,function(){//侦听左旋小按钮
					r.rotation-=90													   
																	   });
			
			
			rightIcon=new SmallRight
			rightIcon.x=50
			rightIcon.y=10
			rightIcon.addEventListener(MouseEvent.MOUSE_DOWN,function(){//侦听右旋
		    		r.rotation+=90													   
																	   });
			handleFileR();//初始化一个文件引用
			
			_loader=new Loader();//loader容器。用来获取图片预览
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);//侦听载入数据完成
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(){//检查文件编码。非图像编码显示错误
				loadOver=true  //跳过读取
				codeError=true //编码错误
				_statusTex.text="文件编码错误";
																					   })
			r=new Sprite   //旋转容器，方便旋转
			r.x=_cSize/2   
			r.y=_cSize/2
			r.addChild(_loader)
			container.addChildAt(r,0);
			
			loadingBar=new Sprite    //loading条
			loadingBar.graphics.beginFill(0x3FEB8D);
			loadingBar.graphics.drawRect(0, _cSize, _cSize, 3);
			loadingBar.graphics.endFill();
			loadingBar.scaleX=0     //先长度为0%
			container.addChild(loadingBar)
			
		}
		
		public function delAtOver(){  //上传完毕后删除对缩略图的移入移出侦听
			container.removeEventListener(MouseEvent.ROLL_OVER,onOverCon)
			container.removeEventListener(MouseEvent.ROLL_OUT,onOutCon)

			}
			
    private  function onOutCon(e:Event){//鼠标移到缩略图上将显示操作菜单
				if(loadOver){ //载入内存完毕，加入缩略图上的操作按钮，左右旋转和删除按钮
				if(container.contains(delIcon))
				container.removeChild(delIcon)
				if(container.contains(rightIcon))
				container.removeChild(rightIcon)
				if(container.contains(leftIcon))
				container.removeChild(leftIcon)
				dispatchEvent(new Event("itemOut"))
				if(_border.alpha==0.5&&!uploadOver)
				{_border.alpha=0}
						}
				}
											  
				private function onDownCon(e:Event) {//鼠标点击
					if((!uploadOver)&&loadOver){
						if(!(e.target as SmallLeft)&&(!(e.target as SmallRight))){//如果不是左右旋转按钮
					switch(_border.alpha)//判断点击前的边框alpha来执行相应操作，标示是否选择
					{
						case 1:        
						_border.alpha=0
						isSelected=false
						break;
						case 0:
						_border.alpha=1
						isSelected=true
						break;
						case 0.5:
						_border.alpha=1
						isSelected=true
						break;
						default:
						//trace("what wrong")
						break;
						}//switch
						
                    //trace(isSelected)
					dispatchEvent(new Event("itemClick"))  //分发事件通知图片组容器
						}//if2
					}//if1
					}  
											  
		private function onOverCon(e:Event){//鼠标移到缩略图上将显示操作菜单 
			if(loadOver){//如果载入完毕
				container.addChild(delIcon)
				container.addChild(rightIcon)
				container.addChild(leftIcon)
				dispatchEvent(new Event("itemOver"))
				if(_border.alpha==0&&!uploadOver){
					_border.alpha=0.5
												}
						}//if
							}//f 
										
		public function turnLeft(){//公共函数 缩略图左旋
			r.rotation-=90
			}
		public function turnRight(){//公共函数 缩略图右旋
			r.rotation+=90
			}//f
			
		private function handleFileR() {//FileReference为单个文件引用类。用来处理单个文件这里为了简单而使用。
		
			fileR.addEventListener(Event.COMPLETE, onFileExecute);//fileR.load()载入内存完毕
			fileR.addEventListener(Event.OPEN, onFileExecute);//打开待上传
			fileR.addEventListener(ProgressEvent.PROGRESS, onFileExecute);//上传中事件
			fileR.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onFileExecute);//上传完毕事件
			fileR.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onFileExecute);//安全错误
			fileR.addEventListener(IOErrorEvent.IO_ERROR, onFileExecute);//io错误。一般是上传地址
			fileR.addEventListener(HTTPStatusEvent.HTTP_STATUS, onFileExecute);//监听服务器返回状态
			if(fileR.size==0 || fileR.size>sizeLimit){//检查文件大小。0字节或者超过大小不载入
				loadOver=true
				sizeError=true
				_statusTex.text="文件大小错误";
				return
				}
		    if(filterArray.indexOf(fileR.type.toLowerCase())==-1)//检查文件格式后缀名
			{    
			    loadOver=true
				typeError=true
				_statusTex.text="文件格式错误";
				typeError=true
				}
			//_statusTex.text="载入预览图..";
			fileR.load();//开始读取图片数据到内存
		}//f
		
		private function onDelIcon(e:Event) {//点击删除小叉后发出事件，通知容器删除
			dispatchEvent(new Event("delImg"))
		}//f
		
		private function onLoaded(e:Event) {//调整缩略图大小和位置
			var w=_loader.width;
			var h=_loader.height;
			var scalePercent:Number=w/h;
			if (w>h) {
				_loader.width=_size;
				_loader.height=_size/scalePercent;
			} else if (h>w) {
				_loader.height=_size;
				_loader.width=_size*scalePercent;
			} else {
				_loader.height=_loader.width=_size;
			}
			_loader.x=-_loader.width/2;
			_loader.y=-_loader.height/2
		}

		public function upload() {//上传
		isUploading=true;
		_urlRequest.url = _urlRequest.url+"&fileName="+encodeURI(fileR.name);
		fileR.upload(_urlRequest);//执行上传
		}//function
		
		public function checkOk(){//公共函数 检测是否有错误，返回true为有错误，false无错误
			if(sizeError){
				_statusTex.text="文件大小错误";
				return true
				}
				if(typeError){
				_statusTex.text="文件类型错误";
				return true
					}
				if(codeError){
				_statusTex.text="文件编码错误";
				return true
					}
				return false
			}//function
			
		private function onFileExecute(e:Event) {//文件相关事件处理
			switch (e.type) {
				case Event.COMPLETE :            //载入完成
				//遇到载入错误（非图片编码格式），直接跳过载入
				if(checkOk()){trace("!!");loadOver=true;return}
				    _loader.loadBytes(fileR.data);
					//_statusTex.text="";
					loadOver=true
					break;
					
				case Event.OPEN :
					//遇到打开错误，（0字节）直接跳过载入内存
					if(checkOk()){trace("打开错误");loadOver=true;return}
					break;

				case ProgressEvent.PROGRESS :    //载入或者上传中
					//_statusTex.text="处理中.."
					if(checkOk()){return}
					
					if(isUploading){//如果是上传
					var persent=ProgressEvent(e).bytesLoaded/ProgressEvent(e).bytesTotal;
					loadingBar.scaleX=persent
					}
					break;

				case DataEvent.UPLOAD_COMPLETE_DATA ://发送完成
					
					if(checkOk()){_statusTex.text="文件错误!";return;}
                    //_statusTex.text="发送完毕!";
					container.addChild(okIcon);
					uploadOver=true
					dispatchEvent(new Event("itemSendOver"))
					
					break;

				case SecurityErrorEvent.SECURITY_ERROR :
					_statusTex.text="安全设置错误！";
					uploadOver=true
					dispatchEvent(new Event("itemSendOver"))
					break;

				case IOErrorEvent.IO_ERROR :
					_statusTex.text="网络或文件错误";
					uploadOver=true
					dispatchEvent(new Event("itemSendOver"))
					break;

				case HTTPStatusEvent.HTTP_STATUS :
					if (e.target.status==200) {
						_statusTex.text="服务器成功处理!";
						
					} else {
						
						_statusTex.text="服务器处理失败!";
					}
					break;

				default :
					_statusTex.text="未知事件";
					break;
			}//switch
		}//function
		
	}//class
}//pac