
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,org.json.*" %>

<jsp:useBean id="hpc" class= "weaver.homepage.cominfo.HomepageElementCominfo" scope="page" />
<jsp:useBean id="rc" class= "weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="scc" class= "weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="dci" class= "weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="role" class= "weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="shp" class= "weaver.splitepage.transform.SptmForHomepage" scope="page" />
<jsp:useBean id="rs" class= "weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="jtc" class= "weaver.hrm.job.JobTitlesComInfo" scope="page" />
<%
    String eid = Util.null2String(request.getParameter("eid")); 
	String esharelevel = Util.null2String(request.getParameter("esharelevel"));
    String  share = hpc.getShare(eid);
	String temp=share;
    String[] shareDetails=share.split("\\^\\^");
    String[] sharetypes;
    String sharetype;
    String sharetypedes;
    String shareinfo;
    String shareinfodes;
    List<String> trs=new ArrayList<String>();
    StringBuffer tr;
    StringBuffer td;
    String[] items;
    String[] sharetypearray;
    for(String sharedetail:shareDetails){
		
        tr=new StringBuffer("<tr  class='contenttr'><td><input class='groupselectbox' type='checkbox' ></td>");
    	sharetypes=sharedetail.split("_");

    	if(sharedetail.length()<3)
    		continue;
    	
    	sharetype=sharedetail.substring(0,1);
    	sharetypearray=sharedetail.substring(2,sharedetail.length()).split(",");
		
    	//人员
    	if(sharetype.equals("1")){
    		sharetypedes=SystemEnv.getHtmlLabelName(1867,user.getLanguage());
    		tr.append("<td>"+sharetypedes+"<input style='display:none;' class='inputStyle' type='checkbox' name='chkShareDetail' value='1$"+sharetypes[1]+"'><input type='hidden' name='txtShareDetail' value='1$"+sharetypes[1]+"' ></td>");
    		//获取人员信息
    		items=sharetypes[1].split(",");
    		td=new StringBuffer("<td>");
    		for(String item:items){
    			td.append("<a href='#'>"+item+"</a>&nbsp;");
    		}
    		td.append("</td>");
			tr.append(td.toString());
			tr.append("<td></td>");
			tr.append("</tr>");	
            trs.add(tr.toString());
    	//分部
    	}else if(sharetype.equals("2")){
    		for(String sharttyeitem:sharetypearray){
	    		sharetypedes=SystemEnv.getHtmlLabelName(141,user.getLanguage())+"+"+SystemEnv.getHtmlLabelName(683,user.getLanguage());
    	    	tr=new StringBuffer("<tr  class='contenttr'><td><input class='groupselectbox' type='checkbox' ></td>");
	    		sharetypes=sharttyeitem.split("_");
	    		shareinfodes=sharetypes[0]+"_"+sharetypes[1]+"_"+sharetypes[2];
				if (sharetypes.length == 4) {
					shareinfodes += "_"+sharetypes[3];
					if ("1".equals(sharetypes[3])) {
						sharetypedes += " ("+SystemEnv.getHtmlLabelName(125963,user.getLanguage())+")";
					}
				} else {
					shareinfodes += "_0";
				}
	    		tr.append("<td>"+sharetypedes+"<input style='display:none;' class='inputStyle' type='checkbox' name='chkShareDetail' value='2$"+shareinfodes+"'><input type='hidden' name='txtShareDetail' value='2$"+shareinfodes+"' ></td>");
	    		//获取人员信息
	    		items=sharetypes[0].split(",");
	    		td=new StringBuffer("<td>");
	    		for(String item:items){
	    			td.append("<a href='#'>"+scc.getSubCompanyname(item)+"</a>&nbsp;");
	    		}
	    		if(sharetypes[1].equals("0"))
	    		  td.append("&nbsp;>="+sharetypes[2]+"</td>");
	    		else
	    		  td.append("&nbsp;<="+sharetypes[2]+"</td>");
	    		td.append("</td>");
				tr.append(td.toString());
				tr.append("<td></td>");
				tr.append("</tr>");
	            trs.add(tr.toString());
    		}
    	//部门
    	}else if(sharetype.equals("3")){
    		for(String sharttyeitem:sharetypearray){
	    		sharetypedes=SystemEnv.getHtmlLabelName(124,user.getLanguage())+"+"+SystemEnv.getHtmlLabelName(683,user.getLanguage());
	    		//sharetypedes="部门+ 安全级别";
				tr=new StringBuffer("<tr  class='contenttr'><td><input class='groupselectbox' type='checkbox' ></td>");
	    		sharetypes=sharttyeitem.split("_");
	    		shareinfodes=sharetypes[0]+"_"+sharetypes[1]+"_"+sharetypes[2];
	    		if (sharetypes.length == 4) {
					shareinfodes += "_"+sharetypes[3];
					if ("1".equals(sharetypes[3])) {
						sharetypedes += " ("+SystemEnv.getHtmlLabelName(125963,user.getLanguage())+")";
					}
				} else {
					shareinfodes += "_0";
				}
	    		tr.append("<td>"+sharetypedes+"<input style='display:none;' class='inputStyle' type='checkbox' name='chkShareDetail' value='3$"+shareinfodes+"'><input type='hidden' name='txtShareDetail' value='3$"+shareinfodes+"' ></td>");
	    		//获取人员信息
	    		items=sharetypes[0].split(",");
	    		td=new StringBuffer("<td>");
	    		for(String item:items){
	    			td.append("<a href='#'>"+dci.getDepartmentname(item)+"</a>&nbsp;");
	    		}
	    		if(sharetypes[1].equals("0"))
	    		  td.append("&nbsp;>="+sharetypes[2]+"</td>");
	    		else
	    		  td.append("&nbsp;<="+sharetypes[2]+"</td>");
	    		td.append("</td>");
				tr.append(td.toString());
				tr.append("<td></td>");
				tr.append("</tr>");
	            trs.add(tr.toString());
    		}
    	//所有人
    	}else if(sharetype.equals("5")){
    		//sharetypedes="";
    		sharetypedes=SystemEnv.getHtmlLabelName(1340,user.getLanguage());
    		shareinfodes=sharetypes[1];
    		tr.append("<td>"+sharetypedes+"<input style='display:none;' class='inputStyle' type='checkbox' name='chkShareDetail' value='5$"+shareinfodes+"'><input type='hidden' name='txtShareDetail' value='5$"+shareinfodes+"' ></td>");
    		//获取人员信息
    		items=sharetypes[1].split(",");
    		td=new StringBuffer("<td>");
    	    td.append(SystemEnv.getHtmlLabelName(1340,user.getLanguage()));
    	    td.append("</td>");
			tr.append(td.toString());
			tr.append("<td></td>");
			tr.append("</tr>");
            trs.add(tr.toString());
    	//角色
    	}else if(sharetype.equals("6")){
    		sharetypedes=SystemEnv.getHtmlLabelName(122,user.getLanguage())+"+"+SystemEnv.getHtmlLabelName(21958,user.getLanguage())+"+"+SystemEnv.getHtmlLabelName(683,user.getLanguage());
    		//sharetypedes="角色+ 角色级别 + 安全级别";

            for(String sharttyeitem:sharetypearray){
                tr=new StringBuffer("<tr  class='contenttr'><td><input class='groupselectbox' type='checkbox' ></td>");
				sharetypes=sharttyeitem.split("_");
				shareinfodes=sharetypes[0]+"_"+sharetypes[1]+"_"+sharetypes[2]+"_"+sharetypes[3];
				tr.append("<td>"+sharetypedes+"<input style='display:none;' class='inputStyle' type='checkbox' name='chkShareDetail' value='6$"+shareinfodes+"'><input type='hidden' name='txtShareDetail' value='6$"+shareinfodes+"' ></td>");
				//获取人员信息
				items=sharetypes[0].split(",");
				td=new StringBuffer("<td>");
				for(String item:items){
					td.append("<a href='#'>"+role.getRolesRemark(item)+"</a>&nbsp;");
				}
				if(sharetypes[1].equals("0")){
					 td.append("&nbsp;"+SystemEnv.getHtmlLabelName(124,user.getLanguage()));
				}else if(sharetypes[1].equals("1")){
					 td.append("&nbsp;"+SystemEnv.getHtmlLabelName(141,user.getLanguage()));    			
				}else if(sharetypes[1].equals("2")){
					 td.append("&nbsp;"+SystemEnv.getHtmlLabelName(140,user.getLanguage()));    			
				}
				if(sharetypes[2].equals("0"))
				  td.append(">="+sharetypes[3]+"</td>");
				else
				  td.append("<="+sharetypes[3]+"</td>");
				td.append("</td>");
				tr.append(td.toString());
				tr.append("<td></td>");
				tr.append("</tr>");
				trs.add(tr.toString());

		    }
    	//安全级别
    	}else if(sharetype.equals("7")){
    		sharetypedes=SystemEnv.getHtmlLabelName(683,user.getLanguage());
			for(String sharttyeitem:sharetypearray){
				sharetypes=sharttyeitem.split("_");
				shareinfodes=sharetypes[0]+"_"+sharetypes[1];
				tr=new StringBuffer("<tr  class='contenttr'><td><input class='groupselectbox' type='checkbox' ></td>");
				sharetypes=sharttyeitem.split("_");
				tr.append("<td>"+sharetypedes+"<input style='display:none;' class='inputStyle' type='checkbox' name='chkShareDetail' value='7$"+shareinfodes+"'><input type='hidden' name='txtShareDetail' value='7$"+shareinfodes+"' ></td>");
				td=new StringBuffer("<td>");
				if(sharetypes[0].equals("0"))
				  td.append("&nbsp;>="+sharetypes[1]+"</td>");
				else
				  td.append("&nbsp;<="+sharetypes[1]+"</td>");
				td.append("</td>");
				tr.append(td.toString());
				tr.append("<td></td>");
				tr.append("</tr>");
				trs.add(tr.toString());
			}
    	}
    }
    
    //存表的新数据
    String newDataSql = "select sharetype,sharevalue,seclevel,seclevelmax,rolelevel,includeSub,jobtitlelevel,jobtitlesharevalue from elementshareinfo where eid = " + eid;
    rs.executeSql(newDataSql);
    while (rs.next()) {
    	String sharetypenew = rs.getString("sharetype");
    	if ("3".equals(sharetypenew)) { // 部门
    		sharetypedes=SystemEnv.getHtmlLabelName(124,user.getLanguage());
			tr=new StringBuffer("<tr  class='contenttr'><td><input class='groupselectbox' type='checkbox' ></td>");
    		shareinfodes=rs.getString("sharevalue")+"_"+rs.getString("includeSub")+"_"+rs.getString("seclevel")+"-"+rs.getString("seclevelmax");
    		tr.append("<td>"+sharetypedes+"<input type='hidden' name='txtShareDetailNew' value='3$"+shareinfodes+"' ></td>");
    		td=new StringBuffer("<td>");
    		td.append(dci.getDepartmentname(rs.getString("sharevalue")));
    		if("1".equals(rs.getString("includeSub"))) {
    			td.append("("+SystemEnv.getHtmlLabelName(125963,user.getLanguage())+")");
    		}
    		td.append("</td>");
			tr.append(td.toString());
			tr.append("<td>");
			tr.append(rs.getString("seclevel")+"-"+rs.getString("seclevelmax"));
			tr.append("</td>");
			tr.append("</tr>");
            trs.add(tr.toString());
    	} else if ("2".equals(sharetypenew)) { // 分部
    		sharetypedes=SystemEnv.getHtmlLabelName(141,user.getLanguage());
			tr=new StringBuffer("<tr  class='contenttr'><td><input class='groupselectbox' type='checkbox' ></td>");
    		shareinfodes=rs.getString("sharevalue")+"_"+rs.getString("includeSub")+"_"+rs.getString("seclevel")+"-"+rs.getString("seclevelmax");
    		tr.append("<td>"+sharetypedes+"<input type='hidden' name='txtShareDetailNew' value='2$"+shareinfodes+"' ></td>");
    		td=new StringBuffer("<td>");
    		td.append(scc.getSubCompanyname(rs.getString("sharevalue")));
    		if("1".equals(rs.getString("includeSub"))) {
    			td.append("("+SystemEnv.getHtmlLabelName(125963,user.getLanguage())+")");
    		}
    		td.append("</td>");
			tr.append(td.toString());
			tr.append("<td>");
			tr.append(rs.getString("seclevel")+"-"+rs.getString("seclevelmax"));
			tr.append("</td>");
			tr.append("</tr>");
            trs.add(tr.toString());
    	} else if ("7".equals(sharetypenew)) { // 所有人
    		sharetypedes=SystemEnv.getHtmlLabelName(1340,user.getLanguage());
			tr=new StringBuffer("<tr  class='contenttr'><td><input class='groupselectbox' type='checkbox' ></td>");
    		shareinfodes=rs.getString("seclevel")+"-"+rs.getString("seclevelmax");
    		tr.append("<td>"+sharetypedes+"<input type='hidden' name='txtShareDetailNew' value='7$"+shareinfodes+"' ></td>");
    		td=new StringBuffer("<td>");
    		td.append(sharetypedes);
    		td.append("</td>");
			tr.append(td.toString());
			tr.append("<td>");
			tr.append(rs.getString("seclevel")+"-"+rs.getString("seclevelmax"));
			tr.append("</td>");
			tr.append("</tr>");
            trs.add(tr.toString());
    	} else if ("1".equals(sharetypenew)) { // 人力资源
    		sharetypedes=SystemEnv.getHtmlLabelName(1867,user.getLanguage());
			tr=new StringBuffer("<tr  class='contenttr'><td><input class='groupselectbox' type='checkbox' ></td>");
    		shareinfodes=rs.getString("sharevalue");
    		tr.append("<td>"+sharetypedes+"<input type='hidden' name='txtShareDetailNew' value='1$"+shareinfodes+"' ></td>");
    		td=new StringBuffer("<td>");
    		td.append(rc.getLastname(rs.getString("sharevalue")));
    		td.append("</td>");
			tr.append(td.toString());
			tr.append("<td>");
			tr.append("</td>");
			tr.append("</tr>");
            trs.add(tr.toString());
    	} else if ("6".equals(sharetypenew)) { // 角色
    		sharetypedes=SystemEnv.getHtmlLabelName(122,user.getLanguage());
			tr=new StringBuffer("<tr  class='contenttr'><td><input class='groupselectbox' type='checkbox' ></td>");
    		shareinfodes=rs.getString("sharevalue")+"_"+rs.getString("rolelevel")+"_"+rs.getString("seclevel")+"-"+rs.getString("seclevelmax");
    		tr.append("<td>"+sharetypedes+"<input type='hidden' name='txtShareDetailNew' value='6$"+shareinfodes+"' ></td>");
    		td=new StringBuffer("<td>");
    		td.append(role.getRolesRemark(rs.getString("sharevalue")));
    		if("0".equals(rs.getString("rolelevel"))){
				 td.append("/"+SystemEnv.getHtmlLabelName(124,user.getLanguage()));
			}else if("1".equals(rs.getString("rolelevel"))){
				 td.append("/"+SystemEnv.getHtmlLabelName(141,user.getLanguage()));    			
			}else if("2".equals(rs.getString("rolelevel"))){
				 td.append("/"+SystemEnv.getHtmlLabelName(140,user.getLanguage()));    			
			}
    		td.append("</td>");
			tr.append(td.toString());
			tr.append("<td>");
			tr.append(rs.getString("seclevel")+"-"+rs.getString("seclevelmax"));
			tr.append("</td>");
			tr.append("</tr>");
            trs.add(tr.toString());
    	} else if("8".equals(sharetypenew)){
    		sharetypedes=SystemEnv.getHtmlLabelName(6086,user.getLanguage());
			tr=new StringBuffer("<tr  class='contenttr'><td><input class='groupselectbox' type='checkbox' ></td>");
    		shareinfodes=rs.getString("sharevalue") + "_" + rs.getString("jobtitlelevel") + "_" + rs.getString("jobtitlesharevalue");
    		tr.append("<td>"+sharetypedes+"<input type='hidden' name='txtShareDetailNew' value='8$"+shareinfodes+"' ></td>");
    		td=new StringBuffer("<td>" + jtc.getJobTitlesmark(rs.getString("sharevalue")));
    		String[] jobtitlesharevalue = rs.getString("jobtitlesharevalue").split("-");
    		String jobtitlesharename = "";
    		for(String item : jobtitlesharevalue){
    			if ("2".equals(rs.getString("jobtitlelevel"))) {
    				jobtitlesharename += dci.getDepartmentname(item) + ",";
    			} else if ("3".equals(rs.getString("jobtitlelevel"))) {
    				jobtitlesharename += scc.getSubCompanyname(item) + ",";
    			}
    		}
    		
    		if (!"".equals(jobtitlesharename)) {
    			jobtitlesharename = jobtitlesharename.substring(0, jobtitlesharename.length()-1);
    		}
    		
    		if ("2".equals(rs.getString("jobtitlelevel"))) {
    			td.append("/" + SystemEnv.getHtmlLabelName(124,user.getLanguage())+"(" + jobtitlesharename + ")");
   			} else if ("3".equals(rs.getString("jobtitlelevel"))) {
   				td.append("/" + SystemEnv.getHtmlLabelName(141,user.getLanguage())+"(" + jobtitlesharename + ")");
   			} else {
   				td.append("/" + SystemEnv.getHtmlLabelName(140,user.getLanguage())+"");
   			}
    		
    		td.append("</td>");
			tr.append(td.toString());
			tr.append("<td></td>");
			tr.append("</tr>");
            trs.add(tr.toString());
   		}
    }
    
    
    JSONArray  trstr=new  JSONArray(trs);
    
