
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="DetailFieldComInfo" class="weaver.workflow.field.DetailFieldComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String strInputMainField = "";
String strInputMainInitField = "";

String strTextareaMainField = "";
String strTextareaMainInitField = "";

String strSelectMainField = "";
String strSelectMainInitField = "";

String strCheckMainField = "";
String strCheckMainInitField = "";

String strBrowserMainField = "";
String strBrowserMainInitField = "";
while(FieldComInfo.next()){
	String _fieldid = FieldComInfo.getFieldid();
	String _fieldname = FieldComInfo.getFieldname();
	
	if(FieldComInfo.getFieldhtmltype(_fieldid).equals("1")) {
		strInputMainField +="<option value='"+_fieldid+"'>"+_fieldname+"</option>";
		if(strInputMainInitField.equals(""))	strInputMainInitField = _fieldname;
	}else if(FieldComInfo.getFieldhtmltype(_fieldid).equals("2")) {
		strTextareaMainField +="<option value='"+_fieldid+"'>"+_fieldname+"</option>";
		if(strTextareaMainInitField.equals(""))	strTextareaMainInitField = _fieldname;
	}else if(FieldComInfo.getFieldhtmltype(_fieldid).equals("5")) {
		strSelectMainField +="<option value='"+_fieldid+"'>"+_fieldname+"</option>";
		if(strSelectMainInitField.equals(""))	strSelectMainInitField = _fieldname;
	}else if(FieldComInfo.getFieldhtmltype(_fieldid).equals("4")) {
		strCheckMainField +="<option value='"+_fieldid+"'>"+_fieldname+"</option>";
		if(strCheckMainInitField.equals(""))	strCheckMainInitField = _fieldname;
	}else if(FieldComInfo.getFieldhtmltype(_fieldid).equals("3")) {
		strBrowserMainField +="<option value='"+_fieldid+"'>"+_fieldname+"</option>";
		if(strBrowserMainInitField.equals(""))	strBrowserMainInitField = _fieldname;
	}
}
String sql ="";
int formid = Util.getIntValue(request.getParameter("formid"),0) ;	
int nElementNum1 = 0;
String piecesShow = "";
String type = Util.null2String(request.getParameter("src")) ;
if(type.equals(""))
	type = "addform";
		
