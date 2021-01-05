
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page import="weaver.workflow.form.FormManager"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@page import="com.weaver.formmodel.util.DateHelper"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />

<HTML><HEAD>
<%
int pageNo = 1;
int pageSize = 12;
String formname = Util.null2String(request.getParameter("formname"));
String browsername = Util.null2String(request.getParameter("browsername"));
String appid = Util.null2String(request.getParameter("appid"));
String formtype = Util.null2String(request.getParameter("formtype"));
String strisReport  = Util.null2String(request.getParameter("isReport"));
boolean isReport = strisReport.equals("1")?true:false;
formtype = isReport?"2":formtype;

String userRightStr = "FORMMODEFORM:ALL";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable ,-1,"",request,response,session);
int subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
String subCompanyId2 = ""+subCompanyId;
%>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_top} " ;//搜索
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(82176,user.getLanguage())+",javascript:searchReset(),_top} " ;//清空条件
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;//清除
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;//取消
RCMenuHeight += RCMenuHeightStep ;

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM NAME=SearchForm action="BrowserBaseList.jsp" method=post>
<input type="hidden" name="isReport" value="<%=strisReport%>">
<table  width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td ></td>
	<td valign="top">
	  <TABLE class=Shadow>
		<tr>
		  <td valign="top">
			 <table class="e8_tblForm" style="margin: 10px 0;">
			   <TR>
				 <TD width="20%" class="e8_tblForm_label"><!-- 自定义浏览框名称 -->
				   <%=SystemEnv.getHtmlLabelName(82014,user.getLanguage())%>
				 </TD>
				 <TD width="30%" class="e8_tblForm_field"><input name="browsername" value="<%=browsername%>" class="InputStyle"></TD>
				 <td width="20%" class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82186,user.getLanguage())%><!-- 所属应用 --><div class="e8_label_desc"></div></td>
				 <td width="30%" class="e8_tblForm_field">
				 <select name="appid" name="appid" style="width:150px" onchange="submitData()" >
				 	<option></option>
					<%
					String appSql = " select * from modeTreeField where (isdelete is null or isdelete=0 )";
					if(fmdetachable.equals("1")){
				          	CheckSubCompanyRight mSubRight = new CheckSubCompanyRight();
				  			int[] mSubCom = mSubRight.getSubComByUserRightId(user.getUID(),"FORMMODEAPP:ALL",0);
				  			String subCompanyIds = "";
				  			for(int i=0;i<mSubCom.length;i++){
				  				if(i==0){
				  					subCompanyIds += ""+mSubCom[i];
				  				}else{
				  					subCompanyIds += ","+mSubCom[i];
				  				}
				  			}
				  			if(subCompanyIds.equals("")){
				  				appSql+= " and 1=2 ";
				  			}else{
				  				appSql+= " and subCompanyId in ("+subCompanyIds+") ";
				  			}
				      }
					appSql += " order  by showOrder asc ";
					RecordSet.executeSql(appSql);
					while(RecordSet.next()){
						int tempAppId = Util.getIntValue(RecordSet.getString("id"),0);
					%>
					<option value="<%=RecordSet.getString("id")%>" <%if(appid.equals(""+tempAppId)){ %> selected="selected" <%} %> ><%=RecordSet.getString("treeFieldName")%></option>
					<%}%>
			  	</select>
				</td>
			    </TR>
			  </table>
			  <%
			  String perpage = "12";
			  String backFields = " a.id,a.customname,b.treefieldname ";
			  String sqlFrom = " from mode_custombrowser a ,modeTreeField b " ;
              String SqlWhere = " where a.appid=b.id and (b.isdelete is null or b.isdelete=0 ) ";
              
              if(fmdetachable.equals("1")){
	              	CheckSubCompanyRight mSubRight = new CheckSubCompanyRight();
		  			int[] mSubCom = mSubRight.getSubComByUserRightId(user.getUID(),"FORMMODEFORM:ALL",0);
		  			String subCompanyIds = "";
		  			for(int i=0;i<mSubCom.length;i++){
		  				if(i==0){
		  					subCompanyIds += ""+mSubCom[i];
		  				}else{
		  					subCompanyIds += ","+mSubCom[i];
		  				}
		  			}
		  			if(subCompanyIds.equals("")){
		  				SqlWhere+= " and 1=2 ";
		  			}else{
		  				SqlWhere+= " and b.subCompanyId in ("+subCompanyIds+") ";
		  			}
              }
			  if(!browsername.equals("")){
				  SqlWhere += " and a.customname like '%"+browsername+"%'";
			  }
			  if(!appid.equals("")){
			      SqlWhere += " and b.id = "+appid;
			  }
			    
		  	 String tableString=""+
				"<table pagesize=\""+perpage+"\" tabletype=\"none\">"+
					"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlsortway=\"desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
						"<head>"+            //自定义浏览框名称 
							"<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(82014,user.getLanguage())+"\" column=\"customname\" orderkey=\"customname\"   />"+
							//所属应用
							"<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(82186,user.getLanguage())+"\" column=\"treefieldname\" orderkey=\"treefieldname\"  />"+
						"</head>"+
				"</table>";
			  %>
			  <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" isShowTopInfo="true"/>
			</td>
		  </tr>
		</TABLE>
	 </td>
	 <td></td>
  </tr>
</table>
</FORM>
</BODY></HTML>

<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);

function btnclear_onclick(){
	var returnjson = {id:"",name:""};
	if(dialog){
	    dialog.callback(returnjson);
	    if(parentWin.customDialogCallBack){
	    	parentWin.customDialogCallBack(0);
	    }
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}

function BrowseTable_onmouseover(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
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
jQuery(document).ready(function(){
	$(".loading", window.document).hide();
	$("#_xTable").bind("click",BrowseTable_onclick);
	$("input[name='browsername']").bind('keydown',function(event){
		if(event.keyCode == 13){    
			submitData();
		}
	});
})
function BrowseTable_onclick(e){
	var e=e||event;
	var target=e.srcElement||e.target;

	if( target.nodeName =="TD"||target.nodeName =="A"  ){
		var tr ;
		if(target.nodeName=="TD"){
			tr = jQuery(target).parent();
		}else if(target.nodeName =="A" ){
			tr = jQuery(target).parent().parent();
		}
		var idValue = tr.find("input[type='checkbox']").val();
		var isvirtualform = 0;
		var vstr = tr.find("td:last").html();
		if(vstr=="<%=SystemEnv.getHtmlLabelName(33885,user.getLanguage())%>"){//虚拟表单
			isvirtualform = 1;
		}
   	 	var nameValue = ""+
   	 				 jQuery(jQuery(target).parents("tr")[0].cells[1]).text();
		var returnjson = {id:idValue,name:nameValue};
		if(dialog){
	    	dialog.callback(returnjson);
	    	if(parentWin.customDialogCallBack){
		    	parentWin.customDialogCallBack(isvirtualform);
		    }
		}else{
	    	window.parent.returnValue  = returnjson;
	    	window.parent.close();
		}
	}
}
function submitData(){
	SearchForm.submit();
}

function submitClear()
{
	btnclear_onclick();
}

function nextPage(){
	document.all("pagenum").value=parseInt(document.all("pagenum").value)+1 ;
	SearchForm.submit();	
}

function perPage(){
	document.all("pagenum").value=document.all("pagenum").value-1 ;
	SearchForm.submit();
}

function searchReset() {
	SearchForm.browsername.value='';
	SearchForm.appid.value='';
}
</script>


