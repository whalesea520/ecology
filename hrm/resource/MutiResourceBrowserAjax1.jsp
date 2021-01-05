<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.Prop,
				weaver.general.GCONST" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<%
String tabid = Util.null2String(request.getParameter("tabid"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
String companyid = Util.null2String(request.getParameter("companyid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String groupid = Util.null2String(request.getParameter("groupid"));
String isNoAccount = Util.null2String(request.getParameter("isNoAccount"));
String newmail = Util.null2String(request.getParameter("newmail"));

boolean isoracle = RecordSet.getDBType().equals("oracle");
if(tabid.equals("")) tabid="0";

int uid=user.getUID();
    String rem = null;
    Cookie[] cks = request.getCookies();

    for (int i = 0; i < cks.length; i++) {
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if (cks[i].getName().equals("resourcemulti" + uid)) {
            rem = cks[i].getValue();
            break;
        }
    }

    if (rem != null)
        rem = tabid + rem.substring(1);
    else
        rem = tabid;
    if (!nodeid.equals(""))
        rem = rem.substring(0, 1) + "|" + nodeid;

Cookie ck = new Cookie("resourcemulti"+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

String[] atts=Util.TokenizerString2(rem,"|");
if(tabid.equals("0")&&atts.length>1){
   nodeid=atts[1];
  if(nodeid.indexOf("com")>-1){
    subcompanyid=nodeid.substring(nodeid.indexOf("_")+1);
    //System.out.println("subcompanyid"+subcompanyid);
    }
  else{
    departmentid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    //System.out.println("departmentid"+departmentid);
    }
}
else if(tabid.equals("1") && atts.length>1) {
	groupid=atts[1];
}
//System.out.println("departmentid"+departmentid);
//System.out.println("tabid"+tabid);

String check_per = Util.null2String(request.getParameter("selectids"));
if(check_per.equals(",")){
	check_per = "";
}
String resourceids = "" ;
String resourcenames ="";
String dpids="";
//如果页面传过来的是自定义组id,而不是resourceids，则把group分解成resourceids
    String initgroupid=Util.null2String(request.getParameter("initgroupid"));

    if(!initgroupid.equals("")){
        check_per="";
        RecordSet.executeSql("select userid from hrmgroupmembers h1,HrmResource h2 where h1.userid=h2.id and groupid="+initgroupid) ;
        String userid;
        while(RecordSet.next()){
            userid=RecordSet.getString("userid");
            if(check_per.equals(""))
            check_per+=userid;
            else
            check_per=check_per+","+userid;
        }
    }
 String coworkid= Util.null2String(request.getParameter("coworkid"));
  if(!coworkid.equals("")){
        check_per="";
        RecordSet.executeSql("select coworkers from cowork_items where id="+coworkid) ;
        String userid;
        while(RecordSet.next()){
            userid=RecordSet.getString("coworkers");
            if(check_per.equals(""))
            check_per+=userid;
            else
            check_per=check_per+","+userid;
        }
    }
  String cowtypeid = Util.null2String(request.getParameter("cowtypeid"));
  if(!cowtypeid.equals("")){
      check_per="";
      RecordSet.executeSql("select members from cowork_types where id="+cowtypeid) ;
      String userid;
      while(RecordSet.next()){
          userid=RecordSet.getString("members");
          if(check_per.equals(""))
          check_per+=userid;
          else
          check_per=check_per+","+userid;
      }
  }
  
  String workID= Util.null2String(request.getParameter("workID"));
  if(!workID.equals("")){
        check_per="";
        RecordSet.executeSql("select resourceID from WorkPlan where id="+workID) ;
        String userid;
        while(RecordSet.next()){
            userid=RecordSet.getString("resourceID");
            if(check_per.equals(""))
            check_per+=userid;
            else
            check_per=check_per+","+userid;
        }
    }
if(!check_per.equals("")){
	//if(check_per.substring(0,1).equals(","))check_per = check_per.substring(1);
	//if(check_per.substring(check_per.length()-1).equals(","))check_per = check_per.substring(0,check_per.length()-1);
	if(check_per.substring(0,1).equals(","))check_per = check_per.substring(1);
	if(check_per.substring(0,1).equals(","))check_per = check_per.substring(1);
	if(check_per.substring(check_per.length()-1).equals(","))check_per = check_per.substring(0,check_per.length()-1);
	if(check_per.substring(check_per.length()-1).equals(","))check_per = check_per.substring(0,check_per.length()-1);
	try{
	String strtmp = "select id,lastname,departmentid from HrmResource where id in ("+check_per+")";
    if(!initgroupid.equals(""))
           strtmp = "select id,lastname,departmentid from HrmResource where id in (select userid from hrmgroupmembers where groupid="+initgroupid+")"; 

	if(!coworkid.equals("")&&isoracle){
      strtmp = "select id,lastname,departmentid from HrmResource where exists  (select 1  from cowork_items where id="+coworkid+" and dbms_lob.instr(coworkers,','||hrmresource.id||',',1,1)>0 )"; 
	}
	//System.out.print(strtmp);
    RecordSet.executeSql(strtmp);
	Hashtable ht = new Hashtable();
	Hashtable htdp = new Hashtable();
	//boolean ifhave=false;
	while(RecordSet.next()){
		//ifhave=true;
        String department = Util.toScreen(RecordSet.getString("departmentid"),user.getLanguage());
                        String mark=DepartmentComInfo.getDepartmentmark(department);

                        if(mark.length()>6)
                        mark=mark.substring(0,6);
                        int length=mark.getBytes().length;
                        if(length<12){
                            for(int i=0;i<12-length;i++){
                              mark+=" ";
                            }
                        }
                        String subcid=DepartmentComInfo.getSubcompanyid1(department);
                        String subc= SubCompanyComInfo.getSubCompanyname(subcid);
                        String lastname=RecordSet.getString("lastname");
                        length=lastname.getBytes().length;
                        if(length<10){
                            for(int i=0;i<10-length;i++){
                              lastname+=" ";
                            }
                        }
                        lastname=lastname+" | "+mark+" | "+subc;
        ht.put(RecordSet.getString("id"),lastname);
        htdp.put(RecordSet.getString("id"),department);
		/*
		if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){

				resourceids +="," + RecordSet.getString("id");
				resourcenames += ","+RecordSet.getString("lastname");
		}
		*/
	}
    strtmp = "select id,lastname, 0 as departmentid from HrmResourcemanager where id in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	while(RecordSet.next()){
		
                        String lastname=RecordSet.getString("lastname");
                        String department = RecordSet.getString("departmentid");
                        int length=lastname.getBytes().length;
                        if(length<10){
                            for(int i=0;i<10-length;i++){
                              lastname+=" ";
                            }
                        }
                        lastname=lastname;
        ht.put(RecordSet.getString("id"),lastname);
        htdp.put(RecordSet.getString("id"),department);
		
	}
	StringTokenizer st = new StringTokenizer(check_per,",");

	while(st.hasMoreTokens()){
		String s = st.nextToken();
		resourceids +=","+s;
		resourcenames += ","+Util.StringReplace(ht.get(s).toString(),",","，");
		dpids +=","+htdp.get(s).toString();
	}
	}catch(Exception e){
		resourceids="";
		resourcenames="";
		dpids="";
	}
}



Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String lastname = Util.null2String(request.getParameter("lastname"));
String resourcetype = Util.null2String(request.getParameter("resourcetype"));
String resourcestatus = Util.null2String(request.getParameter("resourcestatus"));
String jobtitle = Util.null2String(request.getParameter("jobtitle"));
 //departmentid = Util.null2String(request.getParameter("departmentid"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String status = Util.null2String(request.getParameter("status"));
String firstname = Util.null2String(request.getParameter("firstname"));
String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());    
String roleid = Util.null2String(request.getParameter("roleid"));

if(tabid.equals("0")&&departmentid.equals("")&&sqlwhere.equals("")) departmentid=user.getUserDepartment()+"";

if(departmentid.equals("0"))    departmentid="";

if(subcompanyid.equals("0"))    subcompanyid="";

/*if(resourcestatus.equals(""))   resourcestatus="0" ;
if(resourcestatus.equals("-1"))   resourcestatus="" ;*/
if(status.equals("-1")) status = "";
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!lastname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where (lastname like '%"+Util.fromScreen2(lastname,user.getLanguage())+"%' or pinyinlastname like '%"+Util.fromScreen2(lastname,user.getLanguage()).toLowerCase()+"%' )";
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
	}
	else
		sqlwhere += " and jobtitle in(select id from HrmJobTitles where jobtitlename like '%" + Util.fromScreen2(jobtitle,user.getLanguage()) +"%') ";
}
if(!departmentid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where departmentid =" + departmentid +" " ;
	}
	else
		sqlwhere += " and departmentid =" + departmentid +" " ;
}
if(departmentid.equals("")&&!subcompanyid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where subcompanyid1 =" + subcompanyid +" " ;
	}
	else
		sqlwhere += " and subcompanyid1 =" + subcompanyid +" " ;
}
if(!status.equals("")&&!status.equals("9")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where status =" + status +" " ;
	}
	else
		sqlwhere += " and status =" + status +" " ;
}
if(status.equals("")){
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
		 //loginid、account字段整合  qc:128484
			 noAccountSql=" and loginid is not null "+(RecordSet.getDBType().equals("oracle")?"":" and loginid<>'' ");
			
		 }
	 }else{
	  //loginid、account字段整合  qc:128484
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
if(mode==null||!mode.equals("ldap")){
	 sqlstr = "select HrmResource.id,lastname,departmentid,jobtitle "+
    "from HrmResource " + sqlwhere+" order by dsporder,lastname";
if(tabid.equals("0")&&!companyid.equals("")){
sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource where (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);

sqlstr+=" order by dsporder,lastname";
}else if(tabid.equals("0")&&!subcompanyid.equals("")){
sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource where (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);

sqlstr+=" and subcompanyid1="+Util.getIntValue(subcompanyid)+" order by dsporder,lastname";
}else if(tabid.equals("0")&&!departmentid.equals("")){
sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource where (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);

sqlstr+=" and departmentid="+Util.getIntValue(departmentid)+" order by dsporder,lastname";
}
}else{
	 sqlstr = "select HrmResource.id,lastname,departmentid,jobtitle "+
    "from HrmResource " + sqlwhere+" order by dsporder,lastname";
if(tabid.equals("0")&&!companyid.equals("")){
sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource where (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);

sqlstr+=" order by dsporder,lastname";
}else if(tabid.equals("0")&&!subcompanyid.equals("")){
sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource where (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);

sqlstr+=" and subcompanyid1="+Util.getIntValue(subcompanyid)+" order by dsporder,lastname";
}else if(tabid.equals("0")&&!departmentid.equals("")){
sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource where (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);

sqlstr+=" and departmentid="+Util.getIntValue(departmentid)+" order by dsporder,lastname";
}
}

if(tabid.equals("1")&&!groupid.equals("")){
	sqlstr="select t1.id,t1.lastname,t1.departmentid,t1.jobtitle from hrmresource t1,HrmGroupMembers t2 where t1.id=t2.userid and t2.groupid="+groupid+(isNoAccount.equals("1")?"":noAccountSql)+" order by t1.dsporder,t1.lastname";
	}
//add by alan for td:10343
boolean isInit = Util.null2String(request.getParameter("isinit")).equals("");//是否点击过搜索
if((tabid.equals("2") && isInit) ||(tabid.equals("0") && nodeid.equals(""))) sqlstr = "select HrmResource.id,lastname,departmentid,jobtitle from HrmResource WHERE 1=2";


%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>

</HEAD>
<BODY>

<%//@ include file="/systeminfo/RightClickMenuConent.jsp" %>
	
<%//@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% border="0" cellspacing="0" cellpadding="0">

<tr>
  <td height="10" colspan="3" align="right">
  	  <%=SystemEnv.getHtmlLabelName(31503,user.getLanguage())%>&nbsp;<label id="chose_num" style="text-decoration: underline;"></label>&nbsp;<%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>
      <input style="margin-left: 80px;" type="checkbox" value="1" name="isNoAccount" id="isNoAccount" <%=isNoAccount.equals("1")?"checked='checked'":""%>><%=SystemEnv.getHtmlLabelName(31504,user.getLanguage())%>
  </td>
</tr>

<tr>
  <td align="center" valign="top" width="45%">
	
			                <select size="13"  name="from" multiple="true" style="width:100%" class="InputStyle" onclick="blur1($('select[name=srcList]')[0])" onkeypress="checkForEnter($('select[name=from]')[0],$('select[name=srcList]')[0])" ondblclick="one2two($('select[name=from]')[0],$('select[name=srcList]')[0])">
				             </select>
		      <script>
      <%
					RecordSet.executeSql(sqlstr);
					while(RecordSet.next()){
						String ids = RecordSet.getString("id");
						if(newmail.equals("true")){
							// 判断是否是内部邮件模块人员浏览框，该模块需要传递部门ID
							ids= ids+"|"+ RecordSet.getString("departmentid");
						}
						String firstnames = Util.toScreen(RecordSet.getString("firstname"),user.getLanguage());
						String lastnames = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage());
                        int length=lastnames.getBytes().length;
                        if(length<10){
                            for(int i=0;i<10-length;i++){
                              lastnames+=" ";
                            }
                        }

                        String department = Util.toScreen(RecordSet.getString("departmentid"),user.getLanguage());
                        String mark=DepartmentComInfo.getDepartmentmark(department);

                        if(mark.length()>6)
                        mark=mark.substring(0,6);
                        length=mark.getBytes().length;
                        if(length<12){
                            for(int i=0;i<12-length;i++){
                              mark+=" ";
                            }
                        }
                        String subcid=DepartmentComInfo.getSubcompanyid1(department);
                        String subc= SubCompanyComInfo.getSubCompanyname(subcid);
                        lastnames=lastnames+" | "+mark+" | "+subc;
                        %>
						  var option = new Option('<%=lastnames%>','<%=ids%>');
						  $(option).attr("dpid","<%=department%>");
                          document.all("from").options.add(option);


						<%}%>


                      </script>
		
  </td>
  
  <td align="center" width="10%">
				<img src="/images/arrow_u_wev8.gif" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromList();">
				<br>
				<img src="/images/arrow_left_wev8.gif" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onClick="javascript:one2two($('select[name=from]')[0],$('select[name=srcList]')[0]);">
				<br>
				<img src="/images/arrow_right_wev8.gif"  style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:two2one($('select[name=from]')[0],$('select[name=srcList]')[0]);">				
				<br>
				<img src="/images/arrow_left_all_wev8.gif" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(17025,user.getLanguage())%>" onClick="javascript:removeAll($('select[name=from]')[0],$('select[name=srcList]')[0]);">
				<br>				
				<img src="/images/arrow_right_all_wev8.gif"  style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" onclick="javascript:removeAll($('select[name=srcList]')[0],$('select[name=from]')[0]);">				
				<br>
				<img src="/images/arrow_d_wev8.gif"   style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromList();">
  </td>
  <td align="center" valign="top" width="45%">
				<select size="13" name="srcList"  multiple="true" style="width:100%" class="InputStyle" onclick="blur1($('select[name=from]')[0])"
				 onkeypress="checkForEnter($('select[name=srcList]')[0],$('select[name=from]')[0])" ondblclick="two2one($('select[name=from]')[0],$('select[name=srcList]')[0])">
					
					
				</select>
  </td>
		
