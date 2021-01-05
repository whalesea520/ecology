<!DOCTYPE html>
<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.form.FormManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.lang.*" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_si" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="session"/>
<jsp:useBean id="FieldManager" class="weaver.workflow.field.FieldManager" scope="session"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="fieldCommon" class="weaver.workflow.field.FieldCommon" scope="page"/><!--xwj for td3297 20051201-->

<jsp:useBean id="mainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="subCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="secCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SapBrowserComInfo" class="weaver.parseBrowser.SapBrowserComInfo" scope="page" />
<jsp:useBean id="UserDefinedBrowserTypeComInfo" class="weaver.workflow.field.UserDefinedBrowserTypeComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<script type='text/javascript' src="/js/ecology8/request/autoSelect_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
	.LayoutTable input{
		width:178px!important;
	}
	.LayoutTable select{
		width:120px!important;
	}
	#aaaaa{
		cursor: pointer;
	}
    .childItemDiv .e8_outScroll,.childItemDiv .e8_innerShowMust{
        display:none;
    }
</style>
</head>
<%
	String save  = SystemEnv.getHtmlLabelName(30986 , user.getLanguage()) ;
	String menu = SystemEnv.getHtmlLabelName(81804 , user.getLanguage()) ;
	String baseInfo = SystemEnv.getHtmlLabelName(1361 , user.getLanguage()) ;
	int rowsum=0;
	String type="";
	String type2="";
	String fieldname="";
	String fielddbtype="";
	String description="";//xwj for td2977 20051107
	int textheight=4;//xwj for @td2977 20051107
	String fieldhtmltype="";
	int htmltypeid=0;
    int subCompanyId2 = -1;
	String textlength="";
	String textheight_2="";
	int childfieldid = 0;
    String imgwidth="100";
    String imgheight="100";
    String locateTypeDB = "1";
    
	String childfieldname = "";
	String qfws="";
	int fieldid=0;
	fieldid=Util.getIntValue(Util.null2String(request.getParameter("fieldid")),0);
	int isdetail = 0;
	Hashtable selectitem_sh = new Hashtable();
	int decimaldigits = 2;
	String IsOpetype=IntegratedSapUtil.getIsOpenEcology70Sap();
	/* -------------- xwj for td2977 20051107 begin-------------------*/
  	// delete by xwj for td3297 20051201
	/* -------------- xwj for td2977 20051107 end-------------------*/

	//add by xhheng @ 20041213 for TDID 1230
	String isused="";
	isused=Util.null2String(request.getParameter("isused"));

	String message = Util.null2String(request.getParameter("message"));

	type = Util.null2String(request.getParameter("src"));
	type2 = Util.null2String(request.getParameter("srcType"));
	
	if(!type2.equals("mainfield")){
    	imgwidth="50";
        imgheight="50";
    }

    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;
	detachable=0;
    if(detachable==1){
        subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"FieldManage:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("FieldManage:All", user))
            operatelevel=2;
    }

    subCompanyId2 = subCompanyId ;

	if(type=="")
		type = "addfield";
	if(!type.equals("addfield"))
	{
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
		subCompanyId2 =FieldManager.getSubCompanyId2() ;
		description = FieldManager.getDescription();//xwj for td2977 20051107
		textheight = FieldManager.getTextheight();//xwj for @td2977 20051107
		textheight_2 = FieldManager.getTextheight_2();
		childfieldid = FieldManager.getChildfieldid();
        imgwidth = ""+FieldManager.getImgwidth();
        imgheight = ""+FieldManager.getImgheight();
        locateTypeDB= FieldManager.getLocatetype();
        qfws=FieldManager.getQfwws();
		if(fieldhtmltype.equals("1")&&htmltypeid==1){
            if(RecordSet.getDBType().equals("oracle")){
			    textlength=fielddbtype.substring(9,fielddbtype.length()-1);
            }else{
                textlength=fielddbtype.substring(8,fielddbtype.length()-1);
            }
        }else if(fieldhtmltype.equals("1") && htmltypeid==3){//浮点数字段，增加小数位数设置
        	int digitsIndex = fielddbtype.indexOf(",");
        	if(digitsIndex > -1){
        		decimaldigits = Util.getIntValue(fielddbtype.substring(digitsIndex+1, fielddbtype.length()-1), 2);
        	}else{
        		decimaldigits = 2;
        	}
        }else if(fieldhtmltype.equals("1") && htmltypeid==5){//浮点数字段，增加小数位数设置
        	  decimaldigits=Util.getIntValue(""+qfws,2);	
        }
	}
	if(type2.equals("mainfield")){
		isdetail = 0;
	}else{
		isdetail = 1;
	}
	//added by pony on 2006-06-13
	String maincategory = "";
	String subcategory= "";
	String seccategory= "";
	String docPath = "";
	//added end.

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

if(fieldid!=0 && childfieldid!=0){
	if(isdetail == 0){
		rs_si.execute("select fieldname, description from workflow_formdict where id="+childfieldid);
	}else{
		rs_si.execute("select fieldname, description from workflow_formdictdetail where id="+childfieldid);
	}
	if(rs_si.next()){
		childfieldname = Util.null2String(rs_si.getString("fieldname"));
		String description_tmp = Util.null2String(rs_si.getString("description")).trim();
		if(!"".equals(description_tmp)){
			childfieldname = description_tmp;
		}
	}
	
	rs_si.execute("select id, selectvalue, selectname from workflow_SelectItem where isbill=0 and fieldid="+childfieldid);
	while(rs_si.next()){
		int selectvalue_tmp = Util.getIntValue(rs_si.getString("selectvalue"), 0);
		String selectname_tmp = Util.null2String(rs_si.getString("selectname"));
		selectitem_sh.put("si_"+selectvalue_tmp, selectname_tmp);
	}
}

if(type.equals("addfield")){
    if(type2.equals("mainfield")){
        titlename+=SystemEnv.getHtmlLabelName(6074,user.getLanguage());
        titlename+=SystemEnv.getHtmlLabelName(261,user.getLanguage());
    }else{
        titlename+=SystemEnv.getHtmlLabelName(17463,user.getLanguage());
        titlename+=SystemEnv.getHtmlLabelName(261,user.getLanguage());
    }
}else{
    if(type2.equals("mainfield")){
        titlename+=SystemEnv.getHtmlLabelName(6074,user.getLanguage());
        titlename+=SystemEnv.getHtmlLabelName(261,user.getLanguage());
    }else{
        titlename+=SystemEnv.getHtmlLabelName(17463,user.getLanguage());
        titlename+=SystemEnv.getHtmlLabelName(261,user.getLanguage());
    }
}

int count_fields = 0;
if(type2.equals("mainfield")){
    RecordSet.executeSql("select count(*) as fieldcount from workflow_formdict");
    if(RecordSet.next()) count_fields = Util.getIntValue(Util.null2String(RecordSet.getString("fieldcount")),0);
}else{
    RecordSet.executeSql("select count(*) as fieldcount from workflow_formdictdetail");
    if(RecordSet.next()) count_fields = Util.getIntValue(Util.null2String(RecordSet.getString("fieldcount")),0);
}
//out.println("count_fields=="+count_fields);

String texttype="htmltypelist.options[0]=new Option('"+SystemEnv.getHtmlLabelName(608,user.getLanguage())+"',1);"+"\n"+
		"htmltypelist.options[1]=new Option('"+SystemEnv.getHtmlLabelName(696,user.getLanguage())+"',2);"+"\n"+
		"htmltypelist.options[2]=new Option('"+SystemEnv.getHtmlLabelName(697,user.getLanguage())+"',3);"+"\n"+
		"htmltypelist.options[3]=new Option('"+SystemEnv.getHtmlLabelName(18004,user.getLanguage())+"',4);"+"\n"+//xwj for td3131 20051117
		"htmltypelist.options[4]=new Option('"+SystemEnv.getHtmlLabelName(22395,user.getLanguage())+"',5);"+"\n";
		
String locationtype = "htmltypelist.options[0]=new Option('"+SystemEnv.getHtmlLabelName(22981,user.getLanguage())+"',1);"+"\n"; //

//String locatetype = "locatetypelist.options[0]=new Option('"+SystemEnv.getHtmlLabelName(125582,user.getLanguage())+"',1);"+"\n"+
//					"locatetypelist.options[1]=new Option('"+SystemEnv.getHtmlLabelName(81855,user.getLanguage())+"',2);"+"\n"	;  //¶¨Î»ÀàÐÍ£¬°üÀ¨£ºÊÖ¶¯¡¢×Ô¶¯
		
String specialtype="htmltypelist.options[0]=new Option('"+SystemEnv.getHtmlLabelName(21692,user.getLanguage())+"',1);"+"\n"+
		"htmltypelist.options[1]=new Option('"+SystemEnv.getHtmlLabelName(21693,user.getLanguage())+"',2);"+"\n";
String browsertype="";
String browserlabelid="";
//int i=0;
//browsertype+="htmltypelist.options["+i+"]=new Option('','');"+"\n";
browsertype+="jQuery(htmltypelist).append(\"<option></option>\");"+"\n";
//i++;
while(BrowserComInfo.next()){
		if(BrowserComInfo.getBrowserurl().equals("")){ continue;}
 		 if(("224".equals(BrowserComInfo.getBrowserid()))||"225".equals(BrowserComInfo.getBrowserid())){
 				 		continue;//老版本的sap浏览按钮不支持老表单
 		}
 		 
 		if(("256".equals(BrowserComInfo.getBrowserid()))||"257".equals(BrowserComInfo.getBrowserid())){
			continue;//老版本的sap浏览按钮不支持老表单
		}
 		 
 		if (BrowserComInfo.notCanSelect()) continue;
	//browsertype+="htmltypelist.options["+i+"]=new Option('"+
		//SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),user.getLanguage())+
		//"',"+BrowserComInfo.getBrowserid()+");"+"\n";
	//i++;
	browsertype+="jQuery(htmltypelist).append(\"<option match='"+BrowserComInfo.getBrowserPY(user.getLanguage())+"' value='" + BrowserComInfo.getBrowserid() + "'>"+SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),user.getLanguage())+"</option>\");"+"\n";
}
BrowserComInfo.setToFirstrow();
Map th_2_map = FormManager.getRightAttr(user.getLanguage());
String dialog = Util.null2String(request.getParameter("dialog"));
String isclose = Util.null2String(request.getParameter("isclose"));
String openrownum = Util.null2String(request.getParameter("openrownum"));
%>
<body style="overflow:hidden;">
<!-- 
<div id="hideImgIMG" style='position:absolute;top:-100px;z-index:200000'><img onclick='setBTC()'  src='/images/ecology8/workflow/setting_wev8.png'></div>
 -->
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% 
boolean tof = true;
String fieldhtmltypeForSearch = Util.null2String(request.getParameter("fieldhtmltypeForSearch"));
String temptype = Util.null2String(request.getParameter("type"));
String type1 = Util.null2String(request.getParameter("type1"));
String fieldnameForSearch = Util.null2String(request.getParameter("fieldnameForSearch"));
String fielddec = Util.null2String(request.getParameter("fielddec"));
if(operatelevel>0)  tof = false;
if(operatelevel>0){ 		
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(detachable==1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location='/workflow/field/managefield.jsp?subCompanyId="+subCompanyId2+"&srcType="+type2+"&fieldnameForSearch="+fieldnameForSearch+"&fielddec="+fielddec+"&fieldhtmltypeForSearch="+fieldhtmltypeForSearch+"&type="+temptype+"&type1="+type1+"',_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}else{
	if("1".equals(dialog)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btn_cancle(),_top} " ;
	}else{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:history.back(-1),_self}" ;
	}
	RCMenuHeight += RCMenuHeightStep ;
}

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if("1".equals(dialog)){ %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<%}%>
<form name="form1" method="post" action="field_operation.jsp" >
   <input type="hidden" value="<%=type%>" name="src">
   <input type="hidden" value="<%=type2%>" name="srcType">
   <input type="hidden" value="<%=fieldid%>" name="fieldid">
   <!-- modify by xhheng @ 20041222 for TDID 1230-->
   <input type="hidden" value="<%=isused%>" name="isused">
<%
if(!type.equals("addfield")){
	if("2".equals(fieldhtmltype) || "4".equals(fieldhtmltype) || "5".equals(fieldhtmltype) || "7".equals(fieldhtmltype)){
		if(isused.equals("true")){
	%>	 
		<input type="hidden" value="<%=htmltypeid%>" name="htmltype"> 
		<%}%>
	<%}
}%>
<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
    			<input type="button" id="zd_btn_submit" class="e8_btn_top" onclick="submitData()">
    			<!--<input type="button" value="取消" id="zd_btn_cancle"  class="e8_btn_top" onclick="btn_cancle()">  -->						
				<span id="menu"  class="cornerMenu"></span>
			</td>
		</tr>
	</table>  