if(!type.equals("addform")){

	ArrayList formfieldids = new ArrayList();
	ArrayList formfieldlabels = new ArrayList();
	sql = "select * from workflow_fieldlable where formid = "+formid+" and langurageid = 7";
	rs.executeSql(sql);
	while(rs.next()){
		formfieldids.add(rs.getString("fieldid"));
		formfieldlabels.add(rs.getString("fieldlable"));
	}
	
	sql = "select * from workflow_formprop where formid = "+formid;
	rs.executeSql(sql);
	
	while(rs.next()){
		String objid = rs.getString("objid");
		int nElementNum = Util.getIntValue(objid);
		String objval = rs.getString("objtype");
		String fieldlabel = "";
		String fieldname = "";
		String fieldid = Util.null2String(rs.getString("fieldid"));
		int _pos = formfieldids.indexOf(fieldid) ;
		if(_pos != -1)
			fieldlabel = ""+formfieldlabels.get(_pos);
		
		
		String isdetail = rs.getString("isdetail");
		if(isdetail.equals("1"))
			fieldname = DetailFieldComInfo.getFieldname(fieldid);
		else
			fieldname = FieldComInfo.getFieldname(fieldid);
			
		if(objval.equals("1")){
			
			String _colorbold = Util.null2String(rs.getString("attribute2"));
			String _color="black";
			String _showHtml = Util.toHtml(rs.getString("defvalue"));
			String _isbold = " font-weight:bold ";
			
			int tmppos = _colorbold.indexOf(":");
			if(tmppos != -1){
				_color=_colorbold.substring(0,tmppos);
				
				String _tmpstr = _colorbold.substring(tmppos);
				if(!_tmpstr.equals(":1") || _tmpstr.equals(""))
					_isbold = " font-weight:normal ";
			}
			
			String _fontsize = Util.null2String(rs.getString("attribute1"));
			if(!_fontsize.equals(""))
				_fontsize = " font-size:"+_fontsize;
			
			piecesShow +="<move:piece SNAPABLE =1 style='left:"+rs.getString("ptx")+"px;top:"+rs.getString("pty")+"px;width="+rs.getString("width")+"px;height="+rs.getString("height")+"px'  id='sPiece_"+objval+"_"+objid+"' ><div  id='sItem_"+objval+"_"+objid+"' style='color:"+_color+";"+_fontsize+";"+_isbold+"'>"+_showHtml+"</div></move:piece>";
			
		}else if(objval.equals("2")){
			piecesShow +="<move:piece SNAPABLE =1 style='left:"+rs.getString("ptx")+"px;top:"+rs.getString("pty")+"px;width="+rs.getString("width")+"px;height="+rs.getString("height")+"px'  id='sPiece_"+objval+"_"+objid+"' ><img id='sItem_"+objval+"_"+nElementNum+"'  style='width:99%;height:99%' src=\""+rs.getString("defvalue")+"\" border='"+rs.getString("attribute1")+"'></move:piece>";
		}else if(objval.equals("3")){
			String _tmpvalue = fieldname;
			
			String _color = Util.null2String(rs.getString("attribute2"));
			if(!_color.equals(""))
				_color=" background-color:"+_color;
			
			String _defvalue = Util.null2String(rs.getString("defvalue"));
			
			if(!_defvalue.equals(""))
				_tmpvalue += "{"+_defvalue+"}";
			piecesShow +="<move:piece SNAPABLE =1 style='left:"+rs.getString("ptx")+"px;top:"+rs.getString("pty")+"px;width="+rs.getString("width")+"px;height="+rs.getString("height")+"px;"+_color+"'  id='sPiece_"+objval+"_"+objid+"' ><span  id='sTitle_"+objval+"_"+nElementNum+"'>"+fieldlabel+"</span><input id='sItem_"+objval+"_"+nElementNum+"' value='"+_tmpvalue+"' style='width:80%;'></move:piece>";
		}else if(objval.equals("4")){
			String _tmpvalue = fieldname;
			String _defvalue = Util.null2String(rs.getString("defvalue"));
			String _color = Util.null2String(rs.getString("attribute2"));
			if(!_color.equals(""))
				_color=" background-color:"+_color;
			
			if(!_defvalue.equals(""))
				_tmpvalue += "{"+_defvalue+"}";
			piecesShow +="<move:piece SNAPABLE =1 style='left:"+rs.getString("ptx")+"px;top:"+rs.getString("pty")+"px;width="+rs.getString("width")+"px;height="+rs.getString("height")+"px;"+_color+"'  id='sPiece_"+objval+"_"+objid+"' ><span  id='sTitle_"+objval+"_"+nElementNum+"'>"+fieldlabel+"</span><textarea id='sItem_"+objval+"_"+nElementNum+"'  style='width:80%;height:80%'>"+_tmpvalue+"</textarea></move:piece>";
		}else if(objval.equals("5")){
			String _color = Util.null2String(rs.getString("attribute2"));
			if(!_color.equals(""))
				_color=" background-color:"+_color;
			
			piecesShow +="<move:piece SNAPABLE =1 style='left:"+rs.getString("ptx")+"px;top:"+rs.getString("pty")+"px;width="+rs.getString("width")+"px;height="+rs.getString("height")+"px;"+_color+"'  id='sPiece_"+objval+"_"+objid+"' ><span  id='sTitle_"+objval+"_"+nElementNum+"'>"+fieldlabel+"</span><select id='sItem_"+objval+"_"+nElementNum+"' style='width:80%;'><option>"+fieldname+"</optoin></select></move:piece>";
		}else if(objval.equals("6")){
			String _color = Util.null2String(rs.getString("attribute2"));
			if(!_color.equals(""))
				_color=" background-color:"+_color;
			
			String isdef=Util.null2String(rs.getString("defvalue"));
			String bchecked ="";
			if(isdef.equals("1")){
				bchecked = " checked ";
			}
			piecesShow +="<move:piece SNAPABLE =1 style='left:"+rs.getString("ptx")+"px;top:"+rs.getString("pty")+"px;width="+rs.getString("width")+"px;height="+rs.getString("height")+"px;"+_color+"'  id='sPiece_"+objval+"_"+objid+"' ><span  id='sTitle_"+objval+"_"+nElementNum+"'>"+fieldlabel+"</span><input type=checkbox id='sItem_"+objval+"_"+nElementNum+"' value='1'  "+bchecked+" ><span  id='sItem_"+objval+"_"+nElementNum+"_div'>"+fieldname+"</span></move:piece>";
		}else if(objval.equals("7")){
			piecesShow +="<move:piece SNAPABLE =1 style='background: #666666;left:"+rs.getString("ptx")+"px;top:"+rs.getString("pty")+"px;width="+rs.getString("width")+"px;height="+rs.getString("height")+"px;'  id='sPiece_"+objval+"_"+objid+"' ><span  id='sTitle_"+objval+"_"+nElementNum+"'>"+fieldlabel+"</span></move:piece>";
		}else if(objval.equals("9")){
			String _color = Util.null2String(rs.getString("attribute2"));
			if(!_color.equals(""))
				_color=" background-color:"+_color;
			
			piecesShow +="<move:piece SNAPABLE =1 style='left:"+rs.getString("ptx")+"px;top:"+rs.getString("pty")+"px;width="+rs.getString("width")+"px;height="+rs.getString("height")+"px;"+_color+"'  id='sPiece_"+objval+"_"+objid+"' ><span  id='sTitle_"+objval+"_"+nElementNum+"'>"+fieldlabel+"</span><img id='sItem_"+objval+"_"+nElementNum+"' src='/images/formdesign/browser_wev8.gif' border=0 ><span  id='sItem_"+objval+"_"+nElementNum+"_div'>"+fieldname+"</span></move:piece>";
		}
		
		
		if(nElementNum > nElementNum1)
			nElementNum1 =nElementNum;	
	}
}
%>
<HTML xmlns:move>
<HEAD>
<STYLE>
    @media all
    {
	    move\:piece     { 
	                    behavior: url(/htc/movable.htc);
	                    color: black;
	                    border:3 dotted pink;
	                    font: bold 10pt verdana;
	                    mv--boundary:30 800 1630 30;
	                    mv--grid:30 30
	                    }
    }
    
                    
    .bound          {
                    position: absolute;
                    top: 20;
                    left: 20;
                    width: 770;
                    height: 1600
                    }
	

