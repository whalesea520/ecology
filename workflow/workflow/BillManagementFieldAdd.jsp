
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.lang.*" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ taglib uri="/browser" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="session"/>
<jsp:useBean id="FieldManager" class="weaver.workflow.field.FieldManager" scope="session"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src="/js/ecology8/request/autoSelect_wev8.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

</head>
<%
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}

	boolean canedit=true;
	int rowsum=0;
	String type="";
	String type2="";
	String fieldname="";
	String fielddbtype="";
	String fieldhtmltype="";
	int htmltypeid=0;
	String textlength="";
	int childfieldid = 0;
	String childfieldname = "";
    String imgwidth="100";
    String imgheight="100";
    String textheight="5";
	int fieldid=0;
	int billId = 0;
	float orderNum = 0;
	int fieldlabel = 0;
	String sql = "";

	fieldid=Util.getIntValue(Util.null2String(request.getParameter("fieldid")),0);
	billId=Util.getIntValue(Util.null2String(request.getParameter("billId")),0);
	int isdetail = 0;
	Hashtable selectitem_sh = new Hashtable();
	sql="select max(dsporder) as maxOrder from workflow_billfield where viewtype = 0 and billid = " + billId;
	RecordSet.execute(sql);
	if(RecordSet.next()){
		orderNum = Util.getFloatValue(RecordSet.getString("maxOrder"), 0);
	}
	orderNum +=1;
		
	//add by xhheng @ 20041213 for TDID 1230
	String isused="";
    isused=Util.null2String(request.getParameter("isused"));
	String message = Util.null2String(request.getParameter("message"));

	type = Util.null2String(request.getParameter("src"));
	type2 = Util.null2String(request.getParameter("srcType"));
	if(type=="")
		type = "addfield";
	if(!type.equals("addfield"))
	{
		/*
		FieldManager.setFieldid(fieldid);
        if(type2.equals("mainfield")){
		    FieldManager.getFieldInfo();
        }else if(type2.equals("detailfield")){
		    FieldManager.getDetailFieldInfo();
        }
		fieldname=FieldManager.getFieldname();
		fielddbtype=FieldManager.getFielddbtype();
		fieldhtmltype=FieldManager.getFieldhtmltype();
		htmltypeid=FieldManager.getType();
		if(fieldhtmltype.equals("1")&&htmltypeid==1){
            if(RecordSet.getDBType().equals("oracle")){
			    textlength=fielddbtype.substring(9,fielddbtype.length()-1);
            }else{
                textlength=fielddbtype.substring(8,fielddbtype.length()-1);
            }
        }
		*/
		rs.execute("select * from workflow_billfield where billid="+billId+" and id="+fieldid);
		if(rs.next()){
			fielddbtype = Util.null2String(rs.getString("fielddbtype"));
			fieldhtmltype = Util.null2String(rs.getString("fieldhtmltype"));
			htmltypeid = Util.getIntValue(rs.getString("type"), 0);
			childfieldid = Util.getIntValue(rs.getString("childfieldid"), 0);
			fieldlabel = Util.getIntValue(rs.getString("fieldlabel"), 0);
			orderNum = Util.getFloatValue(rs.getString("dsporder"), 0);
            imgwidth = Util.null2String(rs.getString("imgwidth"));
            imgheight = Util.null2String(rs.getString("imgheight"));
            textheight= Util.null2String(rs.getString("textheight"));
			if(fieldhtmltype.equals("1")&&htmltypeid==1){
	            if(RecordSet.getDBType().equals("oracle")){
				    textlength=fielddbtype.substring(9,fielddbtype.length()-1);
	            }else{
	                textlength=fielddbtype.substring(8,fielddbtype.length()-1);
	            }
	        }
		}
	}
	Hashtable childItem_hs = new Hashtable();
	if(childfieldid > 0){
		sql = "select * from workflow_billfield where billid="+billId+" and id="+childfieldid;
		
		rs.execute(sql);
		if(rs.next()){
			childfieldname = SystemEnv.getHtmlLabelName(Util.getIntValue(rs.getString("fieldlabel"), 0), user.getLanguage());
		}
		sql="select * from workflow_SelectItem where fieldid="+childfieldid+" and isbill=1 order by selectvalue";
		rs.execute(sql);
		while(rs.next()){
			String selectname=rs.getString("selectname");
			String selectvalue=rs.getString("selectvalue");
			childItem_hs.put("item"+selectvalue, selectname);
		}
	}
if(fieldlabel != 0){
	fieldname = Util.null2String(SystemEnv.getHtmlLabelName(fieldlabel, user.getLanguage()));
}
if("null".equalsIgnoreCase(fieldname)){
	fieldname = "";
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="";
String needhelp ="";

String actionType = "add";
if(type.equals("addfield")){
    if(type2.equals("mainfield")){
        titlename+=SystemEnv.getHtmlLabelName(82,user.getLanguage())+":";
        titlename+=SystemEnv.getHtmlLabelName(6074,user.getLanguage());
        titlename+=SystemEnv.getHtmlLabelName(261,user.getLanguage());
    }else{
        titlename+=SystemEnv.getHtmlLabelName(82,user.getLanguage())+":";
        titlename+=SystemEnv.getHtmlLabelName(17463,user.getLanguage());
        titlename+=SystemEnv.getHtmlLabelName(261,user.getLanguage());
    }
}else{
	actionType = "edit";
    if(type2.equals("mainfield")){
        titlename+=SystemEnv.getHtmlLabelName(93,user.getLanguage())+":";
        titlename+=SystemEnv.getHtmlLabelName(6074,user.getLanguage());
        titlename+=SystemEnv.getHtmlLabelName(261,user.getLanguage());
    }else{
        titlename+=SystemEnv.getHtmlLabelName(93,user.getLanguage())+":";
        titlename+=SystemEnv.getHtmlLabelName(17463,user.getLanguage());
        titlename+=SystemEnv.getHtmlLabelName(261,user.getLanguage());
    }
}

String texttype="htmltypelist.options[0]=new Option('"+SystemEnv.getHtmlLabelName(608,user.getLanguage())+"',1);"+"\n"+
		"htmltypelist.options[1]=new Option('"+SystemEnv.getHtmlLabelName(696,user.getLanguage())+"',2);"+"\n"+
		"htmltypelist.options[2]=new Option('"+SystemEnv.getHtmlLabelName(697,user.getLanguage())+"',3);"+"\n"+
		"htmltypelist.options[3]=new Option('"+SystemEnv.getHtmlLabelName(22395,user.getLanguage())+"',5);"+"\n";
String browsertype="";
String browserlabelid="";
//int i=0;
browsertype+="jQuery(htmltypelist).append(\"<option></option>\");"+"\n";
while(BrowserComInfo.next()){
	if(BrowserComInfo.getBrowserurl().equals("")){ continue;}
	 if(("224".equals(BrowserComInfo.getBrowserid()))||"225".equals(BrowserComInfo.getBrowserid())){
         //这里属于系统表单，占不支持新的sap功能
 		 continue;
 	 }
 	  if("226".equals(BrowserComInfo.getBrowserid())||"227".equals(BrowserComInfo.getBrowserid())){
         //这里属于系统表单，占不支持新的sap功能
 		 continue;
 	 }
 	 if (BrowserComInfo.notCanSelect()) continue;
	//browsertype+="htmltypelist.options["+i+"]=new Option('"+
		//SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),user.getLanguage())+
		//"',"+BrowserComInfo.getBrowserid()+");"+"\n";
	//i++;
 	browsertype+="jQuery(htmltypelist).append(\"<option match='"+BrowserComInfo.getBrowserPY(user.getLanguage())+"' value='" + BrowserComInfo.getBrowserid() + "'>"+SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),user.getLanguage())+"</option>\");"+"\n";
}
BrowserComInfo.setToFirstrow();

