<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.proj.util.PropUtil"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("Cpt4Mode:DeprecationSettings", user)){
	response.sendRedirect("/notice/noright.jsp");	
	return;
}

    String nameQuery1 = Util.null2String(request.getParameter("flowTitle"));
    String nameQuery = Util.null2String(request.getParameter("nameQuery"));
    String formid = Util.null2String(request.getParameter("formid"));
    String wftype = Util.null2String(request.getParameter("wftype"));
    String lastmoddate = Util.null2String(request.getParameter("lastmoddate"));
    String lastmoddate1 = Util.null2String(request.getParameter("lastmoddate1"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>

</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<body style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
String canAdd="false";
String canEdit="false";
String canDel="false";



if(HrmUserVarify.checkUserRight("Cpt4Mode:DeprecationSettings", user)){
	canEdit="true";
}

if(HrmUserVarify.checkUserRight("Cpt4Mode:DeprecationSettings", user)){
	canAdd="true";
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:onAdd(-1),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("Cpt4Mode:DeprecationSettings", user)){
	canDel="true";
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:batchDel(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("Cpt4Mode:DeprecationSettings", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(125898,user.getLanguage())+",javascript:calculate(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}


String pageId=Util.null2String(PropUtil.getPageId("mode4cpt_cptdeprecationconftab"));
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<TABLE class=Shadow>
<tr>
<td valign="top">
<form name="frmSearch" method="post" >
<input type="hidden" name="pageId" id="pageId" value="<%=pageId  %>" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%
		if(HrmUserVarify.checkUserRight("Cpt4Mode:DeprecationSettings", user)){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("82",user.getLanguage())%>" class="e8_btn_top"  onclick="onAdd(-1)"/>
			<%
		}
		%>
		<%
		if(HrmUserVarify.checkUserRight("Cpt4Mode:DeprecationSettings", user)){
			
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("32136",user.getLanguage())%>" class="e8_btn_top" onclick="batchDel()"/>
			<%
		}
		%>
		<%
		if(HrmUserVarify.checkUserRight("Cpt4Mode:DeprecationSettings", user)){

			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("125898",user.getLanguage())%>" class="e8_btn_top" onclick="calculate()"/>
			<%
		}
		%>

			
			<input type="text" class="searchInput" name="flowTitle" value="<%=nameQuery1 %>" />
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
		<div class="advancedSearchDiv" id="advancedSearchDiv">
			<wea:layout type="4col">
			    <wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'>
			    	<wea:item><%=SystemEnv.getHtmlLabelName(1359,user.getLanguage())%></wea:item>
				    <wea:item><input  name=nameQuery class=InputStyle value='<%=nameQuery %>'></wea:item>
			    	<wea:item><%=SystemEnv.getHtmlLabelName(15828,user.getLanguage())%></wea:item>
			    	<wea:item>
						<input  name=formid class=InputStyle value='<%=formid %>' >
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(125873,user.getLanguage())%></wea:item>
					<wea:item>
						<select name="wftype" id="wftype">
							<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
							<option value="1" <%="1".equalsIgnoreCase(wftype)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(1363,user.getLanguage())%></option>
							<option value="0" <%="0".equalsIgnoreCase(wftype)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(125023,user.getLanguage())%></option>
						</select>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(19521,user.getLanguage())%></wea:item>
					<wea:item>
						<span class="wuiDateSpan" selectId="lastmoddate_sel" selectValue="">
							  <input class=wuiDateSel type="hidden" name="lastmoddate" value="<%=lastmoddate %>">
							  <input class=wuiDateSel  type="hidden" name="lastmoddate1" value="<%=lastmoddate1 %>">
						</span>
					</wea:item>
			    </wea:group>
			    <wea:group context="">
			    	<wea:item type="toolbar">
			    		<input class="zd_btn_submit" type="submit" name="submit1" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>"/>
			    		<input class="zd_btn_cancle" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>"/>
			    		<input class="zd_btn_cancle" type="button" name="cancel" id="cancel" value="<%=SystemEnv.getHtmlLabelNames("201",user.getLanguage())%>"  />
			    	</wea:item>
			    </wea:group>
			</wea:layout>
		</div>
	</form>		
<%

//String popedomOtherpara=canEdit+"_"+canDel+"_"+canShare;
String popedomOtherpara="";

//操作列参数
JSONObject operatorInfo=new JSONObject();
operatorInfo.put("userid", user.getUID());
operatorInfo.put("usertype", user.getLogintype());
operatorInfo.put("languageid", user.getLanguage());
operatorInfo.put("operatortype", "mode4cptdeprecationconftab");//操作项类型
operatorInfo.put("operator_num", 4);//操作项数量
operatorInfo.put("operator_val", popedomOtherpara);



String sqlWhere = " where 1=1 ";

if(!"".equals(nameQuery1)){
	sqlWhere+=" and t1.deprename like '%"+nameQuery1+"%'  ";
}
if("".equals(nameQuery)){
	nameQuery=nameQuery1;
}
if(!"".equals(nameQuery)){
	sqlWhere+=" and t1.deprename like '%"+nameQuery+"%'  ";
}
if(!"".equals(formid)){
	sqlWhere += " and  t1.depremethod like '%"+formid+"%'  ";
}
if(!"".equals(wftype)){
	sqlWhere += " and t1.sptcount='"+wftype+"' ";
}
if(!"".equals(lastmoddate)){
	sqlWhere += " and t1.lastmoddate>='"+lastmoddate+"' ";
}
if(!"".equals(lastmoddate1)){
	sqlWhere += " and t1.lastmoddate<='"+lastmoddate1+"' ";
}

String orderby =" t1.lastmoddate ";
int perpage=10;                                 
String backfields = " * ";
String fromSql  = " uf4mode_cptdepreconf t1 ";
//out.print("select "+backfields+" from "+fromSql+" "+sqlWhere+" "+orderby);
String tableString=""+
        "<table  pageId=\""+pageId+"\"  instanceid=\"CptCapitalAssortmentTable\"  tabletype=\"checkbox\"  pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),"mode4cpt")+"\"  >"+
        " <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.formmode.cuspage.cpt.util.Mode4CptTransUtil.getCanDelDeprecation' />"+
        "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlprimarykey=\"id\" sqlorderby=\""+orderby+"\" sqlsortway=\"desc\" sqldistinct=\"true\" />"+
        "<head>";
        
        	tableString+="<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(1359,user.getLanguage())+"\" column=\"deprename\" orderkey=\"deprename\"  />";
            tableString+=
              "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15828, user.getLanguage())+"\" column=\"depremethod\" orderkey=\"depremethod\" transmethod='weaver.formmode.cuspage.cpt.util.Mode4CptTransUtil.getDepremethod'  />"+
              "<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(125873,user.getLanguage())+"\" column=\"sptcount\" orderkey=\"sptcount\" otherpara='"+user.getLanguage()+"' transmethod='weaver.formmode.cuspage.cpt.util.Mode4CptTransUtil.getSptcount' />"+
              "<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(18624,user.getLanguage())+"\" column=\"isopen\" orderkey=\"isopen\" transmethod='weaver.proj.util.ProjectTransUtil.getImgTrueOrFalse' />"+
					  "<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(19521,user.getLanguage())+"\" column=\"lastmoddate\" orderkey=\"lastmoddate\" />"+
					  "</head>"+
        "<operates width=\"5%\">"+
         "   <popedom column='id' otherpara='"+operatorInfo.toString() +"' transmethod='weaver.formmode.cuspage.cpt.util.Mode4CptTransUtil.getOperates'  ></popedom>"+
        "    <operate href=\"javascript:onUse()\" text=\""+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
        "    <operate href=\"javascript:onNouse()\" text=\""+SystemEnv.getHtmlLabelName(18096,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
        "    <operate href=\"javascript:onEdit()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"2\"/>"+
        "    <operate href=\"javascript:onDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"3\"/>"+
        "</operates>"+
        "</table>"; 
%>

<!-- listinfo -->
<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />
</td>
</tr>
</TABLE>

</BODY>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">

function onToogle(id,isopen){
	if(id){
		var type="";
		jQuery.ajax({
			url : "/formmode/cuspage/cpt/conf/cptdeprecationop.jsp",
			type : "post",
			async : true,
			data : {"method":"toggleuse","id":id,"isopen":isopen},
			dataType : "json",
			contentType: "application/x-www-form-urlencoded; charset=utf-8", 
			success: function do4Success(msg){
				if(msg&&msg.referenced){
					var info="";
					for(var i=0;i<msg.referenced.length;i++){
						info+=msg.referenced[i]+" ";
					}
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83732",user.getLanguage())%>:\n"+info);
				}else{
					//window.top.Dialog.alert("使用成功！");
				}
				_table.reLoad();
				
			}
		});
	}
	
}
function onNouse(id){
	onToogle(id,'0');
}
function onUse(id){
	onToogle(id,'1');
}
function onWfset(id,wfid){
	if(wfid){
		var url="/workflow/workflow/addwf.jsp?src=editwf&wfid="+wfid+"&isTemplate=0&versionid_toXtree=1&from=mode4cptwf&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("21954",user.getLanguage())%>";
		openDialog(url,title,800,600,false,true);
	}
}


function newDialog(type,id){
	var url="/formmode/cuspage/cpt/conf/cptdeprecationadd.jsp?wftype=<%=wftype %>&isdialog=1&id="+id;
	var title="<%=SystemEnv.getHtmlLabelNames("125865",user.getLanguage())%>";
	openDialog(url,title,600,450,false,true);
}
function onAdd(){
	var url="/formmode/cuspage/cpt/conf/cptdeprecationadd.jsp?wftype=<%=wftype %>&isdialog=1";
	title="<%=SystemEnv.getHtmlLabelNames("125865",user.getLanguage())%>";
	openDialog(url,title,600,450,false,true);
}

function onEdit(id){
	var url="/formmode/cuspage/cpt/conf/cptdeprecationadd.jsp?wftype=<%=wftype %>&isdialog=1&id="+id;
	title="<%=SystemEnv.getHtmlLabelNames("125865",user.getLanguage())%>";
	openDialog(url,title,600,450,false,true);
}

function onDel(id){
	if(id){
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83600",user.getLanguage())%>',function(){
			jQuery.post(
				"/formmode/cuspage/cpt/conf/cptdeprecationop.jsp",
				{"method":"delete","id":id,"wftype":"<%=wftype %>"},
				function(data){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
						_table.reLoad();
					});
				}
			);
			
		});
	}
}
function calculate(){
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("28296,125898",user.getLanguage())%>?',function(){
		jQuery.ajax({
			url : "/formmode/cuspage/cpt/conf/cptdeprecationop.jsp",
			type : "post",
			async : true,
			data : {"method":"calculate"},
			dataType : "json",
			contentType: "application/x-www-form-urlencoded; charset=utf-8",
			success: function do4Success(data){
				if(data&&data.msg&&trim(data.msg).length>0){
					window.top.Dialog.alert(data.msg);
				}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("15144",user.getLanguage())%>!");
				}

			}
		});

	});
}

function batchDel(){
	var typeids = "";
	$("input[name='chkInTableTag']").each(function(){
	if($(this).attr("checked"))			
		typeids = typeids +$(this).attr("checkboxId")+",";
	});
	if(typeids=="") return ;
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83601",user.getLanguage())%>',function(){
		jQuery.ajax({
			url : "/formmode/cuspage/cpt/conf/cptdeprecationop.jsp",
			type : "post",
			async : true,
			data : {"method":"batchdelete","id":typeids,"wftype":"<%=wftype %>"},
			dataType : "json",
			contentType: "application/x-www-form-urlencoded; charset=utf-8", 
			success: function do4Success(msg){
				if(msg&&msg.referenced){
					var info="";
					for(var i=0;i<msg.referenced.length;i++){
						info+=msg.referenced[i]+" ";
					}
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83732",user.getLanguage())%>:\n"+info);
				}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>");
				}
				_table.reLoad();
				
			}
		});
	});
}



function onBtnSearchClick(){
	frmSearch.submit();
}
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});

</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