</tr>
<tr>
<td height="10" colspan=3 style="text-align: right;">
</td>
</tr>
<tr>
     <td align="center" valign="bottom" colspan=3>
     
        <BUTTON class=btnSearch onclick="btnsub_onclick();" accessKey=S <%if(!tabid.equals("2")){%>style="display:none"<%}%> id=btnsub><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
     
	<BUTTON class=btn accessKey=O  id=btnok onclick="btnok_onclick();"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=2  id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
        <BUTTON class=btnReset accessKey=T  id=btncancel onclick="btncancel_onclick();";><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
     </td>
</tr>
</TABLE>
<!--########//Shadow Table End########-->

<script language="javascript">
var resourceids = "<%=resourceids%>"
var resourcenames = "<%=resourcenames%>"
var dpids = "<%=dpids%>"
//Load
var resourceArray = new Array();
for(var i =1;i<resourceids.split(",").length;i++){
	if(resourceids.split(",")[i]!=0)
	resourceArray[i-1] = resourceids.split(",")[i]+"~"+resourcenames.split(",")[i]+"~"+dpids.split(",")[i];
	//alert(resourceArray[i-1]);
}

loadToList();
function loadToList(){
	var selectObj = $("select[name=srcList]")[0];
	for(var i=0;i<resourceArray.length;i++){
		addObjectToSelect(selectObj,resourceArray[i]);
	}
	
}


