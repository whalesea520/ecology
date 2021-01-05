
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.lang.*" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browser" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="session"/>
<jsp:useBean id="FieldManager" class="weaver.workflow.field.FieldManager" scope="session"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="SapBrowserComInfo" class="weaver.parseBrowser.SapBrowserComInfo" scope="page" />
<jsp:useBean id="SelectItemManager" class="weaver.workflow.selectItem.SelectItemManager" scope="page" />
<%@page import="weaver.workflow.form.FormManager"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src="/js/ecology8/request/autoSelect_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/jquery-autocomplete/jquery.autocomplete_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>



<style type="text/css">
	select{
		width: 105px!important;
	}
	input{
		width: 150px!important;
	}
    .childItemDiv .e8_outScroll,.childItemDiv .e8_innerShowMust{
        display:none;
    }
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<%
	String formRightStr = "FormManage:All";
	int billId=Util.getIntValue(Util.null2String(request.getParameter("billId")),0);
	int isbill=Util.getIntValue(Util.null2String(request.getParameter("isbill")),-1);
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	int operateLevel = UserWFOperateLevel.checkWfFormOperateLevel(detachable,user,formRightStr,billId,isbill);
	if (!HrmUserVarify.checkUserRight(formRightStr, user) || operateLevel < 0) {
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
	String textlength="5";
	int childfieldid = 0;
	String childfieldname = "";
	String imgwidth="100";
    String imgheight="100";
	int fieldid=0;
	
	float orderNum = 0;
	int fieldlabel = 0;
	String sql = "";
	int textheight = 0;
	String textheight_2 = "1";
	String locateTypeDB = "";
	fieldid=Util.getIntValue(Util.null2String(request.getParameter("fieldid")),0);
	
	int frompage=Util.getIntValue(Util.null2String(request.getParameter("frompage")),0);
	
	String selectItemType = "0";
	int pubchoiceId = 0;
	String pubchoicespan = "";
	int pubchilchoiceId = 0;
	String pubchilchoicespan = "";
	
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

	String fromWFCode = Util.null2String(request.getParameter("fromWFCode"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	String fHtmlType = Util.null2String(request.getParameter("fieldHtmlType"));
	String fname = Util.null2String(request.getParameter("fieldname"));
	String lableid = Util.null2String(request.getParameter("lableid"));
	String idcode = "";
	
	if(isclose.equals("1") && fHtmlType.equals("1") ){
		rs.executeSql("select id from workflow_billfield where billid="+billId+" and fieldname = '"+fname+"' and fieldlabel = '"+lableid+ "' and fieldHtmlType = "+fHtmlType);
		while(rs.next()){
			idcode = Util.null2String(rs.getString("id"));
			lableid = SystemEnv.getHtmlLabelName(Integer.parseInt(lableid), user.getLanguage());
		}
	}
	
	boolean isshowPubChildOption = false;
	String detailtable = "";
	
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
            locateTypeDB = Util.null2String(rs.getString("locateType"));
			if(fieldhtmltype.equals("1")&&htmltypeid==1){
	            if(RecordSet.getDBType().equals("oracle")){
				    textlength=fielddbtype.substring(9,fielddbtype.length()-1);
	            }else{
	                textlength=fielddbtype.substring(8,fielddbtype.length()-1);
	            }
	        }
			textheight = Util.getIntValue(rs.getString("textheight"), 4);
			textheight_2 = Util.null2String(rs.getString("textheight_2"));
			
			detailtable = Util.null2String(rs.getString("detailtable"));
			
			selectItemType = Util.getIntValue(Util.null2String(rs.getString("selectItemType")),0) + "";
		    pubchoiceId = Util.getIntValue(Util.null2String(rs.getString("pubchoiceId")),0);
		    pubchilchoiceId = Util.getIntValue(Util.null2String(rs.getString("pubchilchoiceId")),0);
		    pubchoicespan = SelectItemManager.getPubchoiceName(pubchoiceId);
			pubchilchoicespan = SelectItemManager.getPubchilchoiceFieldName(pubchilchoiceId,user.getLanguage());
			if(!pubchoicespan.equals("")){
				pubchoicespan = "<a title='" + pubchoicespan + "' href='javaScript:eidtSelectItem("+pubchoiceId+")'>" + pubchoicespan + "</a>&nbsp";
			}
			
			if(fieldhtmltype.equals("5")){
				isshowPubChildOption = SelectItemManager.hasPubChoice(billId,Util.getIntValue(Util.null2String(rs.getString("viewtype")),0),detailtable);
			}
		}
	}
	
	Map th_2_map = FormManager.getRightAttr(user.getLanguage());	  		
	String th_2[] = textheight_2.split(",");
	String th_2_span = "";
	for(int k=0;k<th_2.length;k++){
		if(th_2[k].equals("0") || th_2[k].equals(""))continue;
		th_2_span += ","+th_2_map.get(th_2[k]);
	}
	if(!th_2_span.equals("")) th_2_span = th_2_span.substring(1);
		
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
String locationTypeOption="htmltypelist.options[0]=new Option('"+SystemEnv.getHtmlLabelName(22981,user.getLanguage())+"',1);"+"\n";
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
	if(type.equals("addfield")){
		if(("256".equals(BrowserComInfo.getBrowserid()))||"257".equals(BrowserComInfo.getBrowserid())){
			continue;//老版本的树形浏览按钮不支持老表单
		}
	}else{
		if(!(htmltypeid==3&&("256".equals(fieldhtmltype)||"257".equals(fieldhtmltype)))){
			if(("256".equals(BrowserComInfo.getBrowserid()))||"257".equals(BrowserComInfo.getBrowserid())){
				continue;//老版本的树形浏览按钮不支持老表单
			}
		}
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

<body  >
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<%if(frompage==1){ %>
<div class="zDialog_div_content">
	
<%}else{ 
    if(!"wfcode".equals(fromWFCode)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/workflow/workflow/BillManagementDetail0.jsp?billId="+billId+",_self}" ;
		RCMenuHeight += RCMenuHeightStep ;
    }
} 

if(canedit && operateLevel > 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="form1" method="post" action="BillManagementFieldOperation0.jsp" >
   <input type="hidden" value="<%=type%>" name="src">
   <input type="hidden" value="<%=type2%>" name="srcType">
   <input type="hidden" value="<%=fieldid%>" name="fieldid">
   <input type="hidden" value="<%=actionType%>" name="actionType">
   <input type="hidden" value="<%=billId%>" name="billId">
   <input type="hidden" value="<%=fromWFCode%>" name="fromWFCode">
   <input type="hidden" value="<%=frompage%>" name="frompage">
   <input type="hidden" value="<%=isbill%>" name="isbill">
   
   <!-- modify by xhheng @ 20041222 for TDID 1230-->
   <input type="hidden" value="<%=isused%>" name="isused">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<%if(operateLevel > 0) {%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData();">
				<%} %>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<%
String tmpStr = "";
if(message.equals("1")){
    tmpStr = "<font color=red>"+SystemEnv.getHtmlLabelName(15440,user.getLanguage())+"!</font>";
}else if(message.equals("2")){
    tmpStr = "<font color=red>"+SystemEnv.getHtmlLabelName(18556,user.getLanguage())+"</font>";
}
%>
<%=tmpStr%>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
	    <wea:item><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item>
	    <wea:item>
			<%if(canedit){%>
				<input class=Inputstyle type="text" name="fieldname" size="40" value="<%=fieldname%>" onBlur='checkinput("fieldname","fieldnamespan")'>
				<span id=fieldnamespan><%if("".equals(fieldname)){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span> (<%=SystemEnv.getHtmlLabelName(18557,user.getLanguage())%>)
			<%} else {%>
				<%=SystemEnv.getHtmlLabelName(fieldlabel, user.getLanguage())%>
			<%}%>	    
	    </wea:item>
	    
	    <wea:item><%=SystemEnv.getHtmlLabelName(17997,user.getLanguage())%></wea:item>
		<wea:item><%=(type2.equals("detailfield")?SystemEnv.getHtmlLabelName(18550,user.getLanguage()):SystemEnv.getHtmlLabelName(21778,user.getLanguage()))%></wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" class="Inputstyle" name="orderNum" value="<%=orderNum%>" onKeyPress="ItemDecimal_KeyPress('orderNum', 6, 2)" onBlur="checkDecimal_self(this, 6, 2)">
		</wea:item>
		
	    
	    <wea:item><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%></wea:item>
	    <wea:item>
			<%if(canedit){ %>
				<%if(isused.equals("true")){ %>
					<input type="hidden" value="<%=fieldhtmltype%>" id="fieldhtmltype" name="fieldhtmltype">
					<select class=inputstyle  size="1" id="fieldhtmltype" name="fieldhtmltype" onChange="showType()" disabled style="float: left;">
				<%}else{ %>
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
							<option value="9" <%if(fieldhtmltype.equals("9")){%> selected<%}%>>
							<%=SystemEnv.getHtmlLabelName(125583,user.getLanguage())%></option>
						<%}%>
					</select>
				<%if(fieldhtmltype.equals("")){ %>

					<span style="float:left;">
					<span id=typespan><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></span>
					<select class=inputstyle  size=1 name=htmltype id=selecthtmltype onChange="typeChange()">
						<option value="1"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
						<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
						<option value="5"><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>
					</select>
					<%-- 
					<span id="locateTypeSpan" style="display:none">
						<span><%=SystemEnv.getHtmlLabelName(125581,user.getLanguage())%></span>
						<select id="locateType" name="locateType">
							<option value="1" ><%=SystemEnv.getHtmlLabelName(125582,user.getLanguage()) %></option>
							<option value="2" ><%=SystemEnv.getHtmlLabelName(81855,user.getLanguage())%></option>
						</select>
					</span>
					--%>
					<select class=inputstyle  size=1 style="width: 120px;" name="specialhtmltype" id="specialhtmltype" onChange="typeChange()">
						<option value="1"><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></option>
					</select>
					<span id="selecthtmltypespan" style="display: none;">
						<img align="absMiddle" src="/images/BacoError_wev8.gif">
					</span>
					<span id=lengthspan><%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%></span>
					<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
					<input class=Inputstyle type=input size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>" style="width:50px!important;">
					<select style="display:none" class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()">
						<option value=''></option>
						<%
						List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
						for(int j=0;j<AllBrowserId.size();j++){
						%>
						<option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
						<%}%>
					</select>
					<span id=strlengthspan><%if(textlength.equals("")||textlength.equals("0")){%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
					<span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=6 maxlength=4 name="imgwidth" onChange="checklength('imgwidth','imgwidthspan')" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=imgwidth%>" style="display:none;width:50px!important;">
					<span id=imgwidthspan style="display:none"></span>
					<span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=6 maxlength=4 name="imgheight" onChange="checklength('imgheight','imgheightspan')" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=imgheight%>" style="display:none;width:50px!important;">
					<span id=imgheightspan style="display:none"></span>
					
					
					<span id="selectItemTypeSpan" style="display:none;">
					    <div style="float: left;margin-left:10px;margin-top: 5px;">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>&nbsp;&nbsp;</div>
					    <select id="selectItemType" name="selectItemType" class=inputstyle  style="float: left;width: 150px;" onchange="selectItemTypeChange('selectItemType');">
		                    <option value="0" ><%=SystemEnv.getHtmlLabelName(124929,user.getLanguage())%></option>
		                    <option value="1" ><%=SystemEnv.getHtmlLabelName(124930,user.getLanguage())%></option>
		                    <%if(isshowPubChildOption){ %>
		                    <option value="2" ><%=SystemEnv.getHtmlLabelName(124931,user.getLanguage())%></option>
		                    <%}  %>
		                </select>
		                
	                    <div style="float:left;margin-top:5px;">
	                    <span id="childfieldNotesSpan" style="display:none;">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
	                    </div>
	                    <%-- 
	                    <button type=button  id="showChildFieldBotton" class=Browser onClick="onShowChildField('childfieldidSpan', 'childfieldid')" style="display:none"></BUTTON>
	                    <span id="childfieldidSpan" style="display:none"></span>
	                    <input type="hidden" value="" name="childfieldid" id="childfieldid">
	                    --%>
	                    <div id="showChildFieldBotton" style="display:none;width:25px;float:left" class="childItemDiv">
	                      <brow:browser viewType="0" name='childfieldid' browserValue=""
	                          getBrowserUrlFn="showChildField"
	                          _callback="selectChildField"
	                          hasInput="false" isSingle="true" hasBrowser = "true"  isMustInput='1' width="25px"
	                          browserSpanValue=""></brow:browser>
	                    </div>
                        <div style="float:left;margin-top:5px;">
	                    <span style="display:none" id="childfieldidSpan" name="childfieldidSpan" class="childfieldidSpan" title=''></span>
                        </div>
					</span>
					
					<span id="pubchoiceIdSpan" style="display:none;"> &nbsp;&nbsp;
					    <div style="margin-left:10px;float:left;">
		                	<brow:browser width="150px" viewType="0" name="pubchoiceId"
						    browserUrl="/workflow/selectItem/selectItemMain.jsp?topage=selectItemBrowser&url=/workflow/selectItem/selectItemBrowser.jsp"
						    completeUrl="/data.jsp?type=pubChoice"
							hasInput="true" isSingle="true"
							isMustInput="2"
							browserValue='<%=pubchoiceId+""%>'
							browserSpanValue='<%=pubchoicespan%>'
							browserDialogWidth="550px"
							browserDialogHeight="650px" _callback="setPreviewPub"></brow:browser>
						</div>
						
						<span>
							<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>
						</span>
						<select id="previewPubchoiceId" name="previewPubchoiceId" >
							<option value="" ></option>
						</select>
	                </span>
	                
	                <span id="pubchilchoiceIdSpan" style="display:none;margin-left:10px;">
	                	<div style="float: left;margin-left:10px;margin-top: 5px;"><%=SystemEnv.getHtmlLabelName(124957,user.getLanguage())%></div>
	                	<brow:browser width="150px" viewType="0" name="pubchilchoiceId"
					    browserUrl="/workflow/selectItem/selectItemMain.jsp?topage=selectItemSupFieldBrowser&url=/workflow/selectItem/selectItemSupFieldBrowser.jsp"
					    completeUrl='<%="javascript:getcompleteurl()"%>'
						hasInput="true" isSingle="true"
						isMustInput="2"
						browserValue='<%=pubchilchoiceId+""%>'
						browserSpanValue='<%=pubchilchoicespan%>'
						browserDialogWidth="550px"
						browserDialogHeight="650px" getBrowserUrlFn="onShowPubchilchoiceId"></brow:browser>
	                </span>
					
					
					<span id="div3_3" <%if(htmltypeid==165||htmltypeid==166||htmltypeid==167||htmltypeid==168){%>style="display:inline-table;vertical-align:middle;"<%}else{%>style="display:none;vertical-align:middle;"<%}%>><span style='float:left;margin-top:3px;'><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage()) %></span><brow:browser width="105px" viewType="0" name="decentralizationbroswerType"
							browserValue='<%=textheight_2%>'
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/form/rightAttributeDepat.jsp?selectValue=#id#"
						    completeUrl="/data.jsp"
							hasInput="true" isSingle="true"
							isMustInput='<%="" + (!isused.equals("true") ? 2 : 0)%>'
							browserDialogWidth="400px"
							browserDialogHeight="290px"
							_callback="typeChange"
							browserSpanValue='<%=th_2_span%>'></brow:browser>
					</span>
					</span>
					<span id="cusbspan" style="display:none;float:none;">
						<brow:browser width="150px" viewType="0" name="cusb"
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
						    completeUrl="/data.jsp"
							hasInput="false" isSingle="true"
							isMustInput="2" browserDialogWidth="550px"
							browserDialogHeight="650px"
							_callback="typeChange"></brow:browser>
					</span>	
				<%}else if(fieldhtmltype.equals("1")){%>
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
				<%if(htmltypeid==1){%>
					<span id=lengthspan><%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%></span>
					<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
					<input class=Inputstyle type=input size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
						onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>" <%if(isused.equals("true")){out.print("disabled");}%>>
					<span id=strlengthspan><%if(textlength.equals("")||textlength.equals("0")){%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
					<span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=6 maxlength=4 name="imgwidth" onChange="checklength('imgwidth','imgwidthspan')"
					 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=imgwidth%>" style="display:none;width:50px!important;">
					<span id=imgwidthspan style="display:none"></span>
					<span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=6 maxlength=4 name="imgheight" onChange="checklength('imgheight','imgheightspan')"
					 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=imgheight%>" style="display:none;width:50px!important;">
					<span id=imgheightspan style="display:none"></span>
				
				<%} else {%>
				<span id=lengthspan></span>
					<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
					<input type=input  class=Inputstyle style=display:none size=10 maxlength=3 style="width:50px!important;" name="strlength" onChange="checklength('strlength','strlengthspan')"
					onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>" <%if(isused.equals("true")){out.print("disabled");}%>>
					<span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
					<span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=6 maxlength=4 name="imgwidth" onChange="checklength('imgwidth','imgwidthspan')"
					 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=imgwidth%>" style="display:none;width:50px!important;">
					<span id=imgwidthspan style="display:none"></span>
					<span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=6 maxlength=4 name="imgheight" onChange="checklength('imgheight','imgheightspan')"
					 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=imgheight%>" style="display:none;width:50px!important;">
					<span id=imgheightspan style="display:none"></span>
				
				<%}%>
				<%}else if(fieldhtmltype.equals("3")){%>
					<span style="display:block;float:left;width: 500px;">
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
							if(("224".equals(BrowserComInfo.getBrowserid()))||"225".equals(BrowserComInfo.getBrowserid())){
								//这里属于系统表单，占不支持新的sap功能
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
					</select>
					<span id="selecthtmltypespan" style="display: none;">
						<img align="absMiddle" src="/images/BacoError_wev8.gif">
					</span>
					<span id=lengthspan></span>
					<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
					<input class=Inputstyle type=input style="display:none;width:50px!important;" size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>">				
					<select <%if(htmltypeid!=224&&htmltypeid!=225){%>style="display:none"<%}%> class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()"  <%if(isused.equals("true")){%>disabled<%}%>>
						<option value=''></option>
						<%
						List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
						for(int j=0;j<AllBrowserId.size();j++){
						%>
						<option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
						<%}%>
					</select>
					<span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
					<!-- TD15999 开始-->
					<%if(isused.equals("true")){%>
					<input type="hidden" value="<%=fielddbtype%>" name="sapbrowser">
					<%}%>
					<span id="div3_3" <%if(htmltypeid==165||htmltypeid==166||htmltypeid==167||htmltypeid==168){%>style="display:inline-table;vertical-align:middle;"<%}else{%>style="display:none;vertical-align:middle;"<%}%>><span style='float:left;margin-top:3px;'><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage()) %></span><brow:browser width="105px" viewType="0" name="decentralizationbroswerType"
								browserValue='<%=textheight_2%>'
							    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/form/rightAttributeDepat.jsp?selectValue=#id#"
							    completeUrl="/data.jsp"
								hasInput="true" isSingle="true"
								isMustInput='<%="" + (!isused.equals("true") ? 2 : 0)%>'
								browserDialogWidth="400px"
								browserDialogHeight="290px"
								_callback="typeChange"
								browserSpanValue='<%=th_2_span%>'></brow:browser>
					
					</span>
					<!-- TD15999 结束-->
					<span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=6 maxlength=4 name="imgwidth" onChange="checklength('imgwidth','imgwidthspan')" 
					onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=imgwidth%>" style="display:none;width:50px!important;">
					<span id=imgwidthspan style="display:none"></span>
					<span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=6 maxlength=4 name="imgheight" onChange="checklength('imgheight','imgheightspan')"
					 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=imgheight%>" style="display:none;width:50px!important;">
					<span id=imgheightspan style="display:none"></span>
					</span>
				<span id="cusbspan" style="display:none;float:none;">
						<brow:browser width="150px" viewType="0" name="cusb"
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
						    completeUrl="/data.jsp"
							hasInput="false" isSingle="true"
							isMustInput="2" browserDialogWidth="550px"
							browserDialogHeight="650px"
							_callback="typeChange"></brow:browser>
					</span>	
				<%}else if(fieldhtmltype.equals("2")||fieldhtmltype.equals("4")){%>
					<span id=typespan></span>
					<select class=inputstyle  style=display:none size=1 name=htmltype id=selecthtmltype onChange="typeChange()"></select>
					<span id="selecthtmltypespan" style="display: none;">
						<img align="absMiddle" src="/images/BacoError_wev8.gif">
					</span>
					<span id=lengthspan><%if (fieldhtmltype.equals("2")) {%><%=SystemEnv.getHtmlLabelName(222,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(15449,user.getLanguage())%><%}%></span>
					<input type='checkbox' name="htmledit" <%if (fieldhtmltype.equals("2")) {%> style="display:none" <%}%>  <%if (htmltypeid==2) {%> checked  disabled<%}%> value="2" onclick="onfirmhtml()">
					<input class=Inputstyle type=input style="display:none;width:50px!important;" size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
					onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>">
					<span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
					<span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=6 maxlength=4 name="imgwidth" onChange="checklength('imgwidth','imgwidthspan')"
					 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=imgwidth%>" style="display:none;width:50px!important;">
					<span id=imgwidthspan style="display:none"></span>
					<span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=6 maxlength=4 name="imgheight" onChange="checklength('imgheight','imgheightspan')"
					 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=imgheight%>" style="display:none;width:50px!important;">
					<span id=imgheightspan style="display:none"></span>   
				
				<%}else if(fieldhtmltype.equals("5")){%>
				
					<span id=typespan></span>
					<select class=inputstyle  style=display:none size=1 name=htmltype id=selecthtmltype onChange="typeChange()"></select>
					<span id="selecthtmltypespan" style="display: none;">
						<img align="absMiddle" src="/images/BacoError_wev8.gif">
					</span>
					<span id=lengthspan></span>
					<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
					<input type=input class="InputStyle" style=display:none size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
						onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>">
					<span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
					
					
					<span id="selectItemTypeSpan">
					    <div style="float: left;margin-left:10px;margin-top: 5px;">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>&nbsp;&nbsp;</div>
					    <%if(isused.equals("true")){%>
					    <select id="selectItemType" disabled name="selectItemType" class=inputstyle  style="float: left;width: 150px;" onchange="selectItemTypeChange('selectItemType');">
		                <%}else{ %>
		                <select id="selectItemType" name="selectItemType" class=inputstyle  style="float: left;width: 150px;" onchange="selectItemTypeChange('selectItemType');">
		                <%} %>
		                    <option value="0" <%if(selectItemType.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124929,user.getLanguage())%></option>
		                    <option value="1" <%if(selectItemType.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124930,user.getLanguage())%></option>
		                    <%if(isshowPubChildOption){ %>
		                    <option value="2" <%if(selectItemType.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124931,user.getLanguage())%></option>
		                    <%} %>
		                </select>
		                
                        <div style="float:left;margin-left:10px;margin-top:5px;">
	                    <span id="childfieldNotesSpan" style="<%if(!selectItemType.equals("0")){ %>display:none;<%} %>"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
	                    </div>
	                    <%--<button type=button style="<%if(!selectItemType.equals("0")){ %>display:none;<%} %>" id="showChildFieldBotton" class=Browser onClick="onShowChildField('childfieldidSpan', 'childfieldid')"></BUTTON>
	                    <span id="childfieldidSpan" style="<%if(!selectItemType.equals("0")){ %>display:none;<%} %>"><%=childfieldname%></span>
	                    <input type="hidden" value="<%=childfieldid%>" name="childfieldid" id="childfieldid">
	                    --%>
	                    <div id="showChildFieldBotton" style="<%if(!selectItemType.equals("0")){ %>display:none;<%} %>;width:25px;float:left" class="childItemDiv">
	                      <brow:browser viewType="0" name='childfieldid' browserValue='<%="" + childfieldid%>'
	                          getBrowserUrlFn="showChildField"
	                          _callback="selectChildField"
	                          hasInput="false" isSingle="true" hasBrowser = "true"  isMustInput='1' width="25px"
	                          browserSpanValue="<%=childfieldname%>"></brow:browser>
	                    </div>
	                    <div style="float:left;margin-top:5px;">
	                    <span style="<%if(!selectItemType.equals("0")){ %>display:none;<%} %>" id="childfieldidSpan" name="childfieldidSpan" class="childfieldidSpan" title='<%=childfieldname%>'><%=childfieldname%></span>
	                    </div>
		                <%if(isused.equals("true")){%>
		                <input name="selectItemType" id="selectItemType" type="hidden" value="<%=selectItemType %>"/>
		                <%} %>
					</span>
					
					<span id="pubchoiceIdSpan" style="<%if(!selectItemType.equals("1")){ %>display:none;<%} %> ">
					    <div style="margin-left:10px;float:left;">
		                	<brow:browser width="150px" viewType="0" name="pubchoiceId"
						    browserUrl="/workflow/selectItem/selectItemMain.jsp?topage=selectItemBrowser&url=/workflow/selectItem/selectItemBrowser.jsp"
						    completeUrl="/data.jsp?type=pubChoice"
							hasInput="true" isSingle="true"
							isMustInput="0"
							browserValue='<%=pubchoiceId+""%>'
							browserSpanValue='<%=pubchoicespan%>'
							browserDialogWidth="550px"
							browserDialogHeight="650px" _callback="setPreviewPub"></brow:browser>
						</div>
						
						
						<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>
						<select id="previewPubchoiceId" name="previewPubchoiceId" >
							<option value="" ></option>
						</select>
	                </span>
	                
	                <span id="pubchilchoiceIdSpan" style="<%if(!selectItemType.equals("2")){ %>display:none;<%} %>">
	                    <div style="float: left;margin-left:10px;margin-top: 5px;">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(124957,user.getLanguage())%>&nbsp;&nbsp;</div>
	                	<brow:browser width="150px" viewType="0" name="pubchilchoiceId"
					    browserUrl="/workflow/selectItem/selectItemMain.jsp?topage=selectItemSupFieldBrowser&url=/workflow/selectItem/selectItemSupFieldBrowser.jsp"
					    completeUrl='<%="javascript:getcompleteurl()"%>'
						hasInput="true" isSingle="true"
						isMustInput="0"
						browserValue='<%=pubchilchoiceId+""%>'
						browserSpanValue='<%=pubchilchoicespan%>'
						browserDialogWidth="550px"
						browserDialogHeight="650px" getBrowserUrlFn="onShowPubchilchoiceId"></brow:browser>
	                </span>
	                
					
					<span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=6 maxlength=4 name="imgwidth" onChange="checklength('imgwidth','imgwidthspan')"
					 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=imgwidth%>" style="display:none;width:50px!important;">
					<span id=imgwidthspan style="display:none"></span>
					<span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=6 maxlength=4 name="imgheight" onChange="checklength('imgheight','imgheightspan')"
					 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=imgheight%>" style="display:none;width:50px!important;">
					<span id=imgheightspan style="display:none"></span>
				
				<%}else if(fieldhtmltype.equals("6")){
					String displaystr="display:none";
					if(htmltypeid==2) displaystr="display:''";
				%>
				
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
					<span id=lengthspan style="<%=displaystr%>"><%=SystemEnv.getHtmlLabelName(24030,user.getLanguage())%></span>
					<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
					<input type=input class="InputStyle" size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
					 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textheight%>" style="<%=displaystr%>">
					<span id=strlengthspan ></span>
					<span id=imgwidthnamespan style="<%=displaystr%>"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=6 maxlength=4 name="imgwidth" onChange="checklength('imgwidth','imgwidthspan')"
					 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=imgwidth%>" style="<%=displaystr%>">
					<span id=imgwidthspan style="<%=displaystr%>"></span>
					<span id=imgheightnamespan style="<%=displaystr%>"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=6 maxlength=4 name="imgheight" onChange="checklength('imgheight','imgheightspan')"
					 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=imgheight%>" style="<%=displaystr%>">
					<span id=imgheightspan style="<%=displaystr%>"></span>
				
				<%}else if(fieldhtmltype.equals("7")){%>
				
					<button type=button  class=btn id=btnaddRow style="display:none" name=btnaddRow onclick="addRow()"><%=SystemEnv.getHtmlLabelName(15443,user.getLanguage())%></BUTTON>
					<button type=button  class=btn id=btnsubmitClear style="display:none" name=btnsubmitClear onclick="submitClear()"><%=SystemEnv.getHtmlLabelName(15444,user.getLanguage())%></BUTTON>
					<span id=typespan></span>
					<%if(isused.equals("true")){%>
					<select class=inputstyle  style=display:'' size=1 id=selecthtmltype name=selecthtmltype onChange="typeChange()" disabled>
						<option value="1" <%if(htmltypeid==1) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
						<option value="2" <%if(htmltypeid==2) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></option>
					</select>
					<input type="hidden" name="htmltype" id="htmltype" value="<%=htmltypeid%>">
					<%}else{%>
					<select class=inputstyle  style=display:'' size=1 id=selecthtmltype name=htmltype onChange="typeChange()">
						<option value="1" <%if(htmltypeid==1) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
						<option value="2" <%if(htmltypeid==2) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></option>
					</select>
					<%}%>
					<span id="selecthtmltypespan" style="display: none;">
						<img align="absMiddle" src="/images/BacoError_wev8.gif">
					</span>
					<input type="text"  name="textheight" maxlength=2 size=4 onKeyPress="ItemCount_KeyPress()" class=Inputstyle style=display:none>
				
					<span id=lengthspan></span>
					<input type='checkbox' name="htmledit" style="display:none"  value="2">
					<input type=input class="InputStyle" style=display:none size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
					onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>">
					<span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
					<span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=6 maxlength=4 name="imgwidth" onChange="checklength('imgwidth','imgwidthspan')"
					 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=imgwidth%>" style="display:none">
					<span id=imgwidthspan style="display:none"></span>
					<span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=6 maxlength=4 name="imgheight" onChange="checklength('imgheight','imgheightspan')"
					 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=imgheight%>" style="display:none">
					<span id=imgheightspan style="display:none"></span>
				<%}else if(fieldhtmltype.equals("9")){%>
					<span id=typespan><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></span>
					<!-- modify by xhheng @ 20041222 for TDID 1230-->
					<!-- 单行文本框，在类型 整形、浮点型向文本的转换会出现数据库异常，故禁止转换-->
					<%if(isused.equals("true")){%>
					<input type="hidden" value="<%=htmltypeid%>" name="htmltype">
					<select class=inputstyle  size=1 name=htmltype id=selecthtmltype onChange="typeChange()" disabled>
					<%}else{%>
					<select class=inputstyle  size=1 name=htmltype id=selecthtmltype onChange="typeChange()">
					<%}%>
						<option value="1" <%if(htmltypeid==1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(22981,user.getLanguage())%></option>
					</select>
					<%-- 
					<%if(htmltypeid==1){%>
					<span id="locateTypeSpan" style="display:''">
						<span><%=SystemEnv.getHtmlLabelName(125581,user.getLanguage())%></span>
						<%if(isused.equals("true")){%>
						<input type="hidden" value="<%=locateTypeDB%>" name="locateType">
						<select id="locateType" name="locateType" disabled>						
						<%}else {%>
						<select id="locateType" name="locateType">
						<%} %>
							<option value="1" <%if(locateTypeDB.equals("1")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(125582,user.getLanguage()) %></option>
							<option value="2" <%if(locateTypeDB.equals("2")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(81855,user.getLanguage())%></option>
						</select>
					</span>
					<%}%>
					--%>
				<%}else{
					out.println("<td class=field></td><td class=field></td>");
				  }
			} else {%>
				<%if(fieldhtmltype.equals("1")){%><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%><%}%>
				<%if(fieldhtmltype.equals("2")){%><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%><%}%>
				<%if(fieldhtmltype.equals("3")){%><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%><%}%>
				<%if(fieldhtmltype.equals("4")){%><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%><%}%>
				<%if(fieldhtmltype.equals("5")){%><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%><%}%>
				
				<input id="fieldhtmltype" name="fieldhtmltype" type="hidden" value="<%=fieldhtmltype %>"/>
			<%}%>   
	    </wea:item>
	    <wea:item> </wea:item>
	    <wea:item> 
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
			%>   
	   		<div id="customlink" <%out.println(iscustomlink);%>>
	   			<table width="100%">
	   				<tr>
	   					<td width="25%">
	   						<%=SystemEnv.getHtmlLabelName(606,user.getLanguage())%>　
	   						<input class=inputstyle type=text name=displayname size=20 value="<%=displayname%>" maxlength=1000>　
	   					</td>
	   					<td>
	   						<%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%>　
	   						<input class=inputstyle type=text size=50 name=linkaddress value="<%=linkaddress%>" maxlength=1000>
							&nbsp;&nbsp;
	   						<%=SystemEnv.getHtmlLabelName(18391,user.getLanguage())%>
	   					</td>
	   				</tr>
	   			</table>
	   		</div>	
	　　		<div id="descriptive" <%out.println(isdescriptive);%>>
				<table width="100%">
					<tr>
						<td width="8%"><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></td>
						<td>
							<textarea class='inputstyle' style='width:60%;height:100px' name=descriptivetext><%=Util.StringReplace(descriptivetext,"<br>","\n")%></textarea>
						</td>
					</tr>
				</table>
			</div>				    	    
			<%
			rowsum+=1;
			%>	   
		</wea:item>
		
	</wea:group>
	
	
</wea:layout>


<div id="selectdiv" <%if(fieldhtmltype.equals("5") && selectItemType.equals("0")){%>style="display:''" <%} else {%>style="display:none"<%}%>>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(124984,user.getLanguage())%>' >
		    <wea:item type="groupHead">
		        <span style="float:right;">
				<input type="button" class="addbtn" style="width:21px !important;"  title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="addRow()"/>
				<input type="button" class="delbtn" style="width:21px !important;"  title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="submitClear()"/>
				</span>
			</wea:item>
			<wea:item attributes="{'isTableList':'true'}">
				<%if(fieldid==0){%>
				<table class="ListStyle" id="oTable" cols=3>
					<colgroup>
			  	  		<col width=10%>
		  	  			<col width=50%>
		  	  			<col width=30%>
		  	  			<col width=10%>
		  	  		</colgroup>
			  	   	 <tr class="header notMove">
			  	   		<td><input type="checkbox" name="selectall" id="selectall" onclick="SelAll(this)"></td>
			  	   		<td><%=SystemEnv.getHtmlLabelName(15442,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(22663,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(22151,user.getLanguage())%></td> 
			  	   	</tr>
				<%
					//rowsum++;
				}else{%> 
				<table class="ListStyle" id="oTable" cols=4>
					<colgroup>
		  	  			<col width=10%>
		  	  			<col width=50%>
		  	  			<col width=30%>
		  	  			<col width=10%>
		  	  		</colgroup>
			  	   	 <tr class="header notMove">
			  	   		<td><input type="checkbox" name="selectall" id="selectall" onclick="SelAll(this)"></td>
			  	   		<td><%=SystemEnv.getHtmlLabelName(15442,user.getLanguage())%></td> 
						<td><%=SystemEnv.getHtmlLabelName(22663,user.getLanguage())%></td>  
						<td><%=SystemEnv.getHtmlLabelName(22151,user.getLanguage())%></td> 
			  	   	</tr>
					<%
					int colorcount=0;
					sql="select * from workflow_SelectItem where fieldid="+fieldid+" and isbill=1 order by listorder";
					RecordSet.executeSql(sql);
					while(RecordSet.next()){
						String selectname=RecordSet.getString("selectname");
						String id=RecordSet.getString("id");
						String selectvalue=RecordSet.getString("selectvalue");
							String cancel=RecordSet.getString("cancel");
						String listorder = RecordSet.getString("listorder");
						String temp = "";
						String childitemid = Util.null2String(RecordSet.getString("childitemid"));
						String childitemStr = "";
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
					%>
					<tr class="DataDark">
						<td  height="23" width=10%><input type='checkbox' name='check_select' id="check_select_<%=rowsum %>" value="<%=selectvalue%>" >
						&nbsp;<img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>' />
						<input type='hidden' name='listorder_<%=rowsum %>' id="listorder_<%=rowsum %>" value="<%=listorder%>" >
						<input type='hidden' name='id_<%=rowsum %>' id="id_<%=rowsum %>" value="<%=id%>" >
						</td>
						<td>
							<input class=Inputstyle type=text name="field_<%=rowsum%>_name" value="<%=Util.toScreen(selectname,user.getLanguage())%>" style="width:50%" onchange="checkinput('field_<%=rowsum%>_name','field_<%=rowsum%>_span')">
							<span id="field_<%=rowsum%>_span"></span>
						</td>
						<td>
							<%-- <button type=button  class="Browser" onClick="onShowChildSelectItem('childItemSpan<%=rowsum%>', 'childItem<%=rowsum%>')" id="selectChildItem<%=rowsum%>" name="selectChildItem<%=rowsum%>"></BUTTON>
							<input type="hidden" id="childItem<%=rowsum%>" name="childItem<%=rowsum%>" value="<%=childitemid%>">
							<span id="childItemSpan<%=rowsum%>" name="childItemSpan<%=rowsum%>"><%=childitemStr%></span>
							--%>
							<div style="float:left; display:inline;width:25px;" class="childItemDiv">
							  <%if(childitemid.startsWith(",")){childitemid = childitemid.substring(1);} %>
                              <brow:browser viewType="0" name='<%="childItem"+rowsum%>' browserValue="<%=childitemid%>"
                                  getBrowserUrlFn="showChildSelectItem" getBrowserUrlFnParams='<%=""+rowsum%>'
                                  _callback="selectChildSelectItem"
                                  _callbackParams='<%=""+rowsum%>'
                                  hasInput="false" isSingle="false" hasBrowser = "true"  isMustInput='1' width="25px"
                                  browserSpanValue="<%=childitemStr%>"></brow:browser>
                            </div>
                            <span id="childItemSpan<%=rowsum%>" name="childItemSpan<%=rowsum%>" class="childItemSpan" title='<%=childitemStr%>'><%=childitemStr%></span>
						</td>
						<td><input type='checkbox' name="cancel_<%=rowsum%>" <%=temp%>  value='1'></td>
					</tr>
				<% rowsum++;}%>
				<%}%>
			  	</table>
			</wea:item>
		</wea:group>
</wea:layout>
</div>

<input type="hidden" value="0" name="selectsnum">
<input type="hidden" value="" name="delids">
</form>

<%if(frompage==1){ %>

</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
</wea:layout>
</div>
<%} %>

<script language="JavaScript" src="/js/addRowBg_wev8.js" ></script>
<script type="text/javascript" language="javascript">
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}

jQuery(document).ready(function(){
	resizeDialog(document);
});

function btn_cancle(){
	dialog.closeByHand();
	parentWin._table.reLoad();
}
if("<%=isclose%>"=="1"){
	if("<%=fromWFCode%>" == "wfcode"){
		if("<%=fHtmlType%>" == "1"){
			var lableid = "<%=lableid%>";
			var idcode = "<%=idcode%>";
			var returnjson  = {lableid:lableid,idcode:idcode};
			try{
		        dialog.callback(returnjson);
		    }catch(e){}
			try{
		     	dialog.close(returnjson);
		 	}catch(e){}
		}else{
			dialog.close();
		}
	}else{
		parentWin._table.reLoad();
		dialog.close();
	}
}


<%
if(pubchoiceId>0){
%>
	setPreviewPub();
<%
}
%>





function setPreviewPub(event,datas,name){
	var pubchoiceId = jQuery("#pubchoiceId").val()
	
	jQuery("#previewPubchoiceId").empty();
	jQuery.ajax({
			type: "POST",
			cache: false,
			url: "/workflow/selectItem/selectItemAjaxData.jsp?src=pubchoiceback&id="+pubchoiceId,
		    dataType: "json",  
		    async:false,
		    //contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(){
			},
		    error:function (XMLHttpRequest, textStatus, errorThrown) {
		    } , 
		    success : function (data, textStatus) {
		        jQuery("#previewPubchoiceId").append("<option value=''></option>");
		        var _data = data;
		    	for(var i=0;i<_data.length;i++){
		    	    var tt = _data[i];
		    	    var _id = tt.id;
		    	    var _name = tt.name;
		    		jQuery("#previewPubchoiceId").append("<option value='"+_id+"'>"+_name+"</option>");
		    	}
		    	//beautySelect("#previewPubchoiceId");
		    	__jNiceNamespace__.reBeautySelect("#previewPubchoiceId");
		    } 
	}); 
	
	
}

function eidtSelectItem(id){
	var title = "";
	var url = "";
	title = "<%=SystemEnv.getHtmlLabelName(124896,user.getLanguage())%>";
	url="/workflow/selectItem/selectItemMain.jsp?topage=selectItemEdit&src=edit&id="+id;
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 600;
	diag_vote.maxiumnable = true;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}

function selectItemTypeChange(obj){
	var value = jQuery("#"+obj).val();
	if(value != 0){
		jQuery("#selectdiv").hide();
		
		$G("childfieldNotesSpan").style.display='none';
		$G("showChildFieldBotton").style.display='none';
		$G("childfieldidSpan").style.display='none';
	}else{
		jQuery("#selectdiv").show();
		
		$G("childfieldNotesSpan").style.display='';
		$G("showChildFieldBotton").style.display='';
		$G("childfieldidSpan").style.display='';
	}
	
	if(value==1){
		jQuery("#pubchoiceIdSpan").show();
	}else{
		jQuery("#pubchoiceIdSpan").hide();
	}
	
	if(value==2){
		jQuery("#pubchilchoiceIdSpan").show();
	}else{
		jQuery("#pubchilchoiceIdSpan").hide();
	}
	
	
}
	
function SelAll(obj){
	//$("input[type=checkbox]").attr("checked",obj.checked);
	var ckd = jQuery(obj).attr("checked");
	jQuery("input[id^='check_select_']").each(function(){
		if(ckd){
			jQuery(this).attr("checked",true);
			changeCheckboxStatus(this, true);
		}else{
			jQuery(this).attr("checked",false);
			changeCheckboxStatus(this, false);
		}
	});
}


function onShowPubchilchoiceId() {
    var isdetail = 0;
    var detailtable = "";
    url = "/workflow/selectItem/selectItemMain.jsp?topage=selectItemSupFieldBrowser&fieldhtmltype=5&billid=<%=billId%>" + detailtable + "&isdetail=" + isdetail + "&isbill=1&fieldid=<%=fieldid%>";
    return url;
}

function getcompleteurl(){
    var isdetail = 0;
    var detailtable = "";
    url = "/data.jsp?type=pubChoice&pubchild=1&isSys=1&fieldhtmltype=5&billid=<%=billId%>" + detailtable + "&isdetail=" + isdetail + "&isbill=1&fieldid=<%=fieldid%>";
    return url;
}


function setSelectItemType(){
	$("#selectItemType option[value='2']").remove(); 
	
	var isdetail = 0;
    var detailtable = "";
    
	jQuery.ajax({
			type: "POST",
			cache: false,
			url: "/workflow/selectItem/selectItemAjaxData.jsp?src=hasPubChoice&isdetail="+isdetail+"&formid=<%=billId%>&detailtable="+detailtable,
		    dataType: "text",  
		    async:false,
		    //contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(){
			},
		    error:function (XMLHttpRequest, textStatus, errorThrown) {
		    } , 
		    success : function (data, textStatus) {
		        var _data = data.trim();
		        if(_data=="true"){
					jQuery("#selectItemType").append("<option value='2'><%=SystemEnv.getHtmlLabelName(124931,user.getLanguage())%></option>");		        
		        }
		    	__jNiceNamespace__.reBeautySelect("#selectItemType");
		    } 
	}); 
}


	
jQuery(document).ready(function(){
	registerDragEvent();
	jQuery("tr.notMove").bind("mousedown", function() {
		return false;
	});
});	
	
	
	
function registerDragEvent() {
	var fixHelper = function(e, ui) {
		ui.children().each(function() {
		    $(this).width($(this).width()); // 在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了

		    $(this).height($(this).height());
		});
		return ui;
	};

	var copyTR = null;
	var startIdx = 0;

	var idStr = "#oTable";
	jQuery(idStr + " tbody tr").bind("mousedown", function(e) {
		copyTR = jQuery(this).next("tr.Spacing");
	});
        
    jQuery(idStr + " tbody").sortable({ // 这里是talbe tbody，绑定 了sortable
        helper: fixHelper, // 调用fixHelper
        axis: "y",
        start: function(e, ui) {
            ui.helper.addClass("e8_hover_tr") // 拖动时的行，要用ui.helper
            if(ui.item.hasClass("notMove")) {
            	e.stopPropagation && e.stopPropagation();
            	e.cancelBubble = true;
            }
            if(copyTR) {
       			copyTR.hide();
       		}
       		startIdx = ui.item.get(0).rowIndex;
            return ui;
        },
        stop: function(e, ui) {
            ui.item.removeClass("e8_hover_tr"); // 释放鼠标时，要用ui.item才是释放的行
        	if(ui.item.get(0).rowIndex < 1) { // 不能拖动到表头上方

                if(copyTR) {
           			copyTR.show();
           		}
        		return false;
        	}
           	if(copyTR) {
	       	  	/* if(ui.item.get(0).rowIndex > startIdx) {
	        	  	ui.item.before(copyTR.clone().show());
				}else {
	        	  	ui.item.after(copyTR.clone().show());
				} */
				if(ui.item.prev("tr").attr("class") == "Spacing") {
					ui.item.after(copyTR.clone().show());
				}else {
					ui.item.before(copyTR.clone().show());
				}
	       	  	copyTR.remove();
	       	  	copyTR = null;
       		}
           	return ui;
        }
    });
}


rowindex = "<%=rowsum%>";
delids = "";
var rowColor="" ;
function addRow()
{			
    rowColor = getRowBg();
	//ncol = oTable.cols;
	ncol = oTable.rows[0].cells.length;
	oRow = oTable.insertRow(-1);
	//oRow.className = "DataLight";
	jQuery(oRow).addClass("DataDark");
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background="#FFFFFF";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_select' id='check_select_"+rowindex+"'  value='0'> &nbsp;<img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>' /><input type='hidden' name='listorder_"+rowindex+"' id='listorder_<%=rowsum %>' value="+rowindex+" >";
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
			    /*
				var oDiv = document.createElement("div");
				var sHtml = "<button type=button  class=\"Browser\" onClick=\"onShowChildSelectItem('childItemSpan"+rowindex+"', 'childItem"+rowindex+"')\" id=\"selectChildItem"+rowindex+"\" name=\"selectChildItem"+rowindex+"\"></BUTTON>"
							+ "<input type=\"hidden\" id=\"childItem"+rowindex+"\" name=\"childItem"+rowindex+"\" value=\"\" >"
							+ "<span id=\"childItemSpan"+rowindex+"\" name=\"childItemSpan"+rowindex+"\"></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				*/
				
                var oDiv = document.createElement("div");
                var sHtml = "<div style='float:left; display:inline;width:25px;' class='childItemDiv'>"
                            + "\r\n<span  id='childItem"+rowindex+"' name='childItem"+rowindex+"' ></span>"
                            + "\r\n</div><span id=\"childItemSpan"+rowindex+"\" class=\"childItemSpan\" name=\"childItemSpan"+rowindex+"\"></span>";
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
                jQuery("#childItem"+rowindex).e8Browser({
                   name:"childItem"+rowindex,
                   viewType:"0",
                   browserValue:"",
                   isMustInput:"1",
                   browserSpanValue:"",
                   getBrowserUrlFn:"showChildSelectItem",
                   getBrowserUrlFnParams:''+rowindex,
                   _callback:"selectChildSelectItem",
                   _callbackParams:rowindex,
                   hasInput:false,
                   isSingle:false,
                   hasBrowser:true,
                   width:"25px",
                   hasAdd:false
                   });
				break;
			case 3:
			    var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name=\"cancel_"+rowindex+"\"  value='1'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex = rowindex*1 +1;
	jQuery("body").jNice();
}

if("<%=isclose%>"==1 && "<%=fHtmlType%>" == 1 ){
	var dialog = parent.getDialog(window);
	var lableid = "<%=lableid%>";
	var idcode = "<%=idcode%>";
	var returnjson  = {lableid:lableid,idcode:idcode};
	try{
        dialog.callback(returnjson);
    }catch(e){}
	try{
     	dialog.close(returnjson);
 	}catch(e){}
}
if("<%=isclose%>"==1 && "<%=fHtmlType%>" != 1 ){
	var dialog = parent.getDialog(window);
	dialog.close();
}

function deleteRow1()
{
	$("input[name=check_select]").each(function(){
		if($(this).attr("checked")){
			$(this).closest("tr").remove();
		}
	});
}

function bindSelectDate(name){
    $("select[name="+name+"]").selectbox("detach");
    $("select[name="+name+"]").selectbox();
}

function showType(){
	jQuery('#selecthtmltypespan').hide();
	jQuery('#selecthtmltype').autoSelect('hide');
	var htmltypeedit = $G("htmledit");
	var fieldhtmltypelist = window.document.forms[0].fieldhtmltype;
	var htmltypelist = window.document.forms[0].htmltype;
	var cusbspan=$G("cusbspan");//td15999
	var sapbrowser=$G("sapbrowser");
	jQuery("#specialhtmltype").selectbox("hide");
	//jQuery("#htmltypelist").selectbox("show");
	if(fieldhtmltypelist.value==2||fieldhtmltypelist.value==4){
		htmltypelist.style.display='none';
		htmltypeedit.style.display='none';
		typespan.innerHTML='';
		lengthspan.innerHTML='';
		if(fieldhtmltypelist.value==2) { 
			htmltypeedit.style.display='';
			lengthspan.innerHTML='<%=SystemEnv.getHtmlLabelName(222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15449,user.getLanguage())%>';
		}
		//jQuery("#locateTypeSpan").css("display", "none");
		window.document.forms[0].strlength.style.display='none';
		strlengthspan.innerHTML='';
		$G("selectdiv").style.display='none';
		$G("customlink").style.display='none';
		$G("descriptive").style.display='none';
		$G("childfieldNotesSpan").style.display='none';
		$G("showChildFieldBotton").style.display='none';
		$G("childfieldidSpan").style.display='none';
		
		$G("selectItemTypeSpan").style.display='none';
		$G("pubchilchoiceIdSpan").style.display='none';
		$G("pubchoiceIdSpan").style.display='none';
		
		
		
		$G("imgwidthnamespan").style.display='none';
		$G("imgwidthspan").style.display='none';
		$G("imgheightnamespan").style.display='none';
		$G("imgheightspan").style.display='none';
		$G("imgwidth").style.display='none';
		$G("imgheight").style.display='none';
		$("select[name=htmltype]").next().hide();
		if(typeof(cusbspan) != undefined) cusbspan.style.display='none';//td15999
		if(typeof(sapbrowser) != undefined) sapbrowser.style.display='none';
		 <%
		if(userm ==1) {
		%>
		 shieldingRightMenu();
		<%}%>
		$G("ViewLines").style.display="none";
	}
	if(fieldhtmltypelist.value==5){
		htmltypeedit.style.display='none';
		htmltypelist.style.display='none';
		$("select[name=htmltype]").next().hide();
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
        
        $G("selectItemTypeSpan").style.display='';
		$G("pubchilchoiceIdSpan").style.display='none';
		$G("pubchoiceIdSpan").style.display='none';
		setSelectItemType();
		//jQuery("#locateTypeSpan").css("display", "none");
        $G("imgwidthnamespan").style.display='none';
        $G("imgwidthspan").style.display='none';
        $G("imgheightnamespan").style.display='none';
        $G("imgheightspan").style.display='none';
        $G("imgwidth").style.display='none';
        $G("imgheight").style.display='none';
        if(typeof(cusbspan) != undefined) cusbspan.style.display='none';//td15999
        if(typeof(sapbrowser) != undefined) sapbrowser.style.display='none';
		<%
		if(userm ==1) {
		%>
		showRightMenu(); 
		<%}%>
		$G("ViewLines").style.display="";
		
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
		<%=browsertype %>
		//jQuery("#locateTypeSpan").css("display", "none");
		sortOption(htmltypelist); //下拉框排序
		$(htmltypelist).selectbox('hide');
        jQuery(htmltypelist).autoSelect();
		$G("customlink").style.display='none';
		$G("descriptive").style.display='none';
		$G("childfieldNotesSpan").style.display='none';
		$G("showChildFieldBotton").style.display='none';
		 typeChange();
		$G("childfieldidSpan").style.display='none';
		
		$G("selectItemTypeSpan").style.display='none';
		$G("pubchilchoiceIdSpan").style.display='none';
		$G("pubchoiceIdSpan").style.display='none';
		
		$G("imgwidthnamespan").style.display='none';
		$G("imgwidthspan").style.display='none';
		$G("imgheightnamespan").style.display='none';
		$G("imgheightspan").style.display='none';
		$G("imgwidth").style.display='none';
		$G("imgheight").style.display='none';
		if($G("htmltype").value==224){
			sapbrowser.style.display='';
			if($G("sapbrowser").value==""){
				strlengthspan.innerHTML='<IMG src="/images/BacoError_wev8.gif" align=absMiddle>';
			}
		}
		<%
		if(userm ==1) {
		%>
		 shieldingRightMenu();
		<%} %>
		$G("ViewLines").style.display="none";
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
		//jQuery("#locateTypeSpan").css("display", "none");
		bindSelectDate("htmltype");	
		$G("customlink").style.display='none';
		$G("descriptive").style.display='none';
		$G("childfieldNotesSpan").style.display='none';
		$G("showChildFieldBotton").style.display='none';
		$G("childfieldidSpan").style.display='none';
		
		$G("selectItemTypeSpan").style.display='none';
		$G("pubchilchoiceIdSpan").style.display='none';
		$G("pubchoiceIdSpan").style.display='none';
		
		$G("imgwidthnamespan").style.display='none';
		$G("imgwidthspan").style.display='none';
		$G("imgheightnamespan").style.display='none';
		$G("imgheightspan").style.display='none';
		$G("imgwidth").style.display='none';
		$G("imgheight").style.display='none';
		$("select[name=htmltype]").hide();
		$("select[name=htmltype]").next().show();
		
		if(typeof(cusbspan) != undefined) cusbspan.style.display='none';//td15999
		<%
		if(userm ==1) {
		%>
			hieldingRightMenu();
		<%}%>
		$G("ViewLines").style.display="none";
	}
	if(fieldhtmltypelist.value==6){
		htmltypelist.style.display='none';
		htmltypeedit.style.display='none';
		typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>';
		strlengthspan.innerHTML='';
		$G("selectdiv").style.display='none';
		for(var count = htmltypelist.options.length - 1; count >= 0; count--)
		htmltypelist.options[count] = null;
		htmltypelist.options[0] = new Option('<%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%>',1);
		htmltypelist.options[1] = new Option('<%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%>',2);
		htmltypelist.style.display='';
		//jQuery("#locateTypeSpan").css("display", "none");
		bindSelectDate("htmltype");	
		$G("customlink").style.display='none';
		$G("descriptive").style.display='none';
		$G("childfieldNotesSpan").style.display='none';
		$G("showChildFieldBotton").style.display='none';
		$G("childfieldidSpan").style.display='none';
		
		$G("selectItemTypeSpan").style.display='none';
		$G("pubchilchoiceIdSpan").style.display='none';
		$G("pubchoiceIdSpan").style.display='none';
		
		if(htmltypelist.value==1){
			$G("imgwidthnamespan").style.display='none';
			$G("imgwidthspan").style.display='none';
			$G("imgheightnamespan").style.display='none';
			$G("imgheightspan").style.display='none';
			$G("imgwidth").style.display='none';
			$G("imgheight").style.display='none';
			lengthspan.innerHTML='';
			window.document.forms[0].strlength.style.display='none';
		}else{
			lengthspan.innerHTML='<%=SystemEnv.getHtmlLabelName(24030,user.getLanguage())%>';
			window.document.forms[0].strlength.style.display='';
			$G("imgwidthnamespan").style.display='';
			$G("imgwidthspan").style.display='';
			$G("imgheightnamespan").style.display='';
			$G("imgheightspan").style.display='';
			$G("imgwidth").style.display='';
			$G("imgheight").style.display='';
		}
		$G("ViewLines").style.display="none";
	}
	if(fieldhtmltypelist.value==7){
		htmltypeedit.style.display='none';
		//htmltypelist.style.display='';
		typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%>';
		lengthspan.innerHTML='';
		window.document.forms[0].strlength.style.display='none';
		strlengthspan.innerHTML='';
		$G("selectdiv").style.display='none';
		htmltypelist.style.display='none';
		jQuery("select[name=htmltype]").next().hide();
		//htmltypelist = $G("selecthtmltype");
		//jQuery("#htmltypelist").selectbox("hide");
		jQuery("#specialhtmltype").selectbox("show");
		
		//for(var count = htmltypelist.options.length - 1; count >= 0; count--)
		//	htmltypelist.options[count] = null;
		//htmltypelist.options[0] = new Option('',1);
		//htmltypelist.options[1] = new Option('',2);
		//htmltypelist.style.display='';
		//bindSelectDate("htmltype");
		//jQuery("#locateTypeSpan").css("display", "none");	
		$G("customlink").style.display='';
		$G("descriptive").style.display='none';
		$G("childfieldNotesSpan").style.display='none';
		$G("showChildFieldBotton").style.display='none';
		$G("childfieldidSpan").style.display='none';
		
		$G("selectItemTypeSpan").style.display='none';
		$G("pubchilchoiceIdSpan").style.display='none';
		$G("pubchoiceIdSpan").style.display='none';
		
		$G("imgwidthnamespan").style.display='none';
		$G("imgwidthspan").style.display='none';
		$G("imgheightnamespan").style.display='none';
		$G("imgheightspan").style.display='none';
		$G("imgwidth").style.display='none';
		$G("imgheight").style.display='none';
		if(typeof(cusbspan) != undefined) cusbspan.style.display='none';//td15999
		if(typeof(sapbrowser) != undefined) sapbrowser.style.display='none';
		<%
		if(userm ==1) {
		%>
		 shieldingRightMenu();
		<%} %>
		$G("ViewLines").style.display="";
	}
	if(fieldhtmltypelist.value==9){
		htmltypeedit.style.display='none';   //对应第三个标签，如文本长度
		htmltypelist.style.display='';		 //对应第二个选择框
		typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%>';  //字段类型
		lengthspan.innerHTML='<%=SystemEnv.getHtmlLabelName(125581,user.getLanguage())%>';//定位方式
		$G("selectdiv").style.display='none';
		for(var count = htmltypelist.options.length - 1; count >= 0; count--)
		htmltypelist.options[count] = null;
		<%=locationTypeOption%>
		lengthspan.innerHTML='';
		window.document.forms[0].strlength.style.display='none';
		typeChange();
		bindSelectDate("htmltype");	
		$G("customlink").style.display='none';
		$G("descriptive").style.display='none';
		$G("childfieldNotesSpan").style.display='none';
		$G("showChildFieldBotton").style.display='none';
		$G("childfieldidSpan").style.display='none';
		
		$G("selectItemTypeSpan").style.display='none';
		$G("pubchilchoiceIdSpan").style.display='none';
		$G("pubchoiceIdSpan").style.display='none';
		
		$G("imgwidthnamespan").style.display='none';
		$G("imgwidthspan").style.display='none';
		$G("imgheightnamespan").style.display='none';
		$G("imgheightspan").style.display='none';
		$G("imgwidth").style.display='none';
		$G("imgheight").style.display='none';
		jQuery("select[name=htmltype]").hide();
		jQuery("select[name=htmltype]").next().show();
		strlengthspan.style.display='none';
		
		if(typeof(cusbspan) != undefined) cusbspan.style.display='none';//td15999
		<%
		if(userm ==1) {
		%>
			hieldingRightMenu();
		<%}%>
		$G("ViewLines").style.display="none";
	}
}

	function typeChange(){
		jQuery('#selecthtmltypespan').hide();
		var fieldhtmltypelist = window.document.forms[0].fieldhtmltype;
		var htmltypelist = window.document.forms[0].htmltype;
		var sapbrowser=$G("sapbrowser");
		var cusbspan=$G("cusbspan");
        var cusb=$G("cusb");
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
		
		if(fieldhtmltypelist.value==9){
			//jQuery("#locateTypeSpan").css("display", "");
		}
		
		//td15999
		$G("div3_3").style.display = "none";
		if(fieldhtmltypelist.value==3){
			if (htmltypelist.value == '') {
        		jQuery('#selecthtmltypespan').show();
        	}
			if(htmltypelist.value==161||htmltypelist.value==162){
				cusbspan.style.display='';
			}else if(htmltypelist.value==224||htmltypelist.value==225){
				sapbrowser.style.display='';
				if(sapbrowser.value==''||sapbrowser.value==0){
					strlengthspan.innerHTML='<IMG src="/images/BacoError_wev8.gif" align=absMiddle>';
				}else
                    strlengthspan.innerHTML='';
				strlengthspan.style.display='';
			}else if(htmltypelist.value==165 || htmltypelist.value==166 || htmltypelist.value==167 || htmltypelist.value==168){
				$G("div3_3").style.display = "inline-table";
				cusb.value='';
				cusbspan.style.display='none';
				sapbrowser.value='';
				sapbrowser.style.display='none';
				strlengthspan.innerHTML='';
				strlengthspan.style.display='none';
			}else{
				cusb.value=''
				cusbspan.style.display='none';
				sapbrowser.value='';
				sapbrowser.style.display='none';
				strlengthspan.innerHTML='';
				strlengthspan.style.display='none';
			}

		}
		if(fieldhtmltypelist.value==6){
			if(htmltypelist.value==1){
                $G("imgwidthnamespan").style.display='none';
                $G("imgwidthspan").style.display='none';
                $G("imgheightnamespan").style.display='none';
                $G("imgheightspan").style.display='none';
                $G("imgwidth").style.display='none';
                $G("imgheight").style.display='none';
                lengthspan.innerHTML='';
                window.document.forms[0].strlength.style.display='none';
			}else{
                lengthspan.innerHTML='<%=SystemEnv.getHtmlLabelName(24030,user.getLanguage())%>';
                window.document.forms[0].strlength.style.display='';
                $G("imgwidthnamespan").style.display='';
                $G("imgwidthspan").style.display='';
                $G("imgheightnamespan").style.display='';
                $G("imgheightspan").style.display='';
                $G("imgwidth").style.display='';
                $G("imgheight").style.display='';
			}
		}
        if(fieldhtmltypelist.value==7){
        	var specialvalue = jQuery("#specialhtmltype").val();
			if(specialvalue == 1){
               $G("customlink").style.display='';
               $G("descriptive").style.display='none';
			}
		    if(specialvalue == 2){
               $G("customlink").style.display='none';
               $G("descriptive").style.display='';
			}
			jQuery("select[name=htmltype]").val(specialvalue);
		}
		BTCOpen();
	}
	
	function BTCOpen(){
            //清空已有BTC对象
            var btc = new BTC();

            var tempBtc;
            while(tempBtc = BTCArray.shift()){
              jQuery("#selecthtmltype_autoSelect .sbToggle").removeClass("sbToggle-btc-reverse")
              tempBtc.remove();
            }
    	    <%
            if (HrmUserVarify.checkUserRight("SysadminRight:Maintenance", user)){ 
            %>
            jQuery("#selecthtmltype_autoSelect .sbHolder").next(".btc_type_edit").remove();
            jQuery("#selecthtmltype_autoSelect .sbHolder").after("<img onclick='setBTC()' class='btc_type_edit' src='/images/ecology8/workflow/setting_wev8.png'>");
    	    jQuery("#selecthtmltype_autoSelect").css("width",jQuery("#selecthtmltype_autoSelect .sbHolder").width()+30);
    	    <%}%>
    	    //浏览框类型选择框处理
            jQuery("#selecthtmltype_autoSelect .sbToggle").addClass("sbToggle-btc");
            jQuery("#selecthtmltype_autoSelect .sbToggle").unbind("click");
            jQuery("#selecthtmltype_autoSelect").find(".sbSelector").unbind("focus");
            jQuery("#selecthtmltype_autoSelect").find(".sbSelector").unbind("blur");  
            jQuery("#selecthtmltype_autoSelect").find(".sbSelector").css("text-indent","0");  
            jQuery("#selecthtmltype_autoSelect").find(".sbSelector").css("font-size","12px");  
            jQuery("#selecthtmltype_autoSelect").find(".sbSelector").unbind("click");     
            jQuery("#selecthtmltype_autoSelect").find(".sbSelector").bind("focus",function(){
				    if(jQuery("#selecthtmltype_autoSelect .sbToggle").hasClass("sbToggle-btc-reverse")){
				       if(BTCArray.length>0){
				       	jQuery("#selecthtmltype_autoSelect .sbToggle").trigger("click");
				       }
				    };
			});
			
			jQuery("#selecthtmltype_autoSelect .sbToggle").bind("click",function(){
			   if(jQuery("#selecthtmltype_autoSelect .sbToggle").hasClass("sbToggle-btc-reverse")){
               	  btc.remove();
			   }else{
			   	  btc.init({
				  renderTo:jQuery("#selecthtmltype_autoSelect"),
			      headerURL:"/workflow/field/BTCAjax.jsp?action=queryHead&noneedtree=1",
				  contentURL:"/workflow/field/BTCAjax.jsp?action=queryContent&noneedtree=1",
				  contentHandler:function(value){
					    jQuery("#selecthtmltype").val(value);
					    jQuery("#selecthtmltype").trigger("change");
				  },
				  clickHandler:function(event){
						var e = event || window.event;
						var $container = $("#container_"+btc.id);
				        var mousePos = [e.clientX,e.clientY];
				        var containPos = [$container.offset().left,$container.offset().top];
				        var $height = $container.height();
				        var $width = $container.width();
				        if(mousePos[0]<containPos[0]||
				        		mousePos[1]<containPos[1]||
				        		mousePos[0]>containPos[0]+$width||
				        		mousePos[1]>containPos[1]+$height){
				        	$container.remove();
				        	jQuery("#selecthtmltype_autoSelect .sbToggle").toggleClass("sbToggle-btc-reverse");
				        }
					}
			  });  
			   }
			   jQuery("#selecthtmltype_autoSelect .sbToggle").toggleClass("sbToggle-btc-reverse");
			});
    }
    function setBTC(){
            var url = "/systeminfo/BrowserMain.jsp?url=/workflow/field/browsertypesetting.jsp?noneedtree=1";
            var dlg=new window.top.Dialog();//定义Dialog对象
			var title = "<%=SystemEnv.getHtmlLabelName(125117, user.getLanguage())%>";
			dlg.Width=550;//定义长度
			dlg.Height=600;
			dlg.URL=url;
			dlg.Title=title;
			dlg.show();
    }
	function checksubmit(){
		//fieldhtmltypelist = window.document.forms[0].fieldhtmltype;
		fieldhtmltypelist=document.getElementById("fieldhtmltype");
		
		htmltypelist = window.document.forms[0].htmltype;
		if(fieldhtmltypelist.value==1){
			if(htmltypelist.value==1){
				if(form1.strlength.value==""||form1.strlength.value==0){
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
		if(fieldhtmltypelist.value==3){
			if(htmltypelist.value==224||htmltypelist.value==225){
				if(form1.sapbrowser.value==""||form1.sapbrowser.value==0){
					alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
					return false;
				}
			}
			if(htmltypelist.value==165||htmltypelist.value==166||htmltypelist.value==167||htmltypelist.value==168){
				if(form1.decentralizationbroswerType.value==""){
					alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
					return false;
				}
			}
			
			
		}
		var parastr="fieldname";
		if(fieldhtmltypelist.value==5){
			var selectItemType = jQuery("#selectItemType").val();
			
		    if(selectItemType==0){
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
}

function shieldingRightMenu(){
	var fieldhtmltype = '<%=fieldhtmltype%>';
	var actionType = '<%=actionType%>';
	var userId = '<%=user.getUID()%>';

	if(userId!=null && userId=="1"){		
		if(actionType!="" && actionType=="add"){
			hiddenRCMenuItem(2);
			hiddenRCMenuItem(3);
		}
		
		if(actionType!="" && actionType=="edit" && fieldhtmltype!="" && fieldhtmltype=="5"){
			showRCMenuItem(2);
			showRCMenuItem(3);
		}
	}else{		
		if(actionType!="" && actionType=="add"){
			hiddenRCMenuItem(2);
			hiddenRCMenuItem(3);
		}
		if(actionType!="" && actionType=="edit" && fieldhtmltype!="" && fieldhtmltype=="5"){
			showRCMenuItem(2);
			showRCMenuItem(3);
		}
	}
	rightMenu.style.visibility="visible";
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
	top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(20867,user.getLanguage())%>');
}

function submitData()
{
	if (checksubmit()) {
	    try{
		// TD9015 点击任一按钮，把所有"BUTTON"给灰掉
		for (a=0;a<window.frames["rightMenuIframe"].document.all.length;a++){
			if(window.frames["rightMenuIframe"].document.all.item(a).tagName == "BUTTON"){
				window.frames["rightMenuIframe"].document.all.item(a).disabled=true;
			}
		}
		}catch(e){}

		//如果当前字段类型是选择框， 则对各选项中欧元符号进行替换
		if(document.getElementById("fieldhtmltype").value == 5){
			var selectItemType = jQuery("#selectItemType").val();
		    if(selectItemType==0){
		    	for(var i = 0; i < rowindex; i++){
					var obj = document.getElementById("field_" + i + "_name");
					if(obj){
						obj.value = dealSpecial(obj.value);
					}
				}
				if(document.getElementById("oTable")){
					var disorder = 0;
					jQuery("input[name^=listorder_]").each(function(){
						jQuery(this).val(disorder);
						disorder++;
					});
				}
		    }else if(selectItemType==1){
		    	if(!check_form(form1,"pubchoiceId")){
		    		return;
		    	}
		    }else if(selectItemType==2){
		    	if(!check_form(form1,"pubchilchoiceId")){
		    		return;
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
    var flag = false;
	jQuery("input[id^='check_select_']").each(function(){
		if(jQuery(this).attr("checked")==true){
			flag = true;
		}
	});	
	if(flag){
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
			deleteRow1();
		}, function () {}, 320, 90,true);
	} else {
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");
		return false;
	}
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

function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		
		if (rid != "") {
			if (rid.indexOf(",") == 0) {
				rid = rid.substr(1);
				rname = rname.substr(1);
			}
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ rid + "'>"
						+ rname + "</a>";
			} else {
				spanobj.innerHTML = rname;
			}
			inputobj.value = rid;
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}

function onShowChildField(spanname, inputname) {
	var oldvalue = $G(inputname).value;
	var url = "/systeminfo/BrowserMain.jsp?url=" 
		+ escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5 and fromUser<>1 and billid=<%=billId%> and id<><%=fieldid%> &isdetail=0&isbill=1");
	disModalDialog(url, $G(spanname), $G(inputname), false);
	
	if (oldvalue != $G(inputname).value) {
		onChangeChildField();
	}
}

function onShowChildSelectItem(spanname, inputname) {
	var cfid = $G("childfieldid").value;
	var resourceids = $G(inputname).value;
	var url= "/systeminfo/BrowserMain.jsp?url=" + escape("/workflow/field/SelectItemBrowser.jsp?isbill=1&isdetail=0&childfieldid=" + cfid + "&resourceids=" + resourceids);
	
	disModalDialog(url, $G(spanname), $G(inputname), false);
}

function showChildField() {
    var oldvalue = $G("childfieldid").value;
    var url = "/systeminfo/BrowserMain.jsp?url=" 
        + escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5 and fromUser<>1 and billid=<%=billId%> and id<><%=fieldid%> &isdetail=0&isbill=1");
    
    return url;
}

function selectChildField(e,rt,name){

    if (rt != null) {
        var rid = rt.id;
        var rname = rt.name;
        if (rid != "") {
            jQuery("#childfieldid").val(rid);  
            jQuery("#childfieldidSpan").html(rname);  
        } else {
            jQuery("#childfieldid").val("");  
            jQuery("#childfieldidSpan").html("");
        }
    }
}

function showChildSelectItem(choicerowindex){
    
    var cfid = $G("childfieldid").value;
    var resourceids = jQuery("#childItem" + choicerowindex).val();
    var url= "/systeminfo/BrowserMain.jsp?url=" + escape("/workflow/field/SelectItemBrowser.jsp?isbill=1&isdetail=0&childfieldid=" + cfid + "&resourceids=" + resourceids);
    
    return url;
}
function selectChildSelectItem(e,rt,name,choicerowindex){

    if (rt != null) {
        var rid = rt.id;
        var rname = rt.name;
        if (rid != "") {
            var resourceids = rid.substr(1);
            var resourcenames = rname.substr(1);
            jQuery("#childItem" + choicerowindex).val(resourceids);  
            jQuery("#childItemSpan" + choicerowindex).html(resourcenames);  
            jQuery("#childItemSpan" + choicerowindex).attr("title",resourcenames);
        } else {
            jQuery("#childItem" + choicerowindex).val("");  
            jQuery("#childItemSpan" + choicerowindex).html("");
            jQuery("#childItemSpan" + choicerowindex).removeAttr("title");
        }
    }

}
</script>
<script type="text/javascript">
     <%if(userm ==1){%>
        var rightMenuIframe=  document.getElementById("rightMenuIframe");
          $(rightMenuIframe).load(
            function(){
               shieldingRightMenu();
            }
          );
     <% }%>
     
     jQuery(function ()  {
    	 jQuery("#specialhtmltype").selectbox("hide");
     });
</script>
<script language="javascript" src="/js/browsertypechooser/btc_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/js/browsertypechooser/browserTypeChooser_wev8.css">
</body></html>
