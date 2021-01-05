<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF="/css/Weaver_wev8.css">
<script type="text/javascript">
    var parentWin = null;
    var dialog = null;
    try{
        parentWin = parent.parent.getParentWindow(parent);
        dialog = parent.parent.getDialog(parent);
    }catch(e){}
</script>
</HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String name = Util.null2String(request.getParameter("name"));
String description = Util.null2String(request.getParameter("description"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where name like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and name like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!description.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where description like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and description like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
}
%>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="assest"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("703",user.getLanguage()) %>'/>
</jsp:include>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:dialog.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;



%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>" class="e8_btn_top"  onclick="onSubmit()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="CapitalTypeBrowser.jsp" method=post>
<input type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item><input name=name value='<%=name%>' class="InputStyle"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item><input name=description value='<%=description%>' class="InputStyle"></wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item></wea:item>
	</wea:group>
</wea:layout>

<%



String orderby =" id ";
String tableString = "";
int perpage=10;                                 
String backfields = " id,name,description";
String fromSql  = " CptCapitalType ";

tableString =   " <table instanceid=\"BrowseTable\" id=\"BrowseTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"0%\"  text=\""+"ID"+"\" column=\"id\" orderkey=\"id\"   />"+
                "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelNames("195",user.getLanguage())+"\" column=\"name\" orderkey=\"name\"   />"+
                "           <col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelNames("433",user.getLanguage())+"\" column=\"description\" orderkey=\"description\"  />"+
                "       </head>"+
                " </table>";
%>

<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />



 
</FORM>
<script language="javascript">
    function submitData()
    {
        if (check_form(SearchForm,''))
            SearchForm.submit();
    }

    function submitClear()
    {
        btnclear_onclick();
    }

    function BrowseTable_onclick(e){
        var e=e||event;
        var target=e.srcElement||e.target;

        if( target.nodeName =="TD"||target.nodeName =="A"  ){
            if(dialog){
                var returnjson={id:jQuery(jQuery(target).parents("tr")[0].cells[1]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[2]).text(),other1:jQuery(jQuery(target).parents("tr")[0].cells[2]).text()};
                try{
                    dialog.callback(returnjson);
                }catch(e){}
                try{
                    dialog.close(returnjson);
                }catch(e){}
            }else{
                window.parent.parent.returnValue = {id:jQuery(jQuery(target).parents("tr")[0].cells[1]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[2]).text(),other1:jQuery(jQuery(target).parents("tr")[0].cells[2]).text()};
                window.parent.parent.close();
            }
        }
    }
    function btnclear_onclick(){
        if(dialog){
            var returnjson={id:"0",name:"",other1:""};
            try{
                dialog.callback(returnjson);
            }catch(e){}
            try{
                dialog.close(returnjson);
            }catch(e){}
        }else{
            window.parent.parent.returnValue = {id:"",name:"",other1:""};
            window.parent.parent.close();
        }
    }

    function onSubmit()
    {
        SearchForm.submit();
    }
    function onClose()
    {
        window.parent.parent.close();
    }
    $(function(){
        $("#_xTable").find("table.ListStyle").live('click',BrowseTable_onclick);
    });
</script>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="submitClear();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>

</BODY>
</HTML>