String specialtype="htmltypelist.options[0]=new Option('"+SystemEnv.getHtmlLabelName(21692,user.getLanguage())+"',1);"+"\n"+
		"htmltypelist.options[1]=new Option('"+SystemEnv.getHtmlLabelName(21693,user.getLanguage())+"',2);"+"\n";

%>

<%
	BaseBean bbrm = new BaseBean();
	int userm = 1;
	userm = Util.getIntValue(bbrm.getPropValue("systemmenu", "userightmenu"), 1);
%>
<body <%if(userm ==1){%> onload="shieldingRightMenu();" <% }%>>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(canedit){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/workflow/workflow/BillManagementDetail.jsp?billId="+billId+",_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
	if(userm == 1) {
		if(!actionType.equals("") && actionType.equals("edit") && !fieldhtmltype.equals("") && fieldhtmltype.equals("5")){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(15443,user.getLanguage())+",javascript:addRow(),_self}" ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(15444,user.getLanguage())+",javascript:submitClear(),_self}" ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		if(!actionType.equals("") && actionType.equals("add")){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(15443,user.getLanguage())+",javascript:addRow(),_self}" ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(15444,user.getLanguage())+",javascript:submitClear(),_self}" ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		hiddenmenu=1;
	}else {
		if(actionType.equals("edit") && fieldhtmltype.equals("5")){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(15443,user.getLanguage())+",javascript:addRow(),_self}";
				RCMenuHeight += RCMenuHeightStep ;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(15444,user.getLanguage())+",javascript:submitClear(),_self}" ;
				RCMenuHeight += RCMenuHeightStep ;
		}
		if(actionType.equals("add")) {
			RCMenu += "{"+SystemEnv.getHtmlLabelName(15443,user.getLanguage())+",javascript:addRow(),_self}" ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu +="{"+SystemEnv.getHtmlLabelName(15444,user.getLanguage())+",javascript:submitClear(),_self}";
			RCMenuHeight += RCMenuHeightStep ;
		}	
	}

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="form1" method="post" action="BillManagementFieldOperation.jsp" >
   <input type="hidden" value="<%=type%>" name="src">
   <input type="hidden" value="<%=type2%>" name="srcType">
   <input type="hidden" value="<%=fieldid%>" name="fieldid">
   <input type="hidden" value="<%=actionType%>" name="actionType">
   <input type="hidden" value="<%=billId%>" name="billId">
   <!-- modify by xhheng @ 20041222 for TDID 1230-->
   <input type="hidden" value="<%=isused%>" name="isused">
	<input type="hidden" value="<%=actionType%>" name="actionType">
	
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

   <table class="viewform" width="100%">
   <COLGROUP>
   <COL width="10%">
   <COL width="20%">
   <COL width="35%">
   <COL width="35%">
   <TR class="Title">
    	  <TH colSpan=4><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%>
          <%
              String tmpStr = "";
if(message.equals("1")){
    tmpStr = "<font color=red>"+SystemEnv.getHtmlLabelName(15440,user.getLanguage())+"!</font>";
}else if(message.equals("2")){
    tmpStr = "<font color=red>"+SystemEnv.getHtmlLabelName(18556,user.getLanguage())+"</font>";
}
          %>
          <%=tmpStr%>
          </TH></TR>
    <TR class="Spacing" style="height:1px;">
    	  <TD class="Line1" colSpan=4></TD></TR>

  <tr>
    <td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
    <%if(canedit){%>
    <td class=field colspan=3><input class=Inputstyle type="text" name="fieldname" size="40" value="<%=fieldname%>"
	onBlur='checkinput("fieldname","fieldnamespan")'>
    <span id=fieldnamespan><%if("".equals(fieldname)){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span> (<%=SystemEnv.getHtmlLabelName(18557,user.getLanguage())%>)</td>
    <%} else {%>
    <td class=field colspan=3><%=SystemEnv.getHtmlLabelName(fieldlabel, user.getLanguage())%></td><%}%>
  </tr>
<tr class="Spacing" style="height:1px;">
	<td colspan="4" class="Line"></td>
</tr>

  <tr>
    <td><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%></td>
    <td class=field>
    <%if(canedit){%>
    <!-- modify by xhheng @ 20041222 for TDID 1230-->
    <%if(isused.equals("true")){%>
      <input type="hidden" value="<%=fieldhtmltype%>" name="fieldhtmltype">
      <select class=inputstyle  size="1" id="fieldhtmltype" name="fieldhtmltype" onChange="showType()" disabled style="float: left;">
    <%}else{%>
      <select class=inputstyle  size="1" id="fieldhtmltype" name="fieldhtmltype" onChange="showType()" style="float: left;">
    <%}%>
    <option value="1" <%if(fieldhtmltype.equals("1")){%> selected<%}%>>
    	<%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
    <option value="2" <%if(fieldhtmltype.equals("2")){%> selected<%}%>>
    	<%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
    <option value="3" <%if(fieldhtmltype.equals("3")){%> selected<%}%>>
    	<%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
    <option value="4" <%if(fieldhtmltype.equals("4")){%> selected<%}%>>
    	<%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
    <option value="5" <%if(fieldhtmltype.equals("5")){%> selected<%}%>>
    	<%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>
    <!-- add by xhheng @20050309 for 附件上传 -->
    <%if(type2.equals("mainfield")){%>
    <option value="6" <%if(fieldhtmltype.equals("6")){%> selected<%}%>>
    	<%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%></option>
    <option value="7" <%if(fieldhtmltype.equals("7")){%> selected<%}%>>
    	<%=SystemEnv.getHtmlLabelName(21691,user.getLanguage())%></option>
    <%}%>
    </select>
    </td>
    	<%if(fieldhtmltype.equals("")){%>
    	  <td class=field>
    	     <span id=typespan><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></span>
    	     <select class=inputstyle  size=1 name=htmltype id=selecthtmltype onChange="typeChange()">
    	     	<option value="1"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
    	     	<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
    	     	<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
    	     	<option value="5"><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>
    	     </select>
    	     <span id="selecthtmltypespan" style="display: none;">
				<img align="absMiddle" src="/images/BacoError_wev8.gif">
			</span>
    	  </td>
    	  <td class=field>
    	     <span id=lengthspan><%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%></span>
		    <input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
    	     <input class=Inputstyle type=input size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
    	     	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>">
    	     <span id=strlengthspan><%if(textlength.equals("")||textlength.equals("0")){%>
    	     <IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
				<span id="childfieldNotesSpan" style="display:none"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
				<BUTTON  type='button' id="showChildFieldBotton" class=Browser type="button" onClick="onShowChildField(childfieldidSpan, childfieldid)" style="display:none"></BUTTON>
				<span id="childfieldidSpan" style="display:none"></span>
				<input type="hidden" value="" name="childfieldid" id="childfieldid">
				<div id="div3_3" <%if(htmltypeid==165||htmltypeid==166||htmltypeid==167||htmltypeid==168){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
					<%=SystemEnv.getHtmlLabelName(19340,user.getLanguage())%>
					<%if(canedit){%>
						<select class="InputStyle" name="decentralizationbroswerType" id="decentralizationbroswerType"  >
							<option value="1" <%if("1".equals(textheight)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18916,user.getLanguage())%></option>
							<option value="2" <%if("2".equals(textheight)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18919,user.getLanguage())%></option>
						</select>
					<%}else{%>
						<select class="InputStyle" name="decentralizationbroswerTypeselect" id="decentralizationbroswerTypeselect" disabled>
							<option value="1" <%if("1".equals(textheight)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18916,user.getLanguage())%></option>
							<option value="2" <%if("2".equals(textheight)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18919,user.getLanguage())%></option>
						</select>
						<input type="hidden" id="decentralizationbroswerType" name="decentralizationbroswerType" value="<%=textheight%>">
					<%}%>
				</div>
				<span id="cusbspan" style="display:none;float:none;">
						<brow:browser width="150px" viewType="0" name="cusb"
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
						    completeUrl="/data.jsp"
							hasInput="false" isSingle="true"
							isMustInput="2" browserDialogWidth="550px"
							browserDialogHeight="650px"
							_callback="typeChange"></brow:browser>
					</span>	
    	  </td>
    	<%}else if(fieldhtmltype.equals("1")){%>
    	   <td class=field>
    	     <span id=typespan><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></span>
          <!-- modify by xhheng @ 20041222 for TDID 1230-->
          <!-- 单行文本框，在类型 整形、浮点型向文本的转换会出现数据库异常，故禁止转换-->
          <%if(isused.equals("true")){%>
            <input type="hidden" value="<%=htmltypeid%>" name="htmltype">
            <select class=inputstyle  size=1 name=htmltype id=selecthtmltype onChange="typeChange()" disabled>
          <%}else{%>
            <select class=inputstyle  size=1 name=htmltype id=selecthtmltype onChange="typeChange()">
          <%}%>
    	     	<option value="1" <%if(htmltypeid==1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
    	     	<option value="2" <%if(htmltypeid==2){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
    	     	<option value="3" <%if(htmltypeid==3){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
    	     	<option value="5" <%if(htmltypeid==5){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>
    	     </select>
    	     <span id="selecthtmltypespan" style="display: none;">
				<img align="absMiddle" src="/images/BacoError_wev8.gif">
			</span>
    	   </td>
    	  <%if(htmltypeid==1){%>
    	   <td class=field>
    	     <span id=lengthspan><%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%></span>
			  <input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
    	     <input class=Inputstyle type=input size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
    	     	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>" <%if(isused.equals("true")){out.print("disabled");}%>>
    	     <span id=strlengthspan><%if(textlength.equals("")||textlength.equals("0")){%>
    	     <IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
    	   </td>
    	  <%} else {%>
    	   <td class=field><span id=lengthspan></span>
					<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
    	     <input type=input  class=Inputstyle style=display:none size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
    	     	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>" <%if(isused.equals("true")){out.print("disabled");}%>>
    	     <span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
    	     <IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
    	   </td><%}%>
    	<%}else if(fieldhtmltype.equals("3")){%>
    	   <td class=field>
    	     <span id=typespan><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></span>
           <!-- modify by xhheng @ 20041222 for TDID 1230 start-->
           <!-- 因为浏览按钮随类型不同而采用不同的数据类型，故已使用后，其类型也禁止转换-->
          <%String browserid="";%>
          <%if(isused.equals("true")){%>
            <select class=inputstyle  size=1 name=htmltype id=selecthtmltype onChange="typeChange()" disabled>
          <%}else{%>
            <select class=inputstyle  size=1 name=htmltype id=selecthtmltype onChange="typeChange()">
          <%}%>
    	     <%while(BrowserComInfo.next()){
    	     		 if("224".equals(BrowserComInfo.getBrowserid())||"225".equals(BrowserComInfo.getBrowserid())){
                 		 	//存在新的，就不能建老的sap
 				 			continue;
 						}
 						 if("226".equals(BrowserComInfo.getBrowserid())||"227".equals(BrowserComInfo.getBrowserid())){
					         //这里属于系统表单，占不支持新的sap功能
					 		 continue;
					 	 }
 						if (BrowserComInfo.notCanSelect()) continue;
    	     %>
    	     	<option match="<%=BrowserComInfo.getBrowserPY(user.getLanguage())%>" value="<%=BrowserComInfo.getBrowserid()%>" <%if(BrowserComInfo.getBrowserid().equals(htmltypeid+"")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
              <%if(BrowserComInfo.getBrowserid().equals(htmltypeid+"") && isused.equals("true")) {
                browserid=BrowserComInfo.getBrowserid();
              }%>
    	     <%}%>
           <%if(isused.equals("true")){%>
            <input type="hidden" value="<%=browserid%>" name="htmltype">
           <%}%>
           <!-- modify by xhheng @ 20041222 for TDID 1230 end-->
    	     </select>
    	     <span id="selecthtmltypespan" style="display: none;">
				<img align="absMiddle" src="/images/BacoError_wev8.gif">
			</span>
    	   </td>
    	   <td class=field><span id=lengthspan></span>
			 <input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
    	     <input  class=Inputstyle type=input style=display:none size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
    	     	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>">
    	     <span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
    	     <IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
				<div id="div3_3" <%if(htmltypeid==165||htmltypeid==166||htmltypeid==167||htmltypeid==168){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
					<%=SystemEnv.getHtmlLabelName(19340,user.getLanguage())%>
						<select class="InputStyle" name="decentralizationbroswerTypeselect" id="decentralizationbroswerTypeselect" disabled>
							<option value="1" <%if("1".equals(textheight)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18916,user.getLanguage())%></option>
							<option value="2" <%if("2".equals(textheight)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18919,user.getLanguage())%></option>
						</select>
						<input type="hidden" id="decentralizationbroswerType" name="decentralizationbroswerType" value="<%=textheight%>">
				</div>
				<span id="cusbspan" style="display:none;float:none;">
						<brow:browser width="150px" viewType="0" name="cusb"
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
						    completeUrl="/data.jsp"
							hasInput="false" isSingle="true"
							isMustInput="2" browserDialogWidth="550px"
							browserDialogHeight="650px"
							_callback="typeChange"></brow:browser>
					</span>	
           </td>
    	<%}else if(fieldhtmltype.equals("2")||fieldhtmltype.equals("4")){%>
    	   <td class=field><span id=typespan></span>
    	   		<select class=inputstyle  style=display:none size=1 name=htmltype id=selecthtmltype onChange="typeChange()"></select>
    	   		<span id="selecthtmltypespan" style="display: none;">
						<img align="absMiddle" src="/images/BacoError_wev8.gif">
					</span>
    	   </td>
    	   <td class=field><span id=lengthspan><%if (fieldhtmltype.equals("2")) {%><%=SystemEnv.getHtmlLabelName(222,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(15449,user.getLanguage())%><%}%></span>
			<input type='checkbox' name="htmledit" <%if (fieldhtmltype.equals("2")) {%> style="display:none" <%}%>  <%if (htmltypeid==2) {%> checked  disabled<%}%> value="2" onclick="onfirmhtml()">
    	   	<input  class=Inputstyle type=input style=display:none size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
    	     	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>">
    	   	<span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
    	        <IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
    	   </td>
    	<%}else if(fieldhtmltype.equals("5")){%>
    	   <td class=field><span id=typespan></span>
		   <select class=inputstyle  style=display:none size=1 name=htmltype id=selecthtmltype onChange="typeChange()"></select>
		   <span id="selecthtmltypespan" style="display: none;">
						<img align="absMiddle" src="/images/BacoError_wev8.gif">
					</span>
		   </td>
    	   <td class=field><span id=lengthspan></span>
			<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
    	   	<input   type=input class="InputStyle" style=display:none size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
    	     	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>">
    	   	<span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
    	        <IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
				<span id="childfieldNotesSpan"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
				<BUTTON  type='button' id="showChildFieldBotton" class=Browser type="button" onClick="onShowChildField(childfieldidSpan, childfieldid)"></BUTTON>
				<span id="childfieldidSpan" ><%=childfieldname%></span>
				<input type="hidden" value="<%=childfieldid%>" name="childfieldid" id="childfieldid">
    	   </td>
    	<%}else if(fieldhtmltype.equals("6")){
        %>
    	  <td class=field>
    	   <span id=typespan><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>
           <%if(isused.equals("true")){%>
            <input type="hidden" value="<%=htmltypeid%>" name="htmltype">
            <select class=inputstyle  size=1 name=htmltype id=selecthtmltype onChange="typeChange()" disabled>
          <%}else{%>
            <select class=inputstyle  size=1 name=htmltype id=selecthtmltype onChange="typeChange()">
          <%}%>
            <option value="1" <%if(htmltypeid==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></option>
			<option value="2" <%if(htmltypeid==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></option>
    	   </select>
    	   <span id="selecthtmltypespan" style="display: none;">
						<img align="absMiddle" src="/images/BacoError_wev8.gif">
					</span>
		   </td>
    	   <td class=field><span id=lengthspan style="display:none"></span>
			<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
    	   	<input   type=input class="InputStyle" size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
    	     	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' style="display:none">
    	   	<span id=strlengthspan ></span>
    	   </td>
    	<%}else if(fieldhtmltype.equals("7")){%>
    	   <td class=field>
    	   <BUTTON  type='button' class=btn id=btnaddRow style="display:none" name=btnaddRow onclick="addRow()"><%=SystemEnv.getHtmlLabelName(15443,user.getLanguage())%></BUTTON>
  	   		<BUTTON  type='button' class=btn id=btnsubmitClear style="display:none" name=btnsubmitClear onclick="submitClear()"><%=SystemEnv.getHtmlLabelName(15444,user.getLanguage())%></BUTTON>
    	   <span id=typespan></span>
			<%if(isused.equals("true")){%>
    	   <select class=inputstyle  style=display:'' size=1 id=selecthtmltype name=selecthtmltype onChange="typeChange()" disabled>
    	    <option value="1" <%if(htmltypeid==1) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
			<option value="2" <%if(htmltypeid==2) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></option>
    	   </select>
			<input type="hidden" name="htmltype" id="htmltype" value="<%=htmltypeid%>">
			<%}else{%>
			<select class=inputstyle  style=display:'' size=1 id=selecthtmltype name=htmltype id=selecthtmltype onChange="typeChange()">
    	    <option value="1" <%if(htmltypeid==1) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
			<option value="2" <%if(htmltypeid==2) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></option>
    	   </select>
			<%}%>
			<span id="selecthtmltypespan" style="display: none;">
				<img align="absMiddle" src="/images/BacoError_wev8.gif">
			</span>
    	   <input type="text"  name="textheight" maxlength=2 size=4 onKeyPress="ItemCount_KeyPress()" class=Inputstyle style=display:none>
		   </td>
    	   <td class=field><span id=lengthspan></span>
			<input type='checkbox' name="htmledit" style="display:none"  value="2">
    	   	<input   type=input class="InputStyle" style=display:none size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
    	     	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>">
    	   	<span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
    	        <IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
    	   </td>
    	<%}else{
    		out.println("<td class=field></td><td class=field></td>");
    	}
    } else {%>
	    <%if(fieldhtmltype.equals("1")){%><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%><%}%>
	    <%if(fieldhtmltype.equals("2")){%><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%><%}%>
	    <%if(fieldhtmltype.equals("3")){%><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%><%}%>
	    <%if(fieldhtmltype.equals("4")){%><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%><%}%>
	    <%if(fieldhtmltype.equals("5")){%><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%><%}%>
    </td>
    <%}%>
  </tr>
  <tr class="Spacing" style="height:1px;">
	<td colspan=8 class="Line"></td>
</tr>
  <tr>
  	<td>&nbsp;</td>
  	<td class=field colspan=5>
  	<div id=selectdiv <%if(fieldhtmltype.equals("5")){%>style="display:''" <%} else {%>style="display:none"<%}%>> 
  	   	<%if(fieldid==0){%>
		<table class="ViewForm" id="oTable" cols=3>
  	  <col width=10%><col width=50%><col width=40%>
  	   	<tr>
  	   		<td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
  	   		<td><%=SystemEnv.getHtmlLabelName(15442,user.getLanguage())%></td>
			<td><%=SystemEnv.getHtmlLabelName(22663,user.getLanguage())%></td>
  	   	</tr>
		<tr class="Line" style="height:1px;"><td colspan="2" ></td></tr>
  	   	<tr  class=DataLight>
  	   	   	<td height="23" width=10%><input type='checkbox' name='check_select' value="<%=rowsum%>" ></td>
		   	<td >
		   	<input type=text class=Inputstyle name="field_<%=rowsum%>_name" style="width=50%" onchange="checkinput('field_<%=rowsum%>_name','field_<%=rowsum%>_span')">
		   	<span id="field_<%=rowsum%>_span"><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
			</td>
			<td>
				<BUTTON  type='button' class="Browser" type="button" onClick="onShowChildSelectItem(childItemSpan<%=rowsum%>, childItem<%=rowsum%>)" id="selectChildItem<%=rowsum%>" name="selectChildItem<%=rowsum%>"></BUTTON>
				<input type="hidden" id="childItem<%=rowsum%>" name="childItem<%=rowsum%>" value="" >
				<span id="childItemSpan<%=rowsum%>" name="childItemSpan<%=rowsum%>"></span>
			</td>
		</tr>
		<%}
		else{%>
		  <table class="ViewForm" id="oTable" cols=4>
  	  <col width=10%><col width=50%><col width=30%><col width=10%>
  	   	<tr>
  	   		<td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
  	   		<td><%=SystemEnv.getHtmlLabelName(15442,user.getLanguage())%></td>
			<td><%=SystemEnv.getHtmlLabelName(22663,user.getLanguage())%></td>
			<td><%=SystemEnv.getHtmlLabelName(22151,user.getLanguage())%></td> 
  	   	</tr>
		<tr class="Line" style="height:1px;"><td colspan="4" ></td></tr>
		<%
		int colorcount=0;
			sql="select * from workflow_SelectItem where fieldid="+fieldid+" and isbill=1 order by selectvalue";
			RecordSet.executeSql(sql);
			while(RecordSet.next()){
				String selectname=RecordSet.getString("selectname");
				String selectvalue=RecordSet.getString("selectvalue");
				String childitemid = Util.null2String(RecordSet.getString("childitemid"));
				String childitemStr = "";
					String cancel=RecordSet.getString("cancel");
				String temp = "";
				if("1".equals(cancel)){
					temp = " checked=true ";
				}
				if(!"".equals(childitemid)){
					String[] childitemid_sz = Util.TokenizerString2(childitemid, ",");
					for(int cx=0; (childitemid_sz!=null && cx<childitemid_sz.length); cx++){
						String childtiem_tmp = Util.null2String((String)childItem_hs.get("item"+(Util.null2String(childitemid_sz[cx]))));
						if(!"".equals(childtiem_tmp)){
							childitemStr = childitemStr + "," + childtiem_tmp;
						}
					}
					if(!"".equals(childitemStr)){
						childitemStr = childitemStr.substring(1);
					}
				}

if(colorcount==0){
		colorcount=1;
%>
<TR class=DataLight>
<%
	}else{
		colorcount=0;
%>
<TR class=DataDark>
	<%
	}
	%>
			<td  height="23" width=10%>
			<input type='checkbox' name='check_select' value="<%=selectvalue%>" ></td>
			<td >
			<input   class=Inputstyle type=text name="field_<%=rowsum%>_name"
			value="<%=Util.toScreen(selectname,user.getLanguage())%>" style="width=50%"
			onchange="checkinput('field_<%=rowsum%>_name','field_<%=rowsum%>_span')">
			<span id="field_<%=rowsum%>_span"></span></td>
			<td>
				<BUTTON  type='button' class="Browser" type="button" onClick="onShowChildSelectItem(childItemSpan<%=rowsum%>, childItem<%=rowsum%>)" id="selectChildItem<%=rowsum%>" name="selectChildItem<%=rowsum%>"></BUTTON>
				<input type="hidden" id="childItem<%=rowsum%>" name="childItem<%=rowsum%>" value="<%=childitemid%>">
				<span id="childItemSpan<%=rowsum%>" name="childItemSpan<%=rowsum%>"><%=childitemStr%></span>
			</td>
				<td><input type='checkbox' name="cancel_<%=rowsum%>" <%=temp%>  value='1'></td> 
		</tr>
		<%	rowsum++;
			}%>

		<%}%>

	  </table>
    </div> 
<%
  String displayname = "";
  String linkaddress = "";
  String descriptivetext = "";
  String iscustomlink = "style=display:none";
  String isdescriptive = "style=display:none";
  
  
  if(fieldhtmltype.equals("7")){
     rs.executeSql("select * from workflow_specialfield where fieldid = " + fieldid + " and isbill = 1");
     rs.next();
     displayname = rs.getString("displayname");
     linkaddress = rs.getString("linkaddress");
     descriptivetext = rs.getString("descriptivetext");
     if(htmltypeid == 1) iscustomlink = "style=display:''";
     if(htmltypeid == 2) isdescriptive = "style=display:''";
  }
    String displaystr="display:none";
  if(fieldhtmltype.equals("6")){
        if(htmltypeid==2) displaystr="display:''";
  }
%>
   <div id="customlink" <%out.println(iscustomlink);%>><table width="100%"><tr><td><%=SystemEnv.getHtmlLabelName(606,user.getLanguage())%></td><td><input class=inputstyle type=text name=displayname size=20 value="<%=displayname%>" maxlength=1000>　</td></tr><tr><td><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%></td><td><input class=inputstyle type=text size=50 name=linkaddress value="<%=linkaddress%>" maxlength=1000><br><%=SystemEnv.getHtmlLabelName(18391,user.getLanguage())%></td></tr></table></div>
   <div id="descriptive" <%out.println(isdescriptive);%>><table width="100%"><tr><td width="8%"><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%>　</td><td><textarea class='inputstyle' style='width:60%;height:100px' name=descriptivetext><%=Util.StringReplace(descriptivetext,"<br>","\n")%></textarea></td></tr></table></div>
    <div id="imgdiv" style="<%=displaystr%>">
        <span id=imgnumspan ><%=SystemEnv.getHtmlLabelName(24030,user.getLanguage())%></span>
    	<input   type=input class="InputStyle" size=10 maxlength=3 name="textheight" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textheight%>">
        <span id=imgwidthnamespan><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
    	<input   type=input class="InputStyle" size=6 maxlength=4 name="imgwidth" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=imgwidth%>">
        <span id=imgheightnamespan><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
    	<input   type=input class="InputStyle" size=6 maxlength=4 name="imgheight" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=imgheight%>">
    </div>
	</td>
  </tr>

<%
rowsum+=1;
%>
  <tr class="Spacing" style="height:1px;">
	<td colspan=6 class="Line"></td>
</tr>

  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></td>
	<td colspan=5 class=field >
    <input type="text" class="Inputstyle" name="orderNum" value="<%=orderNum%>" onKeyPress="ItemDecimal_KeyPress('orderNum', 6, 2)" onBlur="checkDecimal_self(this, 6, 2)">
    </td>
</tr>
  <tr class="Spacing" style="height:1px;">
	<td colspan=6 class="Line"></td>
</tr>
  <tr>
    <td ><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
	<td colspan=5 class=field >
    <%=(type2.equals("detailfield")?SystemEnv.getHtmlLabelName(18550,user.getLanguage()):SystemEnv.getHtmlLabelName(18549,user.getLanguage()))%>
    </td>
</tr>

 

  <tr class="Spacing" style="height:1px;">
	<td colspan=6 class="Line"></td>
</tr>
</table>
</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>


<input type="hidden" value="0" name="selectsnum">
<input type="hidden" value="" name="delids">

</form>
<script language="JavaScript" src="/js/addRowBg_wev8.js" >
</script>
<script>
rowindex = "<%=rowsum%>";
delids = "";
var rowColor="" ;
function addRow()
{			rowColor = getRowBg();
	ncol = jQuery(oTable).attr("cols");
	oRow = oTable.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background=rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input   type='checkbox' name='check_select' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='Inputstyle styled input' type='input' size='25' name='field_"+rowindex+"_name' style='width=50%'"+
							" onchange=checkinput('field_"+rowindex+"_name','field_"+rowindex+"_span')>"+
							" <span id='field_"+rowindex+"_span'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON  type='button' class=\"Browser\" type='button' onClick=\"onShowChildSelectItem(childItemSpan"+rowindex+", childItem"+rowindex+")\" id=\"selectChildItem"+rowindex+"\" name=\"selectChildItem"+rowindex+"\"></BUTTON>"
							+ "<input type=\"hidden\" id=\"childItem"+rowindex+"\" name=\"childItem"+rowindex+"\" value=\"\" >"
							+ "<span id=\"childItemSpan"+rowindex+"\" name=\"childItemSpan"+rowindex+"\"></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex = rowindex*1 +1;
}

function deleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_select')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_select'){
			if(document.forms[0].elements[i].checked==true) {
				if(document.forms[0].elements[i].value!='0')
					delids +=","+ document.forms[0].elements[i].value;
                    //alert(rowsum1);
				oTable.deleteRow(rowsum1+1);
			}
			rowsum1 -=1;
		}

	}
}
</script>
<script language=javascript>
	var userm='<%=userm%>';
	function showType(){
		jQuery('#selecthtmltypespan').hide();
		jQuery('#selecthtmltype').autoSelect('hide');
		htmltypeedit = $G("htmledit");
		fieldhtmltypelist = window.document.forms[0].fieldhtmltype;
		htmltypelist = window.document.forms[0].htmltype;
		cusbspan=$G("cusbspan");//td15999
		
		if(fieldhtmltypelist.value==2||fieldhtmltypelist.value==4){
			htmltypelist.style.display='none';
			 htmltypeedit.style.display='none';
			 typespan.innerHTML='';
			 lengthspan.innerHTML='';
			 if(fieldhtmltypelist.value==2) { htmltypeedit.style.display='';
			lengthspan.innerHTML='<%=SystemEnv.getHtmlLabelName(222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15449,user.getLanguage())%>';
			}
			
			window.document.forms[0].strlength.style.display='none';
			strlengthspan.innerHTML='';
			$G("selectdiv").style.display='none';
            $G("customlink").style.display='none';
            $G("descriptive").style.display='none';
            $G("childfieldNotesSpan").style.display='none';
            $G("showChildFieldBotton").style.display='none';
            $G("childfieldidSpan").style.display='none';
            $G("imgdiv").style.display='none';
            if(typeof(cusbspan) != undefined) cusbspan.style.display='none';//td15999
		    <%
		    	if(userm ==1) {
		    %>
	            shieldingRightMenu();
		    <%
		    	} 
		    %>
				
	    }
		if(fieldhtmltypelist.value==5){
			//alert('55'+cusb.value);
			htmltypeedit.style.display='none';
			htmltypelist.style.display='none';
			typespan.innerHTML='';
			lengthspan.innerHTML='';
			window.document.forms[0].strlength.style.display='none';
			strlengthspan.innerHTML='';
			$G("selectdiv").style.display='';
            $G("customlink").style.display='none';
            $G("descriptive").style.display='none';
            $G("childfieldNotesSpan").style.display='';
            $G("showChildFieldBotton").style.display='';
            $G("childfieldidSpan").style.display='';
            $G("imgdiv").style.display='none';
            if(typeof(cusbspan) != undefined) cusbspan.style.display='none';//td15999
                  <%
		    	if(userm ==1) {
		    %>
				 showRightMenu(); //跟其他选择框不一样
		     <%
		    	} 
		    %>
            
		}
		if(fieldhtmltypelist.value==3){
			 htmltypeedit.style.display='none';
			htmltypelist.style.display='';
			typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%>';
			lengthspan.innerHTML='';
			window.document.forms[0].strlength.style.display='none';
			strlengthspan.innerHTML='';
			$G("selectdiv").style.display='none';

			for(var count = htmltypelist.options.length - 1; count >= 0; count--)
				htmltypelist.options[count] = null;
			<%=browsertype%>
			sortOption(htmltypelist); //下拉框排序
			$(htmltypelist).selectbox('hide');
            jQuery(htmltypelist).autoSelect();
            $G("customlink").style.display='none';
            $G("descriptive").style.display='none';
            $G("childfieldNotesSpan").style.display='none';
            $G("showChildFieldBotton").style.display='none';
             typeChange();
            $G("childfieldidSpan").style.display='none';
            $G("imgdiv").style.display='none';
            <%
		    	if(userm ==1) {
		    %>
	            shieldingRightMenu();
		    <%
		    	} 
		    %>
	}
		if(fieldhtmltypelist.value==1){
			 htmltypeedit.style.display='none';
			htmltypelist.style.display='';
			typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%>';
			lengthspan.innerHTML='<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>';
			window.document.forms[0].strlength.style.display='';
			if(form1.strlength.value==''||form1.strlength.value==0)
				strlengthspan.innerHTML='<IMG src="/images/BacoError_wev8.gif" align=absMiddle>';
			strlengthspan.style.display='';
			$G("selectdiv").style.display='none';
			for(var count = htmltypelist.options.length - 1; count >= 0; count--)
				htmltypelist.options[count] = null;
			<%=texttype%>
            $G("customlink").style.display='none';
            $G("descriptive").style.display='none';
            $G("childfieldNotesSpan").style.display='none';
            $G("showChildFieldBotton").style.display='none';
            $G("childfieldidSpan").style.display='none';
            $G("imgdiv").style.display='none';
            if(typeof(cusbspan) != undefined) cusbspan.style.display='none';//td15999

             <%
		    	if(userm ==1) {
		    %>
	            shieldingRightMenu();
		    <%
		    	}
		    %>
           
		}
        if(fieldhtmltypelist.value==6){
			htmltypelist.style.display='none';
			 htmltypeedit.style.display='none';
			typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>';
            lengthspan.innerHTML='';
			window.document.forms[0].strlength.style.display='none';
			strlengthspan.innerHTML='';
			$G("selectdiv").style.display='none';
            for(var count = htmltypelist.options.length - 1; count >= 0; count--)
				htmltypelist.options[count] = null;
            htmltypelist.options[0] = new Option('<%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%>',1);
            htmltypelist.options[1] = new Option('<%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%>',2);
			htmltypelist.style.display='';
            $G("customlink").style.display='none';
            $G("descriptive").style.display='none';
            $G("childfieldNotesSpan").style.display='none';
            $G("showChildFieldBotton").style.display='none';
            $G("childfieldidSpan").style.display='none';
            if(htmltypelist.value==1){
                $G("imgdiv").style.display='none';
            }else{
                $G("imgdiv").style.display='';
            }
            if(typeof(cusbspan) != undefined) cusbspan.style.display='none';//td15999
             <%
		    	if(userm ==1) {
		    %>
	            shieldingRightMenu();
		   <%
		    	} 
		    %>
           
        }
		if(fieldhtmltypelist.value==7){
			htmltypeedit.style.display='none';
			htmltypelist.style.display='';
			typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%>';
			lengthspan.innerHTML='';
			window.document.forms[0].strlength.style.display='none';
			strlengthspan.innerHTML='';
			$G("selectdiv").style.display='none';
			for(var count = htmltypelist.options.length - 1; count >= 0; count--)
				htmltypelist.options[count] = null;
			<%=specialtype%>
            $G("customlink").style.display='';
            $G("descriptive").style.display='none';
            $G("childfieldNotesSpan").style.display='none';
            $G("showChildFieldBotton").style.display='none';
            $G("childfieldidSpan").style.display='none';
            $G("imgdiv").style.display='none';
            if(typeof(cusbspan) != undefined) cusbspan.style.display='none';//td15999
            <%
		    	if(userm ==1) {
		    %>
	            shieldingRightMenu();
		    <%
		    	} 
		    %>
           
        }
	}

	function typeChange(){
		jQuery('#selecthtmltypespan').hide();
		fieldhtmltypelist = window.document.forms[0].fieldhtmltype;
		htmltypelist = window.document.forms[0].htmltype;
		cusbspan=$G("cusbspan");
        cusb=$G("cusb");
		if(fieldhtmltypelist.value==1){
			if(htmltypelist.value==1){
				lengthspan.innerHTML='<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>';
				window.document.forms[0].strlength.style.display='';
				if(form1.strlength.value==''||form1.strlength.value==0){
					strlengthspan.innerHTML='<IMG src="/images/BacoError_wev8.gif" align=absMiddle>';
				}
				strlengthspan.style.display='';
			}
			else{
				lengthspan.innerHTML='';
				window.document.forms[0].strlength.style.display='none';
				strlengthspan.innerHTML='';
				strlengthspan.style.display='none';
			}
		}
		//td15999
		document.getElementById("div3_3").style.display = "none";
		if(fieldhtmltypelist.value==3){
			if (htmltypelist.value == '') {
        		jQuery('#selecthtmltypespan').show();
        	}
			if(htmltypelist.value==161||htmltypelist.value==162){
				cusbspan.style.display='';
				if(cusb.value==''||cusb.value==0){
					strlengthspan.innerHTML='<IMG src="/images/BacoError_wev8.gif" align=absMiddle>';
				}else
                    strlengthspan.innerHTML='';
				strlengthspan.style.display='';
			}else if(htmltypelist.value==165 || htmltypelist.value==166 || htmltypelist.value==167 || htmltypelist.value==168){
				document.getElementById("div3_3").style.display = "";
				cusb.value='';
				cusbspan.style.display='none';
				strlengthspan.innerHTML='';
				strlengthspan.style.display='none';
			}else{
				cusb.value=''
				cusbspan.style.display='none';
				strlengthspan.innerHTML='';
				strlengthspan.style.display='none';
			}

		}

        if(fieldhtmltypelist.value==6){
			if(htmltypelist.value==1){
                $("#imgdiv").hide();
			}else{
                $G("imgdiv").style.display='';
			}
		}
        if(fieldhtmltypelist.value==7){
			if(htmltypelist.value==1){
               $G("customlink").style.display='';
               $G("descriptive").style.display='none';
			}
		    if(htmltypelist.value==2){
               $G("customlink").style.display='none';
               $G("descriptive").style.display='';
			}
		}
	}
	function checksubmit(){
		fieldhtmltypelist = window.document.forms[0].fieldhtmltype;
		htmltypelist = window.document.forms[0].htmltype;
		if(fieldhtmltypelist.value==1){
			if(htmltypelist.value==1){
				if($GetEle("strlength").value==""||form1.strlength.value==0){
					alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
					return false;
				}
			}
		}
		//td15999
		if(fieldhtmltypelist.value==3){
			if(htmltypelist.value==''){
				alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
					return false;
			}
			if(htmltypelist.value==161||htmltypelist.value==162){
				if(form1.cusb.value==""||form1.cusb.value==0){
					alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
					return false;
				}
			}
		}
		var parastr="fieldname";
		if(fieldhtmltypelist.value==5){
			for(k=0;k<rowindex;k++){
				len = document.forms[0].elements.length;
				var i=0;
				for(i=len-1; i >= 0;i--) {
					if (document.forms[0].elements[i].name=="field_"+k+"_name"){
						parastr+=",field_"+k+"_name";
						break;
					}
				}
			}
		}
		document.forms[0].selectsnum.value=rowindex;
		document.forms[0].delids.value=delids;
		return check_form(document.form1,parastr);
	}

function checklength(elementname,spanid){
	tmpvalue = $G(elementname).value;

	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	if(tmpvalue!=""&&tmpvalue!=0){
		 $G(spanid).innerHTML='';
	}
	else{
	 $G(spanid).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 $G(elementname).value = "";
	}
}

function showRightMenu(){	
	showRCMenuItem(2);	
	showRCMenuItem(3);
	//$G("rightMenuIframe").height=rightMenuIframe.document.getElementById('menuTable').offsetHeight;
}




function shieldingRightMenu(){
	var fieldhtmltype = '<%=fieldhtmltype%>';
	var actionType = '<%=actionType%>';
	var userId = '<%=user.getUID()%>';
	if(fieldhtmltype=="5"){
	if(userId!=null && userId=="1"){
		if(actionType!="" && actionType=="add"){
			hiddenRCMenuItem(2);
			hiddenRCMenuItem(3);
			//$G("rightMenuIframe").height=rightMenuIframe.document.getElementById('menuTable').offsetHeight;
		}
		if(actionType!="" && actionType=="edit" && fieldhtmltype!="" && fieldhtmltype=="5"){
			showRCMenuItem(2);
			showRCMenuItem(3);
			//$G("rightMenuIframe").height=rightMenuIframe.document.getElementById('menuTable').offsetHeight;
			//$G("rightMenuIframe").height=rightMenuIframe.document.body.scrollHeight*(1.0);
		}
		if(actionType!="" && actionType=="edit" && fieldhtmltype!="" && fieldhtmltype!="5"){
			//$G("rightMenuIframe").height=rightMenuIframe.document.body.scrollHeight*(0.68);
		}
	}else{
		if(actionType!="" && actionType=="add"){
			hiddenRCMenuItem(2);
			hiddenRCMenuItem(3);
			//$G("rightMenuIframe").height=rightMenuIframe.document.getElementById('menuTable').offsetHeight;
			//$G("rightMenuIframe").height=rightMenuIframe.document.body.scrollHeight*(0.5);
		}
		if(actionType!="" && actionType=="edit" && fieldhtmltype!="" && fieldhtmltype=="5"){
			showRCMenuItem(2);
			showRCMenuItem(3);
			//$G("rightMenuIframe").height=rightMenuIframe.document.getElementById('menuTable').offsetHeight;
			//$G("rightMenuIframe").height=rightMenuIframe.document.body.scrollHeight*(1.0);
		}
		if(actionType!="" && actionType=="edit" && fieldhtmltype!="" && fieldhtmltype!="5"){
			//$G("rightMenuIframe").height=rightMenuIframe.document.body.scrollHeight*(1.0);
		}
	}
	rightMenu.style.visibility="visible";
}else{
	return false;
}
}

function reinitIframe(){
  var iframe = window.frames["rightMenuIframe"];
  try{
       var bHeight = iframe.document.body.scrollHeight;
       var dHeight = iframe.document.documentElement.scrollHeight;
       var height = Math.max(bHeight, dHeight);
       iframe.height = height;
       }catch(ex){}
}

function sortRule(a,b) {
	var x = a._text;
	var y = b._text;
	return x.localeCompare(y);
}
function op(){
	var _value;
	var _text;
}
function sortOption(obj){
	var tmp = new Array();
	for(var i=0;i<obj.options.length;i++){
	var ops = new op();
	ops._value = obj.options[i].value;
	ops._text = obj.options[i].text;
	ops._match = jQuery(obj.options[i]).attr('match');
	tmp.push(ops);
    }
	tmp.sort(sortRule);
	for(var j=0;j<tmp.length;j++){
	obj.options[j].value = tmp[j]._value;
	obj.options[j].text = tmp[j]._text;
	jQuery(obj.options[j]).attr('match', tmp[j]._match);
	}
}

function onfirmhtml()
{
if (document.form1.htmledit.checked==true)
alert('<%=SystemEnv.getHtmlLabelName(20867,user.getLanguage())%>');

}
function submitData()
{
	if (checksubmit()) {
		// TD9015 点击任一按钮，把所有"BUTTON"给灰掉
		for (a=0;a<window.frames["rightMenuIframe"].document.all.length;a++){
			if(window.frames["rightMenuIframe"].document.all.item(a).tagName == "BUTTON"){
				window.frames["rightMenuIframe"].document.all.item(a).disabled=true;
			}
		}

		//如果当前字段类型是选择框， 则对各选项中欧元符号进行替换
		if(document.getElementById("fieldhtmltype").value == 5){
			for(var i = 0; i < rowindex; i++){
				var obj = document.getElementById("field_" + i + "_name");
				if(obj){
					obj.value = dealSpecial(obj.value);
				}
			}
		}
		form1.submit();
	}
}

//对特殊符号进行处理
function dealSpecial(val){
	//本字符串是欧元符号的unicode码, GBK编辑中不支持欧元符号(需更改为UTF-8), 故只能使用unicode码
	var euro = "\u20AC";
	//本字符串是欧元符号在HTML中的特别表现形式
	var symbol = "&euro;";
	var reg = new RegExp(euro);
	while(val.indexOf(euro) != -1){
		val = val.replace(reg, symbol);
	}  
	return val;
}

function submitClear()
{
	if (isdel())
		deleteRow1();
}
function ItemDecimal_KeyPress(inputname, p, s){
	var tmpvalue = $G(inputname).value;

	var dotCount = 0;
	var afterDotCount=0;
	var hasDot=false;

	var len = -1;
	try{
		len = tmpvalue.length;
	}catch(e){}

	if(len > -1){
		dotCount = tmpvalue.indexOf(".");
		if(dotCount > -1){
			hasDot=true;
			afterDotCount = len - dotCount - 1;
		}
		if(!((window.event.keyCode>=48 && window.event.keyCode<=57) || (window.event.keyCode==46 && hasDot==false))){
			window.event.keyCode=0;
			return;
		}
		if(((p+1)<=len && hasDot==true) || (p<=len && hasDot==false) || (window.event.keyCode==46 && p<=len)){
			window.event.keyCode=0;
			return;
		}
	}
}

function checkDecimal_self(obj, p, s){
	var tmpvalue = obj.value;

	var dotCount = 0;
	var afterDotCount = 0;
	var hasDot=false;

	var len = -1;
	try{
		len = tmpvalue.length;
	}catch(e){}

	if(len > -1){
		dotCount = tmpvalue.indexOf("."); 
		if(dotCount > -1){
			hasDot=true;
			afterDotCount = len - dotCount - 1;
		}
		var beforeNum = tmpvalue;
		var afterNum = "";
		if(hasDot == true){
			beforeNum = beforeNum.substring(0, dotCount);
			afterNum = tmpvalue.substring(dotCount+1, len);
			if(afterDotCount > s){
				afterNum = afterNum.substring(0, s);
				afterDotCount = afterNum.len;
			}
			if((afterDotCount+beforeNum)>p){
				beforeNum = beforeNum.substring(0, (p-afterDotCount));
			}
			if(afterDotCount == 0){
				obj.value = beforeNum;
			}else{
				obj.value = beforeNum + "." + afterNum;
			}
		}else{
			beforeNum = tmpvalue;
			if(len>p){
				beforeNum = beforeNum.substring(0, p);
			}
			obj.value = beforeNum;
		}
	}
}

function onChangeChildField(){
	var rownum = parseInt(rowindex);
	for(var i=0; i<rownum; i++){
		var inputObj = $G("childItem"+i);
		var spanObj = $G("childItemSpan"+i);
		try{
			if(inputObj!=null && spanObj!=null){
				inputObj.value = "";
				spanObj.innerHTML = "";
			}
		}catch(e){}
	}
}
function onShowChildField(spanname, inputname){
	oldvalue = inputname.value
	url=escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5 and fromUser<>1 and billid=<%=billId%> and id<><%=fieldid%> &isdetail=0&isbill=1")
	data = showModalDialog("/systeminfo/BrowserMain.jsp?url="+url)
	if (data){
		if (data.id!=""){
			inputname.value = data.id;
			spanname.innerHTML = data.name
		}else{
			inputname.value = ""
			spanname.innerHTML = ""
		}
	}
	if (oldvalue != inputname.value){
		onChangeChildField()
	}
}


function onShowChildSelectItem(spanname, inputname){
	cfid = form1.childfieldid.value
	resourceids = inputname.value
	url=escape("/workflow/field/SelectItemBrowser.jsp?isbill=1&isdetail=0&childfieldid="+cfid+"&resourceids="+resourceids)
	data = showModalDialog("/systeminfo/BrowserMain.jsp?url="+url)
	if (data){
		if(data.id!=""){
			resourceids = data.id
			resourcenames = data.name
			resourceids = resourceids.substring(1);
			resourcenames = resourcenames.substring(1);
			inputname.value = resourceids
			spanname.innerHTML = resourcenames
		}else{
			inputname.value = ""
			spanname.innerHTML = ""
		}
	}

}
</script>
</body>
</html>