%>
<html>
<HEAD> 
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
    <style>
    body {
		MARGIN: 0px;
	}
	.tablecontainer{
	  padding-left: 0px !important; 
	}
    </style>
</HEAD>
<body>





<form name="frmAdd_<%=eid%>" id="frmAdd_<%=eid%>" method="post" action="ElementShareOperation.jsp">
	<INPUT TYPE="hidden" NAME="eid" value="<%=eid%>">           
	<INPUT type="hidden" Name="method" value="addShare">
	<input type="hidden" name="esharelevel" value="<%=esharelevel %>">
	<input type="hidden" id="includeSub" name="includeSub" value="0">
<wea:layout type="2Col">
     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
      <wea:item><%=SystemEnv.getHtmlLabelName(21956,user.getLanguage())%><!--模板--></wea:item>
      <wea:item>
         <div style='float:left;width: 100px;'>
			 <SELECT class=InputStyle  name=sharetype id="sharetype" onchange="onChangeSharetypeEv(this,relatedshareid,showrelatedsharename)" >   
				<option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
				<option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
				<option value="7" selected><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
				<option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option> 
				<option value="6"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
			   	<option value="8"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>
			   </SELECT>	
        </div>  
        </wea:item>
        <wea:item attributes="{'samePair':\"objtr\"}" ><%=SystemEnv.getHtmlLabelName(106, user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':\"objtr\"}" >	
		<div class='browsercontainer' style='float:left'>
			   <span id="showsubcompany" >
					
					<brow:browser viewType="0" name="showsubcompany" browserValue="" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp"
					hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2' _callback="shareCallBack"
					completeUrl="/data.jsp?type=164" linkUrl="" width="160px"
					browserSpanValue=""></brow:browser>
					<span style="margin-right:15px"></span>
					<input type="checkbox" onclick="onClickIncludeSub(this)"><%=SystemEnv.getHtmlLabelName(125963,user.getLanguage())%>
				</span>
				<span id="showdepartment" >
				  <brow:browser viewType="0" name="showdepartment" browserValue="" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' _callback="shareCallBack"
					completeUrl="/data.jsp?type=4"  width="160px"
					browserSpanValue="">
				   </brow:browser>
				   <span style="margin-right:15px"></span>
					<input type="checkbox" onclick="onClickIncludeSub(this)"><%=SystemEnv.getHtmlLabelName(125963,user.getLanguage())%>
				</span>
				<span id="showrole" >
					<brow:browser viewType="0" name="showrole" browserValue="" 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp"
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' _callback="shareCallBack"
						completeUrl="/data.jsp?type=65" width="160px"
						browserSpanValue="">
			       </brow:browser>
			       <span style="float:left;margin-top:7px;height:17px;line-height:17px;">&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:&nbsp;&nbsp;</span>
			       <SELECT class=InputStyle  name=roletype id="roletype" style="width:60px;">
						<option value='2'><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option><!-- 总部 -->
						<option value='1'><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
						<option selected value='0'><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%></option><!-- 部门 -->
				   </SELECT>
				</span>
				<span id="showuser" >
				   <brow:browser viewType="0" name="showuser" browserValue="" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
					hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2' _callback="shareCallBack"
					completeUrl="/data.jsp" linkUrl="" width="160px"
					browserSpanValue=""></brow:browser>
				</span>  
				<span id="showjobtitleSP">
				<brow:browser viewType="0" name="showjobtitle" browserValue=""
				 browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?selectedids=" 
	         	 hasInput="true" isSingle="false" hasBrowser="true" isMustInput="2" _callback="shareCallBack" 
	         	 completeUrl="/data.jsp?type=24" linkUrl="" width="160px" 
	         	 browserSpanValue="">
	         	</brow:browser>
				</span>                     
            </div>
			
			<input type=hidden name="relatedshareid" id="relatedshareid" value="">
			<input type=hidden name="showrelatedsharename" id="showrelatedsharename" value="">
			
			<input type=hidden name="jobtitlesharevalue" id="jobtitlesharevalue" value="">
			<input type=hidden name="jobtitlesharevaluename" id="jobtitlesharevaluename" value="">

      </wea:item>
      <wea:item attributes="{'samePair':\"sectr\"}"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
      <wea:item attributes="{'samePair':\"sectr\"}">
		<INPUT class="InputStyle" style="width:50px;" type=text id=seclevel name=seclevel size=6 value="0" onchange="checkinput('seclevel','seclevelimage')">
	    <SPAN id=seclevelimage></SPAN>
	        - <INPUT class="InputStyle" style="width:50px;" type=text id=seclevelMax name=seclevelMax size=6 value="100" onchange="checkinput('seclevelMax','seclevelimage2')">
	    <SPAN id=seclevelimage2></SPAN>
      </wea:item>
      <!-- 岗位级别 -->
	<wea:item attributes="{'samePair':\"jobtitletr\"}"><%=SystemEnv.getHtmlLabelName(28169, user.getLanguage())%></wea:item>
	<wea:item attributes="{'samePair':\"jobtitletr\"}">
		<span id=showjobtitlelevel name=showjobtitlelevel style="float:left;">
			<select class=InputStyle id="jobtitlelevel" name="jobtitlelevel" onchange="javascript:changeJobtitlelevel();" >
	         	<option value="1"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
	         	<option value="2"><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%></option>
	         	<option value="3"><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%></option>
	         </select>
		</span>
		<span id="departmentSP" style="float:left;">
		<brow:browser viewType="0" name="department" browserValue=""
			 browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp" 
        	 hasInput="true" isSingle="false" hasBrowser="true" isMustInput="2" _callback="jobtitleShareCallBack" 
        	 completeUrl="/data.jsp?type=4" linkUrl="" width="160px"
        	 browserSpanValue="">
        	</brow:browser>
        	</span>
        	<span id="subcompanySP" style="float:left;">
        	<brow:browser viewType="0" name="subcompany" browserValue=""
		 	 browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp" 
        	 hasInput="true" isSingle="false" hasBrowser="true" isMustInput="2"
        	 completeUrl="/data.jsp?type=164" linkUrl="" width="160px" _callback="jobtitleShareCallBack" 
        	 browserSpanValue="">
        	</brow:browser>
        	</span>
	</wea:item>
	</wea:group>
</wea:layout>

<div class="groupmain" id="ele_share" style="width:100%"></div>
</body>
</html>

<!-- 泛微可编辑表格组件-->
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<SCRIPT type="text/JavaScript">

hideEle("objtr", true);
$(".browsercontainer>span").hide();
hideEle("jobtitletr", true);

var customtrs=<%=trstr%>;

<!--
var items=[

{width:"35%",colname:"<%=SystemEnv.getHtmlLabelName(21956,user.getLanguage())%>",itemhtml:"&nbsp;<%=SystemEnv.getHtmlLabelName(1340, user.getLanguage())%>"},

{width:"35%",colname:"<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>",itemhtml:"&nbsp;<%=SystemEnv.getHtmlLabelName(1340, user.getLanguage())%>"},

{width:"35%",colname:"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>",itemhtml:""}];

var flag = false;
//普通模式使用
var option= {navcolor:"#003399",
             basictitle:"<%=SystemEnv.getHtmlLabelName(1279,user.getLanguage())%>",
             addrowtitle:"<%=SystemEnv.getHtmlLabelName(21690,user.getLanguage())%>",
             deleterowstitle:"<%=SystemEnv.getHtmlLabelName(16182,user.getLanguage())%>",
             colItems:items,
             addrowCallBack:function($this,tr) {
            	 	var re=/^-?\d+$/;
            	    var seclevel = jQuery("#seclevel").val();
            	    var seclevelMax = jQuery("#seclevelMax").val();
             		var thisvalue=document.getElementById("sharetype").value;
				   	var shareTypeValue = thisvalue;
				   	//共享类型
					var shareTypeText = "";
				    //人力资源(1),分部(2),部门(3),具体客户(9),角色后的那个选项值不能为空(4)
				    var relatedShareIds="0";
				    var relatedShareNames="";
				    var relatedShareLevel="";
				    if (thisvalue==1) {
			        	if(!check_form(document.frmAdd_<%=eid%>,'relatedshareid')) {
			        		tr.prev().remove();
							tr.remove();
				            return ;
				        }
				    } else if (thisvalue==2 || thisvalue==3 || thisvalue==6) {
				    	if(!check_form(document.frmAdd_<%=eid%>,'relatedshareid,seclevel,seclevelMax')) {
				    		tr.prev().remove();
							tr.remove();
				            return ;
				        } else if(!re.test(seclevel) || !re.test(seclevelMax) || parseInt(seclevel)>parseInt(seclevelMax))  {
				    		tr.prev().remove();
							tr.remove();
				    		alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
				    		return ;
				    	}
				    } else if (thisvalue==7) {
				    	if(!check_form(document.frmAdd_<%=eid%>,'seclevel,seclevelMax')) {
				    		tr.prev().remove();
							tr.remove();
				            return ;
				        } else if(!re.test(seclevel) || !re.test(seclevelMax) || parseInt(seclevel)>parseInt(seclevelMax))  {
				    		tr.prev().remove();
							tr.remove();
				    		alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
				    		return ;
				    	}
				    } else if (thisvalue==8) {
				    	var checkStr = "showjobtitle";
				    	if ($("#jobtitlelevel").val() == "2") {
				    		checkStr += ",department";
				    	} else if ($("#jobtitlelevel").val() == "3") {
				    		checkStr += ",subcompany";
				    	}
				    	if(!check_form(document.frmAdd_<%=eid%>, checkStr)) {
				    		tr.prev().remove();
							tr.remove();
				            return ;
				        }
				    }
				    switch(parseInt(thisvalue)){
				       	case 1:
				       		shareTypeText = $("#sharetype option:selected").text();
				       		relatedShareIds = $("#relatedshareid").val();
				       		relatedShareNames= $("#showrelatedsharename").val();
				       		break;
				       	case 2:
				       	case 3:
				       		relatedShareLevel = $("#seclevel").val()+"-"+$("#seclevelMax").val();
				       		shareTypeText = $("#sharetype option:selected").text();
				       		relatedShareIds = $("#relatedshareid").val()+"_"+$("#includeSub").val()+"_"+relatedShareLevel;
				       		relatedShareNames= $("#showrelatedsharename").val();
				       		if ("1" == $("#includeSub").val()) {
				       			relatedShareNames += "(<%=SystemEnv.getHtmlLabelName(125963,user.getLanguage())%>)";
				       		}
				       		break;
				       	case 6:
				       		relatedShareLevel = $("#seclevel").val()+"-"+$("#seclevelMax").val();
				       		shareTypeText = $("#sharetype option:selected").text();
				       		relatedShareIds = $("#relatedshareid").val()+"_"+$("#roletype").val()+"_"+relatedShareLevel;
				       		relatedShareNames = $("#showrelatedsharename").val() + "/" + $("#roletype option:selected").text();
				       		break;
				       	case 7:
				       		relatedShareLevel = $("#seclevel").val()+"-"+$("#seclevelMax").val();
				       		shareTypeText = $("#sharetype option:selected").text();
				       		$("#relatedshareid").val(relatedShareLevel);
				       		relatedShareIds = relatedShareLevel;
				       		relatedShareNames = shareTypeText;
				       		break;
				       	case 8:
				       		shareTypeText = $("#sharetype option:selected").text();
				       		var jobtitlelevel = $("#jobtitlelevel").val();
				       		relatedShareNames = $("#showrelatedsharename").val();
				       		if ("2" == jobtitlelevel) {
					       		relatedShareIds = $("#relatedshareid").val() + "_" + jobtitlelevel + "_" + $("#jobtitlesharevalue").val();
				       			relatedShareNames += "/" + "<%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%>" + "(" + $("#jobtitlesharevaluename").val() + ")";
				       		} else if("3" == jobtitlelevel) {
				       			relatedShareIds = $("#relatedshareid").val() + "_" + jobtitlelevel + "_" + $("#jobtitlesharevalue").val();
				       			relatedShareNames += "/" + "<%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%>" + "(" + $("#jobtitlesharevaluename").val() + ")";
				       		} else {
				       			relatedShareIds = $("#relatedshareid").val() + "_" + jobtitlelevel + "_0";
				       			relatedShareNames += "/" + "<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>";
				       		}
				       		break;
				       		
				   }
				
				   //共享类型 + 共享者ID
				   var totalValue=shareTypeValue+"$"+relatedShareIds;
				   tr.find("td:eq(1)").html(shareTypeText+"<input style='display:none;' class='inputStyle' type='checkbox' name='chkShareDetailNew' value='"+totalValue+"'><input type='hidden' name='txtShareDetailNew' value='"+totalValue+"'>");
				   tr.find("td:eq(2)").html(relatedShareNames);
				   tr.find("td:eq(3)").html(relatedShareLevel);
             },
             configCheckBox:true,
		     openindex:true,
             checkBoxItem:{"itemhtml":'<input class="groupselectbox" type="checkbox" name="chkAll" onclick="chkAllClick(this)">',width:"5%"}
            };

//生成相应的可编辑表格对象
var group=new WeaverEditTable(option);

//恢复设置
for(var i=0;i<customtrs.length;i++){
   group.addCustomRow(customtrs[i]);
}

//var customtr="<tr class='contenttr'><td><input class='groupselectbox' type='checkbox' ></td><td>所有人</td><td>所有人</td></tr>";
//group.addCustomRow(customtr);


//将可编辑表格容器附加到dom节点上
$(".groupmain").append(group.getContainer());

function onChangeSharetype(seleObj,txtObj,spanObj){
	var thisvalue=seleObj.value;	
    var strAlert= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	
	if(thisvalue==1){  //人员
 		$("#btnHrm").show();
		$("#btnSubcompany").hide();
		$("#btnDepartment").hide();
		$("#btnRole").hide();
		$("#roletype_tr").hide();
		$("#roletype_tr").prev().hide();
		$("#securitylevel_tr").hide();
		$("#securitylevel_tr").prev().hide();
		$("#roletype").val(0);
		$("#operate").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		txtObj.value="";
		spanObj.innerHTML=strAlert;
		txtObj.value="";		
		spanObj.innerHTML=strAlert;	
	} else if (thisvalue==2)	{ //分部
		document.getElementById("btnHrm").style.display='none';
		document.getElementById("btnSubcompany").style.display='';
		document.getElementById("btnDepartment").style.display='none';
		$("#btnRole").hide();
		$("#roletype_tr").hide();
		$("#roletype_tr").prev().hide();
		$("#securitylevel_tr").show();
		$("#securitylevel_tr").prev().show();
		$("#roletype").val(0);
		$("#operate").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		txtObj.value="";
		spanObj.innerHTML=strAlert;	
	}else if (thisvalue==3)	{ //部门
		document.getElementById("btnHrm").style.display='none';
		document.getElementById("btnSubcompany").style.display='none';
		document.getElementById("btnDepartment").style.display='';
		$("#btnRole").hide();
		$("#roletype_tr").hide();
		$("#roletype_tr").prev().hide();
		$("#securitylevel_tr").show();
		$("#securitylevel_tr").prev().show();
		$("#roletype").val(0);
		$("#operate").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		txtObj.value="";
		spanObj.innerHTML=strAlert;	
	}else if (thisvalue==5)	{ //所有人
		document.getElementById("btnHrm").style.display='none';
		document.getElementById("btnSubcompany").style.display='none';
		document.getElementById("btnDepartment").style.display='none';
		$("#btnRole").hide();
		$("#roletype_tr").hide();
		$("#roletype_tr").prev().hide();
		$("#securitylevel_tr").hide();
		$("#securitylevel_tr").prev().hide();
		$("#roletype").val(0);
		$("#operate").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		txtObj.value="1";
		spanObj.innerHTML="";
	}else if (thisvalue==6){
		$("#btnRole").show();
		$("#btnHrm").hide();
		$("#btnSubcompany").hide();
		$("#btnDepartment").hide();
		$("#roletype_tr").show();
		$("#roletype_tr").prev().show();
		$("#securitylevel_tr").show();
		$("#securitylevel_tr").prev().show();
		$("#roletype").val(0);
		$("#operate").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		txtObj.value="";
		spanObj.innerHTML=strAlert;
	}else if (thisvalue==7){
		$("#btnRole").hide();
		$("#btnHrm").hide();
		$("#btnSubcompany").hide();
		$("#btnDepartment").hide();
		$("#roletype_tr").hide();
		$("#roletype_tr").prev().hide();
		$("#securitylevel_tr").show();
		$("#securitylevel_tr").prev().show();
		txtObj.value=$("#securitylevel").val();
		$("#roletype").val(0);
		$("#operate").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		spanObj.innerHTML="";
	}
	
}
function onChangeSharetypeEv(seleObj,txtObj,spanObj){
	$("#relatedshareid").val("");
	$("#showrelatedsharename").val("");
	var thisvalue=seleObj.value;	
    //var strAlert= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 hideEle("objtr", true);
	 $(".browsercontainer>span").hide();
	 hideEle("sectr", true);
	 hideEle("jobtitletr", true);
	if(thisvalue==1){  //人员
        //人员浏览框
        showEle("objtr");
		$("#showuser").show();
		/* $("#roletype").parent().parent().hide();
		$("#operate").parent().parent().hide();
		$("#roletype").val(0);
		$("#operate").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		txtObj.value="";
		spanObj.innerHTML=strAlert;
		txtObj.value="";		
		spanObj.innerHTML=strAlert;	 */
	} else if (thisvalue==2)	{ //分部
		//分部浏览框
		$("#includeSub").val("0"); 
		showEle("objtr");
		$("#showsubcompany").show();
		showEle("sectr");
        /* $("#roletype").parent().parent().hide();
		$("#operate").parent().parent().show();
		$("#roletype").val(0);
		$("#operate").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		txtObj.value="";
		spanObj.innerHTML=strAlert;	 */
	}else if (thisvalue==3)	{ //部门
		//部门浏览框
		$("#includeSub").val("0"); 
		showEle("objtr");
		$("#showdepartment").show();
		showEle("sectr");
		/* $("#roletype").parent().parent().hide();
        $("#operate").parent().parent().show();
        $("#roletype").val(0);
		$("#operate").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		txtObj.value="";
		spanObj.innerHTML=strAlert;	 */
	}else if (thisvalue==5)	{ //所有人
	    /* $("#roletype").parent().parent().hide();
		$("#operate").parent().parent().hide();
        $("#roletype").val(0);
		$("#operate").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		txtObj.value="1";
		spanObj.innerHTML=""; */
	}else if (thisvalue==6){//角色
		showEle("objtr");
		$("#showrole").show();
		showEle("sectr");
        /* $("#roletype").parent().parent().show();
		$("#operate").parent().parent().show();
		$("#roletype").val(0);
		$("#operate").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		txtObj.value="";
		spanObj.innerHTML=strAlert; */
	}else if (thisvalue==7){//安全级别
		showEle("sectr");
		/* $("#roletype").parent().parent().hide();
		$("#operate").parent().parent().show();
		txtObj.value=$("#securitylevel").val();
		$("#roletype").val(0);
		$("#operate").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		spanObj.innerHTML=""; */
	}else if(thisvalue==8) {//岗位
		//jQuery($GetEle("departmentSP")).css("display","none");
		//jQuery($GetEle("subcompanySP")).css("display","none");
		changeJobtitlelevel();
		showEle("objtr");
		$("#showjobtitleSP").show();
		showEle("jobtitletr");
	}
	
}

function changeJobtitlelevel() {
	var jobtitlelevel = jQuery("#jobtitlelevel").val();
	
	if (jobtitlelevel == 1) {
		jQuery($GetEle("departmentSP")).css("display","none");
		jQuery($GetEle("subcompanySP")).css("display","none");
	} else if (jobtitlelevel == 2) {
		jQuery($GetEle("departmentSP")).css("display","");
		jQuery($GetEle("subcompanySP")).css("display","none");
	}  else if (jobtitlelevel == 3) {
		jQuery($GetEle("departmentSP")).css("display","none");
		jQuery($GetEle("subcompanySP")).css("display","");
	}
}

function removeValue(){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=chks.length-1;i>=0;i--){
        var chk = chks[i];
        if (chk.checked)
            oTable.deleteRow(chk.parentElement.parentElement.parentElement.rowIndex);
    }
}

