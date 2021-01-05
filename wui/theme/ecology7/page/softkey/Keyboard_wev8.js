//定义当前是否大写的状态
window.onload=function(){
	password1=null;		
	setCalcButtonBg();
}


var CapsLockValue=0;

document.write("<style>#softkeyboard td{text-align:center; background-color:#ebebeb;border:1px solid #cccccc;}#softkeyboard input{ border:0;background:#ebebeb;}</style>");
document.write("<DIV align=center id=\"softkeyboard\" name=\"softkeyboard\" style=\"font-family:'微软雅黑';position:absolute; left:0px; top:0px; width:550px; z-index:180;display:none\">  <table id=\"CalcTable\" width=\"100%\" align=\"center\" cellpadding=\"2\" cellspacing=\"0\" bgcolor=\"#ebebeb\" style='border:3px solid #cccccc'>           <FORM id=Calc name=Calc action=\"\" method=post autocomplete=\"off\">       <tr> <td id='keyBoardTitle' title=\"泛微软键盘\" align=\"right\" valign=\"middle\" bgcolor=\"\" style=\"cursor: move;height:30\"> <INPUT type=hidden value=\"\" name=password>  <INPUT type=hidden value=ok name=action2> <span style=\"font-size:13px; padding-right:45px;width:350px\">泛微软键盘</span><INPUT style=\"width:100px;height:30px;padding-top:3px;background-color:#ebebeb;border:1px solid #999999\" type=button value=\"使用键盘输入\" bgtype=\"1\" onclick=\"closekeyboard()\"><span style=\"width:2px;\"></span> </td>      </tr>      <tr align=\"center\">         <td align=\"center\" bgcolor=\"#FFFFFF\"> <table id=\"buttonTB\" align=\"center\"  width=\"100%\" border=\"0\" cellspacing=\"1\" cellpadding=\"0\">\n          <tr> \n            <td> <input type=button value=\" ~ \"> </td>\n            <td> <input type=button value=\" ! \"> </td>\n            <td> <input type=button  value=\" @ \"> </td>\n            <td> <input type=button value=\" # \"> </td>\n            <td> <input type=button value=\" $ \"> </td>\n            <td> <input type=button value=\" % \"> </td>\n            <td> <input type=button value=\" ^ \"> </td>\n            <td> <input type=button value=\" & \"> </td>\n            <td> <input type=button value=\" * \"> </td>\n            <td> <input type=button value=\" ( \"> </td>\n            <td> <input type=button value=\" ) \"> </td>\n            <td> <input type=button value=\" _ \"> </td>\n            <td> <input type=button value=\" + \"> </td>\n            <td> <input type=button value=\" | \"> </td>\n            <td rowspan=\"2\"> <input name=\"button10\" style=\"padding-top:3px;\" type=button value=\"退格\" onclick=\"setpassvalue();\"  onDblClick=\"setpassvalue();\" style=\"width:100px;height:42px\"> </td>\n          </tr>\n          <tr> <td> <input type=button value=\" ` \"> </td>\n            <td> <input type=button value=\" 1 \"> </td>\n            <td> <input type=button value=\" 2 \"> </td>\n            <td> <input type=button value=\" 3 \"> </td>\n            <td> <input type=button value=\" 4 \"> </td>\n            <td> <input type=button value=\" 5 \"> </td>\n            <td> <input type=button value=\" 6 \"> </td>\n            <td> <input type=button value=\" 7 \"> </td>\n            <td> <input type=button value=\" 8 \"> </td>\n            <td> <input type=button value=\" 9 \"> </td>\n            <td> <input name=\"button6\" type=button value=\" 0 \"> </td>\n            <td> <input type=button value=\" - \"> </td>\n            <td> <input type=button value=\" = \"> </td>\n            <td> <input type=button value=\" \\ \"> </td>\n            </tr>\n          <tr> \n            <td> <input type=button value=\" q \"> </td>\n            <td> <input type=button value=\" w \"> </td>\n            <td> <input type=button value=\" e \"> </td>\n            <td> <input type=button value=\" r \"> </td>\n            <td> <input type=button value=\" t \"> </td>\n            <td> <input type=button value=\" y \"> </td>\n            <td> <input type=button value=\" u \"> </td>\n            <td> <input type=button value=\" i \"> </td>\n            <td> <input type=button value=\" o \"> </td>\n            <td> <input name=\"button8\" type=button value=\" p \"> </td>\n            <td> <input name=\"button9\" type=button value=\" { \"> </td>\n            <td> <input type=button value=\" } \"> </td>\n            <td> <input type=button value=\" [ \"> </td>\n            <td> <input type=button value=\" ] \"> </td>\n            <td> <input name=\"button9\" type=button onClick=\"capsLockText();setCapsLock();\"  onDblClick=\"capsLockText();setCapsLock();\" value=\"切换大/小写\" style=\"padding-top:1px;width:100px;\"> </td>\n          </tr>\n          <tr> \n            <td> <input type=button value=\" a \"> </td>\n            <td> <input type=button value=\" s \"> </td>\n            <td> <input type=button value=\" d \"> </td>\n            <td> <input type=button value=\" f \"> </td>\n            <td> <input type=button value=\" g \"> </td>\n            <td> <input type=button value=\" h \"> </td>\n            <td> <input type=button value=\" j \"> </td>\n            <td> <input name=\"button3\" type=button value=\" k \"> </td>\n            <td> <input name=\"button4\" type=button value=\" l \"> </td>\n            <td> <input name=\"button5\" type=button value=\" : \"> </td>\n            <td> <input name=\"button7\" type=button value=\" &quot; \"> </td>\n            <td> <input type=button value=\" ; \"> </td>\n            <td> <input type=button value=\" ' \"> </td>\n            <td rowspan=\"2\" colspan=\"2\"> <input name=\"button12\" type=button onclick=\"OverInput();\" value=\"   确定  \" style=\"padding-top:2px;width:130px;height:42px\"> </td>\n          </tr>\n          <tr> \n            <td> <input name=\"button2\" type=button value=\" z \"> </td>\n            <td> <input type=button value=\" x \"> </td>\n            <td> <input type=button value=\" c \"> </td>\n            <td> <input type=button value=\" v \"> </td>\n            <td> <input type=button value=\" b \"> </td>\n            <td> <input type=button value=\" n \"> </td>\n            <td> <input type=button value=\" m \"> </td>\n            <td> <input type=button value=\" &lt; \"> </td>\n            <td> <input type=button value=\" &gt; \"> </td>\n            <td> <input type=button value=\" ? \"> </td>\n            <td> <input type=button value=\" , \"> </td>\n            <td> <input type=button value=\" . \"> </td>\n            <td> <input type=button value=\" / \"> </td>\n          </tr>\n        </table> </td>    </FORM>      </tr>  </table></DIV>");