<wea:layout type="2col">
	<wea:group context='<%=baseInfo %>'>
		<%
		String tmpStr = "";
		if(message.equals("1")){
		    tmpStr = "<font color=red>"+SystemEnv.getHtmlLabelName(15440,user.getLanguage())+"!</font>";
		}else if(message.equals("2")){
		    tmpStr = "<font color=red>"+SystemEnv.getHtmlLabelName(18556, user.getLanguage())+"</font>";
		}
		%>	
	    <% if(message.equals("1") || message.equals("2")) {%>
	    <wea:item attributes="{'colspan':'full'}"><%=tmpStr%></wea:item>
	    <%} %>
	   	<wea:item><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item>
	   	<wea:item>
	   		<%if(operatelevel>0){ %>
			   	<%if(isused.equals("true")){%>
					<input type="hidden" value="<%=Util.toScreenToEdit(fieldname,user.getLanguage())%>" name="fieldname">
					<%=Util.toScreenToEdit(fieldname,user.getLanguage())%>
				<%}else{%>
					<input class=Inputstyle type="text" name="fieldname" size="40" maxlength="30" value="<%=Util.toScreenToEdit(fieldname,user.getLanguage())%>"	onBlur='checkinput_char_num("fieldname");checkinput("fieldname","fieldnamespan");checkSystemField("fieldname","fieldnamespan","<%=type2%>")'>
					<span id=fieldnamespan><%if(fieldname.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
					<% 
						String helpTile = SystemEnv.getHtmlLabelName(15441,user.getLanguage())+","+SystemEnv.getHtmlLabelName(19881,user.getLanguage())+",";
						if(type2.equals("detailfield")){
							helpTile += SystemEnv.getHtmlLabelName(21764,user.getLanguage());
						}else{
							helpTile += SystemEnv.getHtmlLabelName(21763,user.getLanguage());
						}
					%>
					<span class=fontred>
						<a href='#'  title="<%=helpTile %>"><IMG border="0" src="/wechat/images/remind_wev8.png" align=absMiddle ></a>
					</span>
				<%}%>
	   		<%} else {%>
				<%=Util.toScreen(fieldname,user.getLanguage())%>
			<%}%>
	   	</wea:item>
	   	<wea:item><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item>
			<%if(operatelevel>0){%>
			<input class=Inputstyle type="text" name="description" size="40" value="<%=description%>">
			<%} else {%>
			<%=Util.toScreen(description,user.getLanguage())%>
			<%}%>		
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%></wea:item>
		<wea:item>
			<%if(operatelevel>0){ %>
				<%if(isused.equals("true")){%>
					<input type="hidden" value="<%=fieldhtmltype%>" name="fieldhtmltype">
					<select class=inputstyle  size="1" name="fieldhtmltype" onChange="showType()" disabled style="float: left;">
				<%}else{%>
					<select class=inputstyle  size="1" name="fieldhtmltype" onChange="showType()" style="float: left;">
				<%}%>
						<option value="1" <%if(fieldhtmltype.equals("1")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
						<option value="2" <%if(fieldhtmltype.equals("2")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
						<option value="3" <%if(fieldhtmltype.equals("3")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
						<option value="4" <%if(fieldhtmltype.equals("4")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
						<option value="5" <%if(fieldhtmltype.equals("5")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>
						
						<option value="6" <%if(fieldhtmltype.equals("6")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%></option>
						<%if(type2.equals("mainfield")){%>
						<option value="7" <%if(fieldhtmltype.equals("7")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(21691,user.getLanguage())%></option>
						<option value="9" <%if(fieldhtmltype.equals("9")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(125583,user.getLanguage())%></option>
						<%}%>
						
						
					</select>
				<%
				if(fieldhtmltype.equals("")){ 
				%>
					<span style="display:block;float:left;width:400px;" _noWidth=true >
					<button type=button class=addbtn id=btnaddRow style="display:none;margin-left:5px;float: left;" name=btnaddRow onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></button>
					<button type=button class=delbtn id=btnsubmitClear style="display:none;margin-left:5px;float: left;" name=btnsubmitClear onclick="submitClear()" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></button>
					 &nbsp;&nbsp;<span id=typespan><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>&nbsp;
					<select class=inputstyle  size=1 style="width: 120px;" name=htmltype id=selecthtmltype onChange="typeChange()">
						<option value="1"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
						<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
						<option value="4"><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option><!--xwj for td3131 20051115-->
						<option value="5"><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>
					</select>
					<select class=inputstyle  size=1 style="width: 120px;" name="filehtmltype" id="filehtmltype" onChange="typeChange()">
						<option value="1"><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></option>
					</select>
					<select class=inputstyle  size=1 style="width: 120px;" name="specialhtmltype" id="specialhtmltype" onChange="typeChange()">
						<option value="1"><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></option>
					</select>
					<select class=inputstyle  size=1 style="width: 120px;" name="browsetbuttonype" id="browsetbuttonype" onChange="typeChange()">
						<%=browsertype%>
					</select>
					
					<span id="selecthtmltypespan" style="display: none;">
						<img align="absMiddle" src="/images/BacoError_wev8.gif">
					</span>
					<span onclick='setBTC()' style="display:none;" id='aaaaa'><img style="vertical-align: middle;" src='/images/ecology8/workflow/setting_wev8.png'></span>
					<input type="text" value="<%=textheight%>" name="textheight" maxlength=2 size=4 onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)" class=Inputstyle style=display:none><!--xwj for @td2977 20051110 -->
				
					<span id=lengthspan><%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%></span>
					<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
					<input class=Inputstyle type=input  size=10 maxlength=3 style="width:50px!important;" name="strlength" onBlur="checkPlusnumber1(this);checklength('strlength','strlengthspan')" onKeyPress="ItemPlusCount_KeyPress()" value="<%=textlength%>">
					<!-- zzl--start -->
					<button type="button" style="display:none" class="Browser browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
					<span id="showinner"></span>
					<span id="showimg" style="display:none"><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
					<input type="hidden" name="showvalue" id="showvalue">
					<!-- zzl--end -->
					<!-- sap browser -->
					<select style="display:none" class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()" >
						<option value=""></option>
						<%
						List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
						for(int j=0;j<AllBrowserId.size();j++){
						%>
						<option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
						<%}%>
					</select>
					<span id=strlengthspan><%if(textlength.equals("")||textlength.equals("0")){%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
					<span id="decimaldigitsspan" style="display:none">
					<span><%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%></span>
					<select id="decimaldigits" name="decimaldigits">
						<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
						<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
						<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
						<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
					</select>
					</span>
					<%--  
					<span id="locatetypespan" style="display:none">
						<span><%=SystemEnv.getHtmlLabelName(125581,user.getLanguage())%></span>
						<select id="locatetype" name="locatetype">
							<option value="1" <%if(locateTypeDB=="1"){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(125582,user.getLanguage()) %></option>
							<option value="2" <%if(locateTypeDB=="2"){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(81855,user.getLanguage())%></option>
						</select>
					</span>
					--%>
					 <span id=showprepspan_show style="display:none;float:none;"><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage())%><div style="float:right;margin-right: 100px;">
						 <brow:browser width="105px" viewType="0" name="showprep"
							browserValue="1"
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/form/rightAttributeDepat.jsp?selectValue=#id#"
						    completeUrl="/data.jsp"
							hasInput="true" isSingle="true"
							isMustInput="2"
							browserDialogWidth="400px"
							browserDialogHeight="290px"
							_callback="typeChange"
							browserSpanValue="本部门"></brow:browser>
						 </div>
		            </span>  
		
				  	
				  	<span id=subcombroswerTypespan style="display:none" ><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage())%></span>
				  	<button style="display:none" type=button  class='browser' name='subcombroswerType_btn' id='subcombroswerType_btn' onclick='MainRightAttrBrowserSubcom()'></button>
					<span style="display:none" id='subcombroswerType_span'></span>
					<input type='hidden'  name='subcombroswerType' id='subcombroswerType' value=''>
					<span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
					<input   type=input class="InputStyle" size=10 maxlength=4 name="imgwidth" onBlur="checkPlusnumber1(this);checklength('imgwidth','imgwidthspan')"
					onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgwidth%>" style="display:none">
					<span id=imgwidthspan style="display:none"></span>
					<span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
					<input   type=input class="InputStyle" size=10 maxlength=4 name="imgheight" onBlur="checkPlusnumber1(this);checklength('imgheight','imgheightspan')"
					onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgheight%>" style="display:none">
					<span id=imgheightspan style="display:none"></span>
					
					<span id="childfieldNotesSpan" style="display:none;height:30px;line-height:30px;float:left;text-align:center;"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
					
					<span id="showChildFieldBotton" style="display:none;float:felt;">
				    <!--  qyw 2014-05-12 update 
						<button type='button' id="showChildFieldBotton" class=Browser onClick="onShowChildField('childfieldidSpan', 'childfieldid')"></button>
					-->	
					<brow:browser name="childfieldid" viewType="0" hasBrowser="true" hasAdd="false" 
		                 getBrowserUrlFn="onShowChildField_new" isMustInput="1" isSingle="true" hasInput="true"
		                completeUrl="/data.jsp?type=fieldBrowser&isbill=0"  width="150px" browserValue="" browserSpanValue=""  />
		                </span>
						<span id="childfieldidSpan"></span>
						<input type="hidden" value="" name="childfieldid" id="childfieldid">
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
					
				<%}
				if(fieldhtmltype.equals("1")){ %>
					<span style="display:block;float:left;width:400px;" _noWidth=true>
					<button type=button class=addbtn id=btnaddRow style="display:none;margin-left:5px;float: left;" name=btnaddRow onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></BUTTON>
					<button type=button class=delbtn id=btnsubmitClear style="display:none;margin-left:5px;float: left;" name=btnsubmitClear onclick="submitClear()" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></BUTTON>
					&nbsp;<span id=typespan><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>
					<input type="text" name="textheight" maxlength=2 size=4 onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)" class=Inputstyle style=display:none><!--xwj for @td2977 20051110 -->
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
						<option value="4" <%if(htmltypeid==4){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option><!--xwj for td3131 20051115-->
						<option value="5" <%if(htmltypeid==5){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>
					</select>
					<select class=inputstyle  size=1 style="width: 120px;" name="filehtmltype" id="filehtmltype" onChange="typeChange()">
						<option value="1"><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></option>
					</select>
					<select class=inputstyle  size=1 style="width: 120px;" name="specialhtmltype" id="specialhtmltype" onChange="typeChange()">
						<option value="1"><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></option>
					</select>
					<select class=inputstyle  size=1 style="width: 120px;" name="browsetbuttonype" id="browsetbuttonype" onChange="typeChange()">
						<%=browsertype%>
					</select>
					<span id="selecthtmltypespan" style="display:none;">
						<img align="absMiddle" src="/images/BacoError_wev8.gif">
					</span>
					
					<span onclick='setBTC()' style="display:none;" id='aaaaa'><img style="vertical-align: middle;" src='/images/ecology8/workflow/setting_wev8.png'></span>
					<%if(htmltypeid==1){ %>
						<span id=lengthspan><%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%></span>
						<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
						<input class=Inputstyle type=input size=10 maxlength=3 style="width:50px!important;" name="strlength" onBlur="checkPlusnumber1(this);checklength('strlength','strlengthspan')"
							onKeyPress="ItemPlusCount_KeyPress()" value="<%=textlength%>">
						<span id=strlengthspan><%if(textlength.equals("")||textlength.equals("0")){%>
						<IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
						<!-- zzl--start -->
						<!-- 其他按钮修改成本按钮时显示的img -->
						<button type="button" style="display:none" class="Browser browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
						<span id="showinner"></span>
						<span id="showimg"></span>
						<input type="hidden" name="showvalue" id="showvalue">
						<!-- zzl--end -->
						
						<!-- sap browser -->
						<select style="display:none" class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()" >
							<option value=""></option>
							<%
							List AllBrowserId=SapBrowserComInfo.getAllBrowserId();  
							for(int j=0;j<AllBrowserId.size();j++){
							%>
							<option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
							<%}%>
						</select>
						<span id="decimaldigitsspan" style="display:none">
						<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
						<%if(isused.equals("true")){%>
						<input type="hidden" id="decimaldigits" name="decimaldigits" value="<%=decimaldigits%>">
						<select id="decimaldigitshidden" name="decimaldigitshidden" size="1" disabled>
						<%}else{%>
						<select id="decimaldigits" name="decimaldigits" size="1">
						<%}%>
							<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
							<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
							<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
							<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
						</select>
						</span>
						<%--  
						<span id="locatetypespan" style="display:none">
							<span><%=SystemEnv.getHtmlLabelName(125581,user.getLanguage())%></span>
							<select id="locatetype" name="locatetype">
								<option value="1" <%if(locateTypeDB=="1"){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(125582,user.getLanguage()) %></option>
								<option value="2" <%if(locateTypeDB=="2"){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(81855,user.getLanguage())%></option>
							</select>
						</span>
						--%>
						</span>

						
						<span id="cusbspan" style="display:none;">
							<brow:browser width="150px" viewType="0" name="cusb"
							    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
							    completeUrl="/data.jsp"
								hasInput="false" isSingle="true"
								isMustInput="2" browserDialogWidth="550px"
								browserDialogHeight="650px"
								_callback="typeChange"></brow:browser>
						</span>
					<%}else if(htmltypeid==3||htmltypeid==5){ %>
						<span id="lengthspan"></span>
						<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
						<input type=input  class=Inputstyle style=display:none size=10  style="width:50px!important;" maxlength=3 name="strlength" onBlur="checkPlusnumber1(this);checklength('strlength','strlengthspan')" onKeyPress="ItemPlusCount_KeyPress()" value="<%=textlength%>">			
						<!-- zzl--start -->
						<button type="button" style="display:none" class="Browser browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
						<span id="showinner"></span>
						<span id="showimg" style="display:none"><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
						<input type="hidden" name="showvalue" id="showvalue">
						<!-- zzl--end -->
						
						<!-- sap browser -->
						<select style="display:none" class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()" >
							<option value=""></option>
							<%
							List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
							for(int j=0;j<AllBrowserId.size();j++){ %>
							<option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
							<%}%>
						</select>
						<span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
						<IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
						 	     
						<span id="decimaldigitsspan" style="display:">
						<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
						<%if(isused.equals("true")){%>
						<input type="hidden" id="decimaldigits" name="decimaldigits" value="<%=decimaldigits%>">
						<select id="decimaldigitshidden" name="decimaldigitshidden" size="1" disabled>
						<%}else{%>
						<select id="decimaldigits" name="decimaldigits" size="1">
						<%}%>
							<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
							<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
							<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
							<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
						</select>
						</span>		
						</span>				
						
						<span id="cusbspan" style="display:none;">
							<brow:browser width="150px" viewType="0" name="cusb"
							    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
							    completeUrl="/data.jsp"
								hasInput="false" isSingle="true"
								isMustInput="2" browserDialogWidth="550px"
								browserDialogHeight="650px"
								_callback="typeChange"></brow:browser>
						</span>
					<%} else { %>
						<span id=lengthspan></span>
						<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
						<input type=input  class=Inputstyle style=display:none size=10 maxlength=3 style="width:50px!important;" name="strlength" onBlur="checkPlusnumber1(this);checklength('strlength','strlengthspan')" onKeyPress="ItemPlusCount_KeyPress()" value="<%=textlength%>">
						
						<!-- zzl--start -->
						<button type="button" style="display:none" class="Browser browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
						<span id="showinner"></span>
						<span id="showimg" style="display:none"><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
						<input type="hidden" name="showvalue" id="showvalue">
						<!-- zzl--end -->
						
						<!-- sap browser -->
						<select style="display:none" class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()" >
							<option value=""></option>
							<%
							List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
							for(int j=0;j<AllBrowserId.size();j++){%>
							<option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
							<%}%>
						</select>
						<span id=strlengthspan style=display:none>
						<%if(textlength.equals("")||textlength.equals("0")){%>
						<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
						<%}%>
						</span>
						</span>
						<span id="decimaldigitsspan" style="display:none">
						<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
						<select id="decimaldigits" name="decimaldigits">
							<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
							<option value="2" <%if(decimaldigits==1){out.print("selected");}%>>2</option>
							<option value="3" <%if(decimaldigits==1){out.print("selected");}%>>3</option>
							<option value="4" <%if(decimaldigits==1){out.print("selected");}%>>4</option>
						</select>
						</span>
						<span id="cusbspan" style="display:none;">
							<brow:browser width="150px" viewType="0" name="cusb"
							    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
							    completeUrl="/data.jsp"
								hasInput="false" isSingle="true"
								isMustInput="2" browserDialogWidth="550px"
								browserDialogHeight="650px"
								_callback="typeChange"></brow:browser>
						</span>
					<%}%>
					<span id=showprepspan_show style="display:none;float:none;"><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage())%><div style="float:right;margin-right: 250px;">
						 <brow:browser width="105px" viewType="0" name="showprep"
							browserValue="1"
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/form/rightAttributeDepat.jsp?selectValue=#id#"
						    completeUrl="/data.jsp"
							hasInput="true" isSingle="true"
							isMustInput="2"
							browserDialogWidth="400px"
							browserDialogHeight="290px"
							_callback="typeChange"
							browserSpanValue="本部门"></brow:browser>
						 </div>
		            </span> 
					<span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=10 maxlength=4 name="imgwidth" onBlur="checkPlusnumber1(this);checklength('imgwidth','imgwidthspan')"
					onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgwidth%>" style="display:none">
					<span id=imgwidthspan style="display:none"></span>
					<span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=10 maxlength=4 name="imgheight" onBlur="checkPlusnumber1(this);checklength('imgheight','imgheightspan')"
						onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgheight%>" style="display:none">
					<span id=imgheightspan style="display:none"></span>
					<span id="childfieldNotesSpan" style="display:none;height:30px;line-height:30px;float:left;text-align:center;"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
					<span id="showChildFieldBotton" style="display:none;float: left;">
					<%--<brow:browser name="childfieldid" viewType="0" hasBrowser="true" hasAdd="false"  browserOnClick="onShowChildField('childfieldidspan', 'childfieldid')"
					 		isMustInput="1" isSingle="true" hasInput="true" completeUrl=""  width="150px" browserValue="" browserSpanValue=""/>	
					</span>	--%>
					
                    <brow:browser name="childfieldid" viewType="0" hasBrowser="true" hasAdd="false" 
                         getBrowserUrlFn="onShowChildField_new" isMustInput="1" isSingle="true" hasInput="true"
                        completeUrl="/data.jsp?type=fieldBrowser&isbill=0"  width="150px" browserValue="" browserSpanValue=""  /></span>
                    </span> 
					
					 <!-- zzl--start -->
					<button type="button" <%if(htmltypeid!=226&&htmltypeid!=227){%>style="display:none"<%}%> class="Browser browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
					<span id="showinner"></span>
					<span id="showimg" style="display:none"><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
					<input type="hidden" name="showvalue" id="showvalue">
					<!-- zzl--end -->
					
					<!-- sap browser -->
					<select <%if(htmltypeid!=224&&htmltypeid!=225){%>style="display:none"<%}%> class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()"  <%if(isused.equals("true")){%>disabled<%}%>>
						<option value=''></option>
						<%
						List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
						for(int j=0;j<AllBrowserId.size();j++){
						%>
						<option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
						<%}%>
					</select>
					
					<span id="cusbspan" style="display:none;">
						<brow:browser width="150px" viewType="0" name="cusb"
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
						    completeUrl="/data.jsp"
							hasInput="false" isSingle="true"
							isMustInput="2" browserDialogWidth="550px"
							browserDialogHeight="650px"
							_callback="typeChange"></brow:browser>
					</span>
			 	<%}
				
				if(fieldhtmltype.equals("9")){ %>
				<span style="display:block;float:left;width:400px;" _noWidth=true>
				<button type=button class=addbtn id=btnaddRow style="display:none;margin-left:5px;float: left;" name=btnaddRow onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></BUTTON>
				<button type=button class=delbtn id=btnsubmitClear style="display:none;margin-left:5px;float: left;" name=btnsubmitClear onclick="submitClear()" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></BUTTON>
				&nbsp;<span id=typespan><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>
				<input type="text" name="textheight" maxlength=2 size=4 onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)" class=Inputstyle style=display:none><!--xwj for @td2977 20051110 -->
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
				<span id="locatetypespan" style="display:'';">
					<span><%=SystemEnv.getHtmlLabelName(125581,user.getLanguage())%></span> <!-- 定位方式 -->
					<select id="locatetype" name="locatetype">
						<option value="1" <%if(locateTypeDB.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(125582,user.getLanguage()) %></option> <!-- 手动 -->
						<option value="2" <%if(locateTypeDB.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(81855,user.getLanguage())%></option>
					</select>
				</span>	
				--%>
				
				<select class=inputstyle  size=1 style="width: 120px;" name="filehtmltype" id="filehtmltype" onChange="typeChange()">
					<option value="1"><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></option>
					<option value="2"><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></option>
				</select>
				<select class=inputstyle  size=1 style="width: 120px;" name="specialhtmltype" id="specialhtmltype" onChange="typeChange()">
					<option value="1"><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
					<option value="2"><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></option>
				</select>
				<select class=inputstyle  size=1 style="width: 120px;" name="browsetbuttonype" id="browsetbuttonype" onChange="typeChange()">
					<%=browsertype%>
				</select>
				<span id="selecthtmltypespan" style="display:none;">
					<img align="absMiddle" src="/images/BacoError_wev8.gif">
				</span>
				
				<span onclick='setBTC()' style="display:none;" id='aaaaa'><img style="vertical-align: middle;" src='/images/ecology8/workflow/setting_wev8.png'></span>
				<%if(htmltypeid==1){ %>
					<span id=lengthspan style="display:none"><%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%></span>
					<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()"/>
					<input class=Inputstyle type=input size=10 maxlength=3 style="width:50px!important;display:none" name="strlength" onBlur="checkPlusnumber1(this);checklength('strlength','strlengthspan')"
						onKeyPress="ItemPlusCount_KeyPress()"  />
					<span id=strlengthspan style="display:none"><%if(textlength.equals("")||textlength.equals("0")){%>
						<IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
					<!-- zzl--start -->
					<!-- 其他按钮修改成本按钮时显示的img -->
					<button type="button" style="display:none" class="Browser browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
					<span id="showinner"></span>
					<span id="showimg"></span>
					<input type="hidden" name="showvalue" id="showvalue" />
					<!-- zzl--end -->
					
					<!-- sap browser -->
					<select style="display:none" class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()" >
						<option value=""></option>
						<%
						List AllBrowserId=SapBrowserComInfo.getAllBrowserId();  
						for(int j=0;j<AllBrowserId.size();j++){
						%>
						<option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
						<%}%>
					</select>
					<span id="decimaldigitsspan" style="display:none">
						<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
						<%if(isused.equals("true")){%>
						<input type="hidden" id="decimaldigits" name="decimaldigits" value="<%=decimaldigits%>">
						<select id="decimaldigitshidden" name="decimaldigitshidden" size="1" disabled>
						<%}else{%>
						<select id="decimaldigits" name="decimaldigits" size="1">
						<%}%>
							<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
							<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
							<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
							<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
						</select>
					</span>
					<%--  
					<span id="locatetypespan" style="display:none">
						<span><%=SystemEnv.getHtmlLabelName(125581,user.getLanguage())%></span>
						<select id="locatetype" name="locatetype">
							<option value="1" <%if(locateTypeDB=="1"){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(125582,user.getLanguage()) %>11111</option>
							<option value="2" <%if(locateTypeDB=="2"){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(81855,user.getLanguage())%>11111</option>
						</select>
					</span>	
					--%>
					</span>
				
					<span id="cusbspan" style="display:none;">
						<brow:browser width="150px" viewType="0" name="cusb"
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
						    completeUrl="/data.jsp"
							hasInput="false" isSingle="true"
							isMustInput="2" browserDialogWidth="550px"
							browserDialogHeight="650px"
							_callback="typeChange"></brow:browser>
					</span>
				<%}%>
				<span id=showprepspan_show style="display:none;float:none;"><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage())%><div style="float:right;margin-right: 250px;">
					 <brow:browser width="105px" viewType="0" name="showprep"
						browserValue="1"
					    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/form/rightAttributeDepat.jsp?selectValue=#id#"
					    completeUrl="/data.jsp"
						hasInput="true" isSingle="true"
						isMustInput="2"
						browserDialogWidth="400px"
						browserDialogHeight="290px"
						_callback="typeChange"
						browserSpanValue="本部门"></brow:browser>
					 </div>
	            </span> 
				<span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
				<input type=input class="InputStyle" size=10 maxlength=4 name="imgwidth" onBlur="checkPlusnumber1(this);checklength('imgwidth','imgwidthspan')"
				onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgwidth%>" style="display:none">
				<span id=imgwidthspan style="display:none"></span>
				<span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
				<input type=input class="InputStyle" size=10 maxlength=4 name="imgheight" onBlur="checkPlusnumber1(this);checklength('imgheight','imgheightspan')"
					onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgheight%>" style="display:none">
				<span id=imgheightspan style="display:none"></span>
				<span id="childfieldNotesSpan" style="display:none;height:30px;line-height:30px;float:left;text-align:center;"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
				<span id="showChildFieldBotton" style="display:none;float: left;">
				<%--<brow:browser name="childfieldid" viewType="0" hasBrowser="true" hasAdd="false"  browserOnClick="onShowChildField('childfieldidspan', 'childfieldid')"
				 		isMustInput="1" isSingle="true" hasInput="true" completeUrl=""  width="150px" browserValue="" browserSpanValue=""/>	
				</span>	--%>
				
                    <brow:browser name="childfieldid" viewType="0" hasBrowser="true" hasAdd="false" 
                         getBrowserUrlFn="onShowChildField_new" isMustInput="1" isSingle="true" hasInput="true"
                        completeUrl="/data.jsp?type=fieldBrowser&isbill=0"  width="150px" browserValue="" browserSpanValue=""  /></span>
                    </span> 
				
				 <!-- zzl--start -->
				<button type="button" <%if(htmltypeid!=226&&htmltypeid!=227){%>style="display:none"<%}%> class="Browser browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
				<span id="showinner"></span>
				<span id="showimg" style="display:none"><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
				<input type="hidden" name="showvalue" id="showvalue">
				<!-- zzl--end -->
				
				<!-- sap browser -->
				<select <%if(htmltypeid!=224&&htmltypeid!=225){%>style="display:none"<%}%> class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()"  <%if(isused.equals("true")){%>disabled<%}%>>
					<option value=''></option>
					<%
					List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
					for(int j=0;j<AllBrowserId.size();j++){
					%>
					<option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
					<%}%>
				</select>
				
				<span id="cusbspan" style="display:none;">
					<brow:browser width="150px" viewType="0" name="cusb"
					    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
					    completeUrl="/data.jsp"
						hasInput="false" isSingle="true"
						isMustInput="2" browserDialogWidth="550px"
						browserDialogHeight="650px"
						_callback="typeChange"></brow:browser>
				</span>
		 		<%}
				
				if(fieldhtmltype.equals("3")){ %>
					<span style="display:block;float:left;width:400px;">
					<button type=button class=addbtn id=btnaddRow style="display:none;margin-left:5px;float: left;" name=btnaddRow onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></BUTTON>
					<button type=button class=delbtn id=btnsubmitClear style="display:none;margin-left:5px;float: left;" name=btnsubmitClear onclick="submitClear()" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></BUTTON>
					&nbsp;&nbsp;<span id=typespan><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>
					<input type="text"  name="textheight" maxlength=2 size=4 onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)" class=Inputstyle style=display:none><!--xwj for @td2977 20051110 -->
					<!-- modify by xhheng @ 20041222 for TDID 1230 start-->
					<!-- 因为浏览按钮随类型不同而采用不同的数据类型，故已使用后，其类型也禁止转换-->
					<%String browserid="";%>
					<%if(isused.equals("true")){%>
					<select class="inputstyle"  size=1 name="browsetbuttonype"  id="browsetbuttonype" onChange="typeChange()" disabled>
					<%}else{%>
					<select class="inputstyle autoSelect"  size=1 name="browsetbuttonype" notbeauty=true id="browsetbuttonype" onChange="typeChange()">
					<%}%>
					<%while(BrowserComInfo.next()){
						if(("224".equals(BrowserComInfo.getBrowserid()))||"225".equals(BrowserComInfo.getBrowserid())){
								continue;//老版本的sap浏览按钮不支持老表单
						}
						if (BrowserComInfo.notCanSelect()) continue;
						%>
						<option match="<%=BrowserComInfo.getBrowserPY(user.getLanguage())%>" value="<%=BrowserComInfo.getBrowserid()%>" <%if(BrowserComInfo.getBrowserid().equals(htmltypeid+"")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
						<%if(BrowserComInfo.getBrowserid().equals(htmltypeid+"") && isused.equals("true")) {
						  browserid=BrowserComInfo.getBrowserid();
						}%>
					<%}%>
					<%if(isused.equals("true")){%>
					<input type="hidden" value="<%=browserid%>" name="browsetbuttonype">
					<%}%>
					</select>
					
					<select class=inputstyle  size=1 style="width: 120px;" name="filehtmltype" id="filehtmltype" onChange="typeChange()">
						<option value="1"><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></option>
					</select>
					<select class=inputstyle  size=1 style="width: 120px;" name="specialhtmltype" id="specialhtmltype" onChange="typeChange()">
						<option value="1"><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></option>
					</select>
					
					<select class=inputstyle  size=1 style="width: 120px;" name="htmltype" id="selecthtmltype" onChange="typeChange()">
						<option value="1"><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
					</select>
					<span id="selecthtmltypespan" style="display:none;">
						<img align="absMiddle" src="/images/BacoError_wev8.gif">
					</span>					
					<span id=lengthspan></span>
					<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
					<input  class=Inputstyle type=input style=display:none size=10 maxlength=3 name="strlength" style="width:50px!important;" onBlur="checkPlusnumber1(this);checklength('strlength','strlengthspan')" onKeyPress="ItemPlusCount_KeyPress()" value="<%=textlength%>">					
					<!-- zzl--start -->
					<!-- 可编辑下的情况 -->
					<button type="button" <%if(htmltypeid!=226&&htmltypeid!=227){%>style="display:none"<%}%> class="Browser browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
					<span id="showinner" ><%if(htmltypeid==226||htmltypeid==227){out.print(fielddbtype);	}%></span>
					<span id="showimg" style="display:none">
					<%
					if(htmltypeid!=226&&htmltypeid!=227){
						out.println("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");	
					}
					%>
					</span>
					
					<span onclick='setBTC()' style="display:none;" id='aaaaa'><img style="vertical-align: middle;" src='/images/ecology8/workflow/setting_wev8.png'></span>
					<input type="hidden"  <%if(htmltypeid!=226&&htmltypeid!=227){%>style="display:none"<%}%> name="showvalue" id="showvalue"   value="<%if(htmltypeid==226||htmltypeid==227){out.print(fielddbtype);}%>">
					<!-- zzl--end -->   
					<!-- sap browser -->
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
					<span id="decimaldigitsspan" style="display:none">
					<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
					<select id="decimaldigits" name="decimaldigits">
						<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
						<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
						<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
						<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
					</select>
					</span>
            		<%						  		
			  		String th_2[] = textheight_2.split(",");
			  		String th_2_span = "";
			  		for(int k=0;k<th_2.length;k++){
			  			if(th_2[k].equals("0") || th_2[k].equals(""))continue;
			  			th_2_span += ","+th_2_map.get(th_2[k]);
			  		}
			  		if(!th_2_span.equals("")) th_2_span = th_2_span.substring(1);
			  		
			  		 %>
		            
		             <span id=showprepspan_show <%if(htmltypeid!=165&&htmltypeid!=166&&htmltypeid!=167&&htmltypeid!=168){%>style="display:none;float:none;"<%}%>  ><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage())%><div style="float:right;margin-right: 100px;">     
						 <brow:browser width="105px" viewType="0" name="showprep"
							browserValue='<%=textheight_2%>'
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/form/rightAttributeDepat.jsp?selectValue=#id#"
						    completeUrl="/data.jsp"
							hasInput="true" isSingle="true"
							isMustInput="2"
							browserDialogWidth="400px"
							browserDialogHeight="290px"
							_callback="typeChange"
							browserSpanValue='<%=th_2_span%>'></brow:browser>
						  </div>
		            </span>   
		            
					
					<%if(isused.equals("true")){%>
					<input type="hidden" value="<%=fielddbtype%>" name="cusb">
					<input type="hidden" value="<%=fielddbtype%>" name="sapbrowser">
					<input type="hidden" value="<%=fielddbtype%>" name="newsapbrowser">
					<%}%>
					<span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=10 maxlength=4 name="imgwidth" onBlur="checkPlusnumber1(this);checklength('imgwidth','imgwidthspan')"
					onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgwidth%>" style="display:none">
					<span id=imgwidthspan style="display:none"></span>
					<span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=10 maxlength=4 name="imgheight" onBlur="checkPlusnumber1(this);checklength('imgheight','imgheightspan')" onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgheight%>" style="display:none">
					<span id=imgheightspan style="display:none"></span>
					<span id="childfieldNotesSpan" style="display:none;height:30px;line-height:30px;float:left;text-align:center;"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
					<span id="showChildFieldBotton" style="display:none;float: left;">
					<%--<brow:browser name="childfieldid" viewType="0" hasBrowser="true" hasAdd="false"  browserOnClick="onShowChildField('childfieldidspan', 'childfieldid')"
					         isMustInput="1" isSingle="true" hasInput="true" completeUrl=""  width="150px" browserValue="" browserSpanValue=""/>
					--%>	
					
                    <brow:browser name="childfieldid" viewType="0" hasBrowser="true" hasAdd="false" 
                         getBrowserUrlFn="onShowChildField_new" isMustInput="1" isSingle="true" hasInput="true"
                        completeUrl="/data.jsp?type=fieldBrowser&isbill=0"  width="150px" browserValue="" browserSpanValue=""  />
                    
					</span>	
					</span>	
					<span id="cusbspan" <%if(htmltypeid!=161&&htmltypeid!=162){%>style="display:none"<%}%>>
						<brow:browser width="150px" viewType="0" name="cusb"  browserValue='<%= htmltypeid==161||htmltypeid==162?fielddbtype:"" %>'
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
						    completeUrl="/data.jsp"
							hasInput="false" isSingle="true"
							isMustInput="2" browserDialogWidth="550px"
							browserDialogHeight="650px"
							_callback="typeChange"
							browserSpanValue='<%=htmltypeid==161||htmltypeid==162?UserDefinedBrowserTypeComInfo.getName(fielddbtype):""%>'></brow:browser>
					</span>
				<%}
				if(fieldhtmltype.equals("4")){ //xwj for @td2977 begin%>
				<span style="display:block;float:left;width:400px;">
					<button type=button class=addbtn id=btnaddRow style="display:none;margin-left:5px;float: left;" name=btnaddRow onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></button>
					<button type=button class=delbtn id=btnsubmitClear style="display:none;margin-left:5px;float: left;" name=btnsubmitClear onclick="submitClear()" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></button>
					 &nbsp;&nbsp;<span id=typespan></span>&nbsp;
					<select class=inputstyle  size=1 style="width: 120px;display:none;" name=htmltype id=selecthtmltype onChange="typeChange()">
						<option value="1"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
						<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
						<option value="4"><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option><!--xwj for td3131 20051115-->
						<option value="5"><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>
					</select>
					<select class=inputstyle  size=1 style="width: 120px;" name="filehtmltype" id="filehtmltype" onChange="typeChange()">
						<option value="1"><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></option>
					</select>
					<select class=inputstyle  size=1 style="width: 120px;" name="specialhtmltype" id="specialhtmltype" onChange="typeChange()">
						<option value="1"><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></option>
					</select>
					<select class=inputstyle  size=1 style="width: 120px;" name="browsetbuttonype" id="browsetbuttonype" onChange="typeChange()">
						<%=browsertype%>
					</select>
					<span id="selecthtmltypespan" style="display: none;">
						<img align="absMiddle" src="/images/BacoError_wev8.gif">
					</span>
					<span onclick='setBTC()' style="display:none;" id='aaaaa'><img style="vertical-align: middle;" src='/images/ecology8/workflow/setting_wev8.png'></span>
					<input type="text" value="<%=textheight%>" name="textheight" maxlength=2 size=4 onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)" class=Inputstyle style=display:none><!--xwj for @td2977 20051110 -->
				
					<span id=lengthspan></span>
					<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
					<input class=Inputstyle type=input  style="display: none;" size=10 maxlength=3 name="strlength" style="width:50px!important;" onBlur="checkPlusnumber1(this);checklength('strlength','strlengthspan')" onKeyPress="ItemPlusCount_KeyPress()" value="<%=textlength%>">
					<!-- zzl--start -->
					<button type="button" style="display:none" class="Browser browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
					<span id="showinner"></span>
					<span id="showimg" style="display:none"><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
					<input type="hidden" name="showvalue" id="showvalue">
					<!-- zzl--end -->
					<!-- sap browser -->
					<select style="display:none" class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()" >
						<option value=""></option>
						<%
						List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
						for(int j=0;j<AllBrowserId.size();j++){
						%>
						<option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
						<%}%>
					</select>
					<span id=strlengthspan style="display: none;"><%if(textlength.equals("")||textlength.equals("0")){%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
					<span id="decimaldigitsspan" style="display:none">
					<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
					<select id="decimaldigits" name="decimaldigits">
						<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
						<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
						<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
						<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
					</select>
					</span>
					 
					 <span id=showprepspan_show style="display:none;float:none;"><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage()) %><div style="float:right;margin-right: 100px;">
						 <brow:browser width="105px" viewType="0" name="showprep"
							browserValue="1"
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/form/rightAttributeDepat.jsp?selectValue=#id#"
						    completeUrl="/data.jsp"
							hasInput="true" isSingle="true"
							isMustInput="2"
							browserDialogWidth="400px"
							browserDialogHeight="290px"
							_callback="typeChange"
							browserSpanValue="本部门"></brow:browser>
						 </div>
		            </span>  
		
				  	
					<span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
					<input   type=input class="InputStyle" size=10 maxlength=4 name="imgwidth" onBlur="checkPlusnumber1(this);checklength('imgwidth','imgwidthspan')"
					onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgwidth%>" style="display:none">
					<span id=imgwidthspan style="display:none"></span>
					<span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
					<input   type=input class="InputStyle" size=10 maxlength=4 name="imgheight" onBlur="checkPlusnumber1(this);checklength('imgheight','imgheightspan')"
					onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgheight%>" style="display:none">
					<span id=imgheightspan style="display:none"></span>
					
					<span id="childfieldNotesSpan" style="display:none;height:30px;line-height:30px;float:left;text-align:center;"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
					
					<span id="showChildFieldBotton" style="display:none;float:felt;">
				    <!--  qyw 2014-05-12 update 
						<button type='button' id="showChildFieldBotton" class=Browser onClick="onShowChildField('childfieldidSpan', 'childfieldid')"></button>
					-->	
					<brow:browser name="childfieldid" viewType="0" hasBrowser="true" hasAdd="false" 
		                 getBrowserUrlFn="onShowChildField_new" isMustInput="1" isSingle="true" hasInput="true"
		                completeUrl="/data.jsp?type=fieldBrowser&isbill=0"  width="150px" browserValue="" browserSpanValue=""  />
		                </span>
						<span id="childfieldidSpan"></span>
						<input type="hidden" value="" name="childfieldid" id="childfieldid">
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
				<%}
	
				/*-- xwj for @td2977 begin--- */
				if(fieldhtmltype.equals("2")){ %>
					<span style="display:block;float:left;width:400px">
					<button type=button class=addbtn id=btnaddRow style="display:none;margin-left:5px;float: left;" name=btnaddRow onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></button>
					<button type=button class=delbtn id=btnsubmitClear style="display:none;margin-left:5px;float: left;" name=btnsubmitClear onclick="submitClear()" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></button>
					 &nbsp;&nbsp;<span id=typespan><%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%></span>&nbsp;
					<select class=inputstyle  size=1 style="width: 120px;display:none;" name=htmltype id=selecthtmltype onChange="typeChange()">
						<option value="1"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
						<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
						<option value="4"><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option><!--xwj for td3131 20051115-->
						<option value="5"><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>
					</select>
					<select class=inputstyle  size=1 style="width: 120px;" name="filehtmltype" id="filehtmltype" onChange="typeChange()">
						<option value="1"><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></option>
					</select>
					<select class=inputstyle  size=1 style="width: 120px;" name="specialhtmltype" id="specialhtmltype" onChange="typeChange()">
						<option value="1"><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></option>
					</select>
					<select class=inputstyle  size=1 style="width: 120px;" name="browsetbuttonype" id="browsetbuttonype" onChange="typeChange()">
						<%=browsertype%>
					</select>
					<span id="selecthtmltypespan" style="display: none;">
						<img align="absMiddle" src="/images/BacoError_wev8.gif">
					</span>
					
					<span onclick='setBTC()' style="display:none;" id='aaaaa'><img style="vertical-align: middle;" src='/images/ecology8/workflow/setting_wev8.png'></span>
					<input type="text" value="<%=textheight%>" name="textheight" maxlength=2 size=4 onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)" class=Inputstyle><!--xwj for @td2977 20051110 -->
				
					<span id=lengthspan ><%=SystemEnv.getHtmlLabelName(222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15449,user.getLanguage())%></span>
					<input type='checkbox' name="htmledit"  <%if (htmltypeid==2 && isused.equals("true") && isdetail != 1) {%> checked disabled <%}else if (htmltypeid==2 && !isused.equals("true") && isdetail != 1) {%> checked <%}else if (htmltypeid !=2 && isused.equals("true") && isdetail != 1) {%> disabled <%}else if (isdetail == 1) {%> disabled <% }%> value="2" onclick="onfirmhtml()">
					<input class=Inputstyle type=input  size=10 maxlength=3 name="strlength" style="width:50px!important;display:none" onBlur="checkPlusnumber1(this);checklength('strlength','strlengthspan')" onKeyPress="ItemPlusCount_KeyPress()" value="<%=textlength%>">
					<!-- zzl--start -->
					<button type="button" style="display:none" class="Browser browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
					<span id="showinner"></span>
					<span id="showimg" style="display:none"><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
					<input type="hidden" name="showvalue" id="showvalue">
					<!-- zzl--end -->
					<!-- sap browser -->
					<select style="display:none" class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()" >
						<option value=""></option>
						<%
						List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
						for(int j=0;j<AllBrowserId.size();j++){
						%>
						<option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
						<%}%>
					</select>
					<span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
					<span id="decimaldigitsspan" style="display:none">
					<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
					<select id="decimaldigits" name="decimaldigits">
						<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
						<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
						<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
						<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
					</select>
					</span>
					 
					 <span id=showprepspan_show style="display:none;float:none;"><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage()) %><div style="float:right;margin-right: 100px;">
						 <brow:browser width="105px" viewType="0" name="showprep"
							browserValue="1"
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/form/rightAttributeDepat.jsp?selectValue=#id#"
						    completeUrl="/data.jsp"
							hasInput="true" isSingle="true"
							isMustInput="2"
							browserDialogWidth="400px"
							browserDialogHeight="290px"
							_callback="typeChange"
							browserSpanValue="本部门"></brow:browser>
						 </div>
		            </span>  
		
				  	
					<span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
					<input   type=input class="InputStyle" size=10 maxlength=4 name="imgwidth" onBlur="checkPlusnumber1(this);checklength('imgwidth','imgwidthspan')"
					onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgwidth%>" style="display:none">
					<span id=imgwidthspan style="display:none"></span>
					<span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
					<input   type=input class="InputStyle" size=10 maxlength=4 name="imgheight" onBlur="checkPlusnumber1(this);checklength('imgheight','imgheightspan')"
					onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgheight%>" style="display:none">
					<span id=imgheightspan style="display:none"></span>
					
					<span id="childfieldNotesSpan" style="display:none;height:30px;line-height:30px;float:left;text-align:center;"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
					
					<span id="showChildFieldBotton" style="display:none;float:felt;">
				    <!--  qyw 2014-05-12 update 
						<button type='button' id="showChildFieldBotton" class=Browser onClick="onShowChildField('childfieldidSpan', 'childfieldid')"></button>
					-->	
					<brow:browser name="childfieldid" viewType="0" hasBrowser="true" hasAdd="false" 
		                 getBrowserUrlFn="onShowChildField_new" isMustInput="1" isSingle="true" hasInput="true"
		                completeUrl="/data.jsp?type=fieldBrowser&isbill=0"  width="150px" browserValue="" browserSpanValue=""  />
		                </span>
						<span id="childfieldidSpan"></span>
						<input type="hidden" value="" name="childfieldid" id="childfieldid">
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
				<%}
				/*-- xwj for @td2977 end--- */
	
				if(fieldhtmltype.equals("5")){ %>
					<span style="display:block;float:left;width:400px;">
					<button type=button class=addbtn id=btnaddRow style="display:'';margin-left:5px;float: left;" name=btnaddRow onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></button>
					<button type=button class=delbtn id=btnsubmitClear style="display:'';margin-left:5px;float: left;" name=btnsubmitClear onclick="submitClear()" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></button>
					<span id=typespan></span>
					<select class=inputstyle  style=display:none size=1 id=selecthtmltype name=htmltype onChange="typeChange()">
						<option value="1"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
						<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
						<option value="4"><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option>
						<option value="5"><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>
					</select>
					<select class=inputstyle  size=1 style="width: 120px;" name="filehtmltype" id="filehtmltype" onChange="typeChange()">
						<option value="1"><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></option>
					</select>
					<select class=inputstyle  size=1 style="width: 120px;" name="specialhtmltype" id="specialhtmltype" onChange="typeChange()">
						<option value="1"><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></option>
					</select>
					<select class=inputstyle  size=1 style="width: 120px;" name="browsetbuttonype" id="browsetbuttonype" onChange="typeChange()">
						<%=browsertype%>
					</select>
					<span id="selecthtmltypespan" style="display:none;">
						<img align="absMiddle" src="/images/BacoError_wev8.gif">
					</span>
					
					<span onclick='setBTC()' style="display:none;" id='aaaaa'><img style="vertical-align: middle;" src='/images/ecology8/workflow/setting_wev8.png'></span>
					<input type="text"  name="textheight" maxlength=2 size=4 onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)" class=Inputstyle style=display:none><!--xwj for @td2977 20051110 -->
					<span id=lengthspan></span>
					<input type='checkbox' name="htmledit" style="display:none"  value="2">
					<input type=input class="InputStyle" style=display:none size=10 maxlength=3 style="width:50px!important;" name="strlength" onBlur="checkPlusnumber1(this);checklength('strlength','strlengthspan')"
					onKeyPress="ItemPlusCount_KeyPress()" value="<%=textlength%>">
					
					<!-- zzl--start -->
					<button type="button" style="display:none" class="Browser browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
					<span id="showinner"></span>
					<span id="showimg" style="display:none"><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
					<input type="hidden" name="showvalue" id="showvalue">
					<!-- zzl--end -->  
					
					<!-- sap browser -->
					<select style="display:none" class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()" >
						<option value=""></option>
						<%
						List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
						for(int j=0;j<AllBrowserId.size();j++){
						%>
						<option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
						<%}%>
					</select>
					<span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
					<span id="decimaldigitsspan" style="display:none">
					<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
					<select id="decimaldigits" name="decimaldigits">
						<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
						<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
						<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
						<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
					</select>
					</span>
					
					<span id=showprepspan_show style="display:none;float:none;"><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage()) %><div style="float:right;margin-right: 100px;">
						 <brow:browser width="105px" viewType="0" name="showprep"
							browserValue="1"
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/form/rightAttributeDepat.jsp?selectValue=#id#"
						    completeUrl="/data.jsp"
							hasInput="true" isSingle="true"
							isMustInput="2"
							browserDialogWidth="400px"
							browserDialogHeight="290px"
							_callback="typeChange"
							browserSpanValue="本部门"></brow:browser>
						 </div>
		            </span>  
					
					<span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=10 maxlength=4 name="imgwidth" onBlur="checkPlusnumber1(this);checklength('imgwidth','imgwidthspan')" onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgwidth%>" style="display:none">
					<span id=imgwidthspan style="display:none"></span>
					<span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=10 maxlength=4 name="imgheight" onBlur="checkPlusnumber1(this);checklength('imgheight','imgheightspan')" onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgheight%>" style="display:none">
					<span id=imgheightspan style="display:none"></span>
					<span id="childfieldNotesSpan" style="height:30px;line-height:30px;float:left;text-align:center;"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
					<span id="showChildFieldBotton" style="float: left;"> 
					<%--<brow:browser name="childfieldid" viewType="0" hasBrowser="true" hasAdd="false" 
		                 getBrowserUrlFn="onShowChildField_new" isMustInput="1" isSingle="true" hasInput="true"
		                completeUrl="/data.jsp?type=fieldBrowser&isbill=0"  width="150px" browserValue='<%=childfieldid+""%>' browserSpanValue='<%=childfieldname%>'  />
		            --%>
		            
                    <brow:browser name="childfieldid" viewType="0" hasBrowser="true" hasAdd="false" 
                         getBrowserUrlFn="onShowChildField_new" isMustInput="1" isSingle="true" hasInput="true"
                        completeUrl="/data.jsp?type=fieldBrowser&isbill=0"  width="150px" browserValue="<%=String.valueOf(childfieldid)%>" browserSpanValue="<%=childfieldname%>"  />
                    
		                </span>
						<input type="hidden" value='<%=childfieldid+""%>' name="childfieldid" id="childfieldid">
					</span>	
					</span>
					<span id="cusbspan" style="display:none;">
						<brow:browser width="150px" viewType="0" name="cusb"
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
						    completeUrl="/data.jsp"
							hasInput="false" isSingle="true"
							isMustInput="2" browserDialogWidth="550px"
							browserDialogHeight="650px"
							_callback="typeChange"></brow:browser>
					</span>
				<%}
				if(fieldhtmltype.equals("6")){
					String displaystr="display:none";
					String strlengthdisplaystr = "display:none";
					if(htmltypeid==2) displaystr="display:''";
					if(htmltypeid==2 && isdetail==0){
						displaystr="display:''";
						strlengthdisplaystr="display:''";
					}
				%>
					<span style="display:block;float:left;width:400px;">
					<button type=button class=addbtn id=btnaddRow style="display:none;margin-left:5px;float: left;" name=btnaddRow onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></BUTTON>
					<button type=button class=delbtn id=btnsubmitClear style="display:none;margin-left:5px;float: left;" name=btnsubmitClear onclick="submitClear()" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></BUTTON>
					&nbsp;&nbsp;<span id=typespan><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>
					<%if(isused.equals("true")){%>
					<input type="hidden" value="<%=htmltypeid%>" name="filehtmltype" >
					<select class=inputstyle  size=1 style="width: 120px;" name="filehtmltype" id="filehtmltype" onChange="typeChange()" disabled>
					<%}else{%>
					<select class=inputstyle  size=1 style="width: 120px;" name="filehtmltype" id="filehtmltype" onChange="typeChange()">
					<%}%>
						<option value="1" <%if(htmltypeid==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></option>
						<option value="2" <%if(htmltypeid==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></option>
					</select>
					
					<select class=inputstyle  size=1 name=htmltype id=selecthtmltype onChange="typeChange()">
						<option value="1" ><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></option>
						<option value="2" ><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></option>
					</select>
					<select class=inputstyle  size=1 style="width: 120px;" name="specialhtmltype" id="specialhtmltype" onChange="typeChange()">
						<option value="1"><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></option>
					</select>
					<select class=inputstyle  size=1 style="width: 120px;" name="browsetbuttonype" id="browsetbuttonype" onChange="typeChange()">
						<%=browsertype%>
					</select>
					<span id="selecthtmltypespan" style="display:none;">
						<img align="absMiddle" src="/images/BacoError_wev8.gif">
					</span>
					<span onclick='setBTC()' style="display:none;" id='aaaaa'><img style="vertical-align: middle;" src='/images/ecology8/workflow/setting_wev8.png'></span>
					<input type="text"  name="textheight" maxlength=2 size=4 onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)" class=Inputstyle style=display:none>
					
					<span id=lengthspan style="<%=strlengthdisplaystr%>"><%=SystemEnv.getHtmlLabelName(24030,user.getLanguage())%></span>
					<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
					<input type=input class="InputStyle" size=10 maxlength=3 name="strlength" style="width:50px!important;<%=strlengthdisplaystr%>" onKeyPress="ItemPlusCount_KeyPress()" onBlur="checkPlusnumber1(this)" value="<%=textheight%>" >
					
					<!-- zzl--start -->
					<button type="button" style="display:none" class="Browser browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
					<span id="showinner"></span>
					<span id="showimg"></span>
					<input type="hidden" name="showvalue" id="showvalue">
					<!-- zzl--end -->  
					
					<!-- sap browser -->
					<select style="display:none" class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()" >
						<option value=""></option>
						<%
						List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
						for(int j=0;j<AllBrowserId.size();j++){
						%>
						<option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
						<%}%>
					</select>
					<span id=strlengthspan ></span>
					<span id="decimaldigitsspan" style="display:none">
					<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
					<select id="decimaldigits" name="decimaldigits">
						<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
						<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
						<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
						<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
					</select>
					</span>
					<span id=showprepspan_show style="display:none;"><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage()) %><div style="float:right;margin-right: 100px;">
						 <brow:browser width="105px" viewType="0" name="showprep"
							browserValue="1"
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/form/rightAttributeDepat.jsp?selectValue=#id#"
						    completeUrl="/data.jsp"
							hasInput="true" isSingle="true"
							isMustInput="2"
							browserDialogWidth="400px"
							browserDialogHeight="290px"
							_callback="typeChange"
							browserSpanValue="本部门"></brow:browser>
						 </div>
		            </span>  
					<span id=imgwidthnamespan style="<%=displaystr%>"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=10 maxlength=4 name="imgwidth" onKeyPress="ItemPlusCount_KeyPress()" onBlur="checkPlusnumber1(this)" value="<%=imgwidth%>" style="<%=displaystr%>">
					<span id=imgwidthspan style="<%=displaystr%>"></span>
					<span id=imgheightnamespan style="<%=displaystr%>"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=10 maxlength=4 name="imgheight" onKeyPress="ItemPlusCount_KeyPress()" onBlur="checkPlusnumber1(this)" value="<%=imgheight%>" style="<%=displaystr%>">
					<span id=imgheightspan style="<%=displaystr%>"></span>
					<span id="childfieldNotesSpan" style="display:none;height:30px;line-height:30px;float:left;text-align:center;"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
					<span id="showChildFieldBotton" style="display:none;float: left;">
					<%--<brow:browser name="childfieldid" viewType="0" hasBrowser="true" hasAdd="false" browserOnClick="onShowChildField('childfieldidspan', 'childfieldid')"
						isMustInput="1" isSingle="true" hasInput="true" completeUrl=""  width="150px" browserValue="" browserSpanValue=""/>	
						--%>
                    <brow:browser name="childfieldid" viewType="0" hasBrowser="true" hasAdd="false" 
                         getBrowserUrlFn="onShowChildField_new" isMustInput="1" isSingle="true" hasInput="true"
                        completeUrl="/data.jsp?type=fieldBrowser&isbill=0"  width="150px" browserValue="" browserSpanValue=""  />
					</span>	
					</span>	
					<span id="cusbspan" style="display:none;">
						<brow:browser width="150px" viewType="0" name="cusb"
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
						    completeUrl="/data.jsp"
							hasInput="false" isSingle="true"
							isMustInput="2" browserDialogWidth="550px"
							browserDialogHeight="650px"
							_callback="typeChange"></brow:browser>
					</span>
				<%}
				if(fieldhtmltype.equals("7")){ %>
					<span style="display:block;float:left;width:400px;">
					<button type=button class=addbtn id=btnaddRow style="display:none;margin-left:5px;float: left;" name=btnaddRow onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></BUTTON>
					<button type=button class=delbtn id=btnsubmitClear style="display:none;margin-left:5px;float: left;" name=btnsubmitClear onclick="submitClear()" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></BUTTON>
					<span id=typespan><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>
					<select class=inputstyle style="width: 120px;" size=1 id=selecthtmltype name=htmltype onChange="typeChange()" >
					<option value="1" ><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
					<option value="2" ><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></option>
					</select>
					
					<select class=inputstyle  size=1 style="width: 120px;" name="filehtmltype" id="filehtmltype" onChange="typeChange()">
						<option value="1"><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></option>
					</select>
					<select class=inputstyle  size=1 style="width: 120px;" name="specialhtmltype" id="specialhtmltype" onChange="typeChange()" <%if(isused.equals("true")){%>disabled<%}%>>
						<option value="1" <%if(htmltypeid==1) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
						<option value="2" <%if(htmltypeid==2) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></option>
					</select>
					<%if(isused.equals("true")){%>
					<input type="hidden" name="specialhtmltype1" value="<%=htmltypeid%>" >
					<%}%>
					<select class=inputstyle  size=1 style="width: 120px;" name="browsetbuttonype" id="browsetbuttonype" onChange="typeChange()">
						<%=browsertype%>
					</select>
					
					<span id="selecthtmltypespan" style="display:none;">
						<img align="absMiddle" src="/images/BacoError_wev8.gif">
					</span>
					<span onclick='setBTC()' style="display:none;" id='aaaaa'><img style="vertical-align: middle;" src='/images/ecology8/workflow/setting_wev8.png'></span>
					<input type="text"  name="textheight" maxlength=2 size=4 onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)" class=Inputstyle style=display:none>

					<span id=lengthspan></span>
					<input type='checkbox' name="htmledit" style="display:none"  value="2">
					<input type=input class="InputStyle" style=display:none size=10 maxlength=3 style="width:50px!important;" name="strlength" onBlur="checkPlusnumber1(this);checklength('strlength','strlengthspan')" onKeyPress="ItemPlusCount_KeyPress()" value="<%=textlength%>">
					
					<!-- zzl--start -->					
					<button type="button" style="display:none"  class="Browser browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
					<span id="showinner"></span>
					<span id="showimg" style="display:none" ><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
					<input type="hidden" name="showvalue" id="showvalue">
					<!-- zzl--end -->
					<!-- sap browser -->
					<select style="display:none" class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()" >
						<option value=""></option>
						<%
						List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
						for(int j=0;j<AllBrowserId.size();j++){
						%>
						<option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
						<%}%>
					</select>
					<span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
					<span id="decimaldigitsspan" style="display:none">
					<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
					<select id="decimaldigits" name="decimaldigits">
						<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
						<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
						<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
						<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
					</select>
					</span>
					<span id=showprepspan_show style="display:none;"><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage()) %><div style="float:right;margin-right: 100px;">
						 <brow:browser width="105px" viewType="0" name="showprep"
							browserValue="1"
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/form/rightAttributeDepat.jsp?selectValue=#id#"
						    completeUrl="/data.jsp"
							hasInput="true" isSingle="true"
							isMustInput="2"
							browserDialogWidth="400px"
							browserDialogHeight="290px"
							_callback="typeChange"
							browserSpanValue="本部门"></brow:browser>
						 </div>
		            </span>  
					<span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=10 maxlength=4 name="imgwidth" onBlur="checkPlusnumber1(this);checklength('imgwidth','imgwidthspan')" onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgwidth%>" style="display:none">
					<span id=imgwidthspan style="display:none"></span>
					<span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
					<input type=input class="InputStyle" size=10 maxlength=4 name="imgheight" onBlur="checkPlusnumber1(this);checklength('imgheight','imgheightspan')" onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgheight%>" style="display:none">
					<span id=imgheightspan style="display:none"></span>
					<span id="childfieldNotesSpan" style="display:none;height:30px;line-height:30px;float:left;text-align:center;"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
					<span id="showChildFieldBotton" style="display:none;float: left;">
					<%--<brow:browser name="childfieldid" viewType="0" hasBrowser="true" hasAdd="false" browserOnClick="onShowChildField('childfieldidspan', 'childfieldid')"
							isMustInput="1" isSingle="true" hasInput="true" completeUrl=""  width="150px" browserValue="" browserSpanValue=""/>
							--%>
                    <brow:browser name="childfieldid" viewType="0" hasBrowser="true" hasAdd="false" 
                         getBrowserUrlFn="onShowChildField_new" isMustInput="1" isSingle="true" hasInput="true"
                        completeUrl="/data.jsp?type=fieldBrowser&isbill=0"  width="150px" browserValue="" browserSpanValue=""  />
					</span>	
					</span>	
					<span id="cusbspan" style="display:none;">
						<brow:browser width="150px" viewType="0" name="cusb"
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
						    completeUrl="/data.jsp"
							hasInput="false" isSingle="true"
							isMustInput="2" browserDialogWidth="550px"
							browserDialogHeight="650px"
							_callback="typeChange"></brow:browser>
					</span>
				<%}
			}else{ %>
				<%if(fieldhtmltype.equals("1")){%><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%><%}%>
				<%if(fieldhtmltype.equals("2")){%><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%><%}%>
				<%if(fieldhtmltype.equals("3")){%><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%><%}%>
				<%if(fieldhtmltype.equals("4")){%><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%><%}%>
				<%if(fieldhtmltype.equals("5")){%><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%><%}%>
				<%if(fieldhtmltype.equals("6")){%><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%><%}%>
				<%if(fieldhtmltype.equals("7")){%><%=SystemEnv.getHtmlLabelName(21691,user.getLanguage())%><%}%>
				<%if(fieldhtmltype.equals("5")){%>
				<span id="childfieldidSpan" >
					<%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;
					<button type=button id="showChildFieldBotton" class=Browser disabled></button>
					<%=childfieldname%>
				</span>
				<%}else{%>
				
				<%}
			}%>		
		</wea:item>
		<wea:item attributes="{'samePair':'ViewLines'}"> </wea:item>
		<wea:item attributes="{'samePair':'ViewLines'}">
  			<div id=selectdiv <%if(fieldhtmltype.equals("5")){%>style="display:''" <%} else {%>style="display:none"<%}%>>
  	  			<table class="liststyle" id="oTable" cols=6 border=0>
  	  				<colgroup>
  	  					<col width="10%">
  	  					<% if(fieldid!=0){%>
  	  					<col width="18%">
  	  					<%}else{ %>
  	  					<col width="28%">
  	  					<%} %>
  	  					<col width="10%">
  	  					<col width="12%">
  	  					<col width="20%">
  	  					<col width="20%">
  	  					<% if(fieldid!=0){%>
  	  					<col width="10%">
  	  					<%} %>
  	  				</colgroup>
  	   				<tr class=header>
			  	   		<td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
			  	   		<td><%=SystemEnv.getHtmlLabelName(15442,user.getLanguage())%></td>
			  	   		<td><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></td>
			  	   		<td><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%></td>
			  	   		<td><%=SystemEnv.getHtmlLabelName(19207,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(22663,user.getLanguage())%></td>
						<% if(fieldid!=0){%>
		  	   			<td><%=SystemEnv.getHtmlLabelName(22151,user.getLanguage())%></td>
		  	   			<%} %>
  	   				</tr>
			  	   	<%if(fieldid==0){
			  	   	%>
			  	   	<tr>
			  	   	   	<td height="23"><input type='checkbox' name='check_select' value="<%=rowsum%>" ></td>
					   	<td>
						   	<div style="float:left; display:inline;width:165px;">
							   	<input type=text class=Inputstyle id="field_<%=rowsum%>_name" name="field_<%=rowsum%>_name" style="width:150px!important;" onchange="checkinput('field_<%=rowsum%>_name','field_<%=rowsum%>_span')">
							   	<span id="field_<%=rowsum%>_span"><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
						   	</div>
					   	</td>
					    <td><input class='InputStyle' type=text name='field_count_<%=rowsum%>_name' value = '0.00' onKeyPress=ItemNum_KeyPress('field_count_<%=rowsum%>_name') style="width:40px!important;"></td>
						<td><input type='checkbox' name='field_checked_<%=rowsum%>_name' value='1'></td>
					    <td>
					    <div style="float:left; display:inline;width:250px;">
					    <input type='checkbox' name='isAccordToSubCom<%=rowsum%>' id='isAccordToSubCom<%=rowsum%>' value='1' style="float: left;"><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;
			    			

							<brow:browser viewType="0" name='<%="maincategory"+rowsum%>' browserValue="<%=maincategory%>" browserBtnID='<%="maincategory"+rowsum%>'  
	            getBrowserUrlFn="onShowCatalog"   getBrowserUrlFnParams='<%=""+rowsum%>'
	            idKey="id" nameKey="path"
				_callback="afterSelect"
				_callbackParams='<%=""+rowsum%>'
	            hasInput="true" isSingle="true" hasBrowser = "true"  isMustInput='1'
	            completeUrl="/data.jsp?type=categoryBrowser&onlySec=true" linkUrl="#" width="60%"
	            browserSpanValue="<%=docPath%>"></brow:browser>
			    			
			    			<span id=mypath<%=rowsum%>><%=docPath%></span>
			    			<input type=hidden id='pathcategory<%=rowsum%>' name='pathcategory<%=rowsum%>' value="<%=docPath%>">
							
			    		</div>
			    		</td>
						<td>
						 <%
						    String selectName = "selectChildItem" + rowsum;
						    String selectChild = "childItem" + rowsum;
						 %>
						 <div style="float:left; display:inline;width:100px;">
				            <%--<button type=button class="Browser" onClick="onShowChildSelectItem('childItemSpan<%=rowsum%>', 'childItem<%=rowsum%>')" id="<%=selectName%>" name="<%=selectName%>"></BUTTON>
				            <input type="hidden" id="childItem<%=rowsum%>" name="childItem<%=rowsum%>" value="" >
                            <span id="childItemSpan<%=rowsum%>" name="childItemSpan<%=rowsum%>"></span>--%>
                                <div style="float:left; display:inline;width:25px;" class="childItemDiv">
                                  <brow:browser viewType="0" name='<%="childItem"+rowsum%>' browserValue=""
                                      getBrowserUrlFn="showChildSelectItem" getBrowserUrlFnParams='<%=""+rowsum%>'
                                      _callback="selectChildSelectItem"
                                      _callbackParams='<%=""+rowsum%>'
                                      hasInput="false" isSingle="false" hasBrowser = "true"  isMustInput='1' width="25px"
                                      browserSpanValue=""></brow:browser>
                                </div>
                                <span id="childItemSpan<%=rowsum%>" name="childItemSpan<%=rowsum%>" class="childItemSpan" title=''></span>
							
						 </div>
						</td>
					</tr>
					<%}else{
					int colorcount=0;
					String sql="select * from workflow_SelectItem where fieldid="+fieldid+" and isbill=0 order by selectvalue";//xwj for td2977 20051107  //"id" is added to "order by" by xwj for td3297 20051130
					RecordSet.executeSql(sql);
					while(RecordSet.next()){
						String selectname=RecordSet.getString("selectname");
						String selectvalue=RecordSet.getString("selectvalue");
						String listorder=RecordSet.getString("listorder");//xwj for td2977 20051107
						String isdefault=RecordSet.getString("isdefault");//xwj for td2977 20051107
						String selectid=RecordSet.getString("id");//xwj for td3286 20051129
						String docspath = "";
		  				String docscategory = RecordSet.getString("docCategory");
		  				String isAccordToSubCom = Util.null2String(RecordSet.getString("isAccordToSubCom"));
		  				String childitemid = Util.null2String(RecordSet.getString("childitemid"));
							String cancel=RecordSet.getString("cancel");//td31072
							
		  				if(!"".equals(docscategory) && null != docscategory)
		  				//根据路径ID得到路径名称
		  				{
		  					List nameList = Util.TokenizerString(docscategory, ",");
		
		  					//String mainCategory = (String)nameList.get(0);
		            		//String subCategory = (String)nameList.get(1);
		            		//String secCategory = (String)nameList.get(2);
		
		            		//docspath = "/" + mainCategoryComInfo.getMainCategoryname(mainCategory) + "/" + subCategoryComInfo.getSubCategoryname(subCategory) + "/" + secCategoryComInfo.getSecCategoryname(secCategory);

							try{
							    String mainCategory = (String)nameList.get(0);
							    String subCategory = (String)nameList.get(1);
							    String secCategory = (String)nameList.get(2);
							    docspath = secCategoryComInfo.getAllParentName(secCategory,true);
							}catch(Exception e){
								docspath = secCategoryComInfo.getAllParentName(docscategory,true);
							}
		  				}
		  				String childitemidStr = "";
		  				if(!"".equals(childitemid)){
		  					String[] itemid_sz = Util.TokenizerString2(childitemid, ",");
		  					for(int cx=0; cx<itemid_sz.length; cx++){
		  						String itemid_tmp = itemid_sz[cx];
		  						try{
			  						String[] checktmp_sz = Util.TokenizerString2(itemid_tmp, "a");
			  						String itemidStr_tmp = Util.null2String((String)selectitem_sh.get("si_"+checktmp_sz[0]));
			  						if(!"".equals(itemidStr_tmp)){
			  							childitemidStr += (itemidStr_tmp + ",");
			  						}
		  						}catch(Exception e){}
		  					}
		  					if(!"".equals(childitemidStr)){
		  						childitemidStr = childitemidStr.substring(0, childitemidStr.length()-1);
		  						if(childitemidStr.length() > 10){
			  						  childitemidStr = childitemidStr.substring(0,8)+"...";
			  					}
		  					}
		  				}
					%>
					<tr>
						<td  height="23">
							<input <% if(tof) out.println("disabled");%> type='checkbox' name='check_select' value="<%=selectvalue%>" <%if(fieldCommon.isOptionUsed(String.valueOf(fieldid),type2,selectvalue,0)){%> disabled = "true" <%}//xwj for td3297 20051201 %>>
						</td>
						<td>
							<div style="float:left; display:inline;width:165px;">
							<input <% if(tof) out.println("disabled");%>  class=Inputstyle type=text name="field_<%=rowsum%>_name" value="<%=Util.toScreen(selectname,user.getLanguage())%>" style="width:150px!important;" onchange="checkinput('field_<%=rowsum%>_name','field_<%=rowsum%>_span')">
							<input type="hidden" value="<%=selectid%>" name="field_id_<%=rowsum%>_name"><!--added by xwj for td3286 20051129-->
							<!--xwj for td2977 20051107 begin-->
							<span id="field_<%=rowsum%>_span"></span>
							</div>
						</td>
						<td><input <% if(tof) out.println("disabled");%> class='InputStyle' type='text' name='field_count_<%=rowsum%>_name'  value = '<%=listorder%>' onKeyPress=ItemNum_KeyPress('field_count_<%=rowsum%>_name') style="width:40px!important;"></td>
						<td><input <% if(tof) out.println("disabled");%> type='checkbox' name='field_checked_<%=rowsum%>_name' value='1' <%if("y".equals(isdefault)){%>checked<%}%>>
					  	</td>
					  	<td>
					  	<div style="float:left; display:inline;width:250px;">
			              	<input  type='hidden' name='selectvalue<%=rowsum%>' id='selectvalue<%=rowsum%>' value='<%=selectvalue%>' >
			              	<input <% if(tof) out.println("disabled");%> type='checkbox' name='isAccordToSubCom<%=rowsum%>' id='isAccordToSubCom<%=rowsum%>' value='1' <%if("1".equals(isAccordToSubCom)){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;

					     

							<brow:browser viewType="0" name='<%="maincategory"+rowsum%>' browserValue="<%=docscategory%>"  
	            getBrowserUrlFn="onShowCatalog"   getBrowserUrlFnParams='<%=""+rowsum%>'
	            idKey="id" nameKey="path"
				_callback="afterSelect"
				_callbackParams='<%=""+rowsum%>'
	            hasInput="true" isSingle="true" hasBrowser = "true"  isMustInput='1'
	            completeUrl="/data.jsp?type=categoryBrowser&onlySec=true" linkUrl="#" width="60%"
	            browserSpanValue="<%=docspath%>"></brow:browser>
			    			
			    		
			    			<input type=hidden id='pathcategory<%=rowsum%>' name='pathcategory<%=rowsum%>' value="<%=docspath%>">
						    
			    		</div>
			    		</td>
						<td>
						<div style="float:left; display:inline;width:100px;">
							<%--<button type=button <% if(tof) out.print("disabled");%> class="Browser" onClick="onShowChildSelectItem('childItemSpan<%=rowsum%>', 'childItem<%=rowsum%>')" id="selectChildItem<%=rowsum%>" name="selectChildItem<%=rowsum%>"></BUTTON>
							<input type="hidden" id="childItem<%=rowsum%>" name="childItem<%=rowsum%>" value="<%=childitemid%>" >
							<span id="childItemSpan<%=rowsum%>" name="childItemSpan<%=rowsum%>"><%=childitemidStr%></span>--%>
							<div style="float:left; display:inline;width:25px;" class="childItemDiv">
                            <%if(childitemid!= null &&childitemid.startsWith(","))childitemid = childitemid.substring(1); %>
                              <brow:browser viewType="0" name='<%="childItem"+rowsum%>' browserValue="<%=childitemid%>"
                                  getBrowserUrlFn="showChildSelectItem" getBrowserUrlFnParams='<%=""+rowsum%>'
                                  _callback="selectChildSelectItem"
                                  _callbackParams='<%=""+rowsum%>'
                                  hasInput="false" isSingle="false" hasBrowser = "true"  isMustInput='1' width="25px"
                                  browserSpanValue="<%=childitemidStr%>"></brow:browser>
                            </div>
                            <span id="childItemSpan<%=rowsum%>" name="childItemSpan<%=rowsum%>" class="childItemSpan" title='<%=childitemidStr%>'><%=childitemidStr%></span>
						</div>
						</td>
				  		<td><input <% if(tof) out.println("disabled");%> type='checkbox' name='cancel_<%=rowsum%>_name' value="<%=cancel%>" onclick="if(this.checked){this.value=1;}else{this.value=0}" <%if("1".equals(cancel)){%>checked<%}%>>					
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
			String iscustomlink = "style=display:none;";
			String isdescriptive = "style=display:none;";
			 
			if(fieldhtmltype.equals("7")){
				rs.executeSql("select * from workflow_specialfield where fieldid = " + fieldid + " and isform = 1");
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
			    <td width="35%"><%=SystemEnv.getHtmlLabelName(606,user.getLanguage())%>&nbsp;&nbsp;<input class=inputstyle type=text name=displayname size=20 value="<%=displayname%>" maxlength=1000>　
			    </td>
			    <td><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%>&nbsp;&nbsp;<input class=inputstyle type=text size=50 name=linkaddress value="<%=linkaddress%>" maxlength=1000>&nbsp;
			    <%=SystemEnv.getHtmlLabelName(18391,user.getLanguage())%>
			    </td>
			   </tr>
			  </table>
			</div>	 
			<div id="descriptive" <%out.println(isdescriptive);%>><table width="100%"><tr><td width="8%"><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%>　</td><td><textarea class='inputstyle' style='width:60%;height:100px' name=descriptivetext><%=Util.StringReplace(descriptivetext,"<br>","\n")%></textarea></td></tr></table></div>			   		
		</wea:item>
		<% rowsum+=1; %>
		<%-- 
		<wea:item><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></wea:item>
		<wea:item>
			<%=(type2.equals("detailfield")?SystemEnv.getHtmlLabelName(18550,user.getLanguage()):SystemEnv.getHtmlLabelName(18549,user.getLanguage()))%>
		</wea:item>
		 --%>
	</wea:group>
</wea:layout>

<input type="hidden" value="0" name="selectsnum">
<input type="hidden" value="" name="openrownum" id="openrownum">
<input type="hidden" value="" name="delids">
<input type="hidden" value="<%=dialog %>" name="dialog">
</form>
<%if("1".equals(dialog)){ %>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()" style="width: 60px!important;">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%} %>
<script language="JavaScript" src="/js/addRowBg_wev8.js" ></script>
<script type="text/javascript">
if("<%=isused %>"==="true"){
	$("body").find("select").selectbox("enable");;
}

if("<%=dialog%>"==1){
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	function btn_cancle(){
		parentWin.closeDialog();
	}
}



if("<%=isclose%>"==1){
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	if("<%=type2%>"=="detailfield"){
		parentWin.location="/workflow/field/managedetailfield.jsp";
	}else{
		parentWin.location="/workflow/field/managefield.jsp";
	}	
	parentWin.closeDialog();
	
}

function OnNewChangeSapBroswerType()
{
	var browsertype=$G("browsetbuttonype").value;
	var showinner=$G("showinner");
	var mark=$G("showinner").innerHTML;
	var showimg=$G("showimg");
	var showvalue=$G("showvalue");
	var left = Math.ceil((screen.width - 1086) / 2);   //实现居中
    var top = Math.ceil((screen.height - 600) / 2);  //实现居中
    var urls = "/integration/browse/integrationBrowerMain.jsp?browsertype="+browsertype+"&mark="+mark+"&srcType=<%=type2%>";
    var tempstatus = "dialogWidth:1086px;dialogHeight:600px;scroll:yes;status:no;dialogLeft:"+left+";dialogTop:"+top+";";
	//var temp=window.showModalDialog(urls,"",tempstatus);
	
	var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = "SAP";
	    dialog.URL = urls;
		dialog.Width = 660;
		dialog.Height = 660;
		dialog.DefaultMax = true;
		dialog.maxiumnable=true;
		dialog.callbackfun=function(temp){
			if(temp){
				showvalue.value=temp;
				showinner.innerHTML=temp;
				showimg.innerHTML="";
			}
		};
 		
		dialog.show();
	
	
	
		showimg.style.display='';
}
function checkSystemField(name,spanname,type){
	var fieldname = $G(name).value;
	fieldname = fieldname.toUpperCase();
	var fieldtype = type;
	if(fieldtype=="mainfield"){
		if(fieldname=="REQUESTID"||fieldname=="BILLFORMID"||fieldname=="BILLID"){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21763,user.getLanguage())%>");
			$G(name).value = "";
			$G(spanname).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		}
	}else if(fieldtype=="detailfield"){
		if(fieldname=="REQUESTID"||fieldname=="ID"||fieldname=="GROUPID"){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21764,user.getLanguage())%>");
			$G(name).value = "";
			$G(spanname).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		}
	}
}
	
rowindex = <%=rowsum%>;
delids = "";
var rowColor="" ;
function addRow() {
	var oTable = $G("oTable");
    rowColor = getRowBg();
	ncol = oTable.rows[0].cells.length;
	oRow = oTable.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input  type='checkbox' name='check_select' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;

				<%--xwj for td2977 20051107 begin--%>
			case 1:
				var oDiv = document.createElement("div");
				oDiv.style.display="inline-block";
				var sHtml = "<div style='float:left; display:inline;width:165px;'><input class=\"Inputstyle\" type='text' style='width:150px!important;float:left;' id='field_"+rowindex+"_name' name='field_"+rowindex+"_name' "+
							" onchange=checkinput('field_"+rowindex+"_name','field_"+rowindex+"_span')>"+
							" <span id='field_"+rowindex+"_span'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span> </div>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = " <input class=\"Inputstyle\" type='text' value = '0.00' style='width:40px!important;' name='field_count_"+rowindex+"_name' "+
							" onKeyPress=ItemNum_KeyPress('field_count_"+rowindex+"_name') >";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = " <input type='checkbox' name='field_checked_"+rowindex+"_name' value='1'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 4:
				var oDiv = document.createElement("div");
				var sHtml = "<div style='float:left; display:inline;width:250px;'><input type='checkbox' name='isAccordToSubCom"+rowindex+"'  id='isAccordToSubCom"+rowindex+"' value='1' ><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;"
							+ "\r\n<span  id='maincategory"+rowindex+"' name='maincategory"+rowindex+"' ></span>"
						    + "\r\n<input type=hidden id='pathcategory" + rowindex + "' name='pathcategory" + rowindex + "' value='<%=docPath%>'>"
						    + "\r\n</div>";

				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
              jQuery("#maincategory"+rowindex).e8Browser({
                 name:"maincategory"+rowindex,
                 viewType:"0",
                 browserValue:"",
                 isMustInput:"1",
                 browserSpanValue:"",
                 hasInput:true,
                 linkUrl:"#",
                 isSingle:true,
                 completeUrl:"/data.jsp?type=categoryBrowser&onlySec=true",
				 getBrowserUrlFn:'onShowCatalog',
				 getBrowserUrlFnParams:''+rowindex,
				 _callback:"afterSelect",
				 _callbackParams:rowindex,
         
                 width:"60%",
                 hasAdd:false,
                 isSingle:true
                 });

				break;
				<%--xwj for td2977 20051107 end--%>
			case 5:
			    /*
				var oDiv = document.createElement("div");
				var sHtml = "<div style='float:left; display:inline;width:100px;'><button type=button class=\"Browser\" onClick=\"onShowChildSelectItem('childItemSpan"+rowindex+"', 'childItem"+rowindex+"')\" id=\"selectChildItem"+rowindex+"\" name=\"selectChildItem"+rowindex+"\"></BUTTON>"
							+ "\r\n<input type=\"hidden\" id=\"childItem"+rowindex+"\" name=\"childItem"+rowindex+"\" value=\"\" >"
							+ "\r\n<span id=\"childItemSpan"+rowindex+"\" name=\"childItemSpan"+rowindex+"\"></span></div>";
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

		}
	}
	rowindex += 1;
	jQuery("body").jNice();
}

function onfirmhtml()
{
if (document.form1.htmledit.checked==true)
	top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(20867,user.getLanguage())%>');

}
function deleteRow1()
{
	$("input[name=check_select]").each(function(){
		var obj = $(this);
		if(obj.attr("checked")){
			obj.closest("tr").remove();
		}
	});
}

</script>
<script language=javascript>
	function showType(){
	    jQuery("#aaaaa").hide();
		jQuery('#selecthtmltypespan').hide();
		jQuery('#browsetbuttonype').autoSelect('hide');
		var fieldhtmltypelist = window.document.forms[0].fieldhtmltype;
		$("select[name=htmltype]").next().hide();
		$("input[name=htmledit]").next().hide();
		var htmltypelist = $G("htmltype");
		var htmltypeedit = $G("htmledit");
		var sapbrowser=$G("sapbrowser");
		var lengthspan=$G("lengthspan");
		//var lengthspan = jQuery("#lengthspan");
		//zzl
		var newsapbrowser=$G("newsapbrowser");
		var showinner=$G("showinner");
		var showimg=$G("showimg");
		
		var type2 = $G("srcType").value;
		
        var cusbspan=$G("cusbspan");
        <!--xwj for @td2977 20051110 begin-->
		if(fieldhtmltypelist.value==4){
		  	window.document.forms[0].textheight.style.display='none'
			htmltypeedit.style.display='none';
			typespan.innerHTML='';
			lengthspan.innerHTML='';
			window.document.forms[0].strlength.style.display='none';
            window.document.forms[0].strlength.value='';
			strlengthspan.innerHTML='';
			$G("selectdiv").style.display='none';
			$G("btnaddRow").style.display='none';
			$G("btnsubmitClear").style.display='none';
			htmltypelist = $G("selecthtmltype");
			htmltypelist.style.display='none';
			jQuery("#specialhtmltype").selectbox("hide");
			jQuery("#filehtmltype").selectbox("hide");
			jQuery("#browsetbuttonype").selectbox("hide");
            cusbspan.style.display='none';
            sapbrowser.style.display='none';
            //zzl
            newsapbrowser.style.display='none';
            showimg.style.display='none';
            showinner.style.display='none';
            //$G("locatetypespan").style.display="none";
            $G("customlink").style.display='none';
            $G("descriptive").style.display='none';
            $G("childfieldNotesSpan").style.display='none';
            $G("showChildFieldBotton").style.display='none';
            
            $G("showprepspan_show").style.display = 'none';
           
            $G("imgwidthnamespan").style.display='none';
            $G("imgwidthspan").style.display='none';
            $G("imgheightnamespan").style.display='none';
            $G("imgheightspan").style.display='none';
            $G("imgwidth").style.display='none';
            $G("imgheight").style.display='none';
            $G("decimaldigitsspan").style.display="none";
            $G("childfieldidSpan").style.display='none';
            
            hideEle("ViewLines");

        }else if(fieldhtmltypelist.value==6){
        	 
		    window.document.forms[0].textheight.style.display='none'
			htmltypeedit.style.display='none';
			typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>';
			strlengthspan.innerHTML='';
			$G("selectdiv").style.display='none';
			$G("btnaddRow").style.display='none';
			$G("btnsubmitClear").style.display='none';
			htmltypelist = $G("selecthtmltype");
			htmltypelist.style.display='none';
			jQuery("#specialhtmltype").selectbox("hide");
			jQuery("#filehtmltype").selectbox("show");
			jQuery("#browsetbuttonype").selectbox("hide");
            //for(var count = htmltypelist.options.length - 1; count >= 0; count--)
			//	htmltypelist.options[count] = null;
            //cusbspan.style.display='none';
            //bindSelectDate("htmltype");	
            //zzl
            newsapbrowser.style.display='none';
            //showimg.style.display='none';
            jQuery("#showimg").css("display","none");
            showinner.style.display='none';
            sapbrowser.style.display='none';
            $G("customlink").style.display='none';
            $G("descriptive").style.display='none';
            $G("childfieldNotesSpan").style.display='none';
            $G("showChildFieldBotton").style.display='none';
            
            $G("decimaldigitsspan").style.display="none";
            
            $G("showprepspan_show").style.display = 'none';
            //$G("locatetypespan").style.display="none";
            var filevalue = jQuery("#filehtmltype").val();
            //alert(filevalue);
            if(filevalue == 1){
                $G("imgwidthnamespan").style.display='none';
                $G("imgwidthspan").style.display='none';
                $G("imgheightnamespan").style.display='none';
                $G("imgheightspan").style.display='none';
                $G("imgwidth").style.display='none';
                $G("imgheight").style.display='none';
                lengthspan.innerHTML='';
                window.document.forms[0].strlength.style.display='none';
                window.document.forms[0].strlength.value='';
            }else{
            	lengthspan.style.display='';
                lengthspan.innerHTML='<%=SystemEnv.getHtmlLabelName(24030,user.getLanguage())%>';
                window.document.forms[0].strlength.style.display='';
                window.document.forms[0].strlength.value='5';
                $G("imgwidth").value='100';
                $G("imgheight").value='100';
                $G("imgwidthnamespan").style.display='';
                $G("imgwidthspan").style.display='';
                $G("imgheightnamespan").style.display='';
                $G("imgheightspan").style.display='';
                $G("imgwidth").style.display='';
                $G("imgheight").style.display='';
                
                if(type2!="mainfield"){
                	window.document.forms[0].strlength.style.display='none';
                    window.document.forms[0].strlength.value='0';
                    
                    lengthspan.style.display='none';
                    
                    $G("imgwidth").value='50';
                    $G("imgheight").value='50';
                }
            }
             $G("childfieldidSpan").style.display='none';
             hideEle("ViewLines");

        }else if(fieldhtmltypelist.value==2){
        	//removeBeatyCheckbox(htmltypeedit);
		  htmltypeedit.style.display='';
		  jQuery(".jNiceCheckbox").css("display","inline-block");
		  //htmltypeedit.jNice();
          //将html格式的是否可用 与  当前是否为明细字段 保持一致
          //标识当前是否为明细字段
          var flagIsDetail = <%=(isdetail == 1)%>;
		  if(flagIsDetail){
		  	jQuery(".jNiceCheckbox_disabled").css("display","inline-block");
			htmltypeedit.disabled = true;
		  }
		  
		  typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>';
		    window.document.forms[0].textheight.style.display='';
		    lengthspan.style.display='';
			lengthspan.innerHTML='<%=SystemEnv.getHtmlLabelName(222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15449,user.getLanguage())%>';
			window.document.forms[0].strlength.style.display='none';
            window.document.forms[0].strlength.value='';
			strlengthspan.innerHTML='';
			$G("selectdiv").style.display='none';
			$G("btnaddRow").style.display='none';
			$G("btnsubmitClear").style.display='none';
			htmltypelist = $G("selecthtmltype");
			htmltypelist.style.display='none';
			jQuery("#specialhtmltype").selectbox("hide");
			jQuery("#filehtmltype").selectbox("hide");
			jQuery("#browsetbuttonype").selectbox("hide");
            cusbspan.style.display='none';
            sapbrowser.style.display='none';
            //zzl
            newsapbrowser.style.display='none';
            showimg.style.display='none';
            showinner.style.display='none';
            //$G("locatetypespan").style.display="none";
            $G("showprepspan_show").style.display = 'none';
                         
            $G("customlink").style.display='none';
            $G("descriptive").style.display='none';
            $G("childfieldNotesSpan").style.display='none';
            $G("showChildFieldBotton").style.display='none';
            
            $G("imgwidthnamespan").style.display='none';
            $G("imgwidthspan").style.display='none';
            $G("imgheightnamespan").style.display='none';
            $G("imgheightspan").style.display='none';
            $G("imgwidth").style.display='none';
            $G("imgheight").style.display='none';
            $("#decimaldigitsspan").hide();
            jQuery("body").jNice();	
            $G("childfieldidSpan").style.display='none';
            hideEle("ViewLines");

        }else if(fieldhtmltypelist.value==5){
            window.document.forms[0].textheight.style.display='none';<!--xwj for @td2977 20051110 end-->
            htmltypeedit.style.display='none';
			typespan.innerHTML='';
			lengthspan.innerHTML='';
			window.document.forms[0].strlength.style.display='none';
            window.document.forms[0].strlength.value='';
			strlengthspan.innerHTML='';
			$G("selectdiv").style.display='';
			$G("btnaddRow").style.display='';
			$G("btnsubmitClear").style.display='';
			htmltypelist = $G("selecthtmltype");
			htmltypelist.style.display='none';
			jQuery("#specialhtmltype").selectbox("hide");
			jQuery("#filehtmltype").selectbox("hide");
			jQuery("#browsetbuttonype").selectbox("hide");
			
            cusbspan.style.display='none';
            sapbrowser.style.display='none';
            $G("showprepspan_show").style.display = 'none';
            //zzl
            newsapbrowser.style.display='none';
            jQuery("#showimg").css("display","none");
            //showimg.style.display='none';
            showinner.style.display='none';
             
            $G("customlink").style.display='none';
            $G("descriptive").style.display='none';
            //$G("locatetypespan").style.display="none";
            //$G("childfieldNotesSpan").style.display='';
            //$G("showChildFieldBotton").style.display='';           
            jQuery("#childfieldNotesSpan").css("display","inline-block");
            jQuery("#showChildFieldBotton").css("display","inline-block");
            $G("imgwidthnamespan").style.display='none';
            $G("imgwidthspan").style.display='none';
            $G("imgheightnamespan").style.display='none';
            $G("imgheightspan").style.display='none';
            $G("imgwidth").style.display='none';
            $G("imgheight").style.display='none';
            $G("decimaldigitsspan").style.display="none";
            $G("childfieldidSpan").style.display='';
            
            showEle("ViewLines");
            

        }else if(fieldhtmltypelist.value==3){
		    window.document.forms[0].textheight.style.display='none';	<!--xwj for @td2977 20051110 end-->
            htmltypeedit.style.display='none';
			typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>';
			lengthspan.innerHTML='';
			window.document.forms[0].strlength.style.display='none';
            window.document.forms[0].strlength.value='';
			strlengthspan.innerHTML='';
			$G("showprepspan_show").style.display = 'none';
			$G("selectdiv").style.display='none';
			$G("btnaddRow").style.display='none';
			$G("btnsubmitClear").style.display='none';
			htmltypelist = $G("selecthtmltype");
			jQuery("#selecthtmltype").selectbox("hide");
			jQuery("#specialhtmltype").selectbox("hide");
			jQuery("#filehtmltype").selectbox("hide");
			//jQuery("#browsetbuttonype").selectbox("show");
			//for(var count = htmltypelist.options.length - 1; count >= 0; count--)
				//htmltypelist.options[count] = null;
			
			//bindSelectDate("htmltype");	
			//$(htmltypelist).selectbox('hide');
            jQuery("#browsetbuttonype").autoSelect();
            $G("customlink").style.display='none';
            $G("descriptive").style.display='none';
            $G("childfieldNotesSpan").style.display='none';
            $G("showChildFieldBotton").style.display='none';
            $G("imgwidthnamespan").style.display='none';
            $G("imgwidthspan").style.display='none';
            $G("imgheightnamespan").style.display='none';
            $G("imgheightspan").style.display='none';
            $G("imgwidth").style.display='none';
            $G("imgheight").style.display='none';
            $G("decimaldigitsspan").style.display="none";
            //$G("locatetypespan").style.display="none";
            typeChange();
            $G("childfieldidSpan").style.display='none';
            //列表排序
            //sortOption();
            sortOption($G("browsetbuttonype"));
            hideEle("ViewLines");
            BTCOpen();
		}else if(fieldhtmltypelist.value==1){
		  window.document.forms[0].textheight.style.display='none';	<!--xwj for @td2977 20051110 end-->
		  htmltypeedit.style.display='none';
		  lengthspan.style.display='';
			typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>';
			//lengthspan.css("display","inline-block");
			lengthspan.innerHTML='<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>';
            window.document.forms[0].strlength.value='';
			window.document.forms[0].strlength.style.display='';
			if(form1.strlength.value==''||form1.strlength.value==0)
				strlengthspan.innerHTML='<IMG src="/images/BacoError_wev8.gif" align=absMiddle>';
			strlengthspan.style.display='';
			$G("selectdiv").style.display='none';
			$G("btnaddRow").style.display='none';
			$G("btnsubmitClear").style.display='none';
			jQuery("#specialhtmltype").selectbox("hide");
			jQuery("#filehtmltype").selectbox("hide");
			jQuery("#browsetbuttonype").selectbox("hide");
			htmltypelist = $G("selecthtmltype");
			htmltypelist.selectedIndex=0;
			htmltypelist.style.display='';			
			for(var count = htmltypelist.options.length - 1; count >= 0; count--)
				htmltypelist.options[count] = null;
			<%=texttype%>
			bindSelectDate("htmltype");	
            cusbspan.style.display='none';
            sapbrowser.style.display='none';
            //zzl
            newsapbrowser.style.display='none';
            showimg.style.display='none';
            showinner.style.display='none';
            
            //$G("locatetypespan").style.display="none";
            $G("showprepspan_show").style.display = 'none';            
			$G("decimaldigitsspan").style.display="none";
            $G("customlink").style.display='none';
            $G("descriptive").style.display='none';
            $G("childfieldNotesSpan").style.display='none';
            $G("showChildFieldBotton").style.display='none';            
            $G("imgwidthnamespan").style.display='none';
            $G("imgwidthspan").style.display='none';
            $G("imgheightnamespan").style.display='none';
            $G("imgheightspan").style.display='none';
            $G("imgwidth").style.display='none';
            $G("imgheight").style.display='none';
            $G("childfieldidSpan").style.display='none';
			
            hideEle("ViewLines");
        }else if(fieldhtmltypelist.value==7){
		    window.document.forms[0].textheight.style.display='none';<!--xwj for @td2977 20051110 end-->
		    htmltypeedit.style.display='none';
			typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>';
			lengthspan.innerHTML='';
			window.document.forms[0].strlength.style.display='none';
            window.document.forms[0].strlength.value='';
			strlengthspan.innerHTML='';
			$G("selectdiv").style.display='none';
			$G("btnaddRow").style.display='none';
			$G("btnsubmitClear").style.display='none';
			htmltypelist = $G("selecthtmltype");
			htmltypelist.style.display='none';
			jQuery("#specialhtmltype").selectbox("show");
			jQuery("#filehtmltype").selectbox("hide");
			jQuery("#browsetbuttonype").selectbox("hide");
			//for(var count = htmltypelist.options.length - 1; count >= 0; count--)
			//	htmltypelist.options[count] = null;
			
            //bindSelectDate("htmltype");
            cusbspan.style.display='none';
            sapbrowser.style.display='none';
            //zzl
            
            var specialvalue = jQuery("#specialhtmltype").val();
			if(specialvalue == 1){
               $G("customlink").style.display='';
               $G("descriptive").style.display='none';
			}
		    if(specialvalue == 2){
               $G("customlink").style.display='none';
               $G("descriptive").style.display='';
			}
			$G("showprepspan_show").style.display = 'none';
            //$G("locatetypespan").style.display="none";
            newsapbrowser.style.display='none';
            showimg.style.display='none';
            showinner.style.display='none';
            //$G("customlink").style.display='';
            //$G("descriptive").style.display='none';
            $G("childfieldNotesSpan").style.display='none';
            $G("showChildFieldBotton").style.display='none';           
            $G("imgwidthnamespan").style.display='none';
            $G("imgwidthspan").style.display='none';
            $G("imgheightnamespan").style.display='none';
            $G("imgheightspan").style.display='none';
            $G("imgwidth").style.display='none';
            $G("imgheight").style.display='none';
            $G("decimaldigitsspan").style.display="none";
            
            $G("childfieldidSpan").style.display='none';
            showEle("ViewLines");;
        }else if(fieldhtmltypelist.value==9){
		  window.document.forms[0].textheight.style.display='none';	<!--xwj for @td2977 20051110 end-->
		  htmltypeedit.style.display='none';
		  lengthspan.style.display='';
			typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>';
			//lengthspan.css("display","inline-block");
			lengthspan.innerHTML='<%=SystemEnv.getHtmlLabelName(125581,user.getLanguage())%>';
            window.document.forms[0].strlength.value='';
			window.document.forms[0].strlength.style.display='';
			//if(form1.strlength.value==''||form1.strlength.value==0)
			//	strlengthspan.innerHTML='<IMG src="/images/BacoError_wev8.gif" align=absMiddle>';
			strlengthspan.style.display='';
			$G("selectdiv").style.display='none';
			$G("btnaddRow").style.display='none';
			$G("btnsubmitClear").style.display='none';
			jQuery("#specialhtmltype").selectbox("hide");
			jQuery("#filehtmltype").selectbox("hide");
			jQuery("#browsetbuttonype").selectbox("hide");
			htmltypelist = $G("selecthtmltype");
			htmltypelist.selectedIndex=0;
			htmltypelist.style.display='';			
			for(var count = htmltypelist.options.length - 1; count >= 0; count--)
				htmltypelist.options[count] = null;
			<%=locationtype%>
			bindSelectDate("htmltype");	
            cusbspan.style.display='none';
            sapbrowser.style.display='none';
            //zzl
            newsapbrowser.style.display='none';
            showimg.style.display='none';
            showinner.style.display='none';
            typeChange();
            $G("showprepspan_show").style.display = 'none';
            
			$G("decimaldigitsspan").style.display="none";
            $G("customlink").style.display='none';
            $G("descriptive").style.display='none';
            $G("childfieldNotesSpan").style.display='none';
            $G("showChildFieldBotton").style.display='none';            
            $G("imgwidthnamespan").style.display='none';
            $G("imgwidthspan").style.display='none';
            $G("imgheightnamespan").style.display='none';
            $G("imgheightspan").style.display='none';
            $G("imgwidth").style.display='none';
            $G("imgheight").style.display='none';
            $G("childfieldidSpan").style.display='none';
            
            hideEle("ViewLines");    
            
        }   
	}
    
    function BTCOpen(){
    		jQuery("#aaaaa").show();
			var btcspan = $("#browsetbuttonype_autoSelect");
			
            //清空已有BTC对象
            var btc = new BTC();

            var tempBtc;
            while(tempBtc = BTCArray.shift()){
              btcspan.find(".sbToggle").removeClass("sbToggle-btc-reverse")
              tempBtc.remove();
            }
            <%
            if (HrmUserVarify.checkUserRight("SysadminRight:Maintenance", user)){ 
            %>
    	    <%}%>
    	    
    	   
    	    //浏览框类型选择框处理
            btcspan.find(".sbToggle").addClass("sbToggle-btc");
            btcspan.find(".sbToggle").unbind("click");
            btcspan.find(".sbSelector").unbind("focus");
            btcspan.find(".sbSelector").unbind("click"); 
            btcspan.find(".sbSelector").unbind("blur");  
            btcspan.find(".sbSelector").css("font-size","12px");  
            btcspan.find(".sbSelector").css("text-indent","0");     
            btcspan.find(".sbSelector").bind("focus",function(){
				    if(btcspan.find(".sbToggle").hasClass("sbToggle-btc-reverse")){
				       if(BTCArray.length>0){
				       	btcspan.find(".sbToggle").trigger("click");
				       }
				    };
			});
			
			btcspan.find(".sbToggle").bind("click",function(){
			
			   if(btcspan.find(".sbToggle").hasClass("sbToggle-btc-reverse")){
               	  btc.remove();
			   }else{
			   	  
			   	  btc.init({
					  renderTo:btcspan,
				      headerURL:"/workflow/field/BTCAjax.jsp?action=queryHead&noneedtree=1",
					  contentURL:"/workflow/field/BTCAjax.jsp?action=queryContent&noneedtree=1",
					  contentHandler:function(value){
						    $("#browsetbuttonype").val(value);
						    $("#browsetbuttonype").trigger("change");
						    btc.remove();
						    $(".sbToggle-btc-reverse").removeClass("sbToggle-btc-reverse");
					  }
			  	  });  
			  	  
			  	  try{
			   	  	 $("#e8_autocomplete_div").hide();			
		          }catch(e){}
			   }
			   btcspan.find(".sbToggle").toggleClass("sbToggle-btc-reverse");
			});
			
			
    }    
   

    function setBTC(){
            var url = "/systeminfo/BrowserMain.jsp?url=/workflow/field/browsertypesetting.jsp?noneedtree=1";
            var dlg=new window.top.Dialog();//定义Dialog对象
			var title = "<%=SystemEnv.getHtmlLabelName(125117,user.getLanguage())%>";
			dlg.Width=550;//定义长度
			dlg.Height=600;
			dlg.URL=url;
			dlg.Title=title;
			dlg.show();
    }
	function typeChange(){
		jQuery('#selecthtmltypespan').hide();
		fieldhtmltypelist = window.document.forms[0].fieldhtmltype;
		var htmltypelist = $G("htmltype");
        var cusbspan=$G("cusbspan");
        var cusb=$G("cusb");
        var showprep=$G("showprep");
        var sapbrowser=$G("sapbrowser");
        var showprepspan_01=$G("showprepspan_show");
        
        //zzl
        var newsapbrowser=$G("newsapbrowser");
        var showimg=$G("showimg");
        var showinner=$G("showinner");
        var showvalue=$G("showvalue")
        var type2 = $G("srcType").value;
        
        if(fieldhtmltypelist.value==1){
			if(htmltypelist.value==1){
				lengthspan.innerHTML='<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>';
				window.document.forms[0].strlength.style.display='';
				if(form1.strlength.value==''||form1.strlength.value==0){
					strlengthspan.innerHTML='<IMG src="/images/BacoError_wev8.gif" align=absMiddle>';
				}
				strlengthspan.style.display='';
		        $G("decimaldigitsspan").style.display="none";
			}else if(htmltypelist.value==3){
				lengthspan.innerHTML='';
				cusbspan.style.display='none';		
				window.document.forms[0].strlength.style.display='none';
				strlengthspan.style.display='none';
				//jQuery("#decimaldigitsspan").css("display","block");
				$G("decimaldigitsspan").style.display="";
			}else if(htmltypelist.value==5){
				lengthspan.innerHTML='';
				cusbspan.style.display='none';		
				window.document.forms[0].strlength.style.display='none';
				strlengthspan.style.display='none';
				//jQuery("#decimaldigitsspan").css("display","block");
				$G("decimaldigitsspan").style.display="";	
			}else{
				lengthspan.innerHTML='';
				window.document.forms[0].strlength.style.display='none';
				strlengthspan.innerHTML='';
				strlengthspan.style.display='none';
				$G("decimaldigitsspan").style.display="none";
			}
		}
		if(fieldhtmltypelist.value==9){
			if(htmltypelist.value==1){
				lengthspan.innerHTML='';
				cusbspan.style.display='none';		
				window.document.forms[0].strlength.style.display='none';
				strlengthspan.style.display='none';
				//$G("locatetypespan").style.display="";
			}
		}
        if(fieldhtmltypelist.value==3){
            BTCOpen();
        	var htmltypelist = $G("browsetbuttonype");
        	//alert(htmltypelist.value);
        	if (htmltypelist.value == '') {
        		jQuery('#selecthtmltypespan').show();
        	}
			if(htmltypelist.value==161||htmltypelist.value==162){
				cusbspan.style.display='';
				if(cusb.value == 'browser.'){
                    cusb.value='';
                    jQuery('#cusbspan').find("#cusbspan").html("");
                    jQuery('#cusbspan').find("#cusbspanimg").html('<img align="absmiddle" src="/images/BacoError_wev8.gif">');
				}
				
				
			}else{
				cusb.value=''
				cusbspan.style.display='none';
				strlengthspan.innerHTML='';
				strlengthspan.style.display='none';
			}
			if(htmltypelist.value==224||htmltypelist.value==225){
				sapbrowser.style.display='';
				if(sapbrowser.value==''||sapbrowser.value==0){
					strlengthspan.innerHTML='<IMG src="/images/BacoError_wev8.gif" align=absMiddle>';
				}else
                    strlengthspan.innerHTML='';
				strlengthspan.style.display='';
			}else{
				sapbrowser.value=''
				sapbrowser.style.display='none';
				strlengthspan.innerHTML='';
				strlengthspan.style.display='none';
			}
			//zzl
			if(htmltypelist.value==226||htmltypelist.value==227){
				newsapbrowser.style.display='';
				showinner.style.display='';
				if(showvalue.value==''){
					//新建的状态下显示的图片
					showimg.innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
				}else
				{
                    showimg.innerHTML='';
                }
				showimg.style.display='';
			}else{
				newsapbrowser.value=''
				newsapbrowser.style.display='none';
				showimg.innerHTML='';
				//showvalue.value='';
				showimg.style.display='none';
				//showinner.innerHTML='';
				showinner.style.display='none';
			}
			
			
            if(htmltypelist.value==165||htmltypelist.value==166||htmltypelist.value==167||htmltypelist.value==168){
				showprepspan_01.style.display='';
			}else{
				//showprep,showprepspan非集成浏览按钮引起的错误
				showprepspan_01.style.display='none';
					
			}
		}
        if(fieldhtmltypelist.value==6){
        	var filevalue = jQuery("#filehtmltype").val();
			if(filevalue == 1){
                $G("imgwidthnamespan").style.display='none';
                $G("imgwidthspan").style.display='none';
                $G("imgheightnamespan").style.display='none';
                $G("imgheightspan").style.display='none';
                $G("imgwidth").style.display='none';
                $G("imgheight").style.display='none';
                
                lengthspan.innerHTML='';
                window.document.forms[0].strlength.style.display='none';
                window.document.forms[0].strlength.value='';
			}else{
				lengthspan.style.display='';
                lengthspan.innerHTML='<%=SystemEnv.getHtmlLabelName(24030,user.getLanguage())%>';
                window.document.forms[0].strlength.style.display='';
                window.document.forms[0].strlength.value='5';
                $G("imgwidth").value='100';
                $G("imgheight").value='100';
                $G("imgwidthnamespan").style.display='';
                $G("imgwidthspan").style.display='';
                $G("imgheightnamespan").style.display='';
                $G("imgheightspan").style.display='';
                $G("imgwidth").style.display='';
                $G("imgheight").style.display='';
                
                if(type2!="mainfield"){
                	window.document.forms[0].strlength.style.display='none';
                    window.document.forms[0].strlength.value='0';
                    lengthspan.style.display='none';
                    $G("imgwidth").value='50';
                    $G("imgheight").value='50';
                }
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
		}
	}


	function checkKey()
	{
	var keys=",PERCENT,PLAN,PRECISION,PRIMARY,PRINT,PROC,PROCEDURE,PUBLIC,RAISERROR,READ,READTEXT,RECONFIGURE,REFERENCES,REPLICATION,RESTORE,RESTRICT,RETURN,REVOKE,RIGHT,ROLLBACK,ROWCOUNT,ROWGUIDCOL,RULE,SAVE,SCHEMA,SELECT,SESSION_USER,SET,SETUSER,SHUTDOWN,SOME,STATISTICS,SYSTEM_USER,TABLE,TEXTSIZE,THEN,TO,TOP,TRAN,TRANSACTION,TRIGGER,TRUNCATE,TSEQUAL,UNION,UNIQUE,UPDATE,UPDATETEXT,USE,USER,VALUES,VARYING,VIEW,WAITFOR,WHEN,WHERE,WHILE,WITH,WRITETEXT,EXCEPT,EXEC,EXECUTE,EXISTS,EXIT,FETCH,FILE,FILLFACTOR,FOR,FOREIGN,FREETEXT,FREETEXTTABLE,FROM,FULL,FUNCTION,GOTO,GRANT,GROUP,HAVING,HOLDLOCK,IDENTITY,IDENTITY_INSERT,IDENTITYCOL,IF,IN,INDEX,INNER,INSERT,INTERSECT,INTO,IS,JOIN,KEY,KILL,LEFT,LIKE,LINENO,LOAD,NATIONAL,NOCHECK,NONCLUSTERED,NOT,NULL,NULLIF,OF,OFF,OFFSETS,ON,OPEN,OPENDATASOURCE,OPENQUERY,OPENROWSET,OPENXML,OPTION,OR,ORDER,OUTER,OVER,ADD,ALL,ALTER,AND,ANY,AS,ASC,AUTHORIZATION,BACKUP,BEGIN,BETWEEN,BREAK,BROWSE,BULK,BY,CASCADE,CASE,CHECK,CHECKPOINT,CLOSE,CLUSTERED,COALESCE,COLLATE,COLUMN,COMMIT,COMPUTE,CONSTRAINT,CONTAINS,CONTAINSTABLE,CONTINUE,CONVERT,CREATE,CROSS,CURRENT,CURRENT_DATE,CURRENT_TIME,CURRENT_TIMESTAMP,CURRENT_USER,CURSOR,DATABASE,DBCC,DEALLOCATE,DECLARE,DEFAULT,DELETE,DENY,DESC,DISK,DISTINCT,DISTRIBUTED,DOUBLE,DROP,DUMMY,DUMP,ELSE,END,ERRLVL,ESCAPE,";
	//以下for oracle.update by cyril on 2008-12-08 td:9722
	keys+="ACCESS,ADD,ALL,ALTER,AND,ANY,AS,ASC,AUDIT,BETWEEN,BY,CHAR,"; 
	keys+="CHECK,CLUSTER,COLUMN,COMMENT,COMPRESS,CONNECT,CREATE,CURRENT,";
	keys+="DATE,DECIMAL,DEFAULT,DELETE,DESC,DISTINCT,DROP,ELSE,EXCLUSIVE,";
	keys+="EXISTS,FILE,FLOAT,FOR,FROM,GRANT,GROUP,HAVING,IDENTIFIED,";
	keys+="IMMEDIATE,IN,INCREMENT,INDEX,INITIAL,INSERT,INTEGER,INTERSECT,";
	keys+="INTO,IS,LEVEL,LIKE,LOCK,LONG,MAXEXTENTS,MINUS,MLSLABEL,MODE,";
	keys+="MODIFY,NOAUDIT,NOCOMPRESS,NOT,NOWAIT,NULL,NUMBER,OF,OFFLINE,ON,";
	keys+="ONLINE,OPTION,OR,ORDER,PCTFREE,PRIOR,PRIVILEGES,PUBLIC,RAW,";
	keys+="RENAME,RESOURCE,REVOKE,ROW,ROWID,ROWNUM,ROWS,SELECT,SESSION,";
	keys+="SET,SHARE,SIZE,SMALLINT,START,SUCCESSFUL,SYNONYM,SYSDATE,TABLE,";
	keys+="THEN,TO,TRIGGER,UID,UNION,UNIQUE,UPDATE,USER,VALIDATE,VALUES,";
	keys+="VARCHAR,VARCHAR2,VIEW,WHENEVER,WHERE,WITH,";
    var fname=window.document.forms[0].fieldname.value;
	if (fname!="")
		{fname=","+fname.toUpperCase()+",";
	if (keys.indexOf(fname)>0)
		{
		top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(19946,user.getLanguage())%>');
		window.document.forms[0].fieldname.focus();
        return false;
	    }
		}
	return true;
	}
	function checksubmit(){
		fieldhtmltypelist = window.document.forms[0].fieldhtmltype;
		htmltypelist = $G("htmltype");
        if (!checkKey())  return false;
		if(fieldhtmltypelist.value==1){
			if(htmltypelist.value==1){
				if(form1.strlength.value==""||form1.strlength.value==0){
					top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
					return false;
				}
			}
		}
		if(fieldhtmltypelist.value==3){
			//if(htmltypelist.value==''){
			if(!$("#browsetbuttonype").val()){
				top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
					return false;
			}
			if($G("browsetbuttonype").value==161||$G("browsetbuttonype").value==162){
			     
				if($("#cusb").val()==""||$("#cusb").val()==0){
					top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
					return false;
				}
			}
			if($G("browsetbuttonype").value==224||$G("browsetbuttonype").value==225){
				if(form1.sapbrowser.value==""||form1.sapbrowser.value==0){
					top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
					return false;
				}
			}
			//zzl
			if($G("browsetbuttonype").value==226||$G("browsetbuttonype").value==227){
				var showvalue=document.getElementById("showvalue").value;
				if(showvalue==""){
					top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
					return false;
				}
			}
			
			if($G("browsetbuttonype").value==165||$G("browsetbuttonype").value==166||$G("browsetbuttonype").value==167||$G("browsetbuttonype").value==168){
				var showprep=document.getElementById("showprep").value;
				if(showprep==""){
					top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
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
    fieldhtmltype = window.document.forms[0].fieldhtmltype.value;
	htmltype = $G("htmltype").value;
    if(fieldhtmltype==6&&htmltype==2){
        $G(spanid).innerHTML='';
    }else{
	tmpvalue = $G(elementname).value;
	
	if(fieldhtmltype==6){ //qc150649 去掉上传附件的 必填符合
		if(spanid.indexOf("strlength")!=-1 || spanid.indexOf("imgwidth")!=-1 ||spanid.indexOf("imgheight")!=-1 ){
			return;
		}
	}

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
</script>
<script language="javascript">
//<!--xwj for td2977 20051118 begin-->
function submitData()
{
	if(check_form(form1,'subcompanyid')){ 
		if("<%=count_fields%>">999){
		    top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23037,user.getLanguage())%>");
		    return;
		}
		<!--xwj for td3131 20051118 begin-->
		var selectvalue = window.document.forms[0].fieldhtmltype.value;
		if (checksubmit()){
			<!--xwj for td3297 20051130 begin-->
			<%if("addfield".equals(type)){%>
				if(selectvalue == "5"){
					if(checkDefault()){
					    if (check_form(form1,'subcompanyid')){
					    	//对选择框中的欧元符号进行特殊处理
							for(var i=0; i<=rowindex; i++){
								var myObj = document.getElementById("field_"+i+"_name");
								if(myObj){
									myObj.value = dealSpecial(myObj.value);
								}
							}
					    	
						 	form1.submit();
							//enableAllmenu();
					    }
					}
				} else {
			        if (check_form(form1,'subcompanyid')){
						form1.submit();
						//enableAllmenu();
			        }
				}
			<%}else{%>
				var fieldhtmltype = <%=fieldhtmltype%>;
				if(fieldhtmltype==5){
					if(checkDefault()){
				        if (check_form(form1,'subcompanyid')){
				        	//对选择框中的欧元符号进行特殊处理
							for(var i=0; i<=rowindex; i++){
								var myObj = document.getElementById("field_"+i+"_name");
								if(myObj){
									myObj.value = dealSpecial(myObj.value);
								}
							}
				        	
						 	form1.submit();
							//enableAllmenu();
				        }
					}
				} else {
			        if (check_form(form1,'subcompanyid')){
						form1.submit();
						//enableAllmenu();
			        }
				}
			<%}%>
			<!--xwj for td3297 20051130 end-->
	
		}
		<!--xwj for td3131 20051118 end-->
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

function checkDefault(){
	var tempcount = 0;
	for(i=0;i<rowindex;i++){
		if($G("field_checked_"+i+"_name")){
			var value = $G("field_checked_"+i+"_name").checked;
			if(value){
				tempcount = tempcount + 1;
			}
		}
	}
	if(tempcount > 1){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83539, user.getLanguage())%>!");
		return false;
	} else {
	//deleted by xwj for td3297 20051130
		return true;
	}
}
<!--xwj for td2977 20051118 end-->

function submitClear()
{
	//检查是否选中要删除的数据项
	var flag = false;
	var col = document.getElementsByName("check_select");
	for(var i = 0; i<col.length; i++){
		if(col[i] && col[i].checked){
			flag = true;
			break;
		}
	}
	if(flag){
		//if (isdel()){
		//	deleteRow1();
		//}
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
			deleteRow1();
		}, function () {}, 320, 90,true);	
	} else {
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");
		return false;
	}
}

function onShowCatalog(choicerowindex){
    var url="";
	var isAccordToSubCom=0;	
	if(document.getElementById("isAccordToSubCom"+choicerowindex)!=null){
		if(document.getElementById("isAccordToSubCom"+choicerowindex).checked){
			isAccordToSubCom=1;
		}
	}

	if(isAccordToSubCom==1){
		url=onShowCatalogSubCom(choicerowindex);
	}else{
		url=onShowCatalogHis(choicerowindex);
	}
	return url;
}
function afterSelect(e,rt,name,choicerowindex){
var docsec=rt.mainid+","+rt.subid+","+rt.id ;
jQuery("input[name=maincategory_"+choicerowindex+"]").val(docsec);	
jQuery("input[name=pathcategory"+choicerowindex+"]").val(jQuery("span[name=maincategory"+choicerowindex+"span]").text() );

}
function onShowCatalogHis(choicerowindex) {	
	   
	 return "/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp";   





}

function onShowCatalogSubCom(index) {



if (jQuery( "#selectvalue"+index).length>0)  {
	var selectvalue=document.getElementById("selectvalue"+index).value;
    return "/systeminfo/BrowserMain.jsp?url=/docs/field/SubcompanyDocCategoryBrowser.jsp?fieldId=<%=fieldid%>&isBill=1&selectValue="+selectvalue;
}else{
 jQuery("#openrownum").val(index);
 submitData();
  return;
}
	
}


//浏览按钮 下拉框选项按照字母顺序排序
function sortRule(a,b) {
	var x = a._text;
	var y = b._text;
	return x.localeCompare(y);
}
function op(){
	var _value;
	var _text;
}
function sortOption(){
	var obj = $G("browsetbuttonype");
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
if("<%=fieldhtmltype%>"=="3") {
   //sortOption();
}
</script>

<script type="text/javascript">
//<!--

function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.html("<a href='" + curl+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>");
			} else {
				spanobj.html(wuiUtil.getJsonValueByIndex(id, 1));
			}
			inputobj.val(wuiUtil.getJsonValueByIndex(id, 0));
		} else {
			spanobj.html(need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "");
			inputobj.val("");
		}
	}
}

function onShowSubcompany() {
	url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&selectedids=" + $G("subcompanyid").value;
	disModalDialog(url, $("#subcompanyspan"), $("#subcompanyid"), true,"#");
}


function onShowChildField(spanname, inputname) {
	var url = "/systeminfo/BrowserMain.jsp?url=" + escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5<%if(fieldid!=0){out.print(" and id<>"+fieldid+" ");}%>&isdetail=<%=isdetail%>&isbill=0");
	disModalDialog(url, $("#"+spanname), $("#"+inputname), false,"#");
}

//qyw 2014-5-12 修改弹出页面显示方式
function onShowChildField_new() {
	var url = "/systeminfo/BrowserMain.jsp?url=" + escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5<%if(fieldid!=0){out.print(" and id<>"+fieldid+" ");}%>&isdetail=<%=isdetail%>&isbill=0");
	return url;
}


function onShowChildSelectItem(spanname, inputname) {
	var cfid = $G("childfieldid").value;
	var resourceids = $G(inputname).value;
	
	var url = "/systeminfo/BrowserMain.jsp?url=" + escape("/workflow/field/SelectItemBrowser.jsp?isbill=0&isdetail=<%=isdetail%>&childfieldid=" + cfid + "&resourceids=" + resourceids);
	var id = showModalDialog(url);
	if (id != null) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if (rid != "") {
			var resourceids = rid.substr(1);
			var resourcenames = rname.substr(1);
			if(resourcenames.length > 8){
				resourcenames = resourcenames.substr(0,8)+"...";
			}			
			$G(inputname).value = resourceids;
			$G(spanname).innerHTML = resourcenames;
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
		}
	}
}


function bindSelectDate(name){
    $("select[name="+name+"]").selectbox("detach");
    $("select[name="+name+"]").selectbox("attach");
}					


function onShowFormSelect_1(inputname){
   	var cfid = $G("selectCategory").value;
	//var resourceids = $G(inputname).value;
	//var url = "/systeminfo/BrowserMain.jsp?url=" + escape("/workflow/field/SelectItemBrowser.jsp?isbill=0&isdetail=<%=isdetail%>&childfieldid=" + cfid + "&resourceids=" + resourceids);
	var url = "/systeminfo/BrowserMain.jsp?url=" + escape("/workflow/field/SelectItemBrowser.jsp?isbill=0&isdetail=<%=isdetail%>&childfieldid=" + cfid + "&resourceids=");
   	return url;
}

 //browsertype 下拉框选项按照字母顺序排序
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
//	var obj = document.getElementById(objid);
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

jQuery(function ()  {
	var sltval = $G("browsetbuttonype").value;
	sortOption($G("browsetbuttonype"));
	<%if(fieldhtmltype.equals("6")){%>
		jQuery("#selecthtmltype").selectbox("hide");
		//jQuery("#filehtmltype").selectbox("hide");
		jQuery("#specialhtmltype").selectbox("hide");
		jQuery("#browsetbuttonype").selectbox("hide");
	<%}else if(fieldhtmltype.equals("7")){%>
		jQuery("#selecthtmltype").selectbox("hide");
		jQuery("#filehtmltype").selectbox("hide");
		jQuery("#browsetbuttonype").selectbox("hide");
		//jQuery("#specialhtmltype").selectbox("hide");
		
	<%}else if(fieldhtmltype.equals("3")){%>
		jQuery("#selecthtmltype").selectbox("hide");
		jQuery("#specialhtmltype").selectbox("hide");
		jQuery("#filehtmltype").selectbox("hide");
		<%if(!isused.equals("true")){%>
		  BTCOpen();
		<%}%>
		//jQuery("#browsetbuttonype").selectbox("hide");
	<%}else{%>
		jQuery("#filehtmltype").selectbox("hide");
		jQuery("#specialhtmltype").selectbox("hide");
		jQuery("#browsetbuttonype").selectbox("hide");
	<%}%>
	jQuery("#browsetbuttonype option[value='" + sltval + "']").attr("selected", true);

});
//-->
</script>
<script type="text/javascript">
$(function(){
	$("#zd_btn_submit").val("<%=save%>");
	$("#menu").attr("title", "<%=menu%>");
})
if("<%=openrownum%>">=0){
jQuery("#maincategory<%=openrownum%>_browserbtn").click();  

}


function showChildSelectItem(choicerowindex){
    var cfid = $G("childfieldid").value;
    var resourceids = jQuery("#childItem" + choicerowindex).val();
    var url= "/systeminfo/BrowserMain.jsp?url=" + escape("/workflow/field/SelectItemBrowser.jsp?isbill=0&isdetail=<%=isdetail%>&childfieldid=" + cfid + "&resourceids=" + resourceids);
    
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
<script language="javascript" src="/wui/theme/ecology8/jquery/js/e8_btn_addOrdel_wev8.js"></script>
<script language="javascript" src="/js/browsertypechooser/btc_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/js/browsertypechooser/browserTypeChooser_wev8.css">
</body>
</html>