function addValue(){
group.addRow();
return;
   	var thisvalue=document.getElementById("sharetype").value;

   	var shareTypeValue = thisvalue;
   	//共享类型
	var shareTypeText = "";
    //人力资源(1),分部(2),部门(3),具体客户(9),角色后的那个选项值不能为空(4)
    var relatedShareIds="0";
    var relatedShareNames="";
    if (thisvalue!=5) {
    	if($("#securitylevel").is(":hidden")){
	        if(!check_form(document.frmAdd_<%=eid%>,'relatedshareid')) {
	            return ;
	        }
        }else{
        	if(!check_form(document.frmAdd_<%=eid%>,'relatedshareid,securitylevel')) {
	            return ;
	        }
        }
    }
    switch(parseInt(thisvalue)){
       	case 1:
       		shareTypeText = $("#sharetype option:selected").text();
       		relatedShareIds = $("#relatedshareid").val();
       		relatedShareNames= $("#showrelatedsharename").val();
       		break;
       	case 2:
       	case 3:
       		shareTypeText = $("#sharetype option:selected").text()+"+"+$("#securitylevel").parent().prev().text();
       		if ("1" == $("#includeSub").val()) {
       			shareTypeText += "(<%=SystemEnv.getHtmlLabelName(125963,user.getLanguage())%>)"
       		}
       		relatedShareIds = $("#relatedshareid").val()+"_"+$("#operate").val()+"_"+$("#securitylevel").val()+"_"+$("#includeSub").val();
       		relatedShareNames= $("#showrelatedsharename").val()+"+"+$("#operate option:selected").text()+$("#securitylevel").val();
       		break;
       	case 5:
       		shareTypeText = $("#sharetype option:selected").text();
       		relatedShareIds = $("#relatedshareid").val();
       		relatedShareNames= shareTypeText;
       		break;
       	case 6:
       		shareTypeText = $("#sharetype option:selected").text()+"+"+$("#roletype").parent().prev().text()+"+"+$("#securitylevel").parent().prev().text();
       		relatedShareIds = $("#relatedshareid").val()+"_"+$("#roletype").val()+"_"+$("#operate").val()+"_"+$("#securitylevel").val();
       		relatedShareNames = $("#showrelatedsharename").val()+"+"+$("#roletype option:selected").text()+"+"+$("#operate option:selected").text()+$("#securitylevel").val();
       		break;
       	case 7:
       		shareTypeText = $("#sharetype option:selected").text();
       		$("#relatedshareid").val($("#securitylevel").val());
       		relatedShareIds =$("#operate").val()+"_"+$("#securitylevel").val();
       		relatedShareNames = $("#operate option:selected").text()+$("#securitylevel").val();
       		break;
       		
   }

   //共享类型 + 共享者ID
   var totalValue=shareTypeValue+"$"+relatedShareIds;
   //if(thisvalue==5) relatedShareNames=shareTypeText;  //所有人

   var oRow = oTable.insertRow(-1);
   var oRowIndex = oRow.rowIndex;

   if (oRowIndex%2==0) oRow.className="dataLight";
   else oRow.className="dataDark";
	
   for (var i =1; i <=3; i++) {   //生成一行中的每一列
      oCell = oRow.insertCell(-1);
      var oDiv = document.createElement("div");
      if (i==1) oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkShareDetail' value='"+totalValue+"'><input type='hidden' name='txtShareDetail' value='"+totalValue+"'>";
      else if (i==2) oDiv.innerHTML=shareTypeText;
	  else if (i==3) oDiv.innerHTML=relatedShareNames;
      oCell.appendChild(oDiv);
   }
}