//给输入的密码框添加新值
function addValue(newValue) {
	if (CapsLockValue==0) {
		Calc.password.value += newValue;
	}
	else {
		Calc.password.value += newValue.toUpperCase();
	}
	password1.value=Calc.password.value;
}

//实现BackSpace键的功能
function setpassvalue() {
	var longnum=Calc.password.value.length;
	var num
	num=Calc.password.value.substr(0,longnum-1);
	Calc.password.value=num;
	var str=Calc.password.value;
	password1.value=Calc.password.value;
}

//输入完毕
function OverInput() {
	var str=Calc.password.value;
	password1.value=Calc.password.value;
	softkeyboard.style.display="none";
	Calc.password.value="";
	password1.readOnly=0;
}

//关闭软键盘
function closekeyboard() {
	password1.readOnly=0;
	password1.focus();
	softkeyboard.style.display="none";
	password1.value="";
}

//显示软键盘

function showkeyboard(event) {
	softkeyboard.style.top=300+"px";
	if(parseInt(event.clientX-390)>0) {
		softkeyboard.style.left=(event.clientX-390)+"px";
	}
	else {
		softkeyboard.style.left=0;
	}
	Calc.password.value="";
	softkeyboard.style.display="block";
	password1.readOnly=1;
	password1.blur();
	password1.value="";
}