function addObjectToSelect(obj,str){
	//alert(obj.tagName+"-"+str)
	val = str.split("~")[0];
	txt = str.split("~")[1];
	dpid = str.split("~")[2];
	//var option = new Option(txt,val)
	//$(option).attr()
	var oOption = new Option(txt,val);
	$(oOption).attr("dpid",dpid);
	obj.options.add(oOption);
}


init($("select[name=from]")[0],$("select[name=srcList]")[0])



function upFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = 0; i <= (len-1); i++) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i>0 && destList.options[i-1] != null){
				fromtext = destList.options[i-1].text;
				fromvalue = destList.options[i-1].value;
				fromdpid = $(destList.options[i-1]).attr("dpid")
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				todpid = $(destList.options[i]).attr("dpid")
				
				destList.options[i-1] = new Option(totext,tovalue);
				$(destList.options[i-1]).attr("dpid",todpid)
				destList.options[i-1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);	
				$(destList.options[i]).attr("dpid",fromdpid)
			}
      }
   }
   reloadResourceArray();
}


function deleteFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function removeAll(from,to){
	
	var len = from.options.length;
	for(var i = 0; i < len; i++) {
	to_len=to.options.length
	txt=from.options[i].text
	val=from.options[i].value
	dpid=$(from.options[i]).attr("dpid");
	to.options[to_len]=new Option(txt,val)	
	$(to.options[to_len]).attr("dpid",dpid)
	}
	
	for(var i = len; i>=0; i--) {
	from.options[i]=null	  
	}
	reloadResourceArray();
	changeNum();
}
function downFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i<(len-1) && destList.options[i+1] != null){
				fromtext = destList.options[i+1].text;
				fromvalue = destList.options[i+1].value;
				fromdpid = $(destList.options[i+1]).attr("dpid");
				
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				todpid = $(destList.options[i]).attr("dpid");
				
				destList.options[i+1] = new Option(totext,tovalue);
				destList.options[i+1].selected = true;
				$(destList.options[i+1]).attr("dpid",todpid);
				destList.options[i] = new Option(fromtext,fromvalue);		
				$(destList.options[i]).attr("dpid",fromdpid);
			}
      }
   }
   reloadResourceArray();
}
//reload resource Array from the List
function reloadResourceArray(){
	resourceArray = new Array();
	var destList = $("select[name=srcList]")[0];
	for(var i=0;i<destList.options.length;i++){
		resourceArray[i] = destList.options[i].value+"~"+destList.options[i].text+"~"+$(destList.options[i]).attr("dpid") ;
	}
	changeNum();
}

