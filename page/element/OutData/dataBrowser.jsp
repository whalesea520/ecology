
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.Util"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("30688",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->dataBrowser.jsp");
	}
	var dialog = null;
	try{
		dialog = parent.parent.getDialog(parent);
	}
	catch(e){}
</script>
</HEAD>
<%
String titlename = SystemEnv.getHtmlLabelName(30688,user.getLanguage());
String tableString = "";
String selectedids_old =  Util.null2String(request.getParameter("selectedids"));
String selectedids = "";
String[] str = selectedids_old.split(",");
for(int i = 0; i < str.length; i++) {
	if(i == 0) {
		selectedids = str[i];
	} else {
		selectedids = selectedids + "," + str[i];
	}
	
}

 %>
<BODY>
<div>
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
<!--				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit"  class="e8_btn_top" onclick="onSave();"/>-->
				<span title="<%=SystemEnv.getHtmlLabelName(25037,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
    <DIV align=right>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
    BaseBean baseBean_self = new BaseBean();
    int userightmenu_self = 1;
    try{
    	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
    }catch(Exception e){}
    if(userightmenu_self == 1){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    %>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
String typename = Util.null2String(request.getParameter("typename"));

String showname = Util.null2String(request.getParameter("showname"));
String backto = Util.null2String(request.getParameter("backto"));
String errormsg = Util.null2String(request.getParameter("errormsg"));

if(!"".equals(backto))
	typename = backto;
String namesimple = Util.null2String(request.getParameter("namesimple"));

String showclass = Util.null2String(request.getParameter("showclass"));
String showtype = Util.null2String(request.getParameter("showtype"));
String sqlwhere = "where 1=1 and showclass='2' ";
/* if(!"".equals(typename))
	sqlwhere += " and a.typename='"+typename+"'";
if(!"".equals(showname))
	sqlwhere += " and a.name like '%"+showname+"%'";
if(!"".equals(namesimple))
	sqlwhere += " and a.name like '%"+namesimple+"%'";
String tableString="";
if(!"".equals(showclass))
{	
	sqlwhere +=" and a.showclass like '%"+2+"%'";
}
if(!"".equals(showtype))
{	
	sqlwhere +=" and a.showtype like '%"+showtype+"%'";
} */
String backfields=" a.id,a.name,a.showname,' ' as nullcolumn " ;
String perpage="10";
String fromSql=" datashowset a "; 
tableString =  " <table instanceid=\"ListTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >";
tableString += " <checkboxpopedom    popedompara=\"column:a.name\" showmethod=\"weaver.general.SplitPageTransmethod.getCheckBox\" />"+
		 " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"a.id\"  sqlprimarykey=\"a.id\" sqlsortway=\"Desc\" sqlisdistinct=\"false\" />"+
         "       <head>"+
         "           <col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(84 ,user.getLanguage())+"\" column=\"showname\" />"+
         "           <col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(195 ,user.getLanguage())+"\" column=\"name\" />"+
         "       </head>"+
         " <browser returncolumn=\"name\" > "+
		 "</browser>"+ 
         " </table>";

%>
    </DIV>
    <form>
    	<TABLE width="100%">
		    <tr>
		        <td valign="top">  
		           	<wea:SplitPageTag  tableString='<%=tableString%>' selectedstrs="<%=selectedids%>" mode="run" />
		        </td>
		    </tr>
		</TABLE>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
			 <input type="button" value="<%=SystemEnv.getHtmlLabelName(128844,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onSave();"/>
			 <input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClear();"/>
	    	 <input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btncancel_onclick();"/>
	    	</wea:item>
		</wea:group>
		</wea:layout>
		</div>		
		
    </form>
</div>

</BODY>
</HTML>



<script type="text/javascript">

	function onSave() {
	    var ids = _xtable_CheckedCheckboxId();
	   
	    var names = _xtable_CheckedCheckboxValue();
	  /*   alert(ids);
	    alert(names); */
	    //根据id取得名字
	    var para = {"ids": ""+ids};
	    var url = "getNameById.jsp";
	    $.get(url, para, function(data) {
	    	names = data;
	    	var returnjson
	    	 if(true) {
				returnjson = {id:ids, name:names};
	    	if(dialog){
				 try{
          			dialog.callback(returnjson);
          			
				}catch(e){
				} 
				
				try{
				     dialog.close(returnjson);
				 }catch(e){}
				}else{
					window.parent.returnValue = returnjson;
			  		window.parent.close();
				}
	    	} else {
	     	 if(dialog){
					dialog.close();
				}else{
			  		window.parent.close();
				}    
			}
	    });
	   
  }
    
    function onClear() {
      var returnjson = {id:"",name:""};
			if(dialog){
				try{
          			dialog.callback(returnjson);
			     }catch(e){}
			
				try{
				     dialog.close(returnjson);
				 }catch(e){}
			}else{
				window.parent.returnValue = returnjson;
		  		window.parent.close();
			}
	}

    

  function btncancel_onclick(){
		if(dialog){
			dialog.close();
		}else{
	  		window.parent.close();
		}
	}
    
	//-->
</SCRIPT>
