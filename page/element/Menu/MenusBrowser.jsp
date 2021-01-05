
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="MenuCenterCominfo" class="weaver.page.menu.MenuCenterCominfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<HTML>
	<HEAD>
		<LINK REL=stylesheet type="text/css" HREF="/css/Weaver_wev8.css">
	</HEAD>
	<%
		String t_name=Util.null2String(request.getParameter("t_name")).trim();
		String t_desc=Util.null2String(request.getParameter("t_desc")).trim();
		
		String sqlwhere = " where 1 = 1 ";
		if(!t_name.equals("")){
		   sqlwhere += " and menuname like '%" +t_name+"%' ";
		}
	
	%>

	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:onsech(),_self} ";
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{" + SystemEnv.getHtmlLabelName(201, user.getLanguage()) + ",javascript:onClose(),_self} ";
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{" + SystemEnv.getHtmlLabelName(311, user.getLanguage()) + ",javascript:btnclear_onclick(),_self} ";
		RCMenuHeight += RCMenuHeightStep;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	
	<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="onsech();" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>
	
	<BODY>
		<FORM NAME="SearchForm"    id="SearchForm"   action="MenusBrowser.jsp" method=post>
		
		<wea:layout type="2col">
			  <wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
				<wea:item> <input name='t_name' class='inputstyle' value='<%=t_name%>'></wea:item>
				
			  </wea:group>
			  <wea:group context="" attributes="{'groupDisplay':'none'}">
			  	<wea:item attributes="{'colspan':'full'}">&nbsp;</wea:item>
			  </wea:group>
			  <wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item attributes="{'isTableList':'true','colspan':'full'}">
					<%
					String tableString="<table  pagesize=\"10\" tabletype=\"none\" valign=\"top\" >"+
					"<sql backfields=\"*\" sqlform=\" from menucenter \"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlwhere=\""+Util.toHtmlForSplitPage(""+sqlwhere)+"\" sqldistinct=\"true\" />"+
					"<head >"+
					 "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\"   column=\"id\" />"+
					 "<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\"  column=\"menuname\" orderkey=\"menuname\" />"+
					 "<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\"  transmethod=\"weaver.splitepage.transform.SptmForHomepage.getMenuType\" otherpara=\""+user.getLanguage()+"\"  column=\"menutype\" orderkey=\"menutype\" />"+
					"</head>"+ "</table>";
				  	%>
				  	<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
				</wea:item>
			  </wea:group>
		</wea:layout>
	
	
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
			    <input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnclear_onclick()">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
		</FORM>
	</BODY>
</HTML>
<script	language="javascript">
function onsech(){
		$("#SearchForm").submit();
}
function replaceToHtml(str){
	var re = str;
	var re1 = "<";
	var re2 = ">";
	do{
		re = re.replace(re1,"&lt;");
		re = re.replace(re2,"&gt;");
        re = re.replace(",","，");
	}while(re.indexOf("<")!=-1 || re.indexOf(">")!=-1)
	return re;
}

var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}


function onClose(){
		 if(dialog){
	    	dialog.close()
	    }else{
		    window.parent.close();
		}
}

function btnclear_onclick(){
	if(dialog){
		try{
		dialog.callbackfun({id:"",name:""});
		}catch(e){}
		try{
		dialog.close({id:"",name:""});
		}catch(e){}

	}else{
	     window.parent.returnValue = {id:"",name:""};
	     window.parent.close();
	}
}

jQuery("#_xTable").bind("click",function(e){
    var target =  e.srcElement||e.target ;
	try{
	    var curRow ;
		if(target.nodeName == "TD" || target.nodeName == "A"){
			curRow=$(target).parents("tr")[0];
		}
		
		if(dialog){
			try{
			    dialog.callbackfun({id:$(curRow.cells[1]).text(),name:$(curRow.cells[2]).text()});
			}catch(e){}
			try{
			dialog.close({id:$(curRow.cells[1]).text(),name:$(curRow.cells[2]).text()});
			}catch(e){}
		}else{
			window.parent.returnValue = {id:$(curRow.cells[1]).text(),name:$(curRow.cells[2]).text()};
			window.parent.close()
		}
	}catch (en) {
		alert(en.message);
	}
});

</script>
