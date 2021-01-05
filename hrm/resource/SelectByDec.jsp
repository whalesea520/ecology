<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<!-- added by wcd 2014-07-08 -->
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.file.Prop,
				weaver.general.GCONST" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="adci" class="weaver.hrm.appdetach.AppDetachComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<!-- added by wcd 2014-07-08 start -->
<%!
/**
 * 取得指定分部下所有分部id（包括指定分部id）
 * @param subId
 * @return
 */
public String getAllSubId(String subId,String ids){
	RecordSet rs_s = new RecordSet();
	rs_s.executeSql("select id from HrmSubCompany where id <> " + subId + " and supsubcomid = "+subId);
	while(rs_s.next()){
		ids += ","+rs_s.getString(1);
		ids = this.getAllSubId(rs_s.getString(1), ids);
	}
	return ids;
}
/**
 * 取得指定部门下所有部门id（包括指定部门id）
 * @param deptId
 * @param ids
 * @return
 */
public String getAllDeptId(String deptId,String ids){
	RecordSet rs_d = new RecordSet();
	rs_d.executeSql("select id from HrmDepartment where id <> " + deptId + " and supdepid = "+deptId);
	while(rs_d.next()){
		ids += ","+rs_d.getString(1);
		ids = this.getAllDeptId(rs_d.getString(1), ids);
	}
	return ids;
}
%>
<!-- added by wcd 2014-07-08 end -->
<%
String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
String tabid = Util.null2String(request.getParameter("tabid"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String groupid = Util.null2String(request.getParameter("groupid"));

String companyid = Util.null2String(request.getParameter("companyid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String needsystem = Util.null2String(request.getParameter("needsystem"));
String isNoAccount = Util.null2String(request.getParameter("isNoAccount"));

int uid=user.getUID();
if(tabid.equals("")) tabid="0";
String rem=(String)session.getAttribute("decresourcemulti");
        if(rem==null){
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("decresourcemulti"+uid)){
        rem=cks[i].getValue();
        break;
        }
        }
        }
        
if(rem!=null)
  rem=tabid+rem.substring(1);
else
  rem=tabid;
if(!nodeid.equals(""))
  rem=rem.substring(0,1)+"|"+nodeid;


session.setAttribute("decresourcemulti",rem);
Cookie ck = new Cookie("decresourcemulti"+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

String[] atts=Util.TokenizerString2(rem,"|");
if(tabid.equals("0")&&atts.length>1){
   nodeid=atts[1];
  if(nodeid.indexOf("com")>-1){
  	//subcompanyid=nodeid.substring(nodeid.indexOf("_")+1);
    //System.out.println("subcompanyid"+subcompanyid);
    }
  else{
    //departmentid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    //System.out.println("departmentid"+departmentid);
    }
}
else if(tabid.equals("1") && atts.length>1) {
	groupid=atts[1];
}

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
//  String lastname = Util.toScreenToEdit(request.getParameter("searchid"),user.getLanguage(),"0");


String lastname = Util.null2String(request.getParameter("lastname"));
String resourcetype = Util.null2String(request.getParameter("resourcetype"));
String resourcestatus = Util.null2String(request.getParameter("resourcestatus"));
String jobtitle = Util.null2String(request.getParameter("jobtitle"));
//String departmentid = Util.null2String(request.getParameter("departmentid"));

String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String status = Util.null2String(request.getParameter("status"));
String firstname = Util.null2String(request.getParameter("firstname"));
String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());
String roleid = Util.null2String(request.getParameter("roleid"));

boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;


if(tabid.equals("0")&&departmentid.equals("")&&subcompanyid.equals("")&&companyid.equals("")) departmentid=user.getUserDepartment()+"";
if(departmentid.equals("0"))    departmentid="";

if(subcompanyid.equals("0"))    subcompanyid="";
// added by wcd 2014-07-08 start
RecordSet.executeSql("select detachable from SystemSet");
int detachable=0;
if(RecordSet.next()){
	detachable=RecordSet.getInt("detachable");
	session.setAttribute("detachable",String.valueOf(detachable));
}


int ishead = 0;
if(!sqlwhere.equals("")){
	ishead = 1;
}else{
	sqlwhere = " where 1=1 ";
	ishead = 1;
}

if(adci.isUseAppDetach()){
	String appdetawhere = adci.getScopeSqlByHrmResourceSearch(user.getUID()+"",true,"resource_hrmresource");
	String tempstr= (appdetawhere!=null&&!"".equals(appdetawhere)?(" and " + appdetawhere):"");
	sqlwhere+=tempstr;
}
	

String alllevel = Util.null2String(request.getParameter("alllevel"));//是否包含下级分部或部门
String search = Util.null2String(request.getParameter("search"));
if(alllevel.equals("") && search.equals("")){
	alllevel = "1";
}
if("0".equals("1")){//判断是否包含下级机构
	if(sqlwhere.length() == 0){
		if(subcompanyid.trim().length() != 0){
			subcompanyid = this.getAllSubId(subcompanyid,subcompanyid);
			sqlwhere = " and subcompanyid1 in("+subcompanyid+") ";
		}else if(departmentid.trim().length() != 0){
			departmentid = this.getAllDeptId(departmentid,departmentid);	
			sqlwhere = " and departmentid in("+departmentid+") ";
		}
	}else{
		if(sqlwhere.indexOf("subcompanyid1")!=-1){
			if(subcompanyid.trim().length() == 0 || detachable == 1){
				subcompanyid = sqlwhere.substring(sqlwhere.indexOf("(")+1,sqlwhere.indexOf(")"));
			}
			if(detachable == 0){
				subcompanyid = this.getAllSubId(subcompanyid,subcompanyid);
			}
			sqlwhere = "";
			if(subcompanyid.trim().length() != 0){
				sqlwhere += " and subcompanyid1 in("+subcompanyid+") ";
			}
			if(departmentid.trim().length() != 0){
				departmentid = this.getAllDeptId(departmentid,departmentid);	
				sqlwhere += (subcompanyid.trim().length() != 0?" and ":" and ")+" departmentid in("+departmentid+") ";
			}
		}else if(sqlwhere.indexOf("departmentid")!=-1){
			if(departmentid.trim().length() == 0 || detachable == 1){
				departmentid = sqlwhere.substring(sqlwhere.indexOf("(")+1,sqlwhere.indexOf(")"));
			}
			if(detachable == 0){
				departmentid = this.getAllDeptId(departmentid,departmentid);
			}
			if(departmentid.trim().length() != 0){
				sqlwhere = "and departmentid in("+departmentid+") ";
			}
		}
	}
}else {
	if(!departmentid.equals("")){
		if(alllevel.equals("1"))departmentid = this.getAllDeptId(departmentid,departmentid);
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where departmentid in(" + departmentid +") " ;
		}
		else
			sqlwhere += " and departmentid in(" + departmentid +") " ;
	}
	if(departmentid.equals("")&&subcompanyid.trim().length() > 0){
		//subcompanyid=SubCompanyComInfo.getSubCompanyTreeStr(subcompanyid)+subcompanyid;
		if(alllevel.equals("1"))subcompanyid = this.getAllSubId(subcompanyid,subcompanyid);
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where subcompanyid1 in(" + subcompanyid +") " ;
		}
		else
			sqlwhere += " and subcompanyid1 in(" + subcompanyid +") " ;
	}
}
// added by wcd 2014-07-08 end
if(!sqlwhere.equals("")) ishead = 1;
if(status.equals("-1")) status = "";
if(!lastname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where (lastname like '%"+Util.fromScreen2(lastname,user.getLanguage())+"%' or pinyinlastname like '%"+Util.fromScreen2(lastname,user.getLanguage()).toLowerCase()+"%')";
	}
	else
		sqlwhere += " and( lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' or pinyinlastname like '%"+Util.fromScreen2(lastname,user.getLanguage()).toLowerCase()+"%')";
}
if(!firstname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where firstname like '%" + Util.fromScreen2(firstname,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and firstname like '%" + Util.fromScreen2(firstname,user.getLanguage()) +"%' ";
}
if(!seclevelto.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where HrmResource.seclevel <= '"+ seclevelto + "' ";
	}
	else
		sqlwhere += " and HrmResource.seclevel <= '"+ seclevelto + "' ";
}
if(!resourcetype.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where resourcetype = '"+ resourcetype + "' ";
	}
	else
		sqlwhere += " and resourcetype = '"+ resourcetype + "' ";
}
if(!jobtitle.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where jobtitle in(select id from HrmJobTitles where jobtitlename like '%" + Util.fromScreen2(jobtitle,user.getLanguage()) +"%') ";
		//sqlwhere += " where jobtitle ="+jobtitle;
	}
	else
		sqlwhere += " and jobtitle in(select id from HrmJobTitles where jobtitlename like '%" + Util.fromScreen2(jobtitle,user.getLanguage()) +"%') ";
		//sqlwhere += " and jobtitle ="+jobtitle;
}
if(!status.equals("")&&!status.equals("8")&&!status.equals("9")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where status =" + status +" " ;
	}
	else
		sqlwhere += " and status =" + status +" " ;
}
if(status.equals("")||status.equals("8")||status.equals("9")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where (status =0 or status = 1 or status = 2 or status = 3) " ;
	}
	else
		sqlwhere += " and (status =0 or status = 1 or status = 2 or status = 3) ";
}
 if(!roleid.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where  HrmResource.ID in (select t1.ResourceID from hrmrolemembers t1,hrmroles t2 where t1.roleid = t2.ID and t2.ID="+roleid+" ) " ;
        }
        else
            sqlwhere += " and    HrmResource.ID in (select t1.ResourceID from hrmrolemembers t1,hrmroles t2 where t1.roleid = t2.ID and t2.ID="+roleid+" ) " ;
    }

 String noAccountSql="";
 if(!isNoAccount.equals("1")){
	 if(mode==null||!mode.equals("ldap")){
		 if(ishead==0){
			 ishead = 1;
			 noAccountSql=" where loginid is not null "+(RecordSet.getDBType().equals("oracle")?"":" and loginid<>'' ");
		 }else{
			 noAccountSql=" and loginid is not null "+(RecordSet.getDBType().equals("oracle")?"":" and loginid<>'' ");
		 }
	 }else{
	 //loginid、account字段整合 qc:128484
		//if(ishead==0){
		//	 ishead = 1;
		//	 noAccountSql=" where account is not null "+(RecordSet.getDBType().equals("oracle")?"":" and account<>'' ");
		 //}else{
		//	 noAccountSql=" and account is not null "+(RecordSet.getDBType().equals("oracle")?"":" and account<>'' ");
		 //}
		if(ishead==0){
			 ishead = 1;
			 noAccountSql=" where loginid is not null "+(RecordSet.getDBType().equals("oracle")?"":" and loginid<>'' ");
		}else{
			 noAccountSql=" and loginid is not null "+(RecordSet.getDBType().equals("oracle")?"":" and loginid<>'' ");
		}
	 }
 }
 sqlwhere=sqlwhere+(isNoAccount.equals("1")?"":noAccountSql); //是否显示无账号人员
 