//xiaofeng
function one2two(m1, m2)
{  
    // add the selected options in m1 to m2
    m1len = m1.length ;
    for ( i=0; i<m1len ; i++){
        if (m1.options[i].selected == true ) {
            m2len = m2.length;
            m2.options[m2len]= new Option(m1.options[i].text, m1.options[i].value);
            //alert($(m1.options[i]).attr("dpid"))
            $(m2.options[m2len]).attr("dpid",$(m1.options[i]).attr("dpid"));
            //alert( $(m2.options[m2len]).attr("dpid"))
        }
    }

reloadResourceArray()

	// remove all the selected options from m1 (because they have already been added to m2)	
	j = -1;
    for ( i = (m1len -1); i>=0; i--){
        if (m1.options[i].selected == true ) {
            m1.options[i] = null;
			j = i;
        }
    }
	
	if (j == -1)
		return;
		
	// move focus to the next item
	if (m1.length <= 0)
		return;
		
	if ((j < 0) || (j > m1.length))
		return;
		
	if (j == 0)
		m1.options[j].selected = true;
	else if (j == m1.length)
		m1.options[j-1].selected = true
	else
		m1.options[j].selected = true;

	changeNum();
}

function two2one(m1, m2)
{
   one2two(m2,m1);
   reloadResourceArray();
   changeNum();
}