function chkAllClick(obj){
	 var chkboxElems= document.getElementsByName("chkShareDetail");
	    for (var j=0;j<chkboxElems.length;j++)
	    {
	        if (obj.checked) 
	        {
	        	if(chkboxElems[j].style.display!='none'){
	            	chkboxElems[j].checked = true ;		
	            }	
	        } 
	        else 
	        {       
	            chkboxElems[j].checked = false ;
	        }
	    }
}

//-->
</SCRIPT>
<SCRIPT type="text/JavaScript">
	function onShowResource(inputname,spanname){
		 linkurl="javaScript:openhrm(";
		 var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
		
		   if (datas) {
			    if (datas.id!= "") {
			        ids = datas.id.split(",");
				    names =datas.name.split(",");
				    sHtml = "";
				    for( var i=0;i<ids.length;i++){
					    if(ids[i]!=""){
					    	sHtml = sHtml+"<a href="+linkurl+ids[i]+")  onclick='pointerXY(event);'>"+names[i]+"</a>&nbsp";
					    }
				    }
				    
				    $("#"+spanname).html(sHtml);
				    $("input[name="+inputname+"]").val(datas.id);
			    }
			    else	{
		    	     $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
				    $("input[name="+inputname+"]").val("");
			    }
			}
}

function shareCallBack(e,datas,name){
     if (datas) {
	    if (datas.id!= "") {
	        ids = datas.id.split(",");
		    names =datas.name.split(",");
		    $("input[name='relatedshareid']").val(datas.id);
			$("#showrelatedsharename").val(names);
	    }
	    else{
    	    $("#showrelatedsharename").val("");
		    $("input[name='relatedshareid']").val("");
	    }
	}
}