/*String sqlstr = "select HrmResource.id,lastname,resourcetype,startdate,enddate,jobtitlename,departmentid "+
			    "from HrmResource , HrmJobTitles " + sqlwhere ;
if(ishead ==0) sqlstr += "where HrmJobTitles.id = HrmResource.jobtitle " ;
else sqlstr += " and HrmJobTitles.id = HrmResource.jobtitle " ;*/

String sqlstr = "";
if(mode==null||!mode.equals("ldap")){//win
	sqlstr = "select HrmResource.id,lastname,departmentid,jobtitle "+
  				"from HrmResource " + sqlwhere+" order by dsporder,lastname"; 

	if(tabid.equals("1")&&!groupid.equals("")){
		if(!sqlwhere.equals("")){
		sqlstr="select id,lastname,departmentid,jobtitle from hrmresource "+sqlwhere+" and id in(select userid from HrmGroupMembers where groupid="+groupid+") order by dsporder,lastname";
		}else{
		sqlstr="select t1.id,t1.lastname,t1.departmentid,t1.jobtitle from hrmresource t1,HrmGroupMembers t2 where t1.id=t2.userid and t2.groupid="+groupid+(isNoAccount.equals("1")?"":noAccountSql)+" order by t1.dsporder,t1.lastname";
		}
		}

		if(tabid.equals("0")&&!companyid.equals("")){
		sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource ";
		sqlstr+=sqlwhere;
		
		if(!isoracle) sqlstr+=" ";
		sqlstr+=" order by dsporder,lastname";
		}else if(tabid.equals("0")&&!subcompanyid.equals("")){
		sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource ";
		sqlstr+=sqlwhere;
		
		//if(!isoracle) sqlstr+="and loginid<>''";
		sqlstr+=" order by dsporder,lastname";
		}else if(tabid.equals("0")&&!departmentid.equals("")){
		sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource ";
		sqlstr+=sqlwhere;
		
		if(!isoracle) sqlstr+=" ";
		sqlstr+=" order by dsporder,lastname";
		}

//add by alan for td:10343
boolean isInit = Util.null2String(request.getParameter("isinit")).equals("");//是否点击过搜索
if((tabid.equals("2") && isInit) ||(tabid.equals("0") && nodeid.equals(""))) sqlstr = "select HrmResource.id,lastname,departmentid,jobtitle from HrmResource WHERE 1=2";

}else{//ldap
	sqlstr = "select HrmResource.id,lastname,departmentid,jobtitle "+
			 "from HrmResource " + sqlwhere+" order by dsporder,lastname"; ;

	if(tabid.equals("1")&&!groupid.equals("")){
		if(!sqlwhere.equals("")){
			sqlstr="select id,lastname,departmentid,jobtitle from hrmresource "+sqlwhere+" and id in(select userid from HrmGroupMembers where groupid="+groupid+") order by dsporder,lastname";
		}else{
			sqlstr="select t1.id,t1.lastname,t1.departmentid,t1.jobtitle from hrmresource t1,HrmGroupMembers t2 where t1.id=t2.userid and t2.groupid="+groupid+(isNoAccount.equals("1")?"":noAccountSql)+" order by t1.dsporder,t1.lastname";
		}
	}

	if(tabid.equals("0")&&!companyid.equals("")){
		sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource ";
		sqlstr+=sqlwhere;
		
		if(!isoracle) {
			sqlstr+=" ";
		}
		sqlstr+=" order by dsporder,lastname";
	}else if(tabid.equals("0")&&!subcompanyid.equals("")){
		sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource ";
		sqlstr+=sqlwhere;
		
		if(!isoracle) {
			sqlstr+=" ";
		}
		sqlstr+=" order by dsporder,lastname";
	}else if(tabid.equals("0")&&!departmentid.equals("")){
		sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource ";
		sqlstr+=sqlwhere;
		
		if(!isoracle) {
			sqlstr+=" ";
		}
		sqlstr+=" order by dsporder,lastname";
	}

	//add by alan for td:10343
	boolean isInit = Util.null2String(request.getParameter("isinit")).equals("");//是否点击过搜索
	if((tabid.equals("2") && isInit) ||(tabid.equals("0") && nodeid.equals(""))){
		sqlstr = "select HrmResource.id,lastname,departmentid,jobtitle from HrmResource WHERE 1=2";
	}
}
%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	try{
		parent.parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("33210",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->ResourceBrowserByRight.jsp");
	}

	var dialog = null;
	try{
		dialog = parent.parent.parent.getDialog(parent.parent);
	}
	catch(e){}
</script>
</HEAD>
<BODY style="height: 85%;">
<div class="zDialog_div_content">
<%//@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%//@ include file="/systeminfo/RightClickMenu.jsp" %>

	<!--########Browser Table Start########-->
<TABLE width=100% class="BroswerStyle"  cellspacing="0" STYLE="margin-top:0">
	<!-- added by wcd 2014-07-08 start -->
	<TR>
		<TD align="right" colspan="3">
			<%if(tabid.equals("0")){ %>
					<input type="checkbox" id="alllevel" name="alllevel" value="1" <%=alllevel.equals("1")?"checked='checked'":""%>/><%=SystemEnv.getHtmlLabelName(33454,user.getLanguage())%>
					<input class=inputstyle type="hidden" name="search" value="1">
				<%} %>
           <input type="checkbox" value="1" name="isNoAccount" id="isNoAccount" <%=isNoAccount.equals("1")?"checked='checked'":""%>><%=SystemEnv.getHtmlLabelName(31504,user.getLanguage())%>
		</TD>
	</TR>
</TABLE>
<!-- <div id="tableList" style="overflow-y:scroll;width:100%;height:295px"> </div> -->
       
		<%
		String tableString=""+
		"<table instanceid=\"BrowseTable\" pageId=\""+PageIdConst.HRM_SelectByDec+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_SelectByDec,user.getUID(),PageIdConst.HRM)+"\"  datasource=\"weaver.hrm.HrmDataSource.getHrmResourceList\" sourceparams=\"sqlstr:"+Util.toHtmlForSplitPage(sqlstr)+"\" tabletype=\"none\">"+
		"<sql backfields=\"*\"  sqlform=\"temp\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  />"+
		"<head>";
			tableString+=	 "<col width=\"0%\" hide=\"true\" text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"ids\" orderkey=\"ids\"/>";
			tableString+=	 "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"lastnames\" orderkey=\"lastnames\"/>";
			tableString += "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+"\" column=\"jobtitlenames\" orderkey=\"jobtitlenames\"/>";
			tableString += "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"departmentids\" orderkey=\"departmentids\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\"/>"+
		"</head>"+
		"</table>";      
		%>
				<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.HRM_SelectByDec %>"/>
		<wea:SplitPageTag  tableString="<%=tableString%>" isShowTopInfo="false"  mode="run"/> 
 
	<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="padding:1px !important;height: 15%;">
		<wea:layout type="2col" needImportDefaultJsAndCss="false">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" class=zd_btn_submit onclick="btnclear_onclick();"  id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>">
	      <input type="button" class=zd_btn_cancle onclick="btncancel_onclick();" id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>">
			</wea:item>
		</wea:group>
		</wea:layout>
			<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
	</div>
	<!--########//Select Table End########-->

