//取消输入框后面跟随的红色惊叹号
function checkinput(elementname,spanid){
	tmpvalue = document.all(elementname).value;
	
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	if(tmpvalue!=""){		
		 document.all(spanid).innerHTML='';
	}
	else{
	 document.all(spanid).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 document.all(elementname).value = "";
	}
}
//判断email格式是否正确
function checkinput_email(elementname,spanid){
	tmpvalue = document.all(elementname).value;
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	if (tmpvalue=="" || tmpvalue.indexOf("@") <1 || tmpvalue.indexOf(".") <1 || tmpvalue.length <5) {	
	 document.all(spanid).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 document.all(elementname).value = "";
	}else{
	 document.all(spanid).innerHTML='';
	}
}

function checkinput1(elementname,spanid){
	tmpvalue = elementname.value;
	
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	if(tmpvalue!=""){		
		 spanid.innerHTML='';
	}
	else{
	 spanid.innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 elementname.value = "";
	}
}
//判断input框中是否输入的是数字,包括小数点
function ItemNum_KeyPress()
{
 if(!(((window.event.keyCode>=48) && (window.event.keyCode<=57)) || window.event.keyCode==46))
  {
     window.event.keyCode=0;
  }
}

//判断input框中是否输入的是数字,不包括小数点
function ItemCount_KeyPress()
{
 if(!((window.event.keyCode>=48) && (window.event.keyCode<=57)) || window.event.keyCode==45 )
  {
     window.event.keyCode=0;
  }
}

//判断input框中是否输入的是数字,包括"-"
function ItemPhone_KeyPress()
{
 if(!(((window.event.keyCode>=48) && (window.event.keyCode<=57)) || window.event.keyCode==45))
  {
     window.event.keyCode=0;
  }
}

//判断input框中是否输入的是数字,不包括小数点
function checkcount(objectname)
{	
	valuechar = document.all(objectname).value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)) isnumber = true ;}
	if(isnumber) document.all(objectname).value = "" ;
}

function checkcount1(objectname)
{	
	valuechar = objectname.value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)) isnumber = true ;}
	if(isnumber) objectname.value = "" ;
}



//判断input框中是否输入的是数字,包括小数点
function checknumber(objectname)
{	
	valuechar = document.all(objectname).value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!=".") isnumber = true ;}
	if(isnumber) document.all(objectname).value = "" ;
}
function checknumber1(objectname)
{	
	valuechar = objectname.value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!=".") isnumber = true ;}
	if(isnumber) objectname.value = "" ;
}

//判断input框中是否输入的是数字,包括"-"
function checkphone(objectname)
{	
	valuechar = document.all(objectname).value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!="-") isnumber = true ;}
	if(isnumber) document.all(objectname).value = "" ;
}
function checkphone1(objectname)
{	
	valuechar = objectname.value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!="-") isnumber = true ;}
	if(isnumber) objectname.value = "" ;
}

function ItemTime_KeyPress()
{
 if(!((window.event.keyCode>=48) && (window.event.keyCode<=58)))
  {
     window.event.keyCode=0;
  }
}

function checktime(objectname)
{	
	valuechar = document.all(objectname).value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!=":") isnumber = true ;}
	if(isnumber) document.all(objectname).value = "" ;
}

function checktime1(objectname)
{	
	valuechar = objectname.value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!=":") isnumber = true ;}
	if(isnumber) objectname.value = "" ;
}


//判断input框中是否输入的是英文字母和数字，并且以字母开头
function checkinput_char_num(objectname)
{	
	valuechar = document.all(objectname).value.split("") ;
	notcharnum = false ;
	notchar = false ;
	notnum = false ;
	for(i=0 ; i<valuechar.length ; i++) {
		notchar = false ;
		notnum = false ;
		charnumber = parseInt(valuechar[i]) ; if(isNaN(charnumber)) notnum = true ;
		if(valuechar[i].toLowerCase()<'a' || valuechar[i].toLowerCase()>'z') notchar = true ;
		if(notnum && notchar) notcharnum = true ;
	}
	if(valuechar[0].toLowerCase()<'a' || valuechar[0].toLowerCase()>'z') notcharnum = true ;
	if(notcharnum) document.all(objectname).value = "" ;
}