function blur1(m){
for(i=0;i<m.length;i++){
m.options[i].selected=false
}
}

function checkForEnter(m1, m2) {
 
   var charCode =  event.keyCode;
   if (charCode == 13) {
      
      one2two(m1, m2);
   }
   return false;
}

function init(m1,m2){
for(i=0;i<m2.length;i++){
ids=m2.options[i].value
for(j=0;j<m1.length;j++){
if(m1.options[j].value==ids){
m1.options[j]=null
break
}
}
}

}

function setResourceStr(){
	
	var resourceids1 =""
    var resourcenames1 = ""
    var dpids1 ="";
        
	for(var i=0;i<resourceArray.length;i++){
		resourceids1 += ","+resourceArray[i].split("~")[0] ;
		
		resourcenames1 += ","+resourceArray[i].split("~")[1].replace(/,/g,"，") ;
		dpids1+= ","+resourceArray[i].split("~")[2];
	}
	resourceids=resourceids1
	resourcenames=resourcenames1
	dpids = dpids1
}
function replaceStr(){
    var re=new RegExp("[ ]*[|][^|]*[|]","g")
    resourcenames=resourcenames.replace(re,"|")
    re=new RegExp("[|][^,]*","g")
    resourcenames=resourcenames.replace(re,"")   
}
function btnok_onclick(){

	 setResourceStr();
     replaceStr();
     window.parent.parent.returnValue = {id:resourceids,name:resourcenames,dpid:dpids};
     window.parent.parent.close();
	
}
function btnclear_onclick(){
	window.parent.parent.returnValue = {id:"",name:"",dpid:""};
     window.parent.parent.close();
}
function btnsub_onclick(){
	//window.parent.parent.frame1.SearchForm.btnsub.click();
		var curDoc;
		if(document.all){
			curDoc=window.parent.frames["frame1"].document
		}
		else{
			curDoc=window.parent.document.getElementById("frame1").contentDocument	
		}
		$(curDoc).find("#btnsub")[0].click();
}
function btncancel_onclick(){
	 window.parent.parent.close();
}

function changeNum(){
	var num = $('select[name=srcList]').children().length;
	$("#chose_num").html(num);
}
jQuery(document).ready(function(){
	changeNum();
});
</script>


</BODY>
</HTML>
