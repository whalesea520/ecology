<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.*" %>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ContractTempletComInfo" class="weaver.hrm.contract.ContractTempletComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<html>
<%
if(!HrmUserVarify.checkUserRight("HrmContractAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}

String contractTypeName = Util.null2String(request.getParameter("contractTypeName"));
String templetId = Util.null2String(request.getParameter("templetId"));
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("15775",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->HrmContractTypeBrowser.jsp");
	}
</script>
</head>
<body>
	<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type=button class="e8_btn_top" onclick="document.SearchForm.submit();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<%
int userid = user.getUID();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(172,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15775,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/contract/contract/HrmContract.jsp,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>	
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:doReset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom:0" action="HrmContractTypeBrowser.jsp" method=post>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
    <wea:item>
      <input class=inputstyle style="width: 120px" id=contractTypeName name=contractTypeName value="<%=contractTypeName%>">
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></wea:item>
    <wea:item>
    	<brow:browser viewType="0" name="templetId" browserValue='<%=templetId %>' 
      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/contract/contracttemplet/HrmConTempletBrowser.jsp?selectedids="
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
      completeUrl="/data.jsp?type=HrmConTemplet" width="120px"
      browserSpanValue='<%=Util.toScreen(ContractTempletComInfo.getContractTempletname(templetId),user.getLanguage()) %>'
      ></brow:browser>
    </wea:item>
	</wea:group>
</wea:layout>

<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width: 100%">
  <TBODY>  
	<TR class=DataHeader>
    <TH style="display: none"></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15775,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15786,user.getLanguage())%></TH>    
    <TH><%=SystemEnv.getHtmlLabelName(15787,user.getLanguage())%></TH>        
  </TR>  
  </tr><TR class=Line><TH colspan="4" ></TH></TR>
 
<%
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
  String departmentid = Util.null2String(request.getParameter("departmentid"));
  String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
  String subcmpanyid1 = "";
  if(subcompanyid.length() > 0){
   	subcmpanyid1 = subcompanyid;
  }else{
  	subcmpanyid1 = DepartmentComInfo.getSubcompanyid1(departmentid);
  }
  int needchange = 0;
  String sql = "";
  String temp = "";
  String sqlwhere = "";
  if(contractTypeName.length()>0){
  	sqlwhere +=" and type.typename like '%"+contractTypeName+"%'";
  }
  
  if(templetId.length()>0){
  	sqlwhere +=" and template.ID = '%"+templetId+"%'";
  }
  
  if(detachable==1){
  		sql = "select type.id,type.typename,type.saveurl,type.contracttempletid,type.ishirecontract,type.remindaheaddate,template.templetname,template.templetdocid from HrmContractType type,HrmContractTemplet template WHERE type.contracttempletid = template.ID " +sqlwhere+ " and type.subcompanyid = "+subcmpanyid1+" order by type.id";  
  }else{
  		sql = "select type.id,type.typename,type.saveurl,type.contracttempletid,type.ishirecontract,type.remindaheaddate,template.templetname,template.templetdocid from HrmContractType type,HrmContractTemplet template WHERE type.contracttempletid = template.ID " +sqlwhere+ " order by type.id";  
	}
 
  	
  String id="";
  String typename="";
  String saveurl="";
  String templetid="";
  String templetname="";
  String templetdocid ="";
  int ishire,aheaddate;
  
  int pathNumber;
  String path;

  rs.executeSql(sql);
  while(rs.next()){
    id = Util.null2String(rs.getString("id"));
    typename  = Util.null2String(rs.getString("typename"));
    saveurl  = Util.null2String(rs.getString("saveurl"));  

	pathNumber = Util.getIntValue(saveurl,-1);
	path = CategoryUtil.getCategoryPath(pathNumber);

    templetid  = Util.null2String(rs.getString("contracttempletid"));
	templetname =Util.null2String(rs.getString("templetname"));
	templetdocid = Util.null2String(rs.getString("templetdocid"));
    if(needchange%2==0){
      
%>  
    <TR class=DataLight>
<%
    }else{    
%>
    <TR class=DataDark>
<%
}
%>    

		<td style="display: none"><A HREF=#><%=id%></a></td> 
    <td><A HREF=#><%=typename%></a></td> 
    <td>

    <a href="/docs/mouldfile/DocMouldDsp.jsp?id=<%=templetdocid%>&urlfrom=hr&subcompanyid=<%=subcmpanyid1%>"><%=templetname%></a>
   
    </td>
    <td><%=path.equals("/")?"":"/"+path%></td>
<%
  needchange++;
  }
%>  
</tbody>      
</table>
</form>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnclear_onclick();">
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
</body>
<script type="text/javascript">
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}catch(e){}
	</script>
<script>
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

function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;
   if( target.nodeName =="TD"||target.nodeName =="A"  ){
	 var curTr=jQuery(target).parents("tr")[0];
	 var returnjson = {
    		 id:jQuery(curTr.cells[0]).text(),
    		 name:jQuery(curTr.cells[1]).text()
    		 };
    
    	if(dialog){
    		dialog.callback(returnjson);
    	}else{ 
     		window.parent.parent.returnValue =returnjson;
      	window.parent.parent.close();
      }
	}
}

function btnclear_onclick(){
  var returnjson = {id:"",name:""};
	if(dialog){
		dialog.callback(returnjson);
	}else{
    window.parent.parent.returnValue = returnjson;
    window.parent.parent.close();
  }
}

function btncancel_onclick(){
	if(dialog){
		dialog.close();
	}else{
    window.parent.parent.close();
  }
}

jQuery(function(){
	jQuery("#BrowseTable").mouseover(BrowseTable_onmouseover);
	jQuery("#BrowseTable").mouseout(BrowseTable_onmouseout);
	jQuery("#BrowseTable").click(BrowseTable_onclick);
	
	//$("#btncancel").click(btncancel_onclick);
	//$("#btnsub").click(btnsub_onclick);
	$("#btnclear").click(btnclear_onclick);
});

function doSearch(){
   jQuery("#SearchForm").submit();
}

function doReset(){
	_writeBackData('templetId','1',{'id':'','name':''});
	jQuery("#contractTypeName").val("");
}
</script>
</html>