//设置是否大写的值
function setCapsLock() {
	if(CapsLockValue==0) {
		CapsLockValue=1
	}
	else {
		CapsLockValue=0
	}
}

function setCalcButtonBg() {
	for(var i=0;i<Calc.elements.length;i++){
		if(Calc.elements[i].type=="button" && Calc.elements[i].bgtype!="1") {
			var str1=Calc.elements[i].value;
			str1=str1.trim();
			if(parseInt(str1.length)==1) 
			{
				Calc.elements[i].style.width="20px";
				Calc.elements[i].style.height="20px";
				Calc.elements[i].onclick=function() {
					var thisButtonValue=this.value.trim();
					addValue(thisButtonValue);
				}
			}
		}
	}
}

String.prototype.trim = function() {
    // 用正则表达式将前后空格
    // 用空字符串替代。
    return this.replace(/(^\s*)|(\s*$)/g, "");
}

var capsLockFlag;
capsLockFlag=true;

function capsLockText() {
	if(capsLockFlag)//改成大写
	{
		for(var i=0;i<Calc.elements.length;i++) {
			var char=Calc.elements[i].value;
			var char=char.trim()
			if(Calc.elements[i].type=="button" && char>="a" && char<="z" && char.length==1) {
			
				Calc.elements[i].value=" "+String.fromCharCode(char.charCodeAt(0)-32)+" "
			}
		}
	}
	else
	{
		for(var i=0;i<Calc.elements.length;i++) {
			var char=Calc.elements[i].value;
			var char=char.trim()
			if(Calc.elements[i].type=="button" && char>="A" && char<="Z" && char.length==1) {
			
				Calc.elements[i].value=" "+String.fromCharCode(char.charCodeAt(0)+32)+" "
			}
		}
	}
	capsLockFlag=!capsLockFlag;
}

function checkKeyBoard(inputObj,event){
	inputObj.value="";
	password1=inputObj;
	showkeyboard(event);
	inputObj.readOnly=1;
}

/*-------------------------鼠标拖动---------------------*/ 
var od = document.getElementById("keyBoardTitle");
var odContent = document.getElementById("softkeyboard"); 
var dx,dy,mx,my,mouseD;
var odrag;
var isIE = document.all ? true : false;
document.onmousedown = function(e){
	var e = e ? e : event;
	if(e.button == (document.all ? 1 : 0)) {
		mouseD = true;   
	}
}
document.onmouseup = function(){
	mouseD = false;
	odrag = "";
	if(isIE){
		od.releaseCapture();
		//od.filters.alpha.opacity = 100;
	}
	else{
		window.releaseEvents(od.MOUSEMOVE);
		od.style.opacity = 1;
	}  
}

//function readyMove(e){ 
od.onmousedown = function(e){
	odrag = this;
	var e = e ? e : event;
	if(e.button == (document.all ? 1 : 0)){
		mx = e.clientX;
		my = e.clientY;
		od.style.left = od.offsetLeft + "px";
		od.style.top = od.offsetTop + "px";
		if(isIE){
			od.setCapture();    
			//od.filters.alpha.opacity = 50;
		}
		else{
			window.captureEvents(Event.MOUSEMOVE);
			od.style.opacity = 0.5;
		}
	} 
}
document.onmousemove = function(e){
	var e = e ? e : event;
	if(mouseD==true && odrag){  
		var mrx = e.clientX - mx;
		var mry = e.clientY - my; 
		od.style.left = parseInt(od.style.left) +mrx + "px";
		od.style.top = parseInt(od.style.top) + mry + "px";   
		odContent.style.left = parseInt(odContent.style.left) +mrx + "px";
		odContent.style.top = parseInt(odContent.style.top) + mry + "px";   
		mx = e.clientX;
		my = e.clientY;
	}
}