</div>
<script type="text/javascript">
jQuery(document).ready(function(){
 	var objid = <%=tabid%>;
	 if(objid == 0 || objid ==1){
			$("#btnsub").next().css("display","none");
		}else{
			$("#btnsub").next().css("display","inline");
		}
 })
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
    		 name:jQuery(curTr.cells[1]).text(),
    		 a1:jQuery(curTr.cells[3]).text(),
    		 a2:jQuery(curTr.cells[4]).text()};
			if(dialog){
				try{
          dialog.callback(returnjson);
     }catch(e){}

			try{
			     dialog.close(returnjson);
			 }catch(e){}
			}else{
				window.parent.parent.returnValue = returnjson;
		  	window.parent.parent.close();
			}
	}
}
function btnclear_onclick(){
  var returnjson = {id:"",name:""};
	if(dialog){
		try{
		          dialog.callback(returnjson);
		     }catch(e){}
		
		try{
		     dialog.close(returnjson);
		 }catch(e){}
	}else{
		window.parent.parent.returnValue = returnjson;
  	window.parent.parent.close();
	}
}

function btnsub_onclick(){
	window.parent.frame1.SearchForm.btnsub.click();
}

function btncancel_onclick(){
	if(dialog){
		dialog.close();
	}else{
  	window.parent.parent.close();
	}
}

function afterDoWhenLoaded(){
	$("#_xTable").find("table.ListStyle tbody").children("tr[class!='Spacing']").each(function(){
		var tr = jQuery(this);
		tr.bind("click",function(){
			var id = tr.children("td:first").next().text();
			var name = tr.children("td:first").next().next().text();
			var a1 = tr.children("td:first").next().next().next().text();
			var a2 = tr.children("td:first").next().next().next().next().text();
			var returnjson = {'id':id,'name':name,'a1':a1,'a2':a2};	 
			if(dialog){
				try{
          dialog.callback(returnjson);
     		}catch(e){}

				try{
				     dialog.close(returnjson);
				 }catch(e){}
			}else{
	    	window.parent.parent.returnValue = returnjson;
	    	window.parent.parent.close();
		 	}
		});
	});
}

$(function(){
	//$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	//$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	//$("#BrowseTable").click(BrowseTable_onclick);
	
	//$("#btncancel").click(btncancel_onclick);
	//$("#btnsub").click(btnsub_onclick);
	
	//$("#btnclear").click(btnclear_onclick);
	
});
</script>
</BODY>
</HTML>
