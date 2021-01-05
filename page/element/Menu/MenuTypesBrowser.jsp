
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo"
	scope="page" />
<jsp:useBean id="mhsc" class="weaver.page.style.MenuHStyleCominfo"
	scope="page" />
<jsp:useBean id="mvsc" class="weaver.page.style.MenuVStyleCominfo"
	scope="page" />

<jsp:useBean id="su" class="weaver.page.style.StyleUtil" scope="page" />
<html>
	<head>
		<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
	</head>
	<%
		//菜单样式浏览页面，可以不用进行权限验证
		/*
		if (!HrmUserVarify.checkUserRight("homepage:styleMaint", user))
		{
			response.sendRedirect("/notice/noright.jsp");
			return;
		}*/

		String type = Util.null2String(request.getParameter("type"));
		ArrayList idList = new ArrayList();
		ArrayList nameList = new ArrayList();
		ArrayList descList = new ArrayList();
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = "";
		String pageEdit = "";
		if ("element".equals(type))
		{
			titlename = SystemEnv.getHtmlLabelName(22913, user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320, user.getLanguage());
			pageEdit = "ElementStyleEdit.jsp";

			esc.setTofirstRow();
			while (esc.next())
			{
				idList.add(esc.getId());
				nameList.add(esc.getTitle());
				descList.add(esc.getDesc());
			}
		}
		else if ("menuh".equals(type))
		{
			titlename = SystemEnv.getHtmlLabelName(22914, user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320, user.getLanguage());
			pageEdit = "MenuStyleEditH.jsp";

			mhsc.setTofirstRow();
			while (mhsc.next())
			{
				idList.add(mhsc.getId());
				nameList.add(mhsc.getTitle());
				descList.add(mhsc.getDesc());
			}
		}
		else if ("menuv".equals(type))
		{
			titlename = SystemEnv.getHtmlLabelName(22915, user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320, user.getLanguage());
			pageEdit = "MenuStyleEditV.jsp";

			mvsc.setTofirstRow();
			while (mvsc.next())
			{
				idList.add(mvsc.getId());
				nameList.add(mvsc.getTitle());
				descList.add(mvsc.getDesc());
			}
		}
		String needfav = "1";
		String needhelp = "";
		
		String t_name=Util.null2String(request.getParameter("t_name")).trim();
		String t_desc=Util.null2String(request.getParameter("t_desc")).trim();
		
	%>

<HTML>
	<HEAD>
		<LINK REL=stylesheet type="text/css" HREF="/css/Weaver_wev8.css">
	</HEAD>

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
		<FORM NAME="SearchForm" action="MenuTypesBrowser.jsp" method=post   id="SearchForm" >
			<input type="hidden" name="pagenum" value=''>
			<input type="hidden" name="type" value='<%=type%>'>

     <wea:layout type="2col">
		 <wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
               <wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
              <wea:item> <input name='name' class='inputstyle' value='<%=t_name%>'></wea:item>
	    </wea:group>
	     <wea:group context="" attributes="{'groupDisplay':'none'}">
			  	<wea:item attributes="{'colspan':'full'}">&nbsp;</wea:item>
		</wea:group>
			  <wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item attributes="{'isTableList':'true','colspan':'full'}">
									
							<TABLE ID=BrowseTable class=BroswerStyle cellspacing="1" style="width:100%;margin-bottom: 50px"
								cellpadding="0">
								<TR class=DataHeader>
									<TH width=0% style="display: none"><%=SystemEnv.getHtmlLabelName(84, user.getLanguage())%></TH>
									<TH>
										<%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></TH>
									<TH>
										<%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></TH>
								</TR>
								<TR class=Line>
									<TH colSpan=3></TH>
								</TR>
								<%
									ArrayList cloneNameList = (ArrayList) nameList.clone();
									Collections.sort(cloneNameList);
									
									for (int i = 0; i < cloneNameList.size(); i++)
									{
										String stylename = (String) cloneNameList.get(i);
										int pos = nameList.indexOf(stylename);

										String styleid = (String) idList.get(pos);
										String styledesc = (String) descList.get(pos);
											if(stylename.indexOf(t_name)!=-1&&styledesc.indexOf(t_desc)!=-1){
								%>
								<TR <%if((i+1)%2==0) out.println(" class='DataDark' "); else out.println(" class='DataLight' ");%>>
									<TD style="display: none"><A HREF=#><%=styleid%></A></TD>
									<TD valign="middle" style="padding-left: 12px;" width="15%">
										<%=stylename%>
									</TD>
									<TD valign="middle" style="padding-left: 12px;" width="40%"><%=styledesc%></TD>
								</TR>
								<%
										}
									}
								%>
							</TABLE>
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
<SCRIPT LANGUAGE=VBS>


</SCRIPT>
<script type="text/javascript">
function onsech(){
		$("#SearchForm").submit();
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
			    dialog.callback({id:"",name:""});
			}catch(e){}
			try{
			dialog.close({id:"",name:""});
			}catch(e){}
	 }else{  
		    window.parent.returnValue = {id:"",name:""};
			window.parent.close();
	  }
}


function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;
   if( target.nodeName =="TD"||target.nodeName =="A"  ){
		var curTr=jQuery(target).parents("tr")[0];
	      
	      if(dialog){
	    	 
	    	 try{
			   dialog.callback({id:jQuery(curTr.cells[0]).text(),name:jQuery(curTr.cells[1]).text()});
			}catch(e){}
			try{
			dialog.close( {
	    		 id:jQuery(curTr.cells[0]).text(),
	    		 name:jQuery(curTr.cells[1]).text()});
			}catch(e){}
		 }else{  
			    window.parent.returnValue = {id:jQuery(curTr.cells[0]).text(),name:jQuery(curTr.cells[1]).text()};
				window.parent.close();
		  }
	      
   }
}
$(function(){

	$("#BrowseTable").click(BrowseTable_onclick);
});
</script>
