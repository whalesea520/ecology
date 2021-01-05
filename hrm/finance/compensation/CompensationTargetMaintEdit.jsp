
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CompensationTargetMaint" class="weaver.hrm.finance.compensation.CompensationTargetMaint" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%@taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
boolean hasright=true;
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));

if(subcompanyid==-1){
	subcompanyid=Util.getIntValue(request.getParameter("subcompanyid"));
}
int departmentid=Util.getIntValue(request.getParameter("departmentid"));
int isedit=Util.getIntValue(request.getParameter("isedit"));
String currentyear =Util.null2String(request.getParameter("CompensationYear"));
String currentmonth =Util.null2String(request.getParameter("CompensationMonth"));

//获得当前的年月
if(currentyear.trim().equals("") || currentmonth.trim().equals("")){
Calendar today = Calendar.getInstance();
currentyear = Util.add0(today.get(Calendar.YEAR), 4);
currentmonth = Util.add0(today.get(Calendar.MONTH) + 1, 2);
}

String showname="";
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable=Util.getIntValue((String)session.getAttribute("detachable"));
if(detachable==1){
    if(subcompanyid>0){
    int operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Compensation:Maintenance",subcompanyid);
    if(operatelevel<1){
        hasright=false;
    }
    }else{
       hasright=false;
    }
}
if(!HrmUserVarify.checkUserRight("Compensation:Maintenance", user) && !hasright){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
//判断是否为部门级权限
int maxlevel=0;
RecordSet.executeSql("select c.rolelevel from SystemRightDetail a, SystemRightRoles b,HrmRoleMembers c where b.roleid=c.roleid and a.rightid = b.rightid and a.rightdetail='Compensation:Maintenance' and c.resourceid="+user.getUID()+" order by c.rolelevel");
while(RecordSet.next()){
    int rolelevel=RecordSet.getInt(1);
    if(maxlevel<rolelevel) maxlevel=rolelevel;
}
if(maxlevel==0){
	hasright = user.getUserDepartment() == departmentid;
	if(!hasright){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
}

ArrayList targetlist=new ArrayList();
ArrayList targetnamelist=new ArrayList();
String subcomidstr="";
if(subcompanyid>0){
    showname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
    if(departmentid>0) showname+="/"+DepartmentComInfo.getDepartmentname(""+departmentid);
    String allrightcompany = SubCompanyComInfo.getRightSubCompany(user.getUID(), "Compensation:Maintenance", 0);
    ArrayList allrightcompanyid = Util.TokenizerString(allrightcompany, ",");
    subcomidstr = SubCompanyComInfo.getRightSubCompanyStr1("" + subcompanyid, allrightcompanyid);
    CompensationTargetMaint.getDepartmentTarget(subcompanyid,departmentid,user.getUID(),"Compensation:Maintenance", 0,false);
    targetlist=CompensationTargetMaint.getTargetlist();
    targetnamelist=CompensationTargetMaint.getTargetnamelist();
}else{
    hasright=false;
}
if(user.getUID()==1){
	hasright=true;
}
int cols=4+targetlist.size();
if(departmentid<1)
cols=cols+2;
ExcelFile.init() ;
ExcelSheet es = new ExcelSheet();
ExcelRow er = es.newExcelRow () ;
ExcelStyle style = ExcelFile.newExcelStyle("Header") ;
style.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
style.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
style.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
style.setAlign(ExcelStyle.WeaverHeaderAlign) ;
er.addStringValue("ID","Header");
er.addStringValue(SystemEnv.getHtmlLabelName(413,user.getLanguage()),"Header");
er.addStringValue(SystemEnv.getHtmlLabelName(19401,user.getLanguage()),"Header");    
for(int i=0;i<targetnamelist.size();i++){
    er.addStringValue((String)targetnamelist.get(i),"Header");
}
er.addStringValue(SystemEnv.getHtmlLabelName(454,user.getLanguage()),"Header");
es.addExcelRow(er);
String isclose = Util.null2String(request.getParameter("isclose"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript>
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}

function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showdeptCompensation(deptid,xuhao){
    var ajax=ajaxinit();
    ajax.open("POST", "CompensationTargetViewAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("subCompanyId=<%=subcompanyid%>&departmentid="+deptid+"&xuhao="+xuhao+"&isedit=1&CompensationYear=<%=currentyear%>&CompensationMonth=<%=currentmonth%>&userid=<%=user.getUID()%>&showdept=<%=departmentid%>");
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                $GetEle("div"+deptid).innerHTML=ajax.responseText;
            }catch(e){
                return false;
            }
        }
    }
}
</script>
</head>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19430,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<div class="zDialog_div_content">
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(hasright){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:save(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18596,user.getLanguage())+",javascript:loadexcel(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(19489,user.getLanguage())+",/weaver/weaver.file.ExcelOut,ExcelOut} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:ondelete(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CompensationTargetMaint.jsp?subCompanyId="+subcompanyid+"&departmentid="+departmentid+",_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="save(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="CompansationTargetMaintOperation.jsp" method=post enctype="multipart/form-data" >
<input type="hidden" id="option" name="option" value="">
<%for(int i=0;i<targetlist.size();i++){%>
<input type="hidden" name="targetid<%=i%>" value="<%=targetlist.get(i)%>">
<%}%>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19464,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%></wea:item>
    <wea:item>
    	<%if(departmentid>0){ %>
    	<%=showname%>
    	<input class=inputstyle type="hidden"  name="departmentid" value="<%=departmentid%>">
    	<%}else{ %>
    		<brow:browser viewType="0"  name="subcompanyid" browserValue='<%=subcompanyid>0?subcompanyid+"":"" %>' 
	        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser.jsp?rightStr=Compensation:Maintenance&selectedids="
	        hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
	        completeUrl="/data.jsp?type=164"
	        _callback="jsSubmit" browserSpanValue='<%=showname %>'>
	      </brow:browser>
     	<%} %>
   	</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(19465,user.getLanguage())%></wea:item>
   	<wea:item>
          <%
          if(isedit!=1){
          %>
              <select class=inputstyle   name="CompensationYear" >
        <%
            // 查询选择框的所有可以选择的值
            int defaultsel=Util.getIntValue(currentyear,2006);
            for(int y=defaultsel-50;y<defaultsel+50;y++){
	   %>
	    <option value="<%=y%>" <%if(defaultsel==y){%>selected<%}%>><%=y%></option>
	   <%
            }
       %>
          </select><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;
              <select class=inputstyle   name="CompensationMonth" >
                  <option value="01" <%if(currentmonth.equals("01")){%>selected<%}%>>01</option>
                  <option value="02" <%if(currentmonth.equals("02")){%>selected<%}%>>02</option>
                  <option value="03" <%if(currentmonth.equals("03")){%>selected<%}%>>03</option>
                  <option value="04" <%if(currentmonth.equals("04")){%>selected<%}%>>04</option>
                  <option value="05" <%if(currentmonth.equals("05")){%>selected<%}%>>05</option>
                  <option value="06" <%if(currentmonth.equals("06")){%>selected<%}%>>06</option>
                  <option value="07" <%if(currentmonth.equals("07")){%>selected<%}%>>07</option>
                  <option value="08" <%if(currentmonth.equals("08")){%>selected<%}%>>08</option>
                  <option value="09" <%if(currentmonth.equals("09")){%>selected<%}%>>09</option>
                  <option value="10" <%if(currentmonth.equals("10")){%>selected<%}%>>10</option>
                  <option value="11" <%if(currentmonth.equals("11")){%>selected<%}%>>11</option>
                  <option value="12" <%if(currentmonth.equals("12")){%>selected<%}%>>12</option>
              </select><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
          <%
              }else{
          %>
          <%=currentyear%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%><%=currentmonth%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
          <input type="hidden" name="CompensationYear" value="<%=currentyear%>">
          <input type="hidden" name="CompensationMonth" value="<%=currentmonth%>">
          <%
              }
          %>
          </wea:item>
				  <%if(hasright){%>
          <wea:item><%=SystemEnv.getHtmlLabelName(16699,user.getLanguage())%></wea:item>
          <wea:item><input class=inputstyle type=file  name="targetfile" size=40>&nbsp;&nbsp;<button Class=AddDoc type=button onclick="loadexcel(this)"><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%></button></wea:item>
				  <%}%>    
				<wea:item>
				
				<font size="2" color="#FF0000">
				<%
				String msg=Util.null2String(request.getParameter("msg"));
				//String msg1=Util.null2String(request.getParameter("msg1"));
				//String msg2=Util.null2String(request.getParameter("msg2"));
				String msg1 = Util.null2String((String)request.getSession().getAttribute("msg1"));
				String msg2 = Util.null2String((String)request.getSession().getAttribute("msg2"));
				String msg3=Util.null2String(request.getParameter("msg3"));
				String msg4=Util.null2String(request.getParameter("msg4"));
				int    dotindex=0;
				int    cellindex=0;
				int    msgsize;
				msgsize=Util.getIntValue(request.getParameter("msgsize"),0);
				
				if (msg.equals("success")){
				    msg=SystemEnv.getHtmlLabelName(19488,user.getLanguage());
				    out.println(msg);
				}else{
				    for (int i=0;i<msgsize;i++){
				        dotindex=msg1.indexOf(",");
				        cellindex=msg2.indexOf(",");
				        out.println(msg1.substring(0,dotindex)+"&nbsp;"+SystemEnv.getHtmlLabelName(18620,user.getLanguage())+"&nbsp;"+msg2.substring(0,cellindex)+"&nbsp;"+SystemEnv.getHtmlLabelName(18621,user.getLanguage())+"&nbsp;"+SystemEnv.getHtmlLabelName(19327,user.getLanguage())+"<br>");
				
				         msg1=msg1.substring(dotindex+1,msg1.length());
				         msg2=msg2.substring(cellindex+1,msg2.length());
				    }
				}
				if(!msg3.trim().equals("")){
				    out.println("<br>"+SystemEnv.getHtmlLabelName(19401,user.getLanguage())+msg3.substring(0,msg3.length()-1)+SystemEnv.getHtmlLabelName(19327,user.getLanguage()));
				}
				if(!msg4.trim().equals("")){
				    out.println("<br>"+SystemEnv.getHtmlLabelName(19383,user.getLanguage())+msg4.substring(0,msg4.length()-1)+SystemEnv.getHtmlLabelName(19327,user.getLanguage()));
				}
				%>
				 </font>
				 </wea:item>
</wea:group>
<%
if( departmentid>0||subcompanyid>0){
    int widthint=450;
    if(departmentid<1){
        widthint+=400;
    }
    for(int i=0;i<targetlist.size();i++){
        widthint+=100;
    }
%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(19454,user.getLanguage())%>'>
<wea:item attributes="{'isTableList':'true'}">
<div style="overflow:auto;width:100%;" id="scrollcontainer">
<div style="min-width:<%=widthint%>px;">
<TABLE class=ListStyle cellspacing=1 id="oTable" width="<%=widthint%>" style="overflow:auto;">
  <TR class=header style="HEIGHT: 30px ;BORDER-Spacing:1pt;word-wrap:break-word; word-break:break-all;">
  <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="50"><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></TH>
  <%if(departmentid<1){%>
  <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="200"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TH>
  <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="200"><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%></TH>
  <%}%>
  <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="100"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TH>
  <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="100"><%=SystemEnv.getHtmlLabelName(19401,user.getLanguage())%></TH>
  <%for(int i=0;i<targetlist.size();i++){%>
  <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="100"><%=targetnamelist.get(i)%></TH>
  <%}%>
  <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="200"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
  </TR>
  <tr> 
       <td colspan="<%=cols%>" style="overflow:auto;">
  <%
  String sql="";
  int i=0;
  int tempdeptid=-100;
  int rows=0;
  if(departmentid>0){
      sql="select distinct a.departmentid,a.id,a.lastname,a.workcode,b.id as comtargetid,b.memo from hrmresource a left join HRM_CompensationTargetInfo b on a.id=b.Userid and b.CompensationYear="+currentyear+" and b.CompensationMonth="+Util.getIntValue(currentmonth)+" where a.subcompanyid1="+subcompanyid+" and a.departmentid="+departmentid+" and a.status in(0,1,2,3) order by a.id";
  }else{
      sql="select distinct a.departmentid,a.id,a.lastname,a.workcode,b.id as comtargetid,b.memo from hrmresource a left join HRM_CompensationTargetInfo b on a.id=b.Userid and b.CompensationYear="+currentyear+" and b.CompensationMonth="+Util.getIntValue(currentmonth)+" where a.subcompanyid1 in("+subcomidstr+") and a.status in(0,1,2,3) order by a.departmentid,a.id";
  }
  RecordSet.executeSql(sql);
  while(RecordSet.next()){
      int viewdeptid=RecordSet.getInt(1);
      er = es.newExcelRow() ;
      int cuserid=RecordSet.getInt("id");
      String cusername=RecordSet.getString("lastname");
      String workcode=RecordSet.getString("workcode");
      String comtargetid=RecordSet.getString("comtargetid");
      String memo=RecordSet.getString("memo");
      ArrayList templist=CompensationTargetMaint.getTarget(comtargetid,targetlist);
      er.addStringValue(""+cuserid);
      er.addStringValue(cusername);
      er.addStringValue(workcode);
      for(int j=0;j<targetlist.size();j++){
          String temp="0";
          if(isedit==1) temp=(String)templist.get(j);
          if(Util.getDoubleValue(temp)>0) er.addValue(temp);
          else er.addStringValue("");
      }
      er.addStringValue(memo);
      if(tempdeptid!=-100&&tempdeptid!=viewdeptid){
  %>
  <div id="div<%=tempdeptid%>"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
  <script>showdeptCompensation("<%=tempdeptid%>","<%=i%>");</script>
  </div>
  <%
          tempdeptid=viewdeptid;
          i+=rows;
          rows=1;
      }else{
          if(tempdeptid==-100) tempdeptid=viewdeptid;
          rows++;
      }
  }
  if(tempdeptid>0){
  %>
  <div id="div<%=tempdeptid%>"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
  <script>showdeptCompensation("<%=tempdeptid%>","<%=i%>");</script>
  </div>
  <%
      i+=rows;
      rows=0;
  }
  %>

  </td>
   </tr></TABLE>
      <input type='hidden' id="rownum" name="rownum" value="<%=i%>">
      </div>
      </div>
   </wea:item>
   	</wea:group>
   	<%} %>
</wea:layout>
  <%
  ExcelFile.setFilename("CompensationTarget") ;
  ExcelFile.addSheet("CompensationTarget", es) ;

  %>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<input type='hidden' id="targetsize" name="targetsize" value="<%=targetlist.size()%>">
</FORM>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
	    	</wea:item>
	   	</wea:group>
	  </wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
	
<script language=javascript>

	$(document).ready(function(){
		var wHeight= window.parent.innerHeight;
		jQuery('#scrollcontainer').css("max-height",wHeight-100);
	});
	
function ondelete(obj){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		document.frmMain.option.value="delete";
        obj.disabled=true;
        document.frmMain.submit();
	});
}
function save(obj) {
		 if(!check_form(document.frmMain,"subcompanyid")){
		 	return;
		 }
    <%if(isedit==1){%>
    document.frmMain.option.value="edit";
    obj.disabled=true;
    document.frmMain.submit();
    <%}else{%>
    obj.disabled=true;
    var ajax=ajaxinit();
    ajax.open("POST", "CompensationTargetCheck.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("subCompanyId=<%=subcompanyid%>&departmentid=<%=departmentid%>&CompensationYear="+document.frmMain.CompensationYear.value+"&CompensationMonth="+document.frmMain.CompensationMonth.value);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            if(ajax.responseText!=1){
                window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19409,user.getLanguage())%>");
                obj.disabled=false;
                return false;
            }else{
                document.frmMain.option.value="add";
                document.frmMain.submit();
            }
            }catch(e){
                return false;
            }
        }
    }
    <%}%>

}
function loadexcel(obj) {
		 if(!check_form(document.frmMain,"subcompanyid")){
		 	return;
		 }
 if (document.frmMain.targetfile.value=="" || document.frmMain.targetfile.value.toLowerCase().indexOf(".xls")<0){
     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18618,user.getLanguage())%>");
     document.frmMain.targetfile.value="";
}else{
    <%if(isedit!=1){%>
     var ajax=ajaxinit();
    ajax.open("POST", "CompensationTargetCheck.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("subCompanyId=<%=subcompanyid%>&departmentid=<%=departmentid%>&CompensationYear="+document.frmMain.CompensationYear.value+"&CompensationMonth="+document.frmMain.CompensationMonth.value);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            if(ajax.responseText!=1){
                window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19409,user.getLanguage())%>");
                return false;
            }else{
                document.frmMain.option.value="loadfile";
                
                /*var showTableDiv  = document.getElementById('_xTable');
                var message_table_Div = document.createElement("div");
                message_table_Div.id="message_table_Div";
                message_table_Div.className="xTable_message";
                showTableDiv.appendChild(message_table_Div);
                var message_table_Div  = document.getElementById("message_table_Div");
                message_table_Div.style.display="inline";
                message_table_Div.innerHTML="<%=SystemEnv.getHtmlLabelName(19470,user.getLanguage())%>";
                var pTop= document.body.offsetHeight/2-60;
                var pLeft= document.body.offsetWidth/2-100;
                message_table_Div.style.position="absolute";
                message_table_Div.style.posTop=pTop;
                message_table_Div.style.posLeft=pLeft;*/
                obj.disabled=true;
                document.frmMain.submit();
            }
            }catch(e){
                return false;
            }
        }
    }
    <%}else{%>
    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(19481,user.getLanguage())%>",function(){
    	document.frmMain.option.value="loadfile";
    	/*
	    var showTableDiv  = document.getElementById('_xTable');
			var message_table_Div = document.createElement("<div>");
			message_table_Div.id="message_table_Div";
			message_table_Div.className="xTable_message";
			showTableDiv.appendChild(message_table_Div);
			var message_table_Div  = document.getElementById("message_table_Div");
			message_table_Div.style.display="inline";
			message_table_Div.innerHTML="<%=SystemEnv.getHtmlLabelName(19470,user.getLanguage())%>";
			var pTop= document.body.offsetHeight/2-60;
			var pLeft= document.body.offsetWidth/2-100;
			message_table_Div.style.position="absolute";
			message_table_Div.style.posTop=pTop;
			message_table_Div.style.posLeft=pLeft;*/
	    obj.disabled=true;
	    document.frmMain.submit();
    })
    <%}%>
 }
}

function jsSubmit(e,datas,name){
	window.location.href="/hrm/finance/compensation/CompensationTargetMaintEdit.jsp?subcompanyid="+datas.id;
}
</script>
</BODY>
</HTML>
