
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DocUserSelfUtil" class="weaver.docs.docs.DocUserSelfUtil" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />

<HTML><HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<META NAME="AUTHOR" CONTENT="InetSDK">
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<%
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
        Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
        Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String docId = Util.null2String(request.getParameter("docId"));
String foldId = Util.null2String(request.getParameter("userCategory"));
String titlename="";
String parentFoldId="";
if (!"".equals(foldId)){
    titlename=SystemEnv.getHtmlLabelName(18472,user.getLanguage())+":"+DocUserSelfUtil.getCatalogName(foldId)+" ";
    parentFoldId=DocUserSelfUtil.getParentid(foldId);
}  else {
    titlename=SystemEnv.getHtmlLabelName(18494,user.getLanguage())+":"+DocComInfo.getDocname(docId)+" ";
    parentFoldId=DocUserSelfUtil.getParentidByDocId(docId);
}

String sharetype= Util.null2String(request.getParameter("sharetype"));
String departmentid= Util.null2String(request.getParameter("departmentid"));
if(departmentid.equals("")) departmentid= user.getUserDepartment()+"";
if(sharetype.equals("")) sharetype="1";


int itemnum=0;
int haspost= Util.getIntValue(request.getParameter("haspost"),0);


if(haspost == 1){%>

<script language=javascript>
    window.opener.parent.mainFrame.location.reload(true);
    window.close();
</script>
<%}%>

