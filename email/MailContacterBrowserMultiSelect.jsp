<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hrm" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="crmContacter" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page" />
<%
int uid = user.getUID();
String sqlstr = "";
String tabid = Util.null2String(request.getParameter("tabid"));
if(tabid.equals("")) tabid="0";
String resourceids = Util.null2String(request.getParameter("resourceids"));
String resourcenames = "";
String _mailUserName="",_mailAddress="";

if(!resourceids.equals("")){
sqlstr = "SELECT * FROM MailUserAddress WHERE id IN ("+resourceids+")";
rs.executeSql(sqlstr);
while(rs.next()){
	_mailUserName = rs.getString("mailUserName");
	_mailAddress = Util.null2String(rs.getString("mailAddress"));
	if(!_mailAddress.equals("")){
		resourcenames += "," + _mailUserName + "<"+_mailAddress+">";
	}else{
		resourcenames += "," + _mailUserName;
	}
}
	resourceids = "," + resourceids;
}

String groupId = Util.null2String(request.getParameter("contacterGroupId"));
String mailUserName = Util.null2String(request.getParameter("mailUserName"));
String mailAddress = Util.null2String(request.getParameter("mailAddress"));
String mailUserType = Util.null2String(request.getParameter("mailUserType"));
String sqlwhere = "";

if(!mailUserName.equals("")) sqlwhere+="AND mailUserName LIKE '%"+mailUserName+"%' ";
if(!mailAddress.equals("")) sqlwhere+="AND mailAddress LIKE '%"+mailAddress+"%' ";
if(!mailUserType.equals("")) sqlwhere+="AND mailUserType='"+mailUserType+"' ";

if(!groupId.equals("")){//From ContacterGroupTree
	sqlwhere += "AND mailGroupId="+groupId+"";
}

sqlstr = "SELECT * FROM MailUserAddress WHERE userId="+uid+" "+sqlwhere+" ORDER BY mailUserName";
%>

<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
</HEAD>
<BODY>
<%//@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%//@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% border="0" cellspacing="0" cellpadding="0">
<tr width=100%>
  <td height="10" colspan="3"></td>
</tr>
<tr width=100%>
<!-- ====================================================================================
Left
==================================================================================== -->
<td align="center" valign="top" width="45%">
	<select size="13" 
		name="from" 
		multiple="true" 
		style="width:100%" 
		class="InputStyle" 
		onclick="blur1('srcList')" 
		onkeypress="checkForEnter('from','srcList')" 
		ondblclick="one2two('from','srcList')">
	</select>
	<script type="text/javascript">
	<%
	rs.executeSql(sqlstr);
	while(rs.next()){
		String ids = rs.getString("id");
		String lastnames = "";
		if(rs.getString("mailUserType").equals("2")){
			lastnames = hrm.getResourcename(rs.getString("mailUserDesc"));
		}else if(rs.getString("mailUserType").equals("3")){
			lastnames = crmContacter.getCustomerContactername(rs.getString("mailUserDesc"));
		}else{
			lastnames = Util.toScreen(rs.getString("mailUserName"),user.getLanguage());
		}
		lastnames = lastnames.replaceAll( ""+'\r', "&nbsp;");
		lastnames = lastnames.replaceAll( ""+'\n', "");
		String email= rs.getString("mailAddress");
		if(!email.equals("")) lastnames=lastnames+" <"+email+">";
	%>
		jQuery("select[name=from]")[0].options.add(new Option('<%=lastnames%>','<%=ids%>'));
	<%}%>
	</script>
</td>
<!-- ====================================================================================
Center
==================================================================================== -->
<td align="center" valign="center" width="10%">
	<img src="/images/arrow_u_wev8.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromList();">
	<br>
	<img src="/images/arrow_r_wev8.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onClick="javascript:one2two('from','srcList');">
	<br>
	<img src="/images/arrow_out_wev8.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:two2one('from','srcList');">				
	<br>
	<img src="/images/arrow_all_wev8.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(17025,user.getLanguage())%>" onClick="javascript:removeAll('from','srcList');">
	<br>				
	<img src="/images/arrow_all_out_wev8.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" onclick="javascript:removeAll('srcList','from');">				
	<br>
	<img src="/images/arrow_d_wev8.gif"   style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromList();">
</td>
<!-- ====================================================================================
Right
==================================================================================== -->
<td align="center" valign="top" width="45%">
	<select size="13" 
		id="srcList"
		name="srcList" 
		multiple="true" 
		style="width:100%" 
		class="InputStyle" 
		onclick="blur1('from')" 
		onkeypress="checkForEnter('srcList','from')" 
		ondblclick="two2one('from','srcList')">
	</select>
</td>
</tr>
<!-- ====================================================================================
Bottom
==================================================================================== -->
<tr width=100% colspan=3>
	<td height="10"></td>
</tr>
<tr width=100%>
	<td align="center" valign="bottom" colspan=3>
		<BUTTON class=btnSearch accessKey=S <%if(!tabid.equals("1")){%>style="display:none"<%}%> id=btnsub onclick="btnsub_onclick()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
		<BUTTON class=btn accessKey=O  id=btnok onclick="btnok_onclick()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
		<BUTTON class=btn accessKey=2  id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
        <BUTTON class=btnReset accessKey=T  id=btncancel onclick="btncancel_onclick()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	</td>
</tr>
</TABLE>

<script language="javascript">
var resourceids = "<%=resourceids%>";
var resourcenames = "<%=resourcenames%>";

//Load
var resourceArray = new Array();
for(var i =1;i<resourceids.split(",").length;i++){
	if(resourceids.split(",")[i]!=0)
	resourceArray[i-1] = resourceids.split(",")[i]+"~"+resourcenames.split(",")[i];
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
	obj.options.add(new Option(txt,val));
	
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
		from = jQuery("select[name="+from+"]")[0];
		to = jQuery("select[name="+to+"]")[0];
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
	var destList  = $("select[name=srcList]")[0];
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
	var destList = $("select[name=srcList]")[0];
	for(var i=0;i<destList.options.length;i++){
		resourceArray[i] = destList.options[i].value+"~"+destList.options[i].text ;
	}
	
}

//xiaofeng
function one2two(m1, m2)
{  
	m1 = jQuery("select[name="+m1+"]")[0];
	m2 = jQuery("select[name="+m2+"]")[0];
    // add the selected options in m1 to m2
    m1len = m1.length ;
    for ( i=0; i<m1len ; i++){
        if (m1.options[i].selected == true ) {
            m2len = m2.length;
            m2.options[m2len]= new Option(m1.options[i].text, m1.options[i].value);
        }
    }

reloadResourceArray();

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
m = jQuery("select[name="+m+"]")[0];
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
    if(resourceids.length>0) resourceids=resourceids.substring(1);
	if(resourcenames.length>0) resourcenames=resourcenames.substring(1); 
}

function btnok_onclick(){

	 setResourceStr();
     replaceStr();
     window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
     window.parent.parent.close();
	
}
function btnclear_onclick(){
	window.parent.parent.returnValue = {id:"",name:""};
     window.parent.parent.close();
}
function btnsub_onclick(){
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
</script>

</BODY>
</HTML>
