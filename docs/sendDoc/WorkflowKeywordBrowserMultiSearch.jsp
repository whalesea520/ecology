
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	var parentWin = parent.parent.parent.getParentWindow(parent.parent);
	var dialog = parent.parent.parent.getDialog(parent.parent);
	var btnok_onclick = function(){
		jQuery("#btnok",parent.getElementById("frame2").contentWindow.document).click();
	}

	var btnclear_onclick = function(){
		jQuery("#btnclear",parent.getElementById("frame2").contentWindow.document).click();
	}
	
	function onClose(){
		 if(dialog){
	    	dialog.close()
	    }else{
		    window.parent.parent.close();
		}
	}
</script>
</HEAD>
<body>
<%
int uid=user.getUID();
    String WorkflowKeywordBrowserMulti = null;

    Cookie[] cks = request.getCookies();

    for (int i = 0; i < cks.length; i++) {
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if (cks[i].getName().equals("WorkflowKeywordBrowserMulti" + uid)) {
            WorkflowKeywordBrowserMulti = cks[i].getValue();
            break;
        }
    }

String rem="2";
if(WorkflowKeywordBrowserMulti!=null&&WorkflowKeywordBrowserMulti.length()>1){
	rem="2"+WorkflowKeywordBrowserMulti.substring(1);
}

Cookie ck = new Cookie("WorkflowKeywordBrowserMulti"+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);
//组合查询不接收条件
String sqlwhere ="";

String strKeyword = Util.null2String(request.getParameter("strKeyword"));


%>
	<FORM NAME="SearchForm" id="SearchForm" STYLE="margin-bottom:0" action="WorkflowKeywordBrowserMultiSelect.jsp" method=post target="frame2">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
if(userightmenu_self == 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:btncancel_reset(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
	<BUTTON type='button' class=btnSearch accessKey=S style="display:none"  id=btnsub onclick="btnsub_onclick();"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<BUTTON type=reset class=btnReset accessKey=T style="display:none" ><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<BUTTON type='button' class=btn accessKey=O style="display:none" id=btnok><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<BUTTON type='button' class=btnReset accessKey=T style="display:none" id=btncancel><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	<BUTTON type='button' class=btn accessKey=2 style="display:none" id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(userightmenu_self == 1){%>
<script>
rightMenu.style.visibility='hidden'
</script>
<%}%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		<input type="button" onclick="doSearch()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="4col">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(21510,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=keyWordName id="keyWordName" ></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(21511,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=keywordDesc id="keywordDesc" ></wea:item>
	</wea:group>
</wea:layout>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="strKeyword" value="<%=strKeyword%>">
<input class=inputstyle type="hidden" name="tabid" id="tabid">
	<!--########//Search Table End########-->
	</FORM>

<script language="javascript" type="text/javascript">
var strKeyword = "";

function doSearch(){
	document.SearchForm.btnsub.click()
}
function btnclear_onclick(){
    window.parent.parent.returnValue = "";
	window.parent.parent.close();
}

function btnok_onclick(){
	setKeywordStr();
    window.parent.parent.returnValue = strKeyword;
    window.parent.parent.close();
}

function btnsub_onclick(){
	setKeywordStr();
    document.all("strKeyword").value = strKeyword;
    document.all("tabid").value=2
    document.SearchForm.submit();
}

function btncancel_onclick(){
    window.parent.parent.close();
}
//2012-08-20 ypc 修改　解决右键菜单　重新设置　不起作用
function btncancel_reset(){
	document.getElementById("SearchForm").reset();
}

function setKeywordStr(){
	var strKeyword1 =""

	try{
		for(var i=0;i<parent.frame2.keywordArray.length;i++){
			strKeyword1 += " "+parent.frame2.keywordArray[i].split("~")[1] ;
	    }
		if(strKeyword1!=""){
			strKeyword1=strKeyword1.substr(1)
		}
	    strKeyword=strKeyword1
    }catch(err){}
}
</script>
</BODY>
</HTML>