</STYLE>
<script language="javascript">

var nElementNum = <%=nElementNum1%>;
var srcObj;
var lastObj;
var objDocument = window.parent.leftFrame.document;
function onDown(){
  
	var objval = document.all("objtype").value;
	var ptx = window.event.x;
	var pty = window.event.y;
		
	if(objval == "1"){
		nElementNum ++;
		var oDiv = document.createElement("div");
		var sHtml = "<move:piece SNAPABLE =1 style='left:"+ptx+"px;top:"+pty+"px;width=240px;height=30px'  id='sPiece_"+objval+"_"+nElementNum+"'  ><div  id='sItem_"+objval+"_"+nElementNum+"' ><%=SystemEnv.getHtmlLabelName(22360, user.getLanguage())%></div></move:piece>"; 
		oDiv.innerHTML = sHtml;
		oDivbound.appendChild(oDiv);			
	}else if(objval == "2"){
		nElementNum ++;
		var oDiv = document.createElement("div");
		var sHtml = "<move:piece  SNAPABLE =1 style='left:"+ptx+"px;top:"+pty+"px;width=240px;height=30px' id='sPiece_"+objval+"_"+nElementNum+"'  ><img id='sItem_"+objval+"_"+nElementNum+"'  style='width:99%;height:99%'></move:piece>"; 
		oDiv.innerHTML = sHtml;
		oDivbound.appendChild(oDiv);
	}else if(objval == "3"){
		nElementNum ++;
		var oDiv = document.createElement("div");
		var sHtml = "<move:piece  SNAPABLE =1 style='left:"+ptx+"px;top:"+pty+"px;width=240px;height=30px' id='sPiece_"+objval+"_"+nElementNum+"'  ><span  id='sTitle_"+objval+"_"+nElementNum+"'><%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%></span><input id='sItem_"+objval+"_"+nElementNum+"' value='<%=strInputMainInitField%>' style='width:80%;'></move:piece>"; 
		oDiv.innerHTML = sHtml;
		oDivbound.appendChild(oDiv);	
	}else if(objval == "4"){
		nElementNum ++;
		var oDiv = document.createElement("div");
		var sHtml = "<move:piece  SNAPABLE =1 style='left:"+ptx+"px;top:"+pty+"px;width=240px;height=30px' id='sPiece_"+objval+"_"+nElementNum+"'  ><span  id='sTitle_"+objval+"_"+nElementNum+"'><%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%></span><textarea id='sItem_"+objval+"_"+nElementNum+"'  style='width:80%;height:80%'><%=strTextareaMainInitField%></textarea></move:piece>"; 
		oDiv.innerHTML = sHtml;
		oDivbound.appendChild(oDiv);
	}else if(objval == "5"){
		nElementNum ++;
		var oDiv = document.createElement("div");
		var sHtml = "<move:piece  SNAPABLE =1 style='left:"+ptx+"px;top:"+pty+"px;width=240px;height=30px' id='sPiece_"+objval+"_"+nElementNum+"'  ><span  id='sTitle_"+objval+"_"+nElementNum+"'><%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%></span><select id='sItem_"+objval+"_"+nElementNum+"' style='width:80%;'><option><%=strSelectMainInitField%></option></select></move:piece>"; 
		oDiv.innerHTML = sHtml;
		oDivbound.appendChild(oDiv);
	}else if(objval == "6"){
		nElementNum ++;
		var oDiv = document.createElement("div");
		var sHtml = "<move:piece  SNAPABLE =1 style='left:"+ptx+"px;top:"+pty+"px;width=240px;height=30px' id='sPiece_"+objval+"_"+nElementNum+"'  ><span  id='sTitle_"+objval+"_"+nElementNum+"'><%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%></span><input type=checkbox id='sItem_"+objval+"_"+nElementNum+"' value='1' checked ><span  id='sItem_"+objval+"_"+nElementNum+"_div'><%=strCheckMainInitField%></span></move:piece>"; 
		oDiv.innerHTML = sHtml;
		oDivbound.appendChild(oDiv);
	}else if(objval == "9"){
		nElementNum ++;
		var oDiv = document.createElement("div");
		var sHtml = "<move:piece  SNAPABLE =1 style='left:"+ptx+"px;top:"+pty+"px;width=240px;height=30px' id='sPiece_"+objval+"_"+nElementNum+"'  ><span  id='sTitle_"+objval+"_"+nElementNum+"'><%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%></span><img id='sItem_"+objval+"_"+nElementNum+"' src='/images/formdesign/browser_wev8.gif' border=0 ><span  id='sItem_"+objval+"_"+nElementNum+"_div'><%=strBrowserMainInitField%></span></move:piece>"; 
		oDiv.innerHTML = sHtml;
		oDivbound.appendChild(oDiv);
	}else if(objval == "7"){
		nElementNum ++;
		var oDiv = document.createElement("div");
		var sHtml = "<move:piece  SNAPABLE =1 style='background: #666666;left:"+ptx+"px;top:"+pty+"px;width=240px;height=3px' id='sPiece_"+objval+"_"+nElementNum+"'  ></move:piece>"; 
		oDiv.innerHTML = sHtml;
		oDivbound.appendChild(oDiv);
	}
	
	if(objval != "0"){	
		srcObj = window.document.all("sPiece_"+objval+"_"+nElementNum);
		
		var oDiv = objDocument.createElement("div");
		var sHtml = "<input type='hidden' name='prop_"+objval+"_"+nElementNum+"_ptx' value='"+ptx+"'>"; 
		sHtml += "<input type='hidden' name='prop_"+objval+"_"+nElementNum+"_pty' value='"+pty+"'>"; 
		sHtml += "<input type='hidden' name='prop_"+objval+"_"+nElementNum+"_width' value='240'>"; 
		sHtml += "<input type='hidden' name='prop_"+objval+"_"+nElementNum+"_height' value='30'>"; 
		oDiv.innerHTML = sHtml;
		objDocument.all("oMPC").appendChild(oDiv);	
	}else
		srcObj = window.event.srcElement;
	
	
	setPropertyDefault(objval,nElementNum);	
	objDocument.all("img_"+(objval*1+1)).src = "/images/formdesign/"+(objval*1+1)+".gif";
	document.all("objtype").value = "0";
	objDocument.all("img_1").src = "/images/formdesign/1-down_wev8.gif";
	
	//使页面内有被聚焦的对象
	document.all("objshowfocus").style.display="";
	document.all("objshowfocus").focus();
	document.all("objshowfocus").style.display="none";
	
}

