<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSetDataSource" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.workflow.dmlaction.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldBase" class="weaver.workflow.dmlaction.commands.bases.FieldBase" scope="page" />
<%@page import="weaver.expdoc.ExpUtil"%>

<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="weaver.hrm.resource.HrmSynDAO"%><HTML><HEAD>
<link href="/css/Weaver_wev8.css" rel="stylesheet" type="text/css" >
<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
<LINK REL=stylesheet type=text/css HREF="/css/Weaver_wev8.css"></HEAD>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<%
String datasourceid = Util.null2String(request.getParameter("datasourceid"));
String  needcheckds = Util.null2String(request.getParameter("needcheckds"));//判断展示的是主表全部，明细全部，过滤后主表全部，过滤后明细表的全部
String dbProid = Util.null2String(request.getParameter("dmlformid"));
String dbprosetingid = Util.null2String(request.getParameter("dmlisdetail"));
String dmltablename = Util.null2String(request.getParameter("dmltablename"));
String callSource = Util.null2String(request.getParameter("callSource"));
int ajax = Util.getIntValue(Util.null2String(request.getParameter("ajax")), 0);
Map allcolnums = new HashMap();
String[] all = null;
ExpUtil eu=new ExpUtil();
	if ("1".equals(needcheckds) || "2".equals(needcheckds)) {
		String outFieldInf = eu.IniDBProFields(dbProid);
		String[] outFieldInfArray = outFieldInf.split("#");
		if (outFieldInfArray.length > 7) {
			String mailTableFiledNames = outFieldInfArray[2];
			String mailTableFiledTypes = outFieldInfArray[3];
			String detailTableFiledNames = outFieldInfArray[4];
			String detailTableFiledTypes = outFieldInfArray[5];
			if ("1".equals(needcheckds)) {
				String[] a = mailTableFiledNames.split(",");
				all = a;
				String[] b = mailTableFiledTypes.split(",");
				for (int i = 0; i < a.length; i++) {
					allcolnums.put(a[i], b[i]);
				}
			}
			if ("2".equals(needcheckds)) {
				String[] a = detailTableFiledNames.split(",");
				all = a;
				String[] b = detailTableFiledTypes.split(",");
				for (int i = 0; i < a.length; i++) {
					allcolnums.put(a[i], b[i]);
				}
			}
		}
	}

	if ("3".equals(needcheckds) || "4".equals(needcheckds)) {
		String outFieldInf=eu.IniDBProFields_new(dbProid,dbprosetingid);//5,7
		if(outFieldInf.equals("")){
			outFieldInf=" # # # # # # # # #";
		}
		//System.out.println(outFieldInf);
		String[] outFieldInfArray = outFieldInf.split("#");
		if (outFieldInfArray.length > 7) {
			String mailTableFiledNames = outFieldInfArray[2];
			String mailTableFiledTypes = outFieldInfArray[3];
			String detailTableFiledNames = outFieldInfArray[4];
			String detailTableFiledTypes = outFieldInfArray[5];
			if ("3".equals(needcheckds)) {
				String[] a = mailTableFiledNames.split(",");
				all = a;
				String[] b = mailTableFiledTypes.split(",");
				for (int i = 0; i < a.length; i++) {
					allcolnums.put(a[i], b[i]);
				}
			}
			if ("4".equals(needcheckds)) {
				String[] a = detailTableFiledNames.split(",");
				all = a;
				String[] b = detailTableFiledTypes.split(",");
				for (int i = 0; i < a.length; i++) {
					allcolnums.put(a[i], b[i]);
				}
			}
		}
	}

//String dbProid = Util.null2String(request.getParameter("dbProid"));
//String dbprosetingid = Util.null2String(request.getParameter("dbprosetingid"));


//out.println("needcheckds : "+needcheckds+"  datasourceid : "+datasourceid+"  dmltablename : "+dmltablename+" dmlformid : "+dmlformid+" dmlisdetail : "+dmlisdetail);




boolean needCnName = false;
Map fieldCnNameMap = new HashMap();
if(StringUtils.isBlank(datasourceid) && "hrsetting".equals(callSource)){//为了不影响其它地方对组织结构4个表的列名称选择，故而增加“调用源（callSource）”请求参数，只有HR同步页面调用来时才显示中文名称
	RecordSet rs1 = new RecordSet();
	int type = -1;
	if("hrmresource".equals(dmltablename)){
		needCnName=true;
		type=4;
	}else if("hrmjobtitles".equals(dmltablename)){
		needCnName=true;
		type=3;
	}else if("hrmdepartment".equals(dmltablename)){
		needCnName=true;
		type=2;
	}else if("hrmsubcompany".equals(dmltablename)){
		needCnName=true;
		type=1;
	}
	fieldCnNameMap = HrmSynDAO.getFeildName(type,user.getLanguage());
}
%>
<BODY>
<div class="zDialog_div_content">
    <DIV align=right>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;


RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/workflow/dmlaction/dmlTableFieldsBrowser.jsp" method=post>
<input type="hidden" id="datasourceid" name="datasourceid" value="<%=datasourceid%>">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(82104,user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true'}">
			<TABLE ID=BrowseTable class="ListStyle" cellspacing="0" style="width: 100%">
			<TR class=header>
			<% if(needCnName){ %>
			<TH width=40%><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></TH>
			<%} %>
			<TH width=<%=needCnName?"30":"70"%>%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TH>
			<TH width=30%><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></TH>
			</TR>
			<%
			if(null!=allcolnums&&allcolnums.size()>0)
			{
				String dbtype = DBTypeUtil.getDataSourceDbtype(RecordSet,datasourceid);
				boolean isright = true;
				//Set columnSet = allcolnums.keySet();
				if(all == null) all = new String[0];
				for(int i = 0 ; i<all.length ; i++)
				{
					String fieldname = Util.null2String(all[i]);//String fieldname = Util.null2String((String)i.next());
					String fielddbtype = Util.null2String((String)allcolnums.get(fieldname));
					boolean iscanhandle = DBTypeUtil.checkFieldDBType(fielddbtype,dbtype);
					String fieldCnName = Util.null2String(fieldCnNameMap.get(fieldname));
					//QC92670 特殊处理
					if(ajax == 1 && fielddbtype.indexOf("clob") > -1) {
						iscanhandle = true;
					}
					fieldname = (fieldname.indexOf(" ")>0)?"["+fieldname+"]":fieldname;
					fieldCnName = StringUtils.isBlank(fieldCnName)?	fieldname : fieldCnName;				
			%>
				<tr height="20px" class=<%if(isright){ %>DataLight<%}else{%>DataDark<%} %>>
					<% if(needCnName){ %>
					<td><%=fieldCnName %></td>
					<%} %>
					<td><%=fieldname %></td>
					<td><%=fielddbtype %></td>
					<td style="display:none;"><%=iscanhandle %></td>
				</tr>
			<%
					isright = isright?false:true;
				}
			}
			%>
			</TABLE>
		</wea:item>
	</wea:group>
</wea:layout>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	    <wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
			    	<input type="button" class=zd_btn_cancle accessKey=2  id=btnclear value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" onclick='onClear();'></input>
	        		<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" onclick='closeDialog();'></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
</div>
</FORM>
</DIV>
</BODY>
</HTML>

<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(82925,user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e);
	}
</script>
<script language="javascript">
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}
function onClear()
{
	btnclear_onclick() ;
}
function onSubmit()
{
	SearchForm.submit();
}
function onClose()
{
	if(dialog){
	    dialog.callback(returnjson);
	}else{ 
	    window.parent.close() ;
	 } 
}
function closeDialog(){
	if(dialog)
	{
		dialog.close();
	}else{
	    window.parent.close();
	}
}

function BrowseTable_onmouseover(e){
}
function BrowseTable_onmouseout(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark"
      }else{
         p.className = "DataLight"
      }
   }
}

function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;
   if( target.nodeName =="TD"||target.nodeName =="A"  ){
		var curTr=jQuery(target).parents("tr")[0];
     //window.parent.returnValue = {id:jQuery(curTr.cells[0]).text(),name:jQuery(curTr.cells[1]).text(),a1:jQuery(curTr.cells[2]).text()};
     // window.parent.close();
      	if(dialog){
	    	dialog.callback({id:jQuery(curTr.cells[0]).text(),name:jQuery(curTr.cells[0]).text(),type:jQuery(curTr.cells[1]).text(),a1:jQuery(curTr.cells[2]).text()});
		}else{ 
		    window.parent.returnValue  = {id:jQuery(curTr.cells[0]).text(),name:jQuery(curTr.cells[0]).text(),type:jQuery(curTr.cells[1]).text(),a1:jQuery(curTr.cells[2]).text()};
		    window.parent.close();
		}
	}
}

function btnclear_onclick(){
	//window.parent.returnValue ={id:"",name:"",a1:""};
	//window.parent.close();
	if(dialog){
	    dialog.callback({id:"",name:"",type:"",a1:""});
	}else{ 
	    window.parent.returnValue  = {id:"",name:"",type:"",a1:""};
	    window.parent.close();
	} 
}
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle();
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	});
});
jQuery(function(){
	jQuery("#BrowseTable").mouseover(BrowseTable_onmouseover);
	jQuery("#BrowseTable").mouseout(BrowseTable_onmouseout);
	jQuery("#BrowseTable").click(BrowseTable_onclick);
	
	//$("#btncancel").click(btncancel_onclick);
	//$("#btnsub").click(btnsub_onclick);
	
	jQuery("#btnclear").click(btnclear_onclick);
	
});

</script>