
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.systeminfo.role.StructureRightHandler,weaver.systeminfo.role.StructureRightInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-30 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
    int id=Util.getIntValue(request.getParameter("id"),0);//角色ID
    int flag=Util.getIntValue(request.getParameter("flag"),0);
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	
    rs.execute("hrmroles_selectSingle",String.valueOf(id));
    rs.next();

    String rolesmark=rs.getString(1);
    String rolesname=rs.getString(2);
    int docid=Util.getIntValue(rs.getString(3),0);
    int roletype=Util.getIntValue(rs.getString(4),0);
    String structureid=rs.getString(5);
	
	String imagefilename = "/images/hdHRMCard_wev8.gif";
    String titlename =SystemEnv.getHtmlLabelName(122,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17865,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
	
	int operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmRolesAdd:Add",Integer.parseInt(structureid));
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
		<script type="text/javascript">
			var parentDialog = parent.parent.getDialog(parent);
			
			function doSave(){
				document.HrmRolesStrRightSet.submit();
			}
			function checkSubchk(parlist) {
				var len = document.HrmRolesStrRightSet.elements.length;
				for(var i=0; i<len; i++) {
					if (document.HrmRolesStrRightSet.elements[i].id=='chk1_'+parlist) {
						var eChecked = document.HrmRolesStrRightSet.elements[i].checked;
						var obj;
						var newId;
						var theEnd = 0;
						var mc = 0;
						var stus = new Array();
						for(var j=0; j<len; j++){
							obj=document.HrmRolesStrRightSet.elements[j];
							newId = obj.id.substr(0,parlist.length+5);
							var isP = false;
							if (newId=='chk1_'+parlist){
								obj.checked = eChecked;
								if(!eChecked){//如果是取消勾选的时候，把对象的obj.disabled 先置为false
									disOrEnableCheckbox(obj,false);
								}
								changeCheckboxStatus(obj,eChecked);
								if (obj.id!='chk1_'+parlist){
									disOrEnableCheckbox(obj,eChecked);
								}
								isP = true;
								$GetEle("span_"+obj.id.substr(5)).style.display=eChecked?'':'none';
							}else if (newId=='chk2_'+parlist || (newId=='leaf_'+parlist && eChecked)){
								obj.checked = eChecked;
								changeCheckboxStatus(obj,eChecked);
								isP = true;
								theEnd = j;
							}
							stus[j] = isP;
							mc = j - theEnd;
							if(isP == false && theEnd > 0 && mc > 3){
								var cnt = 0;
								for(var tmp = theEnd+1; tmp <= j; tmp++){
									if(stus[tmp] == false) cnt++;
								}
								if(cnt == mc) break;
							}
						}
						return;
					}
				}
			}
			function checkSubsel(thisobj,parlist) {
				var len = document.HrmRolesStrRightSet.elements.length;
				for(var i=0; i<len; i++) {
					var _obj = document.HrmRolesStrRightSet.elements[i];
					if (_obj.id=='leaf_'+parlist && _obj.checked) {
						for(var j=0; j<len; j++){
							var obj=document.HrmRolesStrRightSet.elements[j];
							if (obj.id.substr(0,parlist.length+4)=='sel_'+parlist){
								changeSelectValue(obj.id,thisobj.options[thisobj.selectedIndex].value);
							}
						}
						return;
					}
				}
			}
			var dialog = null;//doOpen方法专用对象
			function doOpen(url,title,_dWidth,_dHeight){
				if(dialog==null){
					dialog = new window.top.Dialog();
				}
				dialog.currentWindow = window;
				dialog.Title = title;
				dialog.Width = _dWidth;
				dialog.Height = _dHeight;
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.URL = url;
				dialog.show();
			}
			
			function showLog(id){
				var url = "";
				if(id && id!=""){
					url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=103 and relatedid=")%>&relatedid="+id;
				}else{
					url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=103")%>";
				}
				doOpen(url,"<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
			}
		</script>
	</HEAD>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(operatelevel>0){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave();,_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:showLog("+id+");,_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<%if(operatelevel>0){%>
					<input type=button class="e8_btn_top" onclick="doSave();" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
					<%}%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>

<form method=post name=HrmRolesStrRightSet action=HrmRolesStrRightOperation.jsp>
<table class=ListStyle cols=2  border=0 cellspacing=1 name="tab001">
<COLGROUP>
	<col width="70%">
	<col width="30%">
</COLGROUP>
<TR CLASS=HeaderForXtalbe>
  <th><%=SystemEnv.getHtmlLabelName(17871,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(17872,user.getLanguage())%></th>
</TR>
<TR class=DataLight><TD colspan="2" >
&nbsp&nbsp<IMG src='/images/treeimages/global_wev8.gif' align=absMiddle><%=CompanyComInfo.getCompanyname(""+1)%>
</TD></TR> 
<%  int i =0;
    StructureRightInfo mSri=null;
    StructureRightHandler mSriHander=new StructureRightHandler();
    if(operatelevel>0){
    	//如果有权限操作显示自己的
    	mSriHander.StructureRightInfoDo(id,user.getUID());
    }else{
    	//如果没有操作权限，显示整个树，只做显示，无实际意义
    	mSriHander.StructureRightInfoDo(id,1);
    }
    int structureCount=mSriHander.size();
    for(int j=0;j<structureCount;j++){
      mSri=mSriHander.get(j);
      if(SubCompanyComInfo.getCompanyiscanceled(mSri.getId()).equals("1")){
      	continue;
      }
    if(i==0){i=1;
    %>
    <TR class=DataDark name="tr001">
    <%}else{i=0;%>
    <TR class=DataLight name="tr002">
    <%}%>
    <TD name="td001">
    <!--第一列-->
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <%for(int k=0;k<mSri.getTabNo();k++){%>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <%}%>
    <IMG src='/images/treeimages/Home_wev8.gif' align=absMiddle>
    <%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(mSri.getId()),user.getLanguage())%>
    <%if(mSri.getNodetype()==1){%>
      <input type="checkbox" id='chk1_<%=mSri.getParent_list()%>_' name='chk1_<%=mSri.getParent_list()%>_' value="1" 
      <% if(mSri.getBeChecked()==1) {%>checked<%}%>
      <% if(mSri.getIsdisable()==1) {%>disabled<%}%>
      onclick="checkSubchk('<%=mSri.getParent_list()%>_')" <%if(operatelevel<1){%>style="display:none"<%}%>>
      <input type="checkbox" name='chk_<%=j%>' id='chk2_<%=mSri.getParent_list()%>_' value="1" 
      <% if(mSri.getBeChecked()==1) {%>checked<%}%> style="display:none">
    <%}%>
    <input class=inputstyle type=hidden name='subid_<%=j%>' value=<%=mSri.getId()%> >
    </TD>
    <TD>
    <!--第二列-->
    <%if(mSri.getNodetype()==1){%>
     <span ID='span_<%=mSri.getParent_list()%>_' <%if(mSri.getBeChecked()==0){%>style="display:none"<%}%>>
       <%if(operatelevel>0){%>
           <select name='sel_<%=j%>' id='sel_<%=mSri.getParent_list()%>' 
           <%if(mSri.getIsleaf()== 1){%>onchange="checkSubsel(this,'<%=mSri.getParent_list()%>_')"<%}%>>
              <option value="-1" <%if(mSri.getOperateType_select()==-1){%>selected<%}%> >
              <%=SystemEnv.getHtmlLabelName(17875,user.getLanguage())%></OPTION>
              <%if(mSri.getOperateType_Range()>-1){%>
                <option value="0" <%if(mSri.getOperateType_select()==0){%>selected<%}%> >
                <%=SystemEnv.getHtmlLabelName(17873,user.getLanguage())%></OPTION>
              <%}%>
              <%if(mSri.getOperateType_Range()>0){%>
                <option value="1" <%if(mSri.getOperateType_select()==1){%>selected<%}%> >
                <%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></OPTION>
              <%}%>
              <%if(mSri.getOperateType_Range()>1){%>
                <option value="2" <%if(mSri.getOperateType_select()==2){%>selected<%}%> >
                <%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></OPTION>
              <%}%>
           </select>
           <%if(mSri.getIsleaf()== 1){%>
            <input type="checkbox" id='leaf_<%=mSri.getParent_list()%>_' checked>
            <%=SystemEnv.getHtmlLabelName(17876,user.getLanguage())%>
           <%}%>
       <%}else{%>
            <%if(mSri.getOperateType_select()==0){%>
                <%=SystemEnv.getHtmlLabelName(17873,user.getLanguage())%>
            <%}%>
            <%if(mSri.getOperateType_select()==1){%>              
                <%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
            <%}%>
            <%if(mSri.getOperateType_select()==2){%>
                <%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
            <%}%>
       <%}%>
     </span>
    <%}%>
    </TD></TR>
<%}%>
<input class=inputstyle type=hidden name=structureCount value=<%=structureCount%>>
<input class=inputstyle type=hidden name=roleid value=<%=String.valueOf(id)%>>
</TABLE>
</FORM>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentDialog.close();">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
</BODY>
</HTML>