function setPropertyDefault(objval,objid){
	
	
	var itemList = objDocument.all("itemList"); 
	var len = itemList.length;	
	var propertyTable = objDocument.all("propertyTable");
	
	allobj = objDocument.all;
	for(i=0 ; i<allobj.length ; i++) { 
       		if(allobj[i].id.indexOf("oTr_")!=-1 && allobj[i].style.display==""){
       			allobj[i].style.display='none';       			
       		}
	}
	
	var iFormsOption="";
	iFormsOption += "<option value='0'><%=SystemEnv.getHtmlLabelName(129060, user.getLanguage())%></option>";
	iFormsOption += "<option value='1'><%=SystemEnv.getHtmlLabelName(129061, user.getLanguage())%></option>";

	if(objval == "0"){		
		var optionval ="0";
		if(lastObj)
			lastObj.style.border="3 dotted pink";
		var tureobj = srcObj;
		if(srcObj.tagName.toLowerCase() !="piece")
			tureobj = srcObj.parentElement;	
			
		var trueobjid = tureobj.id;
		if(trueobjid.indexOf("sPiece_")!=-1){
			optionval = trueobjid.substring(7);
			tureobj.style.border="3 solid black";
			
			lastObj = tureobj;
		}	
		
		
		itemList.value=optionval;
		for(i=0 ; i<allobj.length ; i++) { 
			if(allobj[i].id.indexOf("oTr_"+optionval+"_")!=-1 && allobj[i].style.display=="none"){
				allobj[i].style.display='';       			
			}
		}
	}
	
	if(objval == "1"){
		itemList.options[len] = new Option("<%=SystemEnv.getHtmlLabelName(22360, user.getLanguage())%>_"+objid,objval+"_"+objid); 
		itemList.options[len].selected = true;
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_1";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(345, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<textarea name='prop_"+objval+"_"+objid+"_1' class=Inputstyle rows=6 cols=23 onchange='changeProp(this,"+objval+","+objid+",1);'><%=SystemEnv.getHtmlLabelName(22360, user.getLanguage())%></textarea>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);		
		
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_2";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(16197, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		//var sHtml = "<input type='text' class=Inputstyle name='prop_"+objval+"_"+objid+"_2' size=18 value='normal small-caps bold 12pt serif' onchange='changeProp(this,"+objval+","+objid+",2);'>"; 
		//var sHtml = "<textarea name='prop_"+objval+"_"+objid+"_2' class=Inputstyle rows=6 cols=23 onchange='changeProp(this,"+objval+","+objid+",2);'>normal small-caps bold 12pt serif</textarea>"; 
		var sHtml = "<select style='width:100%;' name='prop_"+objval+"_"+objid+"_2' onchange='changeProp(this,"+objval+","+objid+",2);'><option value=''></option><option value='xx-small'>xx-small</option><option value='x-small'>x-small</option><option value='small'>small</option><option value='medium'>medium</option><option value='large'>large</option><option value='x-large'>x-large</option><option value='xx-large'>xx-large</option></select>"; 
		
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_3";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(495, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		//var sHtml = "<input type='text' class=Inputstyle name='prop_"+objval+"_"+objid+"_3' size=18 value='black' onchange='changeProp(this,"+objval+","+objid+",3);'>"; 
		var sHtml = "<BUTTON type='button' CLASS=Browser onclick='SelectColor(this,"+objval+","+objid+",3);'>&nbsp;</BUTTON><span name='prop_"+objval+"_"+objid+"_3_span' id='prop_"+objval+"_"+objid+"_3_span' style='width:20;height:20;background-color:black;'>&nbsp;</span>"; 
		sHtml += "<input type='hidden' class=Inputstyle name='prop_"+objval+"_"+objid+"_3' size=18 value='black' onchange='changeProp(this,"+objval+","+objid+",3);'>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);		
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_4";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(16198, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<input type='checkbox' class=Inputstyle name='prop_"+objval+"_"+objid+"_4' size=18 value='1' onchange='changeProp(this,"+objval+","+objid+",4);' checked >"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		//更多的属性设置。。。
		
	}else if(objval == "2"){
		itemList.options[len] = new Option("<%=SystemEnv.getHtmlLabelName(83737, user.getLanguage())%>_"+objid,objval+"_"+objid); 
		itemList.options[len].selected = true;
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_1";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(15240, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<input type='file' class=Inputstyle name='prop_"+objval+"_"+objid+"_1' size=8 onchange='changeProp(this,"+objval+","+objid+",1);'>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);	
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_2";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(128028, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<input type='text' class=Inputstyle name='prop_"+objval+"_"+objid+"_2' size=18 value='0' onchange='changeProp(this,"+objval+","+objid+",2);'>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);		
		
		//更多的属性设置。。。
	}else if(objval == "3"){
		itemList.options[len] = new Option("<%=SystemEnv.getHtmlLabelName(128146, user.getLanguage())%>_"+objid,objval+"_"+objid); 
		itemList.options[len].selected = true;
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_10";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(700, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<select style='width:100%;' name='prop_"+objval+"_"+objid+"_10' onchange='changeProp(this,"+objval+","+objid+",10);'>"+iFormsOption+"</select>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_1";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<input type='text' class=Inputstyle name='prop_"+objval+"_"+objid+"_1' value='<%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%>' size=18 onchange='changeProp(this,"+objval+","+objid+",1);'>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_2";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(261, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<select style='width:100%;' name='prop_"+objval+"_"+objid+"_2' onchange='changeProp(this,"+objval+","+objid+",2);'><%=strInputMainField%></select>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_3";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(19206, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<input type='text' class=Inputstyle name='prop_"+objval+"_"+objid+"_3' size=18 onchange='changeProp(this,"+objval+","+objid+",3);'>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);	
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_11";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(495, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<BUTTON type='button' CLASS=Browser onclick='SelectColor(this,"+objval+","+objid+",11);'>&nbsp;</BUTTON><span name='prop_"+objval+"_"+objid+"_11_span' id='prop_"+objval+"_"+objid+"_11_span' style='width:20;height:20;'>&nbsp;</span>"; 
		sHtml += "<input type='hidden' class=Inputstyle name='prop_"+objval+"_"+objid+"_11' size=18 value='' onchange='changeProp(this,"+objval+","+objid+",11);'>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		
		
	}else if(objval == "4"){
		itemList.options[len] = new Option("<%=SystemEnv.getHtmlLabelName(128148, user.getLanguage())%>_"+objid,objval+"_"+objid); 
		itemList.options[len].selected = true;
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_10";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(700, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<select style='width:100%;' name='prop_"+objval+"_"+objid+"_10' onchange='changeProp(this,"+objval+","+objid+",10);'>"+iFormsOption+"</select>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_1";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<input type='text' class=Inputstyle name='prop_"+objval+"_"+objid+"_1'  value='<%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%>' size=18 onchange='changeProp(this,"+objval+","+objid+",1);'>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_2";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(261, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<select style='width:100%;' name='prop_"+objval+"_"+objid+"_2' onchange='changeProp(this,"+objval+","+objid+",2);'><%=strTextareaMainField%></select>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_3";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(19206, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<input type='text' class=Inputstyle name='prop_"+objval+"_"+objid+"_3' size=18 onchange='changeProp(this,"+objval+","+objid+",3);'>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);	
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_11";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(495, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<BUTTON type='button' CLASS=Browser onclick='SelectColor(this,"+objval+","+objid+",11);'>&nbsp;</BUTTON><span name='prop_"+objval+"_"+objid+"_11_span' id='prop_"+objval+"_"+objid+"_11_span' style='width:20;height:20;'>&nbsp;</span>"; 
		sHtml += "<input type='hidden' class=Inputstyle name='prop_"+objval+"_"+objid+"_11' size=18 value='' onchange='changeProp(this,"+objval+","+objid+",11);'>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		
	}else if(objval == "5"){
		itemList.options[len] = new Option("<%=SystemEnv.getHtmlLabelName(690, user.getLanguage())%>_"+objid,objval+"_"+objid); 
		itemList.options[len].selected = true;
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_10";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(700, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<select style='width:100%;' name='prop_"+objval+"_"+objid+"_10' onchange='changeProp(this,"+objval+","+objid+",10);'>"+iFormsOption+"</select>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_1";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<input type='text' class=Inputstyle name='prop_"+objval+"_"+objid+"_1'  value='<%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%>' size=18 onchange='changeProp(this,"+objval+","+objid+",1);'>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);		
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_2";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(261, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<select style='width:100%;' name='prop_"+objval+"_"+objid+"_2' onchange='changeProp(this,"+objval+","+objid+",2);'><%=strSelectMainField%></select>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_3";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(19206, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<input type='text' class=Inputstyle name='prop_"+objval+"_"+objid+"_3' size=18 onchange='changeProp(this,"+objval+","+objid+",3);'>"; 
	//	var sHtml = "<select style='width:100%;' name='prop_"+objval+"_"+objid+"_3' onchange='changeProp(this,"+objval+","+objid+",3);'><option value='0'>不默认</option><option value='1' selected >默认</option></select>";
		
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);	
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_11";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(495, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<BUTTON type='button' CLASS=Browser onclick='SelectColor(this,"+objval+","+objid+",11);'>&nbsp;</BUTTON><span name='prop_"+objval+"_"+objid+"_11_span' id='prop_"+objval+"_"+objid+"_11_span' style='width:20;height:20;'>&nbsp;</span>"; 
		sHtml += "<input type='hidden' class=Inputstyle name='prop_"+objval+"_"+objid+"_11' size=18 value='' onchange='changeProp(this,"+objval+","+objid+",11);'>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		
	}else if(objval == "6"){
		itemList.options[len] = new Option("<%=SystemEnv.getHtmlLabelName(127059, user.getLanguage())%>_"+objid,objval+"_"+objid); 
		itemList.options[len].selected = true;
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_10";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(700, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<select style='width:100%;' name='prop_"+objval+"_"+objid+"_10' onchange='changeProp(this,"+objval+","+objid+",10);'>"+iFormsOption+"</select>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_1";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<input type='text' class=Inputstyle name='prop_"+objval+"_"+objid+"_1'  value='<%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%>' size=18 onchange='changeProp(this,"+objval+","+objid+",1);'>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_2";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(261, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<select style='width:100%;' name='prop_"+objval+"_"+objid+"_2' onchange='changeProp(this,"+objval+","+objid+",2);'><%=strCheckMainField%></select>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_3";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(19206, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<select style='width:100%;' name='prop_"+objval+"_"+objid+"_3' onchange='changeProp(this,"+objval+","+objid+",3);'><option value='0'>不选中</option><option value='1' selected >选中</option></select>";
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);	
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_11";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(495, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<BUTTON type='button' CLASS=Browser onclick='SelectColor(this,"+objval+","+objid+",11);'>&nbsp;</BUTTON><span name='prop_"+objval+"_"+objid+"_11_span' id='prop_"+objval+"_"+objid+"_11_span' style='width:20;height:20;'>&nbsp;</span>"; 
		sHtml += "<input type='hidden' class=Inputstyle name='prop_"+objval+"_"+objid+"_11' size=18 value='' onchange='changeProp(this,"+objval+","+objid+",11);'>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
	}else if(objval == "9"){
		itemList.options[len] = new Option("<%=SystemEnv.getHtmlLabelName(32306, user.getLanguage())%>_"+objid,objval+"_"+objid); 
		itemList.options[len].selected = true;
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_10";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(700, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<select style='width:100%;' name='prop_"+objval+"_"+objid+"_10' onchange='changeProp(this,"+objval+","+objid+",10);'>"+iFormsOption+"</select>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_1";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<input type='text' class=Inputstyle name='prop_"+objval+"_"+objid+"_1'  value='<%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%>' size=18 onchange='changeProp(this,"+objval+","+objid+",1);'>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_2";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(261, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<select style='width:100%;' name='prop_"+objval+"_"+objid+"_2' onchange='changeProp(this,"+objval+","+objid+",2);'><%=strBrowserMainField%></select>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_3";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(19206, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
	//	var sHtml = "<input type='text' class=Inputstyle name='prop_"+objval+"_"+objid+"_3' size=18 onchange='changeProp(this,"+objval+","+objid+",3);'>"; 
		var sHtml = "<select style='width:100%;' name='prop_"+objval+"_"+objid+"_3' onchange='changeProp(this,"+objval+","+objid+",3);'><option value='' selected >不默认</option><option value='1'>默认</option></select>";
		
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);	
		
		oRow = propertyTable.insertRow();
		oRow.id="oTr_"+objval+"_"+objid+"_11";
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<%=SystemEnv.getHtmlLabelName(495, user.getLanguage())%>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
		oCell = oRow.insertCell(); 
		var oDiv = objDocument.createElement("div");
		var sHtml = "<BUTTON type='button' CLASS=Browser onclick='SelectColor(this,"+objval+","+objid+",11);'>&nbsp;</BUTTON><span name='prop_"+objval+"_"+objid+"_11_span' id='prop_"+objval+"_"+objid+"_11_span' style='width:20;height:20;'>&nbsp;</span>"; 
		sHtml += "<input type='hidden' class=Inputstyle name='prop_"+objval+"_"+objid+"_11' size=18 value='' onchange='changeProp(this,"+objval+","+objid+",11);'>"; 
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
	}else if(objval == "7"){
		itemList.options[len] = new Option("<%=SystemEnv.getHtmlLabelName(128026, user.getLanguage())%>_"+objid,objval+"_"+objid); 
		itemList.options[len].selected = true;
	}			
	//objDocument.all("oMPC").selectedIndex = 2;		
}


