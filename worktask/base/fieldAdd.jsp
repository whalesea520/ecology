
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.lang.*" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.general.StaticObj" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="session"/>
<jsp:useBean id="FieldManager" class="weaver.workflow.field.FieldManager" scope="session"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />

<jsp:useBean id="mainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="subCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="secCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<%
int rowsum=0;
String type="";
String wttype="";
int wtid = Util.getIntValue(Util.null2String(request.getParameter("wtid")),0);
	String fieldname="";
	String fielddbtype="";
	String description="";//xwj for td2977 20051107
	int textheight=4;//xwj for @td2977 20051107
	String fieldhtmltype="";
	int htmltypeid=0;
	String textlength="";
	int fieldid=0;
	fieldid=Util.getIntValue(Util.null2String(request.getParameter("fieldid")),0);



	/* -------------- xwj for td2977 20051107 begin-------------------*/
  // delete by xwj for td3297 20051201
	/* -------------- xwj for td2977 20051107 end-------------------*/

  //add by xhheng @ 20041213 for TDID 1230
  String isused="";
  isused=Util.null2String(request.getParameter("isused"));

	String message = Util.null2String(request.getParameter("message"));

	type = Util.null2String(request.getParameter("src"));
	wttype = Util.null2String(request.getParameter("wttype"));

	int operatelevel=2;

	if(type.equals("")){
		type = "addfield";
	}
	if(!type.equals("addfield"))
	{
		rs.execute("select * from worktask_fielddict where id="+fieldid);
		if(rs.next()){
			fieldname = Util.null2String(rs.getString("fieldname"));
			fielddbtype = Util.null2String(rs.getString("fielddbtype"));
			fieldhtmltype = Util.null2String(rs.getString("fieldhtmltype"));
			htmltypeid = Util.getIntValue(rs.getString("type"));
			description = Util.null2String(rs.getString("description"));
			textheight = Util.getIntValue(rs.getString("textheight"), 0);
			if(fieldhtmltype.equals("1")&&htmltypeid==1){
				if(RecordSet.getDBType().equals("oracle")){
					textlength = fielddbtype.substring(9,fielddbtype.length()-1);
				}else{
					textlength = fielddbtype.substring(8,fielddbtype.length()-1);
				}
			}
		}
	}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";


if(type.equals("addfield")){
	titlename+=SystemEnv.getHtmlLabelName(82,user.getLanguage())+":";
	if(wttype.equals("1")){
		titlename+=SystemEnv.getHtmlLabelName(21932,user.getLanguage());
	}else if(wttype.equals("2")){
		titlename+=SystemEnv.getHtmlLabelName(21935,user.getLanguage());
	}else{
		titlename+=SystemEnv.getHtmlLabelName(21936,user.getLanguage());
	}
}else{
	titlename+=SystemEnv.getHtmlLabelName(93,user.getLanguage())+":";
	if(wttype.equals("1")){
		titlename+=SystemEnv.getHtmlLabelName(21932,user.getLanguage());
	}else if(wttype.equals("2")){
		titlename+=SystemEnv.getHtmlLabelName(21935,user.getLanguage());
	}else{
		titlename+=SystemEnv.getHtmlLabelName(21936,user.getLanguage());
	}
}

String texttype="htmltypelist.options[0]=new Option('"+SystemEnv.getHtmlLabelName(608,user.getLanguage())+"',1);"+"\n"+
		"htmltypelist.options[1]=new Option('"+SystemEnv.getHtmlLabelName(696,user.getLanguage())+"',2);"+"\n"+
		"htmltypelist.options[2]=new Option('"+SystemEnv.getHtmlLabelName(697,user.getLanguage())+"',3);"+"\n";
		//"htmltypelist.options[3]=new Option('"+SystemEnv.getHtmlLabelName(18004,user.getLanguage())+"',4);"+"\n";//xwj for td3131 20051117
String specialtype="htmltypelist.options[0]=new Option('"+SystemEnv.getHtmlLabelName(21692,user.getLanguage())+"',1);"+"\n"+
		"htmltypelist.options[1]=new Option('"+SystemEnv.getHtmlLabelName(21693,user.getLanguage())+"',2);"+"\n";
String browsertype="";
String browserlabelid="";
int i=0;
while(BrowserComInfo.next()){
	browsertype+="htmltypelist.options["+i+"]=new Option('"+
		SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),user.getLanguage())+
		"',"+BrowserComInfo.getBrowserid()+");"+"\n";
	i++;
}
BrowserComInfo.setToFirstrow();

%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>





