
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpu" class="weaver.page.PageUtil" scope="page"/>

<%@ include file="/systeminfo/init_wev8.jsp" %>


<% 	
boolean canMaint = HrmUserVarify.checkUserRight("homepage:Maint", user);
boolean canEdit=false;

String hpids = hpu.getUserMaintHpidListPublic(user.getUID()).toString().replace("[","").replace("]","");
boolean isDetachable=hpu.isDetachable(request);
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);
String message = Util.null2String(request.getParameter("message"));
//System.out.println("subCompanyId: "+subCompanyId);
//页标题
int operatelevel=0;

if(isDetachable){
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"homepage:Maint",subCompanyId);
}else{
    if(HrmUserVarify.checkUserRight("homepage:Maint", user))       operatelevel=2;
}
if(operatelevel>0&&subCompanyId!=-1) canEdit=true;
if((canMaint && !canEdit)|| (!canMaint && "".equals(hpids))){
     response.sendRedirect("/notice/noright.jsp");
	 return;
}

//门户名称
String infoname = Util.null2String(request.getParameter("infoname"));
	
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>




<BODY>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23018,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//得到分部ID


//System.out.println("operatelevel: "+operatelevel);
//System.out.println("subCompanyId: "+subCompanyId);
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(18633,user.getLanguage())+",javascript:clearAppoint(),_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;
    if(canMaint){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:onNew(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
    }

	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	
	if(HrmUserVarify.checkUserRight("hporder:maint", user)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(24668,user.getLanguage())+",javascript:onOrder(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="searchPortalForm" name="searchPortalForm" method="post" action="HomepageRight.jsp">
	<input type="hidden" id="operate" name="operate" value=""/>
	<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td width="75px">					
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
			<% if(canMaint){ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>" class="e8_btn_top" onclick="onNew();" />
			<%} %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top"  onclick="onSave();"/>
		    <% if(canMaint){ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="onDelAll();"/>
			<%} %>
				<% if(HrmUserVarify.checkUserRight("hporder:maint", user)){ %>
				    <input type="button" value="<%=SystemEnv.getHtmlLabelName(24668,user.getLanguage())%>" class="e8_btn_top" onclick="onOrder();"/>
				<%} %>
				<input type="text" id="searchInput" name="infoname" class="searchInput"  value="<%=infoname %>"/>
				&nbsp;&nbsp;&nbsp;
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<div class="advancedSearchDiv" id="advancedSearchDiv">
	</div>
</form>
<form name="frmAdd" method="post" action="HomepageMaintOperate.jsp?subCompanyId=<%=subCompanyId%>">
<input name="method" type="hidden">
<TEXTAREA id="areaResult" NAME="areaResult" ROWS="2" COLS="30" style="display:none"></TEXTAREA>
	 <!--列表部分-->
  <%
		//得到pageNum 与 perpage
		int pagenum = Util.getIntValue(request.getParameter("pagenum"),1) ;
		int perpage =10;
		//设置好搜索条件
		String 	sqlWhere="";
		if ("sqlserver".equals(rs.getDBType())){
			if (user.getUID()==1){  //sysadmin
				sqlWhere = " where  (creatortype=4  or creatortype=3 and creatorid="+subCompanyId+"  ) and subcompanyid!=-1 and  infoname != ''";
			} else {
				sqlWhere = " where   (creatortype=3 and creatorid="+subCompanyId+") and subcompanyid!=-1 and  infoname != ''";
			}
		} else {
			if (user.getUID()==1){  //sysadmin
				sqlWhere = " where  (creatortype=4  or creatortype=3 and creatorid="+subCompanyId+"  ) and subcompanyid!=-1 and  infoname is not null";
			} else {
				sqlWhere = " where   (creatortype=3 and creatorid="+subCompanyId+"  )  and subcompanyid!=-1 and  infoname is not null";
			}
		}
		
		//名称过滤
		if(!"".equals(infoname) && infoname != null){
			sqlWhere = sqlWhere + " and infoname like '%"+infoname+"%'";
		}
		
		//System.out.println("========sqlWhere"+sqlWhere);
		
		String tableString=""+
				 "<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\" valign=\"top\">"+
				 "<checkboxpopedom popedompara=\"column:id\" showmethod=\"weaver.splitepage.transform.SptmForHomepage.getPortalDel\"/>"+
			   "<sql backfields=\"id,infoname,subcompanyid,isuse,islocked,creatorid,hpcreatorid,hplanuageid,hplastdate\" sqlform=\" from hpinfo \"  sqlorderby=\"subcompanyid\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />"+
			   "<head >"+
				 "<col width=\"5%\"  text=\"ID\"   column=\"id\" orderkey=\"id\" />"+
				 "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\"  column=\"infoname\" orderkey=\"infoname\" />"+
				 "<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\" column=\"subcompanyid\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" orderkey=\"subcompanyid\"/>"+
				 "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+"\" column=\"isUse\" orderkey=\"isUse\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getIsUseStr\" otherpara=\"column:id\"/>"+
				"<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(16213,user.getLanguage())+"\" column=\"islocked\" orderkey=\"islocked\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getIsLockedStr\" otherpara=\"column:id\"/>"+
				"<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"hpcreatorid\" otherpara=\"column:id+column:subcompanyid+"+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getPortalCreator\" />"+
				 "<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(19520,user.getLanguage())+"\" column=\"hplastdate\" />"+
			   "</head>"+
			   "<operates width=\"20%\" >";
       if(operatelevel>0&&subCompanyId!=-1){
                tableString+="<popedom otherpara=\"column:id\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getOperate\"></popedom> "
                	+ "<operate href=\"javascript:doSetElement();\" text=\""+SystemEnv.getHtmlLabelName(19650,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>"
        			 
                + "<operate href=\"javascript:doPriview();\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>"
				 + "<operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" target=\"_blank\"  index=\"2\"/>"
				 + "<operate href=\"javascript:saveNew();\" text=\""+SystemEnv.getHtmlLabelName(350,user.getLanguage())+"\" target=\"_self\"  index=\"3\"/>"
				 + "<operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\"  index=\"4\"/>"
				 + "<operate href=\"javascript:doMaint();\" text=\""+SystemEnv.getHtmlLabelName(19909,user.getLanguage())+"\" target=\"_self\"  index=\"5\"/>"
				 + "<operate href=\"javascript:doShare();\" text=\""+SystemEnv.getHtmlLabelName(19910,user.getLanguage())+"\" target=\"_self\"  index=\"6\"/>";
        }   else {
                tableString+="  <operate  text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" />"+
				"  <operate   text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" />"+
                "  <operate  text=\""+SystemEnv.getHtmlLabelName(350,user.getLanguage())+"\" />"+
                "  <operate   text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\"/>";
        }

        tableString+=  "</operates></table>";
                  %>

	<%

	   String 	sqlWhere2="";
		if ("sqlserver".equals(rs.getDBType())){
			sqlWhere2=" and subcompanyid!=-1 and h1.infoname != ''";
		} else {
			sqlWhere2=" and subcompanyid!=-1 and h1.infoname is not null";
		}
		
		//名称过滤
		if(!"".equals(infoname) && infoname != null){
			sqlWhere2 = sqlWhere2 + " and infoname like '%"+infoname+"%'";
		}
		
		// 无功能权限  但有 页面 维护权限
		if(!HrmUserVarify.checkUserRight("homepage:Maint", user) && !"".equals(hpids)){
			sqlWhere2 = sqlWhere2 + " and id in ("+hpids+")";
		}
		
		
	  //System.out.println("========sqlWhere2"+sqlWhere2);

	  if(subCompanyId==0 && user.getUID()==1&&isDetachable||subCompanyId==0&&!isDetachable){//表总部 显示所有被删除掉分部的首页
			//sqlWhere=" where subcompanyid="+subCompanyId;
			//out.println("&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(25398,user.getLanguage())+SystemEnv.getHtmlLabelName(23018,user.getLanguage()));
			
			tableString="<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\" valign=\"top\" >"+
			 "<checkboxpopedom popedompara=\"column:id\" showmethod=\"weaver.splitepage.transform.SptmForHomepage.getPortalDel\"/>"+
			"<sql backfields=\"id,infoname,subcompanyid,isuse,islocked,creatorid,hpcreatorid,hplanuageid,hplastdate\" sqlform=\" from hpinfo h1 \"  sqlorderby=\"h1.subcompanyid\"  sqlprimarykey=\"h1.id\" sqlsortway=\"asc\" sqlwhere=\""+Util.toHtmlForSplitPage("where 1=1 "+sqlWhere2)+"\" sqldistinct=\"true\" />"+
			"<head >"+
			 "<col width=\"5%\"  text=\"ID\"   column=\"id\" />"+
			 "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\"  column=\"infoname\" orderkey=\"infoname\" />"+
			 "<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\" column=\"subcompanyid\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" orderkey=\"subcompanyid\"/>"+
		  	 "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+"\" column=\"isUse\" orderkey=\"isUse\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getIsUseStr\" otherpara=\"column:id\"/>"+
		  	"<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(16213,user.getLanguage())+"\" column=\"islocked\" orderkey=\"islocked\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getIsLockedStr\" otherpara=\"column:id\"/>"+
			 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"hpcreatorid\" otherpara=\"column:id+column:subcompanyid+"+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getPortalCreator\" />"+									  
			 "<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(19520,user.getLanguage())+"\" column=\"hplastdate\" />"+
			"</head>"
			 + "<operates><popedom otherpara=\"column:id\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getOperate\"></popedom> "
			 + "<operate href=\"javascript:doSetElement();\" text=\""+SystemEnv.getHtmlLabelName(19650,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>"
				
			 + "<operate href=\"javascript:doPriview();\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>" +"";
			 if(canMaint){
				 String tableoperate = "<operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" target=\"_blank\"  index=\"2\"/>"
				 + "<operate href=\"javascript:saveNew();\" text=\""+SystemEnv.getHtmlLabelName(350,user.getLanguage())+"\" target=\"_self\"  index=\"3\"/>"
				 + "<operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\"  index=\"4\"/>"
				 + "<operate href=\"javascript:doMaint();\" text=\""+SystemEnv.getHtmlLabelName(19909,user.getLanguage())+"\" target=\"_self\"  index=\"5\"/>"
				 + "<operate href=\"javascript:doShare();\" text=\""+SystemEnv.getHtmlLabelName(19910,user.getLanguage())+"\" target=\"_self\"  index=\"6\"/>";
				 tableString = tableString + tableoperate;
	         }
			 tableString = tableString + "</operates>"+ "</table>";
		}
		%>
	<TABLE width="100%">
		<TR>
			<TD valign="top">
				<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"   />
			</TD>
		</TR>
	</TABLE>
</form>
</BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
	$(document).ready(function(){
		jQuery("#topTitle").topMenuTitle({searchFn:onSearch});
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();
	});
	
	function onSearch(){
		searchPortalForm.submit();		
	}
	
	function onNew(){
	 	var title = "<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>"; 
	 	var url = "/homepage/maint/HomepagePageEdit.jsp?method=ref&subCompanyId=<%=subCompanyId%>";
	 	showDialog(title,url,900,600,true);
	}
	
	function saveNew(hpid){
	 	var subCompanyId = jQuery("#hpSubid_"+hpid).val();
	 	var title = "<%=SystemEnv.getHtmlLabelName(350,user.getLanguage())%>"; 
	 	var url = "/homepage/maint/HomepagePageEdit.jsp?method=saveNew&hpid="+hpid+"&subCompanyId=<%=subCompanyId%>";
	 	showDialog(title,url,900,600,false);
	}

	function doEdit(hpid){
		var subCompanyId = jQuery("#hpSubid_"+hpid).val();
	 	var title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>"; 
	 	var url = "/homepage/maint/HomepagePageEdit.jsp?opt=edit&method=savebase&hpid="+hpid+"&subCompanyId=<%=subCompanyId%>";
	 	showDialog(title,url,900,600,true);
	}
	
	
	function onOrder(){
	 	var title = "<%=SystemEnv.getHtmlLabelName(24668,user.getLanguage())%>"; 
	 	var url = "/homepage/maint/HomepageLocation.jsp";
	 	showDialog(title,url,600,500,true);
	}
	
	function doSetElement(hpid){
		var subCompanyId = jQuery("#hpSubid_"+hpid).val();
	 	var title = "<%=SystemEnv.getHtmlLabelName(19650,user.getLanguage())%>"; 
	 	var url = "/homepage/maint/HomepageTabs.jsp?_fromURL=ElementSetting&isSetting=true&hpid="+hpid+"&from=setElement&pagetype=&opt=edit&subCompanyId="+subCompanyId;
	 	showDialog(title,url,top.document.body.clientWidth,top.document.body.clientHeight,true);
	}
	
	function doShare(hpid){
		var title = "<%=SystemEnv.getHtmlLabelName(19910,user.getLanguage())%>"; 
        var url="/homepage/maint/HomepageShare.jsp?hpid="+hpid;
        showDialog(title,url,800,600,true);
    }
    
	function doMaint(hpid){
		var title = "<%=SystemEnv.getHtmlLabelName(19909,user.getLanguage())%>"; 
        var url="/homepage/maint/HomepageMaint.jsp?hpid="+hpid;
        showDialog(title,url,800,600,true);
    }
	
	function doPriview(hpid){
		var subCompanyId = jQuery("#hpSubid_"+hpid).val();
	 	var title = "<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>"; 
	 	var url="/homepage/Homepage.jsp?hpid="+hpid+"&opt=privew&subCompanyId="+subCompanyId;
	 	showDialog(title,url,top.document.body.clientWidth,top.document.body.clientHeight,true);
	}
	
	function showDialog(title,url,width,height,showMax){
		var Show_dialog = new window.top.Dialog();
		Show_dialog.currentWindow = window;   //传入当前window
	 	Show_dialog.Width = width;
	 	Show_dialog.Height = height;
	 	Show_dialog.maxiumnable=showMax;
	 	Show_dialog.Modal = true;
	 	Show_dialog.Title = title;
	 	Show_dialog.URL = url;
	 	Show_dialog.show();
	}
	
	function doDel(hpid){
		var subCompanyId = jQuery("#hpSubid_"+hpid).val();
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
			jQuery.post("/homepage/maint/HomepageMaintOperate.jsp?method=delhp&hpid="+hpid,
			function(data){if(data.indexOf("OK")!=-1) location.reload();});
		});
	}
	
	function onDelAll(){
		var hpids = _xtable_CheckedCheckboxId();
		if(hpids==""){
		   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30993,user.getLanguage())%>");
		   return;
		}else{
		   doDel(hpids);
		}
	}

	function onSave(){
		//得到所设置的结果    hpid_isuse_ischecked||hpid_isuse_ischecked||...
		var chkUses=document.getElementsByName("chkUse");
		var returnStr="";
		for(var i=0;i<chkUses.length;i++) {
			var tmepChkUse=chkUses[i];
			var hpid=jQuery(tmepChkUse).attr("hpid");
			var isuse=tmepChkUse.checked?1:0;

			var isuse=tmepChkUse.checked?1:0;
			var ischecked=jQuery("#chkLocked_"+hpid).attr("checked")?1:0;

			returnStr+=hpid+"_"+isuse+"_"+ischecked+"||"
		}
		if (returnStr!="") returnStr=returnStr.substr(0,returnStr.length-2);
		frmAdd.areaResult.value=returnStr;

		frmAdd.method.value="save";
		frmAdd.submit()
	}
	
	function onUse(obj){
		if(!obj.checked){
			var id=obj.id;
			var temppos=id.indexOf ("_");
			var tempid=id.substring(temppos+1,id.length);
			jQuery("#chkLocked_"+tempid).attr("checked",false);
			jQuery("#chkLocked_"+tempid+" ~ span").removeClass("jNiceChecked");		
		}

	}

	function onLock(obj){
		if(obj.checked){
			var id=obj.id;
			var temppos=id.indexOf ("_");
			var tempid=id.substring(temppos+1,id.length);
			jQuery("#chkUse_"+tempid).attr("checked",true);
			jQuery("#chkUse_"+tempid+" ~ span").addClass("jNiceChecked");			
		}
	}
		
	function onTran2(subid,hpid){
	 	onTran(hpid,subid);
	}

	function onTran(hpid,subid){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?subid=<%=subCompanyId%>")
		
		if (datas){
			if(datas.id){
				targetSubid=datas.id;
				url="/homepage/maint/HomepageMaintOperate.jsp?method=tran&srcSubid="+subid+"&tranHpid="+hpid+"&targetSubid="+targetSubid+"&fromSubid=<%=subCompanyId%>&subCompanyId=<%=subCompanyId%>"
				window.location.replace(url);
			}
		}
	}

//-->
</SCRIPT>