function deleteObj(){
	if(event.keyCode==46){
		if(lastObj){
			top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344, user.getLanguage())%>", function (){
				//alert(lastObj.id);
				var optionval1 = lastObj.id.substring(7);				
				var optionval ="0";
				document.all("sPiece_"+optionval1).style.display='none';
				var propertyTable = objDocument.all("propertyTable");
				
				allobj = objDocument.all;
				for(i=0 ; i<allobj.length ; i++) { 
			       		if((allobj[i].id.indexOf("oTr_"))!=-1 && allobj[i].style.display==""){
			       			allobj[i].style.display='none';       			
			       		}
				}
				for(i=0 ; i<allobj.length ; i++) { 
					if((allobj[i].id.indexOf("oTr_"+optionval+"_"))!=-1 && allobj[i].style.display=="none"){
						allobj[i].style.display='';       			
					}
				}		
				
				var itemList = objDocument.all("itemList"); 
				var len = itemList.length;		
				for(i=0;i<len;i++){
					if((itemList.options[i] != null) && (itemList.options[i].value == optionval1)){
						itemList.options[i] = null;
						itemList.value = optionval;
					}				
				}
				lastObj=null;
			}, function () {}, 320, 90,true);
		}	
	}	
	window.event.returnValue=false;
}
function deleteObj1(){
		if(lastObj){
			top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344, user.getLanguage())%>", function (){
				//alert(lastObj.id);
				var optionval1 = lastObj.id.substring(7);				
				var optionval ="0";
				document.all("sPiece_"+optionval1).style.display='none';
				var propertyTable = objDocument.all("propertyTable");
				
				allobj = objDocument.all;
				for(i=0 ; i<allobj.length ; i++) { 
			       		if((allobj[i].id.indexOf("oTr_"))!=-1 && allobj[i].style.display==""){
			       			allobj[i].style.display='none';       			
			       		}
				}
				for(i=0 ; i<allobj.length ; i++) { 
					if((allobj[i].id.indexOf("oTr_"+optionval+"_"))!=-1 && allobj[i].style.display=="none"){
						allobj[i].style.display='';       			
					}
				}		
				
				var itemList = objDocument.all("itemList"); 
				var len = itemList.length;		
				for(i=0;i<len;i++){
					if((itemList.options[i] != null) && (itemList.options[i].value == optionval1)){
						itemList.options[i] = null;
						itemList.value = optionval;
					}				
				}
				lastObj=null;
			}, function () {}, 320, 90,true);
		}
}


