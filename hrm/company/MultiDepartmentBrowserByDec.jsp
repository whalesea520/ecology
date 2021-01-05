
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <script type="text/javascript" src="/js/xtree_wev8.js"></script>
	<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
	<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
	<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" />
</HEAD>
<%
int uid=user.getUID();
int beagenter = Util.getIntValue((String)session.getAttribute("beagenter_"+user.getUID()));
if(beagenter <= 0){
	beagenter = uid;
}
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));
String selectedDepartmentIds = Util.null2String(request.getParameter("selectedDepartmentIds"));
String passedDepartmentIds = Util.null2String(request.getParameter("passedDepartmentIds"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
int fieldid=Util.getIntValue(request.getParameter("fieldid"));
    int isdetail=Util.getIntValue(request.getParameter("isdetail"));
    int isbill=Util.getIntValue(request.getParameter("isbill"),1);
    boolean onlyselfdept=CheckSubCompanyRight.getDecentralizationAttr(beagenter,"Departments:decentralization",fieldid,isdetail,isbill);
    boolean isall=CheckSubCompanyRight.getIsall();
    if(!isall){
        if(onlyselfdept){
            sqlwhere=" where departmentid in("+CheckSubCompanyRight.getDepartmentids()+")";
        }else{
            sqlwhere=" where subcompanyid1 in("+CheckSubCompanyRight.getSubcompanyids()+")";
        }
    }
    String selectedids = Util.null2String(request.getParameter("selectedids"));
    String[] selecteds = selectedids.split("[,]");
    int deptlevel = 0;
    int maxnum=0;
    if(!"".equals(selectedids)&&!"0".equals(selectedids)){
    	for(int i=0;i<selecteds.length;i++){
    		if(!"".equals(selecteds[i])&&!"0".equals(selecteds[i])){
    			maxnum = DepartmentComInfo.getLevelByDepId(selecteds[i]);
    			if(deptlevel<maxnum){
    				deptlevel = maxnum;
    			}
    		}
    	}
    }
    String selectnode = "";
    String supcompanyid = "";
    if(!"".equals(selectedids)&&!"0".equals(selectedids)){
    	for(int i=0;i<selecteds.length;i++){
    		if(!"".equals(selecteds[i])&&!"0".equals(selecteds[i])){
    			supcompanyid = DepartmentComInfo.getSubcompanyid1(selecteds[i]);
    			selectnode = ",dept_"+supcompanyid+"_"+selecteds[i]+selectnode;
    		}
    	}
    }
    if(selectnode.startsWith(",")){
    	selectnode = selectnode.substring(1);
    }
String nodeid=null;
String nodeids=null;
Cookie[] cks= request.getCookies();
String rem=null;
for(int i=0;i<cks.length;i++){
//System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
if(cks[i].getName().equals("departmentmulti"+uid)){
  rem=cks[i].getValue();
  break;
}
}
if(rem!=null&&rem.length()>1)
nodeids=rem.substring(1);
if(nodeids!=null){
 if(nodeids.indexOf("|")>-1)
  nodeid=nodeids.substring(nodeids.lastIndexOf("|")+1);
 else
  nodeid=nodeids;
}
boolean exist=false;
if(nodeid!=null&&nodeid.indexOf("dept")>-1){
    String deptname=DepartmentComInfo.getDepartmentname(nodeid.substring(nodeid.lastIndexOf("_")+1));
    String subcom=DepartmentComInfo.getSubcompanyid1(nodeid.substring(nodeid.lastIndexOf("_")+1));
    if(!deptname.equals("")&&subcom.equals(nodeid.substring(nodeid.indexOf("_")+1,nodeid.lastIndexOf("_"))))
       exist=true;
    else
      exist=false;
}
if(!exist)
nodeid=null;

String[] ids=Util.TokenizerString2(nodeids,"|");
%>


<BODY onload="initTree()">
    <DIV align=right>
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
    BaseBean baseBean_self = new BaseBean();
    int userightmenu_self = 1;
    try{
    	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
    }catch(Exception e){}
    if(userightmenu_self == 1){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
      
        RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    RCMenu += "{"+SystemEnv.getHtmlLabelName(19323,user.getLanguage())+",javascript:needSelectAll(!parent.selectallflag,this),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    %>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(userightmenu_self == 1){%>
    <script>
     rightMenu.style.visibility='hidden'
    </script>
<%}%>
    </DIV>

    <table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
        <colgroup>
        <col width="10">
        <col width="">
        <col width="10">
        <tr>
            <td height="10" colspan="3"></td>
        </tr>
        <tr>
            <td ></td>
            <td valign="top">
                <TABLE class=Shadow>
                    <tr>
                        <td  valign="top">
                            <FORM NAME=select STYLE="margin-bottom:0" action="MultiDepartmentBrowserByDec.jsp" method=post>
                                <input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere)%>">
                                <input class=inputstyle type=hidden name=type value="<%=type%>">
                                <input class=inputstyle type=hidden name=id value="<%=id%>">
                                <input class=inputstyle type=hidden name=level value="<%=level%>">
                                <input class=inputstyle type=hidden name=subid value="<%=subid%>">
                                <input class=inputstyle type=hidden name=nodename value="<%=nodename%>">
                                <textarea style="display:none" name=passedDepartmentIds ><%=passedDepartmentIds%></textarea>
                                <textarea style="display:none" name=selectedDepartmentIds ><%=selectedDepartmentIds%></textarea>
                                <TABLE  ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width:100%;">
                                     <TR class=Line1><TH colspan="4" ></TH></TR>
                                      <TR  >
                                          <TD height=400 colspan="4" >
                                                <div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
                                          </TD>
                                      </TR>
                                </TABLE>
                            </FORM>
                         </td>
                    </tr>
                </TABLE>
            </td>
            <td></td>
        </tr>
        <tr> <td height="10" colspan="3"></td></tr>
        <tr>
        <td align="center" valign="bottom" colspan=3>
	<BUTTON class=btn accessKey=O  id=btnok onclick="onSave()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=2  id=btnclear onclick="onClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
        <BUTTON class=btnReset accessKey=T  id=btncancel onclick="window.parent.close()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
        </td>
        </tr>
    </table>
</BODY>
<script language="javaScript">
var selectallflag=false;
var appendimg = 'subCopany_Colse';
var appendname = 'selObj';
var allselect = "all";
var typename = "checkbox";
var selectreview = "openall";
var selectedids = "<%=selectedids%>";
if(selectedids!="0"&&selectedids!=""){
	cxtree_id = "<%=selectnode%>";
	cxtree_ids = cxtree_id.split(',');
	cxtree_id = cxtree_ids[0];
} 
function initTree(){
CXLoadTreeItem("", "/hrm/tree/DepartmentMultiXMLByDec.jsp?deptlevel=<%=deptlevel%>&onlyselfdept=<%=onlyselfdept%><%if(nodeids!=null){%>&nodeids=<%=nodeids%><%}%>&mathrandom="+Math.random());
var tree = new WebFXTree();
tree.add(cxtree_obj);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
}

var xmlHttp;
var ajaxvalue;
function showAjax(subId,suptype){
	if(window.ActiveXObject){
        xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    else if(window.XMLHttpRequest){
        xmlHttp = new XMLHttpRequest();
    }
    xmlHttp.onreadystatechange = getReturnValue;
	xmlHttp.open("get","MutiDepartmentAjax.jsp?subId="+subId+"&suptype="+suptype,false); 
	xmlHttp.send(); 
}
function getReturnValue(){
	if(xmlHttp.readystate==4){ 
		if(xmlHttp.status==200){
			var returnTemp = xmlHttp.responseText;
			ajaxvalue = returnTemp;
		}
	}
}

function onSaveJavaScript(){      
        var nameStr="";
        if(select.selObj==null) return "";
        if(typeof(select.selObj.length)=="undefined") {
		if(select.selObj.checked) {
			nameStr =  select.selObj.value;
		}
	} else {
		for(var i=0;i<select.selObj.length;i++) {
			if(select.selObj[i].checked) {
				if(select.selObj[i].value.indexOf("_")==0){
					showAjax(select.selObj[i].value.split("_")[1],"com");
					nameStr = nameStr + ajaxvalue;
				}else{
					if(selectallflag){
						if(nameStr.indexOf(select.selObj[i].value)>=0){
							continue;
						}else{
							nameStr = nameStr + select.selObj[i].value + ",";
							showAjax(select.selObj[i].value.split("_")[2],"dep");
							nameStr = nameStr + ajaxvalue;
						}
					}else{
						nameStr = nameStr + select.selObj[i].value + ",";
					}
				}
			}
		}
	}
	arrayname = nameStr.split(",");
	var resultStr1="";
	var resultStr2="";
	for(var j=0;j<arrayname.length;j++){
		arraytemp = arrayname[j].split("_");
		if(arraytemp.length==1){
			break;
		}
		if(resultStr1.indexOf(arraytemp[2]) < 0){
			resultStr1 = resultStr1 + "," + arraytemp[2];
		}
		var strtmp2 = "";
		for(var i=0;i<arraytemp.length;i++){
			if(i>2){
				strtmp2 = strtmp2 + "_" + arraytemp[i];
			}
		}
		if(resultStr2.indexOf(strtmp2.substring(1)) < 0){
			resultStr2 = resultStr2 + "," + strtmp2.substring(1);
		}
	}
        return resultStr1+"$"+resultStr2;
    }  

function showallcheckbox(node){
	for(var i=0;i<node.childNodes.length;i++){
		if(node.childNodes[i].folder){
			if(node.childNodes[i].icon.indexOf(appendimg)<1){
				if(selectallflag){
					document.getElementById(node.childNodes[i].id+'_radio').getElementsByTagName('INPUT')[0].style.display="";	
				}else{
					document.getElementById(node.childNodes[i].id+'_radio').getElementsByTagName('INPUT')[0].style.display="none";
				}
			}
			showallcheckbox(node.childNodes[i]);
		}else{
			continue;
		}
	}
}

function needSelectAll(flag,obj){
   selectallflag=flag;
   showallcheckbox(cxtree_obj);
   i=obj.value.indexOf('>');
   if(selectallflag)
   a=obj.value.substring(0,i+1)+' <%=SystemEnv.getHtmlLabelName(19324,user.getLanguage())%> ';
   else
   a=obj.value.substring(0,i+1)+' <%=SystemEnv.getHtmlLabelName(19323,user.getLanguage())%> ';
   obj.value=a;
}
function onSave(){
	 var trunStr,returnVBArray;
  trunStr =  onSaveJavaScript();
  returnVBArray = trunStr.split("$");
  window.parent.returnValue  = returnVBArray;
  window.parent.close();
}

function onClear(){
	window.parent.returnValue = {id:"",name:""};
   window.parent.close()
}
</script>


</HTML>