<%
boolean tof = false;

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:parentDialog.close(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="worktask"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="submitData()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form name="form1" method="post" action="fieldOperation.jsp" >
   <input type="hidden" value="<%=type%>" name="src">
   <input type="hidden" value="<%=wttype%>" name="wttype">
   <input type="hidden" value="<%=fieldid%>" name="fieldid">
   <input type="hidden" value="<%=isused%>" name="isused">
   <input type="hidden" value="<%=wtid%>" name="wtid">
   <%
  if(!type.equals("addfield"))
	{
	if("2".equals(fieldhtmltype) || "4".equals(fieldhtmltype) || "5".equals(fieldhtmltype) || "6".equals(fieldhtmltype) || "7".equals(fieldhtmltype)){%>
	 <input type="hidden" value="<%=htmltypeid%>" name="htmltype">
	<%}

	}


	%>

<wea:layout type="2col">
  <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' >
    <wea:item attributes="{'colspan':'full','isTableList':'true'}">
   <table class="ListStyle"  >
   <COLGROUP>
   <COL width="15%">
   <COL width="25%">
   <COL width="30%">
   <COL width="30%">
   <TR class="header">
		  <TH colSpan=6><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%>
		  <%
			  String tmpStr = "";
		if(message.equals("1")){
			tmpStr = "<font color=red>"+SystemEnv.getHtmlLabelName(15440,user.getLanguage())+"!</font>";
		}else if(message.equals("2")){
			tmpStr = "<font color=red>"+SystemEnv.getHtmlLabelName(324,user.getLanguage())+"</font>";
		}
		  %>
		  <%=tmpStr%>
		  </TH></TR>


  <tr class="DataDark">
	<td><%=SystemEnv.getHtmlLabelName(23241,user.getLanguage())%></td>
	<%if(operatelevel>0){%>
	<td   colspan=3>
	<%if(isused.equals("true")){%>
	<input type="hidden" value="<%=Util.toScreenToEdit(fieldname,user.getLanguage())%>" name="fieldname">
	<%=Util.toScreenToEdit(fieldname,user.getLanguage())%>
	<%}else{%>
	<input class=Inputstyle type="text" name="fieldname" size="40" maxlength="30" value="<%=Util.toScreenToEdit(fieldname,user.getLanguage())%>"	onBlur='checkinput_char_num("fieldname");checkinput("fieldname","fieldnamespan");checkSystemField("fieldname","fieldnamespan","<%=wttype%>")'>
	<span id=fieldnamespan><%if(fieldname.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
	   <SPAN style="cursor: pointer;">
			 <IMG src="/wechat/images/remind_wev8.png" align=absMiddle title="<%=SystemEnv.getHtmlLabelName(15441,user.getLanguage())%>,<%=SystemEnv.getHtmlLabelName(19881,user.getLanguage())%>,<%=SystemEnv.getHtmlLabelName(21998,user.getLanguage())%>">
	   </SPAN>
	<%}%>
	</td>
	<%}%>
  </tr>


  <!--xwj for td2977 20051107 begin-->
  <tr class="DataDark">
	<td><%=SystemEnv.getHtmlLabelName(30828,user.getLanguage())%></td>
	<%if(operatelevel>0){%>
	<td  colspan=3><input class=Inputstyle type="text" name="description" size="40" value="<%=description%>"></td>
	<%} else {%>
	<td   colspan=5><%=Util.toScreen(description,user.getLanguage())%></td><%}%>
  </tr>
 
<!--xwj for td2977 20051107 end-->

  <tr class="DataDark">
	<td><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%></td>
	<td  >
	<%if(operatelevel>0){%>
	<!-- modify by xhheng @ 20041222 for TDID 1230-->
	<%if(isused.equals("true")){%>
	  <input type="hidden" value="<%=fieldhtmltype%>" name="fieldhtmltype">
	  <select class=inputstyle  size="1" name="fieldhtmltype" onChange="showType()" disabled>
	<%}else{%>
	  <select class=inputstyle  size="1" name="fieldhtmltype" onChange="showType()" >
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
	<!--<option value="6" <%if(fieldhtmltype.equals("6")){%> selected<%}%>>
		<%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%></option>
	--></select>
	</td>
		<%
		//System.out.println("fieldhtmltype======="+fieldhtmltype);
		if(fieldhtmltype.equals("")){%>
		  <td  >
		    <BUTTON class="addbtn" type=button   id=btnaddRow style="display:none" name=btnaddRow onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></BUTTON>
	        <BUTTON class="delbtn" type=button  id=btnsubmitClear style="display:none" name=btnsubmitClear onclick="submitClear()" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></BUTTON>
			 <span id=typespan><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>
			 <select class=inputstyle style="width:120px"  size=1 name=htmltype id=selecthtmltype onChange="typeChange()">
			 	<option value="1"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
			 	<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
			 	<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
			 	<!-- <option value="4"><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option> --><!--xwj for td3131 20051115-->
			 </select>
			 <input type="text" value="<%=textheight%>" name="textheight" maxlength=2 size=4 onKeyPress="ItemCount_KeyPress()" class=Inputstyle style=display:none><!--xwj for @td2977 20051110 -->
		  </td>
		  <td  >
			 <span id=lengthspan><%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%></span>
			 <input class=Inputstyle type=input size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
			 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>">
			 

			 <select style="display:none" style="width:120px" class=inputstyle  name=cusb id=cusb onChange="typeChange()">
			 <option value=''></option>
			 	<%

				 List l=StaticObj.getServiceIds(Browser.class);
				 //System.out.println(l.size());
				 for(int j=0;j<l.size();j++){
				%>
				<option value=<%=l.get(j)%>><%=l.get(j)%></option>
				 <%}%>
			 </select>
			 <span id=showprepspan style="display:none" ><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage())%></span>
			 <select style="display:none" class=inputstyle  name=showprep id=showprep onChange="typeChange()" >
				 <option value='1' selected><%=SystemEnv.getHtmlLabelName(18916,user.getLanguage())%></option>
				 <option value='2' ><%=SystemEnv.getHtmlLabelName(18919,user.getLanguage())%></option>
			 </select> 
			 <span id=strlengthspan><%if(textlength.equals("")||textlength.equals("0")){%>
			 <IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
		  </td>
		<%}
		if(fieldhtmltype.equals("1")){%>
		   <td  >
			 <BUTTON class="addbtn" type=button   id=btnaddRow style="display:none" name=btnaddRow onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></BUTTON>
	        <BUTTON class="delbtn" type=button  id=btnsubmitClear style="display:none" name=btnsubmitClear onclick="submitClear()" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></BUTTON>
			 <span id=typespan><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>
			 <input type="text" name="textheight" maxlength=2 size=4 onKeyPress="ItemCount_KeyPress()" class=Inputstyle style=display:none><!--xwj for @td2977 20051110 -->
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
			 	<!-- <option value="4" <%if(htmltypeid==4){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option> --><!--xwj for td3131 20051115-->
			 </select>
		   </td>
		  <%if(htmltypeid==1){%>
		   <td >
			 <span id=lengthspan><%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%></span>
			 <input class=Inputstyle type=input size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
			 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>">
			 <span id=strlengthspan><%if(textlength.equals("")||textlength.equals("0")){%>
			 <IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
		   </td>
		  <%} else {%>
		   <td ><span id=lengthspan></span>
			 <input type=input  class=Inputstyle style=display:none size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
			 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>">
			 <span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
			 <IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
		   </td><%}%>
		<%}
		if(fieldhtmltype.equals("3")){%>
		   <td >
			<BUTTON class="addbtn" type=button   id=btnaddRow style="display:none" name=btnaddRow onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></BUTTON>
	        <BUTTON class="delbtn" type=button  id=btnsubmitClear style="display:none" name=btnsubmitClear onclick="submitClear()" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></BUTTON>
			 <span id=typespan><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>
			 <input type="text"  name="textheight" maxlength=2 size=4 onKeyPress="ItemCount_KeyPress()" class=Inputstyle style=display:none><!--xwj for @td2977 20051110 -->
		   <!-- modify by xhheng @ 20041222 for TDID 1230 start-->
		   <!-- 因为浏览按钮随类型不同而采用不同的数据类型，故已使用后，其类型也禁止转换-->
		  <%String browserid="";%>
		  <%if(isused.equals("true")){%>
			<select class=inputstyle  size=1 name=htmltype id=selecthtmltype onChange="typeChange()" disabled>
		  <%}else{%>
			<select class=inputstyle  size=1 name=htmltype id=selecthtmltype onChange="typeChange()">
		  <%}%>
			 <%while(BrowserComInfo.next()){%>
			 	<option value="<%=BrowserComInfo.getBrowserid()%>" <%if(BrowserComInfo.getBrowserid().equals(htmltypeid+"")){%> selected <%}%>>
			 		<%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
			  <%if(BrowserComInfo.getBrowserid().equals(htmltypeid+"") && isused.equals("true")) {
				browserid=BrowserComInfo.getBrowserid();
			  }%>
			 <%}%>
		   <%if(isused.equals("true")){%>
			<input type="hidden" value="<%=browserid%>" name="htmltype">
		   <%}%>
		   <!-- modify by xhheng @ 20041222 for TDID 1230 end-->
			 </select>
		   </td>
		   <td ><span id=lengthspan></span>
			 <input  class=Inputstyle type=input style="display:none" size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
			 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>">
			 <span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
			 <IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
			 <select style="width:120px;" <%if(htmltypeid!=161&&htmltypeid!=162){%>style="display:none;"<%}%> class=inputstyle  name=cusb id=cusb onChange="typeChange()"  <%if(isused.equals("true")){%>disabled<%}%>>
			 <option value=''></option>
			 	<%

				 List l=StaticObj.getServiceIds(Browser.class);
				 //System.out.println(l.size());
				 for(int j=0;j<l.size();j++){
				%>
				<option value=<%=l.get(j)%> <%if(fielddbtype.equals(l.get(j))){%>selected<%}%>><%=l.get(j)%></option>
				 <%}%>
			 </select>
			 <span id=showprepspan <%if(htmltypeid!=165&&htmltypeid!=166&&htmltypeid!=167&&htmltypeid!=168){%>style="display:none"<%}%> ><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage())%></span>
			 <select <%if(htmltypeid!=165&&htmltypeid!=166&&htmltypeid!=167&&htmltypeid!=168){%>style="display:none"<%}%> class=inputstyle  name=showprep id=showprep onChange="typeChange()" >
				 <option value='1' <%if(textheight==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18916,user.getLanguage())%></option>
				 <option value='2' <%if(textheight==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18919,user.getLanguage())%></option>
			 </select>
			 <%if(isused.equals("true")){%>
			<input type="hidden" value="<%=fielddbtype%>" name="cusb">
		   <%}%>
			 </td>
		<%}
	  if(fieldhtmltype.equals("4")){//xwj for @td2977 begin%>
	  		<BUTTON class="addbtn" type=button   id=btnaddRow style="display:none" name=btnaddRow onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></BUTTON>
	        <BUTTON class="delbtn" type=button  id=btnsubmitClear style="display:none" name=btnsubmitClear onclick="submitClear()" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></BUTTON>
		   <td ><span id=typespan></span>
		   <select class=inputstyle  style=display:none size=1 name=htmltype id=selecthtmltype onChange="typeChange()"></select>
		   </td>
		   <td ><span id=lengthspan></span>
		   	<input  class=Inputstyle type=input style="display:none" size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
			 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>">
		   	<span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
				<IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
		   </td>
		   <input type="text" name="textheight" maxlength=2 size=4 onKeyPress="ItemCount_KeyPress()" class=Inputstyle style=display:none><!--xwj for @td2977 20051110 -->
		<%}

			/*-- xwj for @td2977 begin--- */
		if(fieldhtmltype.equals("2")){%>
		   <td >
		   <BUTTON class="addbtn" type=button   id=btnaddRow style="display:none" name=btnaddRow onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></BUTTON>
	        <BUTTON class="delbtn" type=button  id=btnsubmitClear style="display:none" name=btnsubmitClear onclick="submitClear()" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></BUTTON>
		   <span id=typespan><%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%></span>
			 <select class=inputstyle  size=1 name=htmltype id=selecthtmltype style="display:none" onChange="typeChange()">
			<option value="1"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
			<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
			<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
			<!-- <option value="4"><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option> --><!--xwj for td3131 20051115-->
			 </select>
			 <input type="text" value="<%=textheight%>" name="textheight" maxlength=2 size=4 onKeyPress="ItemCount_KeyPress()" class=Inputstyle>
		</td>

		   <td ><span id=lengthspan></span>
		   	<input  class=Inputstyle type=input style=display:none size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
			 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>">
		   	<span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
				<IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
		   </td>
		<%}
		/*-- xwj for @td2977 end--- */

		if(fieldhtmltype.equals("5")){%>
		   <td >
		   <BUTTON class="addbtn" type=button   id=btnaddRow   name=btnaddRow onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></BUTTON>
	        <BUTTON class="delbtn" type=button  id=btnsubmitClear  name=btnsubmitClear onclick="submitClear()" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></BUTTON>
		   <span id=typespan></span>
		   <select class=inputstyle  style=display:none size=1 id=selecthtmltype name=htmltype onChange="typeChange()">
		   <option value="1"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
			<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
			<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
			<!-- <option value="4"><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option> -->
		   </select>
		   <input type="text"  name="textheight" maxlength=2 size=4 onKeyPress="ItemCount_KeyPress()" class=Inputstyle style=display:none><!--xwj for @td2977 20051110 -->
		   </td>
		   <td ><span id=lengthspan></span>
		   	<input   type=input class="InputStyle" style=display:none size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
			 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>">
		   	<span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
				<IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
		   </td>
		<%}
		if(fieldhtmltype.equals("6")){%>
		  <td >
		  <BUTTON class="addbtn" type=button   id=btnaddRow style="display:none" name=btnaddRow onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></BUTTON>
	        <BUTTON class="delbtn" type=button  id=btnsubmitClear style="display:none" name=btnsubmitClear onclick="submitClear()" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></BUTTON>
		   <span id=typespan></span>
		   <select class=inputstyle  style=display:none size=1 id=selecthtmltype name=htmltype onChange="typeChange()">
		   </select>
		   <input type="text"  name="textheight" maxlength=2 size=4 onKeyPress="ItemCount_KeyPress()" class=Inputstyle style=display:none><!--xwj for @td2977 20051110 -->
		   </td>
		   <td ><span id=lengthspan></span>
		   	<input   type=input class="InputStyle" style=display:none size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
			 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>">
		   	<span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
				<IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
		   </td>
		<%}
		if(fieldhtmltype.equals("7")){%>
		   <td >
		   <BUTTON class="addbtn" type=button   id=btnaddRow style="display:none" name=btnaddRow onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></BUTTON>
	        <BUTTON class="delbtn" type=button  id=btnsubmitClear style="display:none" name=btnsubmitClear onclick="submitClear()" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></BUTTON>
		   <span id=typespan><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>
		   <select class=inputstyle  style=display:'' size=1 id=selecthtmltype name=htmltype onChange="typeChange()" <%if(isused.equals("true")){%>disabled<%}%>>
			<option value="1" <%if(htmltypeid==1) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
			<option value="2" <%if(htmltypeid==2) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></option>
		   </select>
		   <input type="text"  name="textheight" maxlength=2 size=4 onKeyPress="ItemCount_KeyPress()" class=Inputstyle style=display:none>
		   </td>
		   <td ><span id=lengthspan></span>
		   	<input   type=input class="InputStyle" style=display:none size=10 maxlength=3 name="strlength" onChange="checklength('strlength','strlengthspan')"
			 	onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=textlength%>">
		   	<span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
				<IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
		   </td>
		<%}
	} else {%>
		<%if(fieldhtmltype.equals("1")){%><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%><%}%>
		<%if(fieldhtmltype.equals("2")){%><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%><%}%>
		<%if(fieldhtmltype.equals("3")){%><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%><%}%>
		<%if(fieldhtmltype.equals("4")){%><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%><%}%>
		<%if(fieldhtmltype.equals("5")){%><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%><%}%>
	</td><TD class = field colspan = 3></TD>
	<%}%>
  </tr>
 
  <tr>
  	<td style="padding:0px;" colspan=4>
  	<div id=selectdiv <%if(fieldhtmltype.equals("5")){%>style="display:''" <%} else {%>style="display:none"<%}%>>
  	  <table class="ListStyle" id="oTable" cols=5 border=0 style="margin-bottom: 50px !important">
  	  <col width=8%><col width=40%><col width=52%>
  	   	<tr class="header">
  	   		<td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
  	   		<td><%=SystemEnv.getHtmlLabelName(15442,user.getLanguage())%></td>
  	   		<td><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></td>
  	   	</tr>
		
  	   	<%if(fieldid==0){%>
  	   	<tr  class="DataDark">
  	   	   	<td height="23" width=10%><input type='checkbox' name='check_select' value="<%=rowsum%>" ></td>
		   	<td>
		   	<input type=text class=Inputstyle name="field_<%=rowsum%>_name" style="width=95%" size="25" onchange="checkinput('field_<%=rowsum%>_name','field_<%=rowsum%>_span')">
		   		<!--xwj for td2977 20051107 begin-->
		   	<span id="field_<%=rowsum%>_span"><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span></td>
			<td><input class='InputStyle' type='text' size='25' name='field_count_<%=rowsum%>_name' maxlength='4' style='width=90%' value = '0' onKeyPress="ItemCount_KeyPress_self()" onchange="checkNumber_self(this)"></td>
		 <!--xwj for td2977 20051107 end-->

		</tr>
		<%}
		else{
		int colorcount=0;
			String sql="select * from worktask_SelectItem where fieldid="+fieldid+" order by selectvalue";
			RecordSet.executeSql(sql);
			while(RecordSet.next()){
				String selectname=RecordSet.getString("selectname");
				String selectvalue=RecordSet.getString("selectvalue");
				String orderid=RecordSet.getString("orderid");//xwj for td2977 20051107
				String selectid=RecordSet.getString("id");//xwj for td3286 20051129

if(colorcount==0){
		colorcount=1;
%>
<TR  class="DataDark">
<%
	}else{
		colorcount=0;
%>
<TR  >
	<%
	}
	%>
			<td  height="23" width=10%>
			<input <% if(tof) out.println("disabled");%> type='checkbox' name='check_select' value="<%=selectvalue%>" ></td>
			<td >
			<input <% if(tof) out.println("disabled");%>  class=Inputstyle type=text name="field_<%=rowsum%>_name"
			value="<%=Util.toScreen(selectname,user.getLanguage())%>" style="width=95%"
			onchange="checkinput('field_<%=rowsum%>_name','field_<%=rowsum%>_span')">
			<input type="hidden" value="<%=selectid%>" name="field_id_<%=rowsum%>_name"><!--added by xwj for td3286 20051129-->
			<span id="field_<%=rowsum%>_span"></span></td>
			<td><input <% if(tof) out.println("disabled");%> class='InputStyle' type='text' size='25' maxlength='4' name='field_count_<%=rowsum%>_name' style='width=90%' value = '<%=orderid%>' onKeyPress="ItemCount_KeyPress_self()"  onchange="checkNumber_self(this)"></td>
		</tr>
		<%	rowsum++;
			}%>

		<%}%>

	  </table>
	</div> 

	</td> <%if(!(operatelevel>0)) out.println("<TD class = field ></TD>");%>
  </tr>

<%
rowsum+=1;
%>
 

</table>

 		</wea:item>
	</wea:group>
</wea:layout>


 <div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			    <wea:item type="toolbar">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentDialog.close();">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>

<input type="hidden" value="0" name="selectsnum">
<input type="hidden" value="" name="delids">
</form>
<script language="JavaScript" src="/js/addRowBg_wev8.js" >
</script>
<script>
	
	function checkSystemField(name,spanname,type){
		var fieldname = document.all(name).value;
		var fieldtype = type;
		if(fieldtype=="mainfield"){
			if(fieldname=="requestid"||fieldname=="billformid"||fieldname=="billid"){
				window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(21763,user.getLanguage())%>');
				document.all(name).value = "";
				document.all(spanname).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			}
		}else if(fieldtype=="detailfield"){
			if(fieldname=="requestid"||fieldname=="id"||fieldname=="groupId"){
				window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(21764,user.getLanguage())%>');
				document.all(name).value = "";
				document.all(spanname).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			}
		}
	}
	
rowindex = "<%=rowsum%>";
delids = "";
var rowColor="" ;
function addRow()
{
  //rowColor = getRowBg();
    rowColor = "";
	ncol = jQuery("#oTable").find("tr:first").find("td").length;
	oRow = oTable.insertRow(-1);
	oRow.setAttribute("class", "DataDark"); 
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

				<%--xwj for td2977 20051107 begin--%>
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text' size='25' name='field_"+rowindex+"_name' style='width=95%'"+
							" onchange=checkinput('field_"+rowindex+"_name','field_"+rowindex+"_span')>"+
							" <span id='field_"+rowindex+"_span'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = " <input class='InputStyle' type='text' size='25' maxlength='4' value = '0' name='field_count_"+rowindex+"_name' style='width=90%'"+
							" onKeyPress=\"ItemCount_KeyPress_self()\" onchange=\"checkNumber_self(this)\">";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;

				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
				<%--xwj for td2977 20051107 end--%>

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
function ItemCount_KeyPress_self()
{
 if(!((window.event.keyCode>=48) && (window.event.keyCode<=57)))
  {
     window.event.keyCode=0;
  }
}
function checkNumber_self(obj){
	var ordervalue_tmp = obj.value;
	if(ordervalue_tmp!=null && ordervalue_tmp!=""){
		if(ordervalue_tmp.indexOf("0") == 0){
			obj.value = ordervalue_tmp.substring(1);
		}
		ordervalue_tmp = obj.value;
		var objvalue_new = "";
		var objvalue_length = ordervalue_tmp.length;
		for(var i=0; i<objvalue_length; i++){
			var objvalue_1 = ordervalue_tmp.substring(i,i+1);
			if(!isNaN(objvalue_1)){
				objvalue_new += objvalue_1;
			}
		}
		obj.value = objvalue_new;
	}
}
</script>
<script language=javascript>
	function showType(){
		fieldhtmltypelist = window.document.forms[0].fieldhtmltype;
		htmltypelist = jQuery("#htmltype");
		cusb=document.getElementById("cusb");
		<!--xwj for @td2977 20051110 begin-->
		if(fieldhtmltypelist.value==4 || fieldhtmltypelist.value==6){
		  window.document.forms[0].textheight.style.display='none';
			jQuery(htmltypelist).hide();
			typespan.innerHTML='';
			lengthspan.innerHTML='';
			window.document.forms[0].strlength.style.display='none';
			strlengthspan.innerHTML='';
			jQuery("#selectdiv").hide();
			jQuery("#btnaddRow").hide();
			jQuery("#btnsubmitClear").hide();
			htmltypelist = jQuery("#selecthtmltype");
			jQuery(htmltypelist).hide();
			$("#selecthtmltype").next('span').hide();
			cusb.style.display='none';
		}
		if(fieldhtmltypelist.value==2){
		  jQuery(htmltypelist).hide();
		  typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>';
		  window.document.forms[0].textheight.style.display='';
			lengthspan.innerHTML='';
			window.document.forms[0].strlength.style.display='none';
			strlengthspan.innerHTML='';
			jQuery("#selectdiv").hide();
			jQuery("#btnaddRow").hide();
			jQuery("#btnsubmitClear").hide();
			htmltypelist = jQuery("#selecthtmltype");
			jQuery(htmltypelist).hide();
			$("#selecthtmltype").next('span').hide();
			cusb.style.display='none';
		}
		<!--xwj for @td2977 20051110 end-->
		if(fieldhtmltypelist.value==5){
		  window.document.forms[0].textheight.style.display='none';<!--xwj for @td2977 20051110 end-->
			jQuery(htmltypelist).hide();
			typespan.innerHTML='';
			lengthspan.innerHTML='';
			window.document.forms[0].strlength.style.display='none';
			strlengthspan.innerHTML='';
			jQuery("#selectdiv").show();
			jQuery("#btnaddRow").show();
			jQuery("#btnsubmitClear").show();
			htmltypelist = jQuery("#selecthtmltype");
			$("#selecthtmltype").next('span').hide();
			jQuery(htmltypelist).hide();
			cusb.style.display='none';
		}
		if(fieldhtmltypelist.value==3){
		  window.document.forms[0].textheight.style.display='none';	<!--xwj for @td2977 20051110 end-->
			jQuery(htmltypelist).show();
			typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>';
			lengthspan.innerHTML='';
			window.document.forms[0].strlength.style.display='none';
			strlengthspan.innerHTML='';
			jQuery("#selectdiv").hide();
			jQuery("#btnaddRow").hide();
			jQuery("#btnsubmitClear").hide();
			htmltypelist = jQuery("#selecthtmltype")[0];
			jQuery(htmltypelist).show();
			$("#selecthtmltype").next('span').hide();
			for(var count = htmltypelist.options.length - 1; count >= 0; count--)
				htmltypelist.options[count] = null;
			<%=browsertype%>
		}
		if(fieldhtmltypelist.value==1){
		  window.document.forms[0].textheight.style.display='none';	<!--xwj for @td2977 20051110 end-->
			jQuery(htmltypelist).show();
			typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>';
			lengthspan.innerHTML='<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>';
			window.document.forms[0].strlength.style.display='';
			if(form1.strlength.value==''||form1.strlength.value==0)
				strlengthspan.innerHTML='<IMG src="/images/BacoError_wev8.gif" align=absMiddle>';
			strlengthspan.style.display='';
			jQuery("#selectdiv").hide();
			jQuery("#btnaddRow").hide();
			jQuery("#btnsubmitClear").hide();
			htmltypelist = jQuery("#selecthtmltype")[0];
			jQuery(htmltypelist).show();
			for(var count = htmltypelist.options.length - 1; count >= 0; count--)
				htmltypelist.options[count] = null;
			<%=texttype%>
			cusb.style.display='none';
		}
		if(fieldhtmltypelist.value==7){
		  window.document.forms[0].textheight.style.display='none';<!--xwj for @td2977 20051110 end-->
			jQuery(htmltypelist).hide();
			typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>';
			lengthspan.innerHTML='';
			window.document.forms[0].strlength.style.display='none';
			strlengthspan.innerHTML='';
			jQuery("#selectdiv").hide();
			jQuery("#btnaddRow").hide();
			jQuery("#btnsubmitClear").hide();
			htmltypelist = jQuery("#selecthtmltype")[0];
			jQuery(htmltypelist).show();
			$("#selecthtmltype").next('span').hide();
			for(var count = htmltypelist.options.length - 1; count >= 0; count--)
				htmltypelist.options[count] = null;
			<%=specialtype%>
			cusb.style.display='none';
		}
	}

	function typeChange(){
		fieldhtmltypelist = window.document.forms[0].fieldhtmltype;
		htmltypelist = window.document.forms[0].htmltype;
		cusb=document.getElementById("cusb");
		showprep=document.getElementById("showprep");
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
		if(fieldhtmltypelist.value==3){
			if(htmltypelist.value==161||htmltypelist.value==162){
				cusb.style.display='';
				cusb.style.width = "120px";
				if(cusb.value==''||cusb.value==0){
					strlengthspan.innerHTML='<IMG src="/images/BacoError_wev8.gif" align=absMiddle>';
				}else
					strlengthspan.innerHTML='';
				strlengthspan.style.display='';
			}
			else{
				cusb.value=''
				cusb.style.display='none';
				strlengthspan.innerHTML='';
				strlengthspan.style.display='none';
			}
			if(htmltypelist.value==165||htmltypelist.value==166||htmltypelist.value==167||htmltypelist.value==168){
				showprep.style.display='';
				showprepspan.style.display='';
			}
			else{
				showprep.value='1';
				showprep.style.display='none';
				showprepspan.style.display='none';
			}
		}
	}


	function checkKey()
	{
	var keys=",PERCENT,PLAN,PRECISION,PRIMARY,PRINT,PROC,PROCEDURE,PUBLIC,RAISERROR,READ,READTEXT,RECONFIGURE,REFERENCES,REPLICATION,RESTORE,RESTRICT,RETURN,REVOKE,RIGHT,ROLLBACK,ROWCOUNT,ROWGUIDCOL,RULE,SAVE,SCHEMA,SELECT,SESSION_USER,SET,SETUSER,SHUTDOWN,SOME,STATISTICS,SYSTEM_USER,TABLE,TEXTSIZE,THEN,TO,TOP,TRAN,TRANSACTION,TRIGGER,TRUNCATE,TSEQUAL,UNION,UNIQUE,UPDATE,UPDATETEXT,USE,USER,VALUES,VARYING,VIEW,WAITFOR,WHEN,WHERE,WHILE,WITH,WRITETEXT,EXCEPT,EXEC,EXECUTE,EXISTS,EXIT,FETCH,FILE,FILLFACTOR,FOR,FOREIGN,FREETEXT,FREETEXTTABLE,FROM,FULL,FUNCTION,GOTO,GRANT,GROUP,HAVING,HOLDLOCK,IDENTITY,IDENTITY_INSERT,IDENTITYCOL,IF,IN,INDEX,INNER,INSERT,INTERSECT,INTO,IS,JOIN,KEY,KILL,LEFT,LIKE,LINENO,LOAD,NATIONAL,NOCHECK,NONCLUSTERED,NOT,NULL,NULLIF,OF,OFF,OFFSETS,ON,OPEN,OPENDATASOURCE,OPENQUERY,OPENROWSET,OPENXML,OPTION,OR,ORDER,OUTER,OVER,ADD,ALL,ALTER,AND,ANY,AS,ASC,AUTHORIZATION,BACKUP,BEGIN,BETWEEN,BREAK,BROWSE,BULK,BY,CASCADE,CASE,CHECK,CHECKPOINT,CLOSE,CLUSTERED,COALESCE,COLLATE,COLUMN,COMMIT,COMPUTE,CONSTRAINT,CONTAINS,CONTAINSTABLE,CONTINUE,CONVERT,CREATE,CROSS,CURRENT,CURRENT_DATE,CURRENT_TIME,CURRENT_TIMESTAMP,CURRENT_USER,CURSOR,DATABASE,DBCC,DEALLOCATE,DECLARE,DEFAULT,DELETE,DENY,DESC,DISK,DISTINCT,DISTRIBUTED,DOUBLE,DROP,DUMMY,DUMP,ELSE,END,ERRLVL,ESCAPE,";
	var fname=window.document.forms[0].fieldname.value;
	if (fname!="")
		{fname=","+fname.toUpperCase()+",";

	if (keys.indexOf(fname)>0)
		{
		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(19946,user.getLanguage())%>');
		window.document.forms[0].fieldname.focus();
		return false;
		}
		}
	return true;
	}
	function checksubmit(){
		fieldhtmltypelist = window.document.forms[0].fieldhtmltype;
		htmltypelist =  jQuery("#selecthtmltype")[0];
		if (!checkKey())  return false;
		if(fieldhtmltypelist.value==1){
			if(htmltypelist.value==1){
				if(form1.strlength.value==""||form1.strlength.value==0){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
					return false;
				}
			}
		}
		if(fieldhtmltypelist.value==3){
           	if(htmltypelist.value==161||htmltypelist.value==162){
				if(form1.cusb.value==""||form1.cusb.value==0){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
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
	tmpvalue = document.all(elementname).value;

	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	if(tmpvalue!=""&&tmpvalue!=0){
		 document.all(spanid).innerHTML='';
	}
	else{
	 document.all(spanid).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 document.all(elementname).value = "";
	}
}
</script>
<script language="javascript">
<!--xwj for td2977 20051118 begin-->
function submitData(){

	var selectvalue = window.document.forms[0].fieldhtmltype.value;
	if (checksubmit()){

	<%if("addfield".equals(type)){%>
	if(selectvalue == "5"){
		if(checkDefault()){
			form1.submit();
		}
	}else{
			form1.submit();
	}
	<%}else{%>
	var fieldhtmltype = <%=fieldhtmltype%>;
	if(fieldhtmltype==5){
		if(checkDefault()){
			form1.submit();
		}
	}else{
		form1.submit();
	}
	<%}%>
	}
}

function checkDefault(){
var tempcount = 0;
for(i=0;i<rowindex;i++){
if(document.all("field_checked_"+i+"_name")){
var value = document.all("field_checked_"+i+"_name").checked;
if(value == true){
tempcount = tempcount + 1;
}
}
}
if(tempcount > 1){
window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83539,user.getLanguage())%>");
return false;
}
//deleted by xwj for td3297 20051130
else{
return true;
}
}
<!--xwj for td2977 20051118 end-->

function submitClear()
{
		
    len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_select')
			rowsum1 += 1;
	}
	
	var record = 0;
	
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_select'){
			if(document.forms[0].elements[i].checked==true) {
				record ++;
			}
		}

	}
	
	if(record == 0){
	   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");
	}else{
	   window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(82017,user.getLanguage())%>',function(){
	      for(i=len-1; i >= 0;i--) {
				if (document.forms[0].elements[i].name=='check_select'){
					if(document.forms[0].elements[i].checked==true) {
						if(document.forms[0].elements[i].value!='0')
							delids +=","+ document.forms[0].elements[i].value;
							//alert(rowsum1);
						oTable.deleteRow(rowsum1);
					}
					rowsum1 -=1;
				}
			}
	   });
	}
	
	
}

function onShowCatalog(spanName, index) {
	var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
	if (result != null) {
		if (result[0] > 0)  {
			spanName.innerHTML=result[2];
			document.all("pathcategory"+index).value=result[2];
			document.all("maincategory"+index).value=result[3]+","+result[4]+","+result[1];
			//document.all("subcategory"+index).value=result[4];
			//document.all("seccategory"+index).value=result[1];
		}
		  <!--added xwj for td2048 on 2005-6-1 begin -->
		else{
			spanName.innerHTML="";
			document.all("pathcategory"+index).value="";
			document.all("maincategory"+index).value="";
			//document.all("subcategory"+index).value="";
			//document.all("seccategory"+index).value="";
			}
		<!--added xwj for td2048 on 2005-6-1 end -->
	}
}
</script>

</body>
</html>
