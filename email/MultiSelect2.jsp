<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

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
String companyid = Util.null2String(request.getParameter("companyid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String groupid = Util.null2String(request.getParameter("groupid"));

if(tabid.equals("")) tabid="0";

int uid=user.getUID();
String rem=(String)session.getAttribute("resourcemulti");
        if(rem==null){
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
        if(cks[i].getName().equals("resourcemulti"+uid)){
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


session.setAttribute("resourcemulti",rem);
Cookie ck = new Cookie("resourcemulti"+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

String[] atts=Util.TokenizerString2(rem,"|");
if(tabid.equals("0")&&atts.length>1){
   nodeid=atts[1];
  if(nodeid.indexOf("com")>-1){
    subcompanyid=nodeid.substring(nodeid.indexOf("_")+1);
    }
  else{
    departmentid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    }
}



String sqlstr="";
String check_per = Util.null2String(request.getParameter("resourceids"));
String resourceids = "" ;
String resourcenames ="";
if(!check_per.equals("")){
	try{
	String strtmp = "select id,lastname,email from HrmResource where id in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	Hashtable ht = new Hashtable();
	while(RecordSet.next()){

                        String lastname=RecordSet.getString("lastname");
                        String email= RecordSet.getString("email");
                        if(!email.equals(""))
                        lastname=lastname+" <"+email+">";
        ht.put(RecordSet.getString("id"),lastname);
		/*
		if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){

				resourceids +="," + RecordSet.getString("id");
				resourcenames += ","+RecordSet.getString("lastname");
		}
		*/
	}

	StringTokenizer st = new StringTokenizer(check_per,",");

	while(st.hasMoreTokens()){
		String s = st.nextToken();
		resourceids +=","+s;
		resourcenames += ","+ht.get(s).toString();
	}
	}catch(Exception e){
		
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

String roleid = Util.null2String(request.getParameter("roleid"));

if(departmentid.equals("")&&sqlwhere.equals("")) departmentid=user.getUserDepartment()+"";

if(departmentid.equals("0"))    departmentid="";

if(resourcestatus.equals(""))   resourcestatus="0" ;
if(resourcestatus.equals("-1"))   resourcestatus="" ;



int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!lastname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' ";
}

if(!jobtitle.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where jobtitle in (select id from HrmJobTitles where jobtitlename like '%" + Util.fromScreen2(jobtitle,user.getLanguage()) +"%') ";
	}
	else
		sqlwhere += " and jobtitle in (select id from HrmJobTitles where jobtitlename like '%" + Util.fromScreen2(jobtitle,user.getLanguage()) +"%') ";
}
if(!departmentid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where departmentid =" + departmentid +" " ;
	}
	else
		sqlwhere += " and departmentid =" + departmentid +" " ;
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

 sqlstr = "select HrmResource.id,lastname,departmentid,jobtitle,email "+
			    "from HrmResource  " + sqlwhere +" order by dsporder,lastname";


if(sqlstr.equals("")) sqlstr="select * from hrmresource order by dsporder,lastname";
else if(tabid.equals("1")&&!groupid.equals("")){
sqlstr="select t1.id,t1.lastname,t1.departmentid,t1.jobtitle,t1.email from hrmresource t1,HrmGroupMembers t2 where  (t1.status =0 or t1.status = 1 or t1.status = 2 or status = 3) and t1.id=t2.userid and t2.groupid="+groupid+" order by t1.dsporder,t1.lastname";
}else if(tabid.equals("0")&&!companyid.equals(""))
sqlstr="select id,lastname,departmentid,jobtitle,email from hrmresource where  (status =0 or status = 1 or status = 2 or status = 3) order by dsporder,lastname";
else if(tabid.equals("0")&&!subcompanyid.equals(""))
sqlstr="select id,lastname,departmentid,jobtitle,email from hrmresource where  (status =0 or status = 1 or status = 2 or status = 3) and subcompanyid1="+Util.getIntValue(subcompanyid) +" order by dsporder,lastname";
else if(tabid.equals("0")&&!departmentid.equals(""))
sqlstr="select id,lastname,departmentid,jobtitle,email from hrmresource where  (status =0 or status = 1 or status = 2 or status = 3) and departmentid="+Util.getIntValue(departmentid)+" order by dsporder,lastname";


%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>

</HEAD>
<BODY>

<%//@ include file="/systeminfo/RightClickMenuConent.jsp" %>
	
<%//@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% border="0" cellspacing="0" cellpadding="0">

<tr>
  <td height="10" colspan="3"></td>
</tr>
<tr>
  <td align="center" valign="top" width="45%">
	
			                <select size="13" name="from" multiple="true" style="width:100%" class="InputStyle" onclick="blur1(srcList)" onkeypress="checkForEnter(from,srcList)" ondblclick="one2two(from,srcList)">
				             </select>
		      <script>
      <%
					
					RecordSet.executeSql(sqlstr);
					while(RecordSet.next()){
						String ids = RecordSet.getString("id");
						String lastnames = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage());
                        String email= RecordSet.getString("email");
                        if(!email.equals(""))
                        lastnames=lastnames+" <"+email+">";
                        %>

                          document.all("from").options.add(new Option('<%=lastnames%>','<%=ids%>'));


						<%}%>


                      </script>
		
  </td>
  
  <td align="center" width="10%">
				<img src="/images/arrow_u_wev8.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromList();">
				<br>
				<img src="/images/arrow_r_wev8.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onClick="javascript:one2two(from,srcList);">
				<br>
				<img src="/images/arrow_out_wev8.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:two2one(from,srcList);">				
				<br>
				<img src="/images/arrow_all_wev8.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(17025,user.getLanguage())%>" onClick="javascript:removeAll(from,srcList);">
				<br>				
				<img src="/images/arrow_all_out_wev8.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" onclick="javascript:removeAll(srcList,from);">				
				<br>
				<img src="/images/arrow_d_wev8.gif"   style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromList();">
  </td>
  <td align="center" valign="top" width="45%">
				<select size="13" name="srcList" multiple="true" style="width:100%" class="InputStyle" onclick="blur1(from)" onkeypress="checkForEnter(srcList,from)" ondblclick="two2one(from,srcList)">
					
					
				</select>
  </td>
		
</tr>
<tr>
<td height="10" colspan=3></td>
</tr>
<tr>
     <td align="center" valign="bottom" colspan=3>
     
        <BUTTON class=btnSearch accessKey=S <%if(!tabid.equals("2")){%>style="display:none"<%}%> id=btnsub><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
     
	<BUTTON class=btn accessKey=O  id=btnok><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=2  id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
        <BUTTON class=btnReset accessKey=T  id=btncancel><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
     </td>
</tr>
</TABLE>
<!--########//Shadow Table End########-->

<script language="javascript">
var resourceids = "<%=resourceids%>"
var resourcenames = "<%=resourcenames%>"

//Load
var resourceArray = new Array();
for(var i =1;i<resourceids.split(",").length;i++){
	
	resourceArray[i-1] = resourceids.split(",")[i]+"~"+resourcenames.split(",")[i];
	//alert(resourceArray[i-1]);
}

loadToList();
function loadToList(){
	var selectObj = document.all("srcList");
	for(var i=0;i<resourceArray.length;i++){
		addObjectToSelect(selectObj,resourceArray[i]);
	}
	
}


function addObjectToSelect(obj,str){
	//alert(obj.tagName+"-"+str)
	val = str.split("~")[0];
	txt = str.split("~")[1];
	obj.options.add(new Option(txt,val));
	
}


init(from,srcList)



function upFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = 0; i <= (len-1); i++) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i>0 && destList.options[i-1] != null){
				fromtext = destList.options[i-1].text;
				fromvalue = destList.options[i-1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i-1] = new Option(totext,tovalue);
				destList.options[i-1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}


function deleteFromList(){
	var destList  = document.all("srcList");
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
	to.options[to_len]=new Option(txt,val)	  
	}
	
	for(var i = len; i>=0; i--) {
	from.options[i]=null	  
	}
	
	reloadResourceArray();
}
function downFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i<(len-1) && destList.options[i+1] != null){
				fromtext = destList.options[i+1].text;
				fromvalue = destList.options[i+1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i+1] = new Option(totext,tovalue);
				destList.options[i+1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}
//reload resource Array from the List
function reloadResourceArray(){
	resourceArray = new Array();
	var destList = document.all("srcList");
	for(var i=0;i<destList.options.length;i++){
		resourceArray[i] = destList.options[i].value+"~"+destList.options[i].text ;
	}
	
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


}

function two2one(m1, m2)
{
   one2two(m2,m1);
   reloadResourceArray();
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


var resourceAllValue = "";

function setResourceStr(){
	var resourceids1 =""
	var resourcenames1 = ""

	for(var i=0;i<resourceArray.length;i++){
		resourceids1 += ","+resourceArray[i].split("~")[0] ;
		resourcenames1 += ","+resourceArray[i].split("~")[1];
		resourceAllValue += "," + resourceArray[i];
		
	}
	resourceids=resourceids1
	resourcenames=resourcenames1
}
function replaceStr(){
    if(resourcenames.indexOf("@")<0)
    resourcenames="";
    re=new RegExp("[,]+[^,]*[<]","g")
    resourcenames=resourcenames.replace(re,",")
    re=new RegExp("[>]","g")
    resourcenames=resourcenames.replace(re,"")
    re=new RegExp(",[^,@]*,","g")
    resourcenames=resourcenames.replace(re,",")
}
</script>

<SCRIPT LANGUAGE=VBS>


Sub btnclear_onclick()
     window.parent.returnvalue = ""
     window.parent.close
End Sub


Sub btnok_onclick()
     setResourceStr()
     replaceStr()
     //window.parent.returnvalue =resourcenames	
	  window.parent.returnvalue = resourceAllValue
     window.parent.close
End Sub

Sub btnsub_onclick()
     window.parent.frame1.SearchForm.btnsub.click()
End Sub

Sub btncancel_onclick()
     window.close()
End Sub

</SCRIPT>
</BODY>
</HTML>