function onOver(){
	if(lastObj){
		var element = lastObj;
		
		iHtop = (window.event.y - element.offsetTop)*(window.event.y - element.offsetTop);
		iHbottom = (window.event.y - (element.offsetTop+element.offsetHeight))*(window.event.y - (element.offsetTop+element.offsetHeight));
		iHleft =(window.event.x - element.offsetLeft)*(window.event.x - element.offsetLeft);
		iHright =(window.event.x - (element.offsetLeft+element.offsetWidth))*(window.event.x - (element.offsetLeft+element.offsetWidth));
		
		iMaxDis = 25;
		if(iHtop <= iMaxDis && iHleft <= iMaxDis) {
			element.style.cursor="NW-resize";
		}else if(iHtop <= iMaxDis && iHright <= iMaxDis) {
			element.style.cursor="NE-resize";
		}else if(iHtop <= iMaxDis ) {
			element.style.cursor="N-resize";
		}else if(iHbottom <= iMaxDis && iHleft <= iMaxDis) {
			element.style.cursor="SW-resize";
		}else if(iHbottom <= iMaxDis && iHright <= iMaxDis) {
			element.style.cursor="SE-resize";
		}else if(iHbottom <= iMaxDis ) {
			element.style.cursor="S-resize";
		}else if(iHleft <= iMaxDis ) {
			element.style.cursor="W-resize";
		}else if(iHright <= iMaxDis ) {
			element.style.cursor="E-resize";
		}else {
			element.style.cursor="move";
		}	
		
		
	}
}

