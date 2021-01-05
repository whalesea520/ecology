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
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import fl.managers.StyleManager;
	import flash.utils.Timer
/*   presented by yukon12345  (http://hi.baidu.com/yukon_kanzaki/blog/item/b500fd1f77d808f8e1fe0b88.html) 
	/*   
	/*   generate from BAIDU
	/*   注意：软件遵循MIT使用许可协议（http://zh.wikipedia.org/zh-cn/MIT许可证）
	/*   可自由转载,修改和用于商业用途，但使用时必须保留此注释段所有信息 2010-6-14                                                                                     
	*/
	public class YUploadImg extends Sprite {
		private var sizeLimit=5*1024*1024 //5M上传限制（此参数可更改设置）
		private var parentId = root.loaderInfo.parameters["parentId"];
		private var _upURL="/album/flash/up.jsp?parentId="+parentId;
		//上传地址请设置成你的。如果swf放在和上传处理页面同一网站文件夹，请用相对地址。（此参数可更改设置）
		private var _numLimit=20               //最大允许文件数（此参数可更改设置）
		
		
		private var _noticeCon                 //红色的提醒消息文本容器
		private var _statusTex:TextField;     //状态显示文本               
		private var _urlRequest;
		private var _UIWidth=850;             //整个上传工具的宽度高度
		private var _UIHeight=390;            
		private var _headH=50;                //头部。从最顶到灰色标题栏
		private var _imgShower;               //装载缩略图组的容器。即灰色线框
		private var _imgShowerH=256;          //容器高度
		private var _footH=80;                //底部。灰色线框底部下面所有
		private var _allowComment:Boolean=true;  //允许评论标示
		private var _allowReprint:Boolean=true;  //允许转帖标示量
		private var _footLine                    //底部点状线
		private var _sSelectBu                  //小选择添加图片按钮
		private var _selectBu                    //大  选择添加图片按钮
		private var _fileQueue=null               //文件引用队列。记录当前在显示容器里的缩略图的文件选择。包括已上传的和格式等错误的
		private var _fileRefList                 //记录文件浏览框“确定”按下时候返回的文件引用组
		private var _foot                      //底部容器
		private var _uploadBu                   //上传按钮
		private var _uploadingIndex=0           //当前正在上传的索引号
		private var _uploadedNum                  //已上传了的文件数
		private var _uploadingItem              //正在上传的缩略图类
		private var _isPause                    //是否暂停的标量
		private var _pauseBu                   //暂停按钮 
		private var _cleanUpBu                //“全部清除”按钮
 		private var _seletedItemArray=[]       //被选择的缩略图队列
		private var _allRightBu                 //将选择文件左，右，删除，转按钮
		private var _allLeftBu                 
		private var _allDelBu
		private var _tipsIsHide=true    //提示条是否显示的标志。
		private var _tipsObj           //提示条对象
		private var r1:RadioButton
		private var r2:RadioButton
		private var c1:RadioButton
		private var c2:RadioButton
		public function YUploadImg() {
			stage.scaleMode=StageScaleMode.NO_SCALE;   //不拉伸
			_urlRequest=new URLRequest();
			_urlRequest.url=_upURL;//文件上传路径
			makeHead()
			makeBody()
			makeFoot()
			_fileRefList=new FileReferenceList()
			_fileRefList.addEventListener(Event.SELECT,onFRL)
			_fileRefList.addEventListener(Event.CANCEL,onFRL)
			drawImgShower(0);//绘制显示框
		}
		
		private function  makeHead(){//头部分容器
			//分界线
			var _headLine=new DotLine
			_headLine.y=2
			addChild(_headLine)
			//小"添加图片"按钮
			_sSelectBu=new SmallSelectBu
			_sSelectBu.x=2
			_sSelectBu.y=10
			_sSelectBu.addEventListener(MouseEvent.MOUSE_DOWN,onSelectBu)
			addChild(_sSelectBu)
			//状态输出文本
			_statusTex=new TextField();
			_statusTex.x=100;
			_statusTex.y=10;
			_statusTex.height=20;
			_statusTex.width=500;
			_statusTex.text="最大上传数:"+_numLimit+"；图片不超过5M；允许类型：PNG,JPG,GIF,JPEG"
			addChild(_statusTex)
			//全部清空按钮
			_cleanUpBu=new CleanUpBu
			_cleanUpBu.x=30
			_cleanUpBu.y=_headH+5
			_cleanUpBu.addEventListener(MouseEvent.MOUSE_DOWN,function(){
						var _tmp_i=_imgShower.numChildren-1
						var _tmp_item
						var _tmp_fr
						var _tmp_j=0
						var _tmp_queuedFR
						var _tmp_hasDeled=false
						while(_tmp_i>=0){//从后向前全部删除
							_tmp_item=YItem(_imgShower.getChildAt(_tmp_i))
							if(!_tmp_item.uploadOver){
							_imgShower.removeChild(_tmp_item)
							_fileQueue.splice(_tmp_i,1)
							_tmp_hasDeled=true
								
							}//if有没上传的
							_tmp_i--
							}//while1
							
						if(_tmp_hasDeled){
							_statusTex.text="已清空未上传的图片"
							drawImgShower(_imgShower.numChildren)
							}
						else{
							notice("无可清空图片")
							}	
						if(_fileQueue.length==0){
							setEmptyState()
							}	
																	})
			
			_allRightBu=new AllRightBu   //将选择的图片右转
			_allRightBu.x=_UIWidth-200
			_allRightBu.y=_headH+5
			_allRightBu.addEventListener(MouseEvent.MOUSE_DOWN,onAllRight)
			
			_allLeftBu=new AllLeftBu   //将选择的图片左转
			_allLeftBu.x=_UIWidth-300
			_allLeftBu.y=_headH+5
			_allLeftBu.addEventListener(MouseEvent.MOUSE_DOWN,onAllLeft)
			
			_allDelBu=new AllDelBu   //将选择的图片删除
			_allDelBu.x=_UIWidth-100
			_allDelBu.y=_headH+5
			_allDelBu.addEventListener(MouseEvent.MOUSE_DOWN,onAllDel)
			
			}
		
		private function onAllLeft(e:Event){  //当点击右上角标题栏的左转
			if(_seletedItemArray.length!=0){
				
			var _tmp_i=0
			for each (var _tmp_item in _seletedItemArray){//遍历删除每一个被选择的图片
				YItem(_imgShower.getChildAt(_tmp_item.index)).turnLeft()
				}
			
			}
			else{
				notice("无选中图片")
				}
			
			}
			
		private function onAllRight(e:Event){
			if(_seletedItemArray.length!=0){
				
			var _tmp_i=0
			for each (var _tmp_item in _seletedItemArray){//遍历删除每一个被选择的图片
				YItem(_imgShower.getChildAt(_tmp_item.index)).turnRight()
				}
			
			}
			else{
				notice("无选中图片")
				}
			
			}
		private function onAllDel(e:Event){
			if(_seletedItemArray.length!=0){
				
			var _tmp_i=0
			for each (var _tmp_item in _seletedItemArray){//遍历删除每一个被选择的图片
				delImg(_tmp_item.index)
				}
			_seletedItemArray.length=0
			}
			else{
				notice("无选中图片")
				}
			}
			
	private function delImg(_tmp_index){//按索引删除图片
			_imgShower.removeChildAt(_tmp_index)//删除此图片
			_fileQueue.splice(_tmp_index,1)  //待传队列中删除此文件索引
			if(_fileQueue.length==0)//长度0，清空数组
			{_fileQueue=null
			addChild(_selectBu)
			}
			var _tmp_i=0
			var _tmp_num=_imgShower.numChildren
			while(_tmp_i<_tmp_num){//重新排列剩下的图片,item索引index也要记得改变
				_imgShower.getChildAt(_tmp_i).index=_tmp_i
				_imgShower.getChildAt(_tmp_i).x=10+(_tmp_i%8)*(_UIWidth/8)
				_imgShower.getChildAt(_tmp_i).y=30+Math.floor(_tmp_i/8)*(_imgShowerH/2)
				_tmp_i++
				
				}
				
				if(_tmp_num==0){setEmptyState()}
				drawImgShower(_tmp_num)
				
			}		
			
		private function makeBody(){
			//缩略图片队列容器
			_imgShower=new Sprite();
			_imgShower.x=2
			_imgShower.y=_headH
			addChild(_imgShower);
			
	        //大"添加图片"按钮
		    _selectBu=new SelectBu
			_selectBu.x=_UIWidth/2-_selectBu.width/2
			_selectBu.y=_headH+_imgShowerH/2
			_selectBu.addEventListener(MouseEvent.MOUSE_DOWN,onSelectBu)
			addChild(_selectBu)
			}	
			
		private function makeFoot(){
			//尾部
			_foot=new Sprite
			_foot.x=2
			_foot.y=_UIHeight-_footH
			addChild(_foot)
			//添加底部线
			_footLine=new DotLine
			_footLine.y=5
			_foot.addChild(_footLine)
			//添加上传按钮
			_uploadBu=new UploadBu
			_uploadBu.y=10
			_uploadBu.addEventListener(MouseEvent.MOUSE_DOWN,onUploadBu)
			
			
			//添加暂停按钮
			_pauseBu=new PauseBu
			_pauseBu.y=10
			_pauseBu.x=_uploadBu.width+10
			_pauseBu.addEventListener(MouseEvent.MOUSE_DOWN,onPauseBu)
			
			//“提醒”消息显示容器
			_noticeCon=new Sprite()
			_noticeCon.x=300
			_noticeCon.y=0
			_foot.addChild(_noticeCon)
			//addRadio();//添加单选按钮
			initTips()//初始化蓝色提示条
			}	
			
		private function onSelectBu(e:Event){
			_fileRefList.browse(getTypes())
			}
			
		private function onFRL(e:Event){//当文件浏览框的按钮
			
			if(e.type==Event.SELECT)//如果是“打开”
			{   
				var _tmp_num   
			    var _tmp_i =0
				var _tmp_file
				var _tmp_list
				var _tmp_hasNum
				var _tmp_newH
				
				if(_imgShower.numChildren==0)//文件待上传队列为空
				{    removeChild(_selectBu)
					_fileQueue=clone(_fileRefList.fileList) //获取一个fileList副本
					_tmp_num=_fileQueue.length  
					
					
					if(_tmp_num>_numLimit) //选择文件数超过限制
					{
					notice("所加图片数超过最大限制："+_numLimit+"，只保留前"+_numLimit+"张")
					_fileQueue.splice(_numLimit)     //截断数组只保留限制长度
					}
					_tmp_num=_fileQueue.length //处理后的长度
					
					if(Math.ceil(_tmp_num/8)>2){//超过2列
						drawImgShower(_tmp_num) //重新绘制图片显示大框
						}
					
					while(_tmp_i<_tmp_num){  //遍历可添加的文件引用，放入_imgShower图片组显示容器
						_tmp_file=new YItem(_fileQueue[_tmp_i],_upURL,sizeLimit) //YItem为我写的一个单个缩略图显示容器类
						_tmp_file.x=5+(_tmp_i%8)*(_UIWidth/8) //坐标计算
						_tmp_file.y=30+Math.floor(_tmp_i/8)*128 
						_tmp_file.index=_tmp_i     
						//监听小容器的各事件，分别是删除按钮被点击，整个容器按下，鼠标悬停，和移出
						_tmp_file.addEventListener("delImg",onDelImg)      
						_tmp_file.addEventListener("itemClick",onItemClic)
						_tmp_file.addEventListener("itemOver",onItemOver)
						_tmp_file.addEventListener("itemOut",onItemOut)
						_imgShower.addChild(_tmp_file)
						_tmp_i++
						}
						setUseState()
						
					
				 }//空
				 else{//_fileQueue不空
					 _tmp_list=_fileRefList.fileList  //接收新加入的文件
					 if(_fileQueue.length==_numLimit)//如果原本就满了
					 {
						 notice("图片图片队列已满（"+_numLimit+"张）")
						 }
					 else {//如果原本还不满
					     _tmp_list=delSameFile(_tmp_list);//删掉与在显示图片组显示容器里相同的
						 if(_fileQueue.length+_tmp_list.length>_numLimit)//旧有+新的总长度大于64
					 			{   
						 			_tmp_list.splice(_numLimit-_fileQueue.length) //把多余的扔掉
									 notice("图片总数超过最大限制："+_numLimit+"，只新加部分图片")
						 		}
								_tmp_num=_tmp_list.length
								if(_tmp_num) //经过检查过滤后不空
								{
								_tmp_hasNum=_fileQueue.length
								
								while(_tmp_i<_tmp_num){//加到原有的待传队列之后
						_tmp_file=new YItem(_tmp_list[_tmp_i],_upURL,sizeLimit)
						_tmp_file.x=5+((_tmp_i+_tmp_hasNum)%8)*(_UIWidth/8) 
						_tmp_file.y=30+Math.floor((_tmp_i+_tmp_hasNum)/8)*128
						_tmp_file.index=_tmp_i+_tmp_hasNum
						_tmp_file.addEventListener("delImg",onDelImg)
						_tmp_file.addEventListener("itemClick",onItemClic)
						_tmp_file.addEventListener("itemOver",onItemOver)
						_tmp_file.addEventListener("itemOut",onItemOut)
						_imgShower.addChild(_tmp_file)
						_tmp_i++
									}
						  _fileQueue=_fileQueue.concat(_tmp_list)//添加到文件引用数组末端
								//trace("当前文件引用："+_fileQueue)
						_tmp_num=_fileQueue.length
						if(Math.ceil(_tmp_num/8)>2){//超过2列
						drawImgShower(_tmp_num)  //重绘图片组显示框
						}
						setUseState()
						}
					       } //_fileQueue不满结束
					 }//_fileQueue不空结束
			}
        
		}
		 private function initTips(){//初始化提示条
		 _tipsObj=new TipsAll
		  _tipsObj.visible=false
		  _tipsObj.x=1800 //初始位置
		  _tipsObj.y=1000
		  _tipsObj.tipsText.selectable=false //动态文字不可被选择
		   addChild(_tipsObj)
		   addEventListener(Event.ENTER_FRAME,moveTips) //缓冲移动
			
			}
			private function moveTips(e:Event){//提示条跟随鼠标
				  if(!_tipsIsHide)//如果隐藏标量为fasl
				  {  var targetX=this.mouseX+50
				     var targetY=this.mouseY+50
					  if(stage.mouseX>512)
					    targetX=this.mouseX-50
					   if(stage.mouseY>386)
					   targetY=this.mouseY-50
					   
				   _tipsObj.x+=(targetX-_tipsObj.x)*0.2  //缓动公式
				    _tipsObj.y+=(targetY-_tipsObj.y)*0.2
					
					}
				   }
			
			 
		private function onItemOver(e:Event){  //鼠标悬停
			 _tipsIsHide=false     //显示提示条
		     _tipsObj.visible=true
			 var _tmp_item =e.target as YItem
			 _tipsObj.tipsText.text=_tmp_item.fileR.name  //提示条文字改变
			}
			
		private function onItemOut(e:Event){ //鼠标移出
			 _tipsIsHide=true
		     _tipsObj.visible=false
			}
		private function onItemClic(e:Event){//扫描一遍图片组显示容器，将选中的图片加入批量操作数组
			var _tmp_i=0
			var _tmp_item
			var _tmp_array=[]
			while(_tmp_i<_imgShower.numChildren){
				_tmp_item=YItem(_imgShower.getChildAt(_tmp_i))
				if(_tmp_item.isSelected){
					_tmp_array.push(_tmp_item)
					}
				_tmp_i++
				}
				
			_seletedItemArray=_tmp_array
			}
			
		private function onUploadBu(e:Event){//点击上传
			var _tmp_i=0
		    while(_tmp_i<_imgShower.numChildren){
				if(YItem(_imgShower.getChildAt(_tmp_i)).checkOk())
				{   notice("图片队列有错误图片，请先删除才能上传")
					return
					}
				
				_tmp_i++
				}
			
			if(_uploadingIndex<_imgShower.numChildren){
			_uploadingItem=YItem(_imgShower.getChildAt(_uploadingIndex))
			_uploadingItem.addEventListener("itemSendOver",onWaitItemSend)
			_uploadingItem.upload()
			setUpState()
			}
			else{
				notice("没有可上传的图片")
				
				}
			
			}
			
			private function setUseState(){//有图片时
				if(!_foot.contains(_uploadBu))
			_foot.addChild(_uploadBu)
			if(!contains(_cleanUpBu))
			    addChild(_cleanUpBu)
				if(!contains(_allDelBu))
			    addChild(_allDelBu)
			    if(!contains(_allRightBu))
			    addChild(_allRightBu)
				if(!contains(_allLeftBu))
			    addChild(_allLeftBu)
				//r1.enabled=r2.enabled=c1.enabled=c2.enabled=true
				}
			private function setEmptyState(){//空图片状态时
			if(_foot.contains(_uploadBu))
			_foot.removeChild(_uploadBu)
			if(_foot.contains(_pauseBu))
			_foot.removeChild(_pauseBu)
			if(contains(_cleanUpBu))
			removeChild(_cleanUpBu)
			if(!contains(_selectBu))
			addChild(_selectBu)
			
			if(contains(_allDelBu))
			    removeChild(_allDelBu)
			    if(contains(_allRightBu))
			    removeChild(_allRightBu)
				if(contains(_allLeftBu))
			    removeChild(_allLeftBu)
			//r1.enabled=r2.enabled=c1.enabled=c2.enabled=false
			
					}
			private function setUpState(){//正在上传时
			_isPause=false
			if(_foot.contains(_uploadBu))
			_foot.removeChild(_uploadBu)
			if(!_foot.contains(_pauseBu))
			_foot.addChild(_pauseBu)
			if(contains(_cleanUpBu))
			removeChild(_cleanUpBu)
			
			if(contains(_allDelBu))
			    removeChild(_allDelBu)
			    if(contains(_allRightBu))
			    removeChild(_allRightBu)
				if(contains(_allLeftBu))
			    removeChild(_allLeftBu)
			//r1.enabled=r2.enabled=c1.enabled=c2.enabled=false
				}
			private function setPauseState(){//暂停时
			_isPause=true
			if(_foot.contains(_pauseBu))
			_foot.removeChild(_pauseBu)
			if(!_foot.contains(_uploadBu))
			_foot.addChild(_uploadBu)
			if(!contains(_cleanUpBu))
			addChild(_cleanUpBu)
			if(!contains(_allDelBu))
			    addChild(_allDelBu)
			    if(!contains(_allRightBu))
			    addChild(_allRightBu)
				if(!contains(_allLeftBu))
			    addChild(_allLeftBu)
				//r1.enabled=r2.enabled=c1.enabled=c2.enabled=true
			
				}	
			private function onWaitItemSend(e:Event){//分步一张一张上传图片。等待上一张的上传完毕
				_statusTex.text="正在上传第"+(_uploadingItem.index+1)+"张图片(共"+_fileQueue.length+"张)"
				_uploadingItem.alpha=0.5
				_uploadingItem.delAtOver()
				_uploadingIndex=_uploadingItem.index+1
				if(!_isPause)
				 {
				continueUpload(_uploadingIndex)
				 }
				 else{
					 _statusTex.text="已暂停上传..."
					 }
				}
		  private function onPauseBu(e:Event){//暂停按钮
			  setPauseState()
			  }		
		  private function continueUpload(_tmp_index){//上传下一张
			  if(_tmp_index<_fileQueue.length){
			  _uploadingItem=YItem(_imgShower.getChildAt(_tmp_index))
			_uploadingItem.addEventListener("itemSendOver",onWaitItemSend)
			_uploadingItem.upload()
			  }
			  else{
				  _statusTex.text="共"+_fileQueue.length+"张图片上传完毕"
				  setPauseState()
				  }
			  }
		  
		function notice(_str){ //提醒信息显示函数
	        
			var _tmp_i=0
			while(_tmp_i<_noticeCon.numChildren){//当有新消息时遍历提醒容器，将显示中的每个消息上移一个位置
				if(_noticeCon.getChildAt(_tmp_i)){
				_noticeCon.getChildAt(_tmp_i).y-=18
				_noticeCon.getChildAt(_tmp_i).alpha-=0.3
				}
				_tmp_i++
			}
			var _errorTex=new TextField(); //初始化一个新消息
			var _tmp_tf=new TextFormat
			_tmp_tf.color=0xff0000
			_tmp_tf.align="center";
			_errorTex.defaultTextFormat=_tmp_tf
			_errorTex.x=0;
			_errorTex.y=18;
			_errorTex.height=18;
			_errorTex.width=300;
			_errorTex.text="提醒:"+_str
			
			_noticeCon.addChild(_errorTex)
			var _tmp_timer=new Timer(1000,3)//设置定时器，3次移动提示一条文本后删除该提示文本
			_tmp_timer.addEventListener(TimerEvent.TIMER,function (){
				_errorTex.y-=5;  //每上移一步变透明一点
			    _errorTex.alpha-=0.33
			})
			
			_tmp_timer.addEventListener(TimerEvent.TIMER_COMPLETE,function(){//3次计时后删除
				if(_errorTex){
				_noticeCon.removeChild(_errorTex)
				_errorTex=null
				}
			})
			
			_tmp_timer.start()

			}
		
		private function clone(_fArr:Array) : Array{//返回传入的数组的副本
			var _tmp_i=0
			var _tmp_retArr=[]
			while(_tmp_i<_fArr.length){
				_tmp_retArr.push(_fArr[_tmp_i])
				_tmp_i++
				}
				
				return _tmp_retArr;
			}
		private function delSameFile(_fArr:Array) : Array //从新入图片中剔除与已在缩略图组容器内完全相同的图片并返回一个拷贝
        {
            var _tmp_i
			var _tmp_j
            var _tmp_num//新入图片长度
            var _tmp_fr:FileReference;//单个新入队文件
            var _tmp_isEqual:Boolean = false;//判断是否相同
            var _tmp_fQNum;//已入队文件的长度
            var _tmp_queuedFR:FileReference = null;//单个已入队文件
            var _tmp_retArr:Array = [];
			var _tmp_hasSame=false
            if (_fArr)//新入队文件列
            {   
                _tmp_i = 0;
                _tmp_num = _fArr.length;
                while (_tmp_i < _tmp_num)
                {
                    _tmp_fr = _fArr[_tmp_i] as FileReference;
                    _tmp_isEqual = false;
                    _tmp_j = 0;
                    _tmp_fQNum = this._fileQueue.length;
                    while (_tmp_j < _tmp_fQNum)
                    {   
                        _tmp_queuedFR = this._fileQueue[_tmp_j] as FileReference;
                        if (_tmp_fr.name == _tmp_queuedFR.name && _tmp_fr.type == _tmp_queuedFR.type && _tmp_fr.size == _tmp_queuedFR.size && _tmp_fr.modificationDate.time == _tmp_queuedFR.modificationDate.time && _tmp_fr.creationDate.time == _tmp_queuedFR.creationDate.time)
                        {   _tmp_hasSame=true
                            _tmp_isEqual = true;
							
                            break;
                        }
                        _tmp_j = _tmp_j + 1;
                    }
                    if (!_tmp_isEqual)
                    {
                        _tmp_retArr.push(_tmp_fr);
                    }
                    _tmp_i = _tmp_i + 1;
                }
            }
			if(_tmp_hasSame){notice("新入图片与原图片组有重复，已删除相同图片")}
            return _tmp_retArr;
        }// end function
		
		private function onDelImg(e:Event){//按下删除小按钮时
		var _tmp_item=e.target as YItem
		delImg(_tmp_item.index)
			}
		private function addRadio() { //添加2组单选按钮
			var cG:RadioButtonGroup=new RadioButtonGroup("allowComment");
			var rG:RadioButtonGroup=new RadioButtonGroup("allowReprint");
			 c1 = new RadioButton();
			 c2 = new RadioButton();
			 r1 = new RadioButton();
			 r2 = new RadioButton();
			c1.addEventListener(MouseEvent.CLICK, announceGroup);
			c2.addEventListener(MouseEvent.CLICK, announceGroup);
			r1.addEventListener(MouseEvent.CLICK, announceGroup);
			r2.addEventListener(MouseEvent.CLICK, announceGroup);
			var tf:TextFormat = new TextFormat();
			tf.size=12;
			StyleManager.setStyle("textFormat", tf);
			c1.label="允许评论";
			c2.label="禁止评论";
			r1.label="允许转载";
			r2.label="禁止转载";
			c1.value=true;
			c2.value=false;
			r1.value=true;
			r2.value=false;
			c1.group=cG;
			c2.group=cG;
			r1.group=rG;
			r2.group=rG;
			c1.selected=true;
			r1.selected=true;
			
			c1.move(10,0);
			c2.move(100,0);
			r1.move(10,20);
			r2.move(100,20);

			_foot.addChild(c1);
			_foot.addChild(c2);
			_foot.addChild(r1);
			_foot.addChild(r2);
		}

		function announceGroup(e:MouseEvent):void {  //响应点选按钮事件
			var rb:RadioButton=e.target as RadioButton;
			if (rb.groupName=="allowComment") {
				_allowComment=rb.value;
			} else {
				_allowReprint=rb.value;
			}
		}


		private function drawImgShower(_tmp_num) {//根据缩略图张数重绘上传显示框大小
			var _tmp_height
			if(Math.ceil(_tmp_num/8)<3){//小于2行时 整个UI界面高390，上传显示框高为256
				_tmp_height=_imgShowerH
				_UIHeight=390
				_foot.y=_UIHeight-_footH
				}
				else if(Math.ceil(_tmp_num/8)>2){//大于2行时，每多一行上传框高+128，同时下部操作界面:_foot移动
						_tmp_height=Math.ceil(_tmp_num/8)*128  
						_UIHeight=390+(Math.ceil(_tmp_num/8)-2)*128 
						_foot.y=_UIHeight-_footH
						}
			var _tmp_gp=this._imgShower.graphics;//绘制大框
			_tmp_gp.clear();
			_tmp_gp.lineStyle(1, 13684944);
			_tmp_gp.beginFill(0xfffffe);
			_tmp_gp.drawRect(0, 0, _UIWidth-4, _tmp_height);
			_tmp_gp.endFill();
			_tmp_gp.lineStyle();
			_tmp_gp.beginFill(15658734);       //绘制小标题栏
			_tmp_gp.drawRect(0.5, 0.5, _UIWidth-5, 22);
		}
		
		
        private function getTypes():Array {//返回允许类型数组
			var allTypes:Array = new Array();
			allTypes.push(getImageTypeFilter());
			//allTypes.push(getTextTypeFilter());
			return allTypes;
		}

		private function getImageTypeFilter():FileFilter {//FileFilter类。（1.说明文字，2允许后缀）
			return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
		}

		
	}//class
}//pac