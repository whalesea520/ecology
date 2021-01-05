
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>

<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="ModeTreeFieldComInfo" class="weaver.formmode.setup.ModeTreeFieldComInfo" scope="page" />



<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<%

String superFieldId=Util.null2String(request.getParameter("superFieldId"));
if(superFieldId.equals("")){
	superFieldId=DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID;
}

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/DocTreeDocFieldUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>

</head>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";

String titlename = SystemEnv.getHtmlLabelName(23669,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(365,user.getLanguage());//模块设置新建
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_TOP} " ;//保存
RCMenuHeight += RCMenuHeightStep ;
%>	

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

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

<div id=divMessage style="color:red">
</div>

<FORM id=frmMain name=frmMain action="ModeTreeFieldOperation.jsp" method=post  target="_parent">

        <TABLE class=ViewForm width="100%">
          <COLGROUP> 
		  <COL width="30%">
		  <COL width="70%">
		  <TBODY> 

          <TR class=Title> 
              <TH><%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%></TH><!-- 基本设置 -->
          </TR>
          <TR class=Spacing style="height: 1px!important;"> 
            <TD class=Line1 colSpan=2></TD>
          </TR>

          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD><!-- 说明 -->
            <TD class=FIELD> 
              <INPUT class=InputStyle  name=treeFieldName  maxlength="40" onchange='checkinput("treeFieldName","treeFieldNameImage")' value="">
              <SPAN id=treeFieldNameImage>
			  <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
			  </SPAN>
              </TD>
          </TR>
    <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 

	 <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD><!-- 描述 -->
            <TD class=FIELD> 
				<INPUT class=InputStyle  name=treeFieldDesc value="" maxlength="125" size="50">             
              </TD>
          </TR>
    <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(19411,user.getLanguage())%></TD><!-- 上级节点 -->
            <TD class=Field>
              <SPAN id=superiorFieldSpan>
                  <%=ModeTreeFieldComInfo.getAllSuperiorFieldName(""+superFieldId)%>
              </SPAN> 
              <INPUT class=inputstyle id=superFieldId type=hidden name=superFieldId value=<%=superFieldId%>>                           
            </TD>
          </TR>         
    <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 
            <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD><!-- 顺序 -->
            <TD class=Field> 
              <INPUT class=InputStyle name=showOrder value=0 size=7 maxlength=7  onKeyPress='ItemDecimal_KeyPress("showOrder",6,2)' onBlur='checknumber("showOrder");checkDigit("showOrder",6,2);checkinput("showOrder","showOrderImage")' onchange='checkinput("showOrder","showOrderImage")' >
              <SPAN id=showOrderImage></SPAN>
            </TD>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>

   <input class=inputstyle type=hidden name=operation value="AddSave">
</FORM>
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

</BODY>
</HTML>


<script language=javascript>

//o为错误类型 1:系统不支持10层以上的树状字段！
//           2:同级字段名称不能重复

function checkForAddSave(o){
	if(o=="1"){
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19414,user.getLanguage())%>";//系统不支持10层以上的虚拟目录！
		return;
	}else if(o=="2"){
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19442,user.getLanguage())%>";//同级字段名称不能重复
		return;
	}else if(o==""){
		document.frmMain.submit();	
	}
}

function onSave(obj) {
	if(check_form(frmMain,'treeFieldName,showOrder')){
		obj.disabled = true ;
		var newTreeFieldName=frmMain.treeFieldName.value;
		var newSuperFieldId=frmMain.superFieldId.value;
		newTreeFieldName=escape(newTreeFieldName);
		DocTreeDocFieldUtil.whetherCanAddSave(newTreeFieldName,newSuperFieldId,checkForAddSave);
    }
}

function encode(str){
    return escape(str);
}

function checkDigit(elementName,p,s){
	tmpvalue = document.all(elementName).value;

    var len = -1;
    if(elementName){
		len = tmpvalue.length;
    }

	var integerCount=0;
	var afterDotCount=0;
	var hasDot=false;

    var newIntValue="";
	var newDecValue="";
    for(i = 0; i < len; i++){
		if(tmpvalue.charAt(i) == "."){ 
			hasDot=true;
		}else{
			if(hasDot==false){
				integerCount++;
				if(integerCount<=p-s){
					newIntValue+=tmpvalue.charAt(i);
				}
			}else{
				afterDotCount++;
				if(afterDotCount<=s){
					newDecValue+=tmpvalue.charAt(i);
				}
			}
		}		
    }

    var newValue="";
	if(newDecValue==""){
		newValue=newIntValue;
	}else{
		newValue=newIntValue+"."+newDecValue;
	}
    document.all(elementName).value=newValue;
}

</script>