function onUp(){
	
	var tureobj = srcObj;
	if(srcObj.tagName.toLowerCase() !="piece")
		tureobj = srcObj.parentElement;	
		
	var trueobjid = tureobj.id;
	var optionval="";
	if(trueobjid.indexOf("sPiece_")!=-1){
		optionval = trueobjid.substring(7);
	}	
	
	if(optionval!=""){
		objDocument.all("prop_"+optionval+"_ptx").value=tureobj.offsetLeft;
		objDocument.all("prop_"+optionval+"_pty").value=tureobj.offsetTop;
		objDocument.all("prop_"+optionval+"_width").value=tureobj.offsetWidth;
		objDocument.all("prop_"+optionval+"_height").value=tureobj.offsetHeight;		
	}
}

document.onkeydown = deleteObj;
document.onmousedown = onDown;
document.onmouseup = onUp;
document.onmouseover = onOver;
document.onmousemove = onOver;
</script>
</HEAD>

<BODY background="/images/formdesign/pix_wev8.gif" >

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(91, user.getLanguage())+",javascript:deleteObj1(),_self}" ;
        RCMenuHeight += RCMenuHeightStep ;
   
    %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<input type=hidden name="objtype" value="0">
<input type=text name="objshowfocus" value="0" style="display:none">

<div id=oDivbound>
</div>
<%=piecesShow%>

</BODY>

</HTML>