</head>
<BODY>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String needfav ="";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:doAddShare(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form method="POST" action="PersonalDocOperation.jsp" name="frmShare">
    <TABLE class=form>
    <COLGROUP>
    <TBODY>
    <TR class=separator><TD class=Sep1 ></TD></TR>
    </tbody>
    </table>
  
    <input type=hidden name="docId" value="<%=docId%>">
    <input type=hidden name="foldId" value="<%=foldId%>">
    <input type=hidden name="operation" value="sharefiles">
    <input type=hidden name="itemnum" value="0">


    <TABLE class=Form>
    <COLGROUP>
    <COL width="20%">
    <COL width="30%">
    <COL width="20%">
    <COL width="30%">
    <TR>
    <td><%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%></td>
    <TD class=field>
        <%
        %>
        <SELECT name=sharetype onchange="onChangeSharetype(this.value)" >
            <option value="1" <%if(sharetype.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>            
            <option value="5" <%if(sharetype.equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></option>
 
        </SELECT>
    </TD>
    <%if(sharetype.equals("1")){%>
    <td ><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
    <TD class=field> 
        <select class=saveHistory id=departmentid name=departmentid onchange="onChangedepartmentid(this.value);">
            <option value="0"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
            <% while(DepartmentComInfo.next()) {  
                String tmpdepartmentid = DepartmentComInfo.getDepartmentid() ;
            %>
            <option value=<%=tmpdepartmentid%>  <%if(tmpdepartmentid.equals(departmentid)){%>  selected <%}%> <% if(tmpdepartmentid.equals(departmentid)) {%>selected<%}%>>
            <%=Util.toScreen(DepartmentComInfo.getDepartmentname(),user.getLanguage())%></option>
            <% } %>
        </select>
       
    </TD> 
    <%}else if(sharetype.equals("5")) {%><td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:</td><td><INPUT type=text name=safeLevel class=InputStyle size=6 value="8"></td>
    <%}else{%><td></td><td></td><%}%>
    </tr>
    <TR class=separator><TD class=Sep1 colspan=4 ></TD></TR>
 	  
    </table>
 	  

 	  
    <TABLE ID=BrowseTable class="ListStyle" STYLE="margin-top:0">
    <TBODY>
 
    <TR class="Header">
    <th width=70%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
    <th width=10%><%=SystemEnv.getHtmlLabelName(18497,user.getLanguage())%></th>
    <th width=10%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></th>
    <th width=10%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></th>
    </tr>
    <%
    boolean islight = true;
    ArrayList doclists = Util.TokenizerString(docId,",");
    ArrayList foldlists = Util.TokenizerString(foldId,",");
    
    
    int tmpdocid = 0;
    
    if((doclists.size())==1 && foldlists.size()==0){
        tmpdocid = Util.getIntValue(""+doclists.get(0),0);
    }
    if((doclists.size())==0 && foldlists.size()==1){
        tmpdocid = (-1)*(Util.getIntValue(""+foldlists.get(0),0));
    }
    
    String tmpsql = "";
    
    String selectsql ="";
    if(sharetype.equals("1") && !departmentid.equals("0")){
        selectsql =  "SELECT id,lastname as name FROM HrmResource where ((startdate='' or '"+currentdate+"'>=startdate) and (enddate='' or '"+currentdate+"'<= enddate)) and departmentid =" + departmentid +" " ;
        tmpsql = "select userid as id,max(sharelevel) as sharelevel from docshare where sharetype = 1 and docId="+tmpdocid+" group by userid";
    }else if(sharetype.equals("1") && departmentid.equals("0")){
        selectsql =  "SELECT id,lastname as name FROM HrmResource where ( (startdate='' or (startdate!='' and '"+currentdate+"'>= startdate) ) and (enddate='' or (enddate!='' and '"+currentdate+"'<= enddate)))  " ;
        tmpsql = "select userid as id,max(sharelevel) as sharelevel from docshare where sharetype = 1 and docId="+tmpdocid+" group by userid";
    } else if(sharetype.equals("2")){
        selectsql =  "SELECT id, subcompanyname as name FROM HrmSubCompany WHERE (subcompanyname <> 'Default')";
        tmpsql = "select subcompanyid as id,max(sharelevel) as sharelevel from docshare where sharetype = 2 and docId="+tmpdocid+" group by subcompanyid";
    } else if(sharetype.equals("3")){
        selectsql =  "SELECT id,departmentname as name FROM HrmDepartment ORDER BY seclevel";
        tmpsql = "select departmentid as id,max(sharelevel) as sharelevel from docshare where sharetype = 3 and docId="+tmpdocid+" group by departmentid";
    } else if(sharetype.equals("4")){
        selectsql =  "SELECT id,rolesname as name FROM HrmRoles";
        tmpsql = "select roleid as id,max(sharelevel) as sharelevel from docshare where sharetype = 4 and docId="+tmpdocid+" group by roleid";
    } else if(sharetype.equals("5")){
        selectsql =  "SELECT 0 as id,'"+SystemEnv.getHtmlLabelName(1340,user.getLanguage())+"' as name ";
        tmpsql = "select  0 as id,max(sharelevel) as sharelevel from docshare where sharetype = 5 and docId="+tmpdocid+" group by foralluser";
    }

    ArrayList tmpselectedids = new ArrayList();
    ArrayList tmpsharelevels = new ArrayList();
    
    if(tmpdocid != 0){
        RecordSet.executeSql(tmpsql);
        while(RecordSet.next()){
            tmpselectedids.add(RecordSet.getString("id"));
            tmpsharelevels.add(RecordSet.getString("sharelevel"));
        }
    }
    
    RecordSet.executeSql(selectsql);
    
    ArrayList otherids=new ArrayList();
    ArrayList othernames=new ArrayList();
    int totalItem = RecordSet.getCounts();
   
    %>
    <%
    
    while(RecordSet.next()){
    String tmpid = RecordSet.getString("id");
    
    if(sharetype.equals("1") && tmpid.equals(""+user.getUID()))
        continue;
    
    if(tmpselectedids.indexOf(tmpid)==-1){
        otherids.add(tmpid);
        othernames.add(RecordSet.getString("name"));
        continue;
    }

    %>
    <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
        <TD onclick="document.all('share_<%=itemnum%>')(0).checked=true;"><input type=hidden name="shareid_<%=itemnum%>" value="<%=tmpid%>"><%=RecordSet.getString("name")%></TD>
        <td onclick="document.all('share_<%=itemnum%>')(0).checked=true;"><input type=radio name="share_<%=itemnum%>" value="0" <%if(tmpselectedids.indexOf(tmpid)==-1){%> checked <%}%> ></td>
        <td onclick="document.all('share_<%=itemnum%>')(1).checked=true;"><input type=radio name="share_<%=itemnum%>" value="1" <%if(tmpselectedids.indexOf(tmpid)!=-1 && (""+tmpsharelevels.get(tmpselectedids.indexOf(tmpid))).equals("1") ){%> checked <%}%>></td>
        <td onclick="document.all('share_<%=itemnum%>')(2).checked=true;"><input type=radio name="share_<%=itemnum%>" value="2" <%if(tmpselectedids.indexOf(tmpid)!=-1 && (""+tmpsharelevels.get(tmpselectedids.indexOf(tmpid))).equals("2") ){%> checked <%}%>></td>
  
    </tr>
    <%
    islight=!islight;
    itemnum++;
    }
    %>

    <%

for(int i=0;i<otherids.size();i++){
	String tmpid = ""+otherids.get(i);
		
        
        
        %>
        <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
        <TD onclick="document.all('share_<%=itemnum%>')(0).checked=true;"><input type=hidden name="shareid_<%=itemnum%>" value="<%=tmpid%>"><%=""+othernames.get(i)%></TD>
        <td onclick="document.all('share_<%=itemnum%>')(0).checked=true;"><input type=radio name="share_<%=itemnum%>" value="0" <%if(tmpselectedids.indexOf(tmpid)==-1){%> checked <%}%> ></td>
        <td onclick="document.all('share_<%=itemnum%>')(1).checked=true;"><input type=radio name="share_<%=itemnum%>" value="1" <%if(tmpselectedids.indexOf(tmpid)!=-1 && (""+tmpsharelevels.get(tmpselectedids.indexOf(tmpid))).equals("1") ){%> checked <%}%>></td>
        <td onclick="document.all('share_<%=itemnum%>')(2).checked=true;"><input type=radio name="share_<%=itemnum%>" value="2" <%if(tmpselectedids.indexOf(tmpid)!=-1 && (""+tmpsharelevels.get(tmpselectedids.indexOf(tmpid))).equals("2") ){%> checked <%}%>></td>
 
    </tr>
    <%
    islight=!islight;
    itemnum++;
}
    %>   
    <tr class="line"><td colspan="4"></td></tr>
    </table>                  

    <TABLE class=ListStyle cellspacing="1" >
        <colgroup> 
        <col width="20%"> 
        <col width="60%">
        <col width="20%">
        <tr class=header > 
        <th colspan=3><%=titlename+SystemEnv.getHtmlLabelName(16584,user.getLanguage())%></th></tr>								 
								
        <%
        //查找已经添加的默认共享
        int i=1;
        if (!"".equals(foldId)){
            RecordSet.executeProc("DocShare_SelectByDocID","-"+foldId);
        } else {
            RecordSet.executeProc("DocShare_SelectByDocID",""+docId);
        }
        
        while(RecordSet.next()){
            i++;
            if(i%2==0){%>
        <TR  class="datalight">
        <% } else {%>
        <TR  class="datadark">
            <% }                                            
                                                                        if(RecordSet.getInt("sharetype")==1){%>
            <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
            <TD>
                <%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("userid")),user.getLanguage())%>/
                                <% if(RecordSet.getInt("sharelevel")!=2)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
            </TD>
            <TD align=right>                                       
                <a href="PersonalDocOperation.jsp?operation=shareDelete&docId=<%=docId%>&userCategory=<%=foldId%>&id=<%=RecordSet.getString("id")%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>                                        
            </TD>									        
            <%}else if(RecordSet.getInt("sharetype")==2){%>									       
            <TD<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>/TD>
            <TD>
                <%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcompanyid")),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")!=2)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
            </TD>
            <TD align=right>
                <a href="PersonalDocOperation.jsp?operation=shareDelete&docId=<%=docId%>&userCategory=<%=foldId%>&id=<%=RecordSet.getString("id")%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>   
            </TD>									      
            <%}else if(RecordSet.getInt("sharetype")==3)	{%>									       
            <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
            <TD>
                <%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("departmentid")),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")!=2)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
            </TD>
            <TD align=right>
                <a href="PersonalDocOperation.jsp?operation=shareDelete&docId=<%=docId%>&userCategory=<%=foldId%>&id=<%=RecordSet.getString("id")%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>   
            </TD>									        
            <%}else if(RecordSet.getInt("sharetype")==4)	{%>									      
            <TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
            <TD>
                <%=Util.toScreen(RolesComInfo.getRolesname(RecordSet.getString("roleid")),user.getLanguage())%>/<% if(RecordSet.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
                <% if(RecordSet.getInt("rolelevel")!=2)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
                <% if(RecordSet.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")!=2)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
            </TD>
            <TD align=right>
                <a href="PersonalDocOperation.jsp?operation=shareDelete&docId=<%=docId%>&userCategory=<%=foldId%>&id=<%=RecordSet.getString("id")%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>   
            </TD>									        
            <%}else if(RecordSet.getInt("sharetype")==5)	{%>	 
            <TD><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></TD>
            <TD>												<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")!=2)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
            </TD>
            <TD align=right>
                <a href="PersonalDocOperation.jsp?operation=shareDelete&docId=<%=docId%>&userCategory=<%=foldId%>&id=<%=RecordSet.getString("id")%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>   
            </TD>									      
            <%}else if(RecordSet.getInt("sharetype")<0)	{
                                        String crmtype= "" + ((-1)*RecordSet.getInt("sharetype")) ;
                                        String crmtypename=CustomerTypeComInfo.getCustomerTypename(crmtype);
            %>									      
            <TD><%=Util.toScreen(crmtypename,user.getLanguage())%></TD>
                        <TD>
                <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")!=2)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
            </TD>
            <TD align=right>
                <a href="PersonalDocOperation.jsp?operation=shareDelete&docId=<%=docId%>&userCategory=<%=foldId%>&id=<%=RecordSet.getString("id")%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>   
            </TD>									       
            <%}%>		
        </TR>	
            <%}%>
            </table>
        </TD></TR>
        </TBODY>
    </TABLE>
</form>
<script language=javascript>
function onChangeSharetype(objval){
	location.href="/docs/docs/PersonalDocShare.jsp?docId=<%=docId%>&userCategory=<%=foldId%>&sharetype="+objval;

}
function onChangedepartmentid(objval){
	location.href="/docs/docs/PersonalDocShare.jsp?docId=<%=docId%>&userCategory=<%=foldId%>&sharetype=<%=sharetype%>&departmentid="+objval;

}

function doAddShare(obj){
    obj.disabled = true ;
	document.frmShare.itemnum.value="<%=totalItem%>";
	document.frmShare.submit();
}

function doBack(obj){
    obj.disabled = true ;
	window.location.href="PersonalDocRight.jsp?userCategory=<%=parentFoldId%>";
}
</script>