function jobtitleShareCallBack(e,datas,name) {
	if (datas) {
	    if (datas.id!= "") {
	        ids = datas.id.split(",");
		    names =datas.name.split(",");
		    $("#jobtitlesharevalue").val(ids.join("-"));
			$("#jobtitlesharevaluename").val(names);
	    }
	    else {
	    	$("#jobtitlesharevalue").val("");
			$("#jobtitlesharevaluename").val("");
	    }
	}
}

function doSave(obj){
    //obj.disabled=true;
	frmAdd_<%=eid%>.submit();    
	//alert("");
}	
function onShowSubcompany(inputname,spanname)  {
		linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id=";
		var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+$("input[name="+inputname+"]").val()+"&selectedDepartmentIds="+$("input[name="+inputname+"]").val(),
	    		"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	   if (datas) {
		    if (datas.id!= "") {
		        ids = datas.id.split(",");
			    names =datas.name.split(",");
			    sHtml = "";
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(datas.id);
		    }
		    else	{
	    	     $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			    $("input[name="+inputname+"]").val("");
		    }
		}
}
function onShowDepartment(inputname,spanname){
	linkurl="/hrm/company/HrmDepartmentDsp.jsp?id=";
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+$("input[name="+inputname+"]").val()+"&selectedDepartmentIds="+$("input[name="+inputname+"]").val(),
			"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	 if (datas) {
	    if (datas.id!= "") {
	        ids = datas.id.split(",");
		    names =datas.name.split(",");
		    sHtml = "";
		    for( var i=0;i<ids.length;i++){
			    if(ids[i]!=""){
			    	sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
			    }
		    }
		    $("#"+spanname).html(sHtml);
		    $("input[name="+inputname+"]").val(datas.id);
	    }
	    else	{
    	     $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		    $("input[name="+inputname+"]").val("");
	    }
	}
}


function onShowRole(inputename,tdname){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp","","dialogHeight=550px;dialogWidth=550px;");
	
	if (datas){
	    if (datas.id!="") {
		    $("#"+tdname).html(datas.name);
		    $("input[name="+inputename+"]").val(datas.id);
	    }else{
		    	$("#"+tdname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		    $("input[name="+inputename+"]").val("");
	    }
	}
}

function onClickIncludeSub(obj){
	if(obj.checked){
		$("#includeSub").val("1"); 
	}else{
		$("#includeSub").val("0"); 
	}
}

</script>
