<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
	<link REL=stylesheet type=text/css HREF="/css/Weaver_wev8.css">
	<script type="text/javascript">
		var parentWin = parent.parent.getParentWindow(parent);
		var dialog = parent.parent.getDialog(parent);
	</script>
</HEAD>
<%
int wfid = Util.getIntValue(request.getParameter("workflowid"));
String oldfields = Util.null2String(request.getParameter("oldfields"));
%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="fieldMutilBrowser.jsp" method=post>
<input type="hidden" id="wfid" name="wfid" value="<%=wfid%>">
	<TABLE ID=BrowseTable class="ListStyle" cellspacing="0">
	<TR class=header>
	
	<TH width="10%" style="position: fixed;z-index: 100;width: 10%" ><input class="Inputstyle" id="allcheck"    onClick="CheckAll(this.checked,'checkboxfield')" type="checkbox" ></TH>
	<TH width="90%" style="position: fixed;z-index: 101;left: 10%;"><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TH>
	</TR>
	<%
	int i=0;
	String sql = "";
	String isbill = "";
	String formid = "";
	
	RecordSet.executeSql("select formid,isbill from workflow_base where id="+wfid);
	if(RecordSet.next()){
		formid = RecordSet.getString("formid");
		isbill = RecordSet.getString("isbill");
	}
	if(isbill.equals("0")){//表单
			sql = "select a.fieldid, b.fieldlable, a.isdetail, a.fieldorder, a.isdetail from workflow_formfield a, workflow_fieldlable b "+
				  " where a.formid=b.formid and a.fieldid=b.fieldid and a.formid="+formid+" and b.langurageid = "+user.getLanguage();
			if(RecordSet.getDBType().equals("oracle")){
				sql += " order by a.isdetail desc,a.fieldorder asc ";
			}else{    
				sql += " order by a.isdetail,a.fieldorder ";
			}
	}else if(isbill.equals("1")){//单据
		sql = "select id as fieldid,fieldlabel,viewtype as isdetail,dsporder as fieldorder, viewtype as isdetail from workflow_billfield where billid="+formid;
		sql += " order by viewtype,dsporder";
	}
	
	//out.println("sql:"+sql);
	RecordSet.execute(sql);
	int counts=RecordSet.getCounts();
	int count=0;
	while(RecordSet.next()){
		String fieldlablename = "";
		if(isbill.equals("1")){//单据无法将字段名称作为查询条件，在这里进行处理
			fieldlablename = SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"),user.getLanguage());
		}else{
			fieldlablename = Util.null2String(RecordSet.getString("fieldlable"));
		}
		int id_tmp = Util.getIntValue(RecordSet.getString("fieldid"), 0);
		int isdetail_ = Util.getIntValue(RecordSet.getString("isdetail"), 0);
		String isdetailStr = "";
		if(isdetail_ == 1){
			isdetailStr = "(" + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) + ")";
		}
		String checkStr = "";
		if((","+oldfields+",").indexOf(","+id_tmp+",") > -1){
			checkStr = " checked ";
			count++;
		}
		if(i==0){
			i=1;
	%>
	<TR class=DataLight>
	<%
		}else{
			i=0;
	%>
	<TR class=DataDark>
		<%
		}
		%>
		<TD width="10%"><input class="Inputstyle" type="checkbox"  onClick="checkAll2(this.checked)" value="<%=id_tmp%>" tempid="<%=id_tmp%>" id="checkbox_<%=id_tmp%>" name="checkboxfield" temptitle="<%=fieldlablename%><%=isdetailStr%>" <%=checkStr%>></TD>
		<TD width="90%">
			<%=fieldlablename%><%=isdetailStr%>
		</TD>
	</TR>
	<%}

	%>
	</TABLE>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=O  id=btnok  value="<%="O-"+SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="onSubmit();">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="onClear();">
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

<script language="javascript">
function onClear(){
	var returnjson = Array("","");
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}

var checkedall=<%=counts!=0&&counts==count%>;

jQuery(function () {
	if(checkedall){
        jQuery("#allcheck").attr("checked",true);
        jQuery("#allcheck").next().addClass("jNiceChecked");
	}
})


function  checkAll2(haschecked) {
    if(!haschecked){
        jQuery("#allcheck").attr("checked",false);
        jQuery("#allcheck").next().removeClass("jNiceChecked");
	}

    var fieldList = document.getElementsByName("checkboxfield");
    if(fieldList){
        for(var i=0; i<fieldList.length; i++){
            var fieldcheckbox = fieldList[i];
            if(fieldcheckbox.checked == false){
                jQuery("#allcheck").attr("checked",false);
                jQuery("#allcheck").next().removeClass("jNiceChecked");
                return false;
            }
        }
        jQuery("#allcheck").attr("checked",true);
        jQuery("#allcheck").next().addClass("jNiceChecked");

    }
}


function onSubmit(){
	var fields = "";
	var fieldnames = "";
	var fieldList = document.getElementsByName("checkboxfield");
	if(fieldList){
		for(var i=0; i<fieldList.length; i++){
			var fieldcheckbox = fieldList[i];
			if(fieldcheckbox.checked == true){
				fields = fields + $(fieldcheckbox).attr("tempid") + ",";
				fieldnames = fieldnames + $(fieldcheckbox).attr("temptitle")+ ",";
			}
		}
		if(fields.length > 0){
			fields = fields.substring(0, fields.length-1);
			fieldnames = fieldnames.substring(0, fieldnames.length-1);
		}
	}
	
	var returnjson = Array(fields, fieldnames);
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
	
}
function onClose()
{
	if(dialog){
	    dialog.close();
	}else{  
		window.parent.close() ;
	}	
}

function CheckAll(haschecked,flag) {
    if(haschecked){
        jQuery("input[name="+flag+"]").each(function(){
            var ck = jQuery(this);
            ck.attr("checked",true);
            ck.next().addClass("jNiceChecked");
        });
    }else{
        jQuery("input[name="+flag+"]").each(function(){
            var ck = jQuery(this);
            ck.attr("checked",false);
            ck.next().removeClass("jNiceChecked");
        });
    }
}
</script>