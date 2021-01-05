
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/common.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocUserSelfUtil" class="weaver.docs.docs.DocUserSelfUtil" scope="page" />

<HTML><HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<META NAME="AUTHOR" CONTENT="InetSDK">
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<BODY>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18473,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>


<%
int userCategory= Util.getIntValue(request.getParameter("userCategory"),0);  //用户目录
//System.out.println(userCategory);
int parentid = Util.getIntValue(DocUserSelfUtil.getParentid(""+userCategory),0);   //上级目录
int shareparentid= Util.getIntValue(request.getParameter("shareparentid"),0);       //共享目录


//DocUserSelfUtil.getCatalogName  得到目录的名字
//DocUserSelfUtil.getParentids 得到上级目录的和
//0 根目录  >0 正常文件夹  <0 共享的文件夹   -1 为共享文件
//docshare 里有负数的表示是　文档（个人文档部分的）

String parentids = DocUserSelfUtil.getParentids(""+userCategory);   //如 ,0,3
String selectsql = "";


//System.out.println("userCategory is "+userCategory);
//System.out.println("parentid is "+parentid);
//System.out.println("shareparentid is "+shareparentid);
//System.out.println("parentids is "+parentids);


%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if (userCategory>=0) {
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18475,user.getLanguage())+",javascript:onNewFolder(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18474,user.getLanguage())+",javascript:onNewFile(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;   
    RCMenu += "{"+SystemEnv.getHtmlLabelName(78,user.getLanguage())+",javascript:onMove(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form method="post" name="frmPdocRight" action="PersonalDocOperation.jsp"> 
<input type="hidden" name="operation">
<input type="hidden" name="userCategory" value="<%=userCategory%>">
<DIV class=HdrProps>
    <img src="images/font_win_wev8.gif" width="18" height="18" align="absmiddle"><b><%=SystemEnv.getHtmlLabelName(18499,user.getLanguage())%>:</b>
    <a href="PersonalDocRight.jsp?userCategory=0"><img src="images/folder0_wev8.gif" width="18" height="18" align="absmiddle" border=0><%=SystemEnv.getHtmlLabelName(18476,user.getLanguage())%></a>
    <%
    int tmppos = parentids.indexOf(",0,");
    while(tmppos != -1){
        int endpos = parentids.indexOf(",",tmppos+1);
        String tmpstr = "";
        if(endpos !=-1){
            tmpstr = parentids.substring(tmppos+1,endpos);
        }else{
            tmpstr = parentids.substring(tmppos+1);
        }
        if(!tmpstr.equals("0")){
    %>
    >&nbsp<a href="PersonalDocRight.jsp?userCategory=<%=tmpstr%>"><img src="images/folder0_wev8.gif" width="18" height="18" align="absmiddle" border=0><%=DocUserSelfUtil.getCatalogName(tmpstr)%></a>

    <%}
        tmppos = endpos;
}
if(userCategory>0){
    %>
    >&nbsp<a href="PersonalDocRight.jsp?userCategory=<%=userCategory%>"><img src="images/folder0_wev8.gif" width="18" height="18" align="absmiddle" border=0><%=DocUserSelfUtil.getCatalogName(""+userCategory)%></a>
    <%}if(userCategory < 0 ){
        
    %>
    >&nbsp<a href="PersonalDocRight.jsp?userCategory=-1"><img src="images/folder0_wev8.gif" width="18" height="18" align="absmiddle" border=0><%=SystemEnv.getHtmlLabelName(18472,user.getLanguage())%></a>
    <%
    if(userCategory != -1 ){
    %>
    >&nbsp<a href="PersonalDocRight.jsp?userCategory=<%=userCategory%>"><img src="images/folder0_wev8.gif" width="18" height="18" align="absmiddle" border=0><%=ResourceComInfo.getResourcename(""+((-1)*userCategory))%></a>
    <%}
        
        String shareparentids = DocUserSelfUtil.getParentids(""+shareparentid);
        tmppos = shareparentids.indexOf(",0,");        
        while(tmppos != -1){
            int endpos = shareparentids.indexOf(",",tmppos+1);
            String tmpstr = "";
            if(endpos !=-1){
                tmpstr = shareparentids.substring(tmppos+1,endpos);
            }else{
                tmpstr = shareparentids.substring(tmppos+1);
            }
            if(!tmpstr.equals("0")){
    %>
    >&nbsp<a href="PersonalDocRight.jsp?userCategory=<%=userCategory%>&shareparentid=<%=tmpstr%>"><img src="images/folder0_wev8.gif" width="18" height="18" align="absmiddle" border=0><%=DocUserSelfUtil.getCatalogName(tmpstr)%></a>

    <%}
            tmppos = endpos;
        }
        
        if(shareparentid!=0){
    %>
    >&nbsp<a href="PersonalDocRight.jsp?userCategory=<%=userCategory%>&shareparentid=<%=shareparentid%>"><img src="images/folder0_wev8.gif" width="18" height="18" align="absmiddle" border=0><%=DocUserSelfUtil.getCatalogName(""+shareparentid)%></a>
    <%}	
    }%>
</DIV>

<input type=hidden name="userCategory" value="<%=userCategory%>">

<TABLE class=ListShort>
  <TBODY>
 
  <TR class=Header>
  <td width=10%><input type="checkbox" onclick="doCheckAll(this)">(<%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>)</td>
  <td width=45%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
  <td width=30%><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></td>
  <td width=15%><%=SystemEnv.getHtmlLabelName(15098,user.getLanguage())%></td>
  </tr>
  <%
  boolean islight = true;
  if(userCategory==0){%>
 
 <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
     <TD><input type=checkbox name="selectfolder_root" value="-1" disabled ></TD>
     <td><img src="images/folder1_wev8.gif" width="18" height="18" align="absmiddle" border=0>&nbsp<a href="PersonalDocRight.jsp?userCategory=-1"><%=SystemEnv.getHtmlLabelName(18472,user.getLanguage())%></a></td>
     <td></td>
     <td></td>
 </tr>
<% islight=!islight;
  }
  if(userCategory>=0){
      
      selectsql = "select distinct t1.id from DocUserselfCategory t1,docshare t2 where t1.id = -t2.docid and t1.parentid = "+userCategory +" and t1.userid = "+user.getUID()+" and (t2.sharetype !=1 or (t2.sharetype=1 and t2.userid!="+user.getUID()+"))";
      RecordSet.executeSql(selectsql);
      ArrayList sharefolders = new ArrayList();
      
      while(RecordSet.next()){
          sharefolders.add(RecordSet.getString("id"));
      }
      
      selectsql = "SELECT * FROM DocUserselfCategory where parentid = "+userCategory +" and userid = "+user.getUID();
      RecordSet.executeSql(selectsql);
      
      
      while(RecordSet.next()){
	%>
	 <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
             <TD><input type=checkbox name="selectfolder" value="<%=RecordSet.getString("id")%>"></TD>
             <td><img <%if(sharefolders.indexOf(RecordSet.getString("id"))!=-1){%> src="images/folder2_wev8.gif" <%}else{%>src="images/folder1_wev8.gif" <%}%> width="18" height="18" align="absmiddle" border=0>&nbsp<a href="PersonalDocRight.jsp?userCategory=<%=RecordSet.getString("id")%>"><%=RecordSet.getString("name")%></a></td>
             <td><%=RecordSet.getString("createdate")%>&nbsp<%=RecordSet.getString("createtime")%></td>

             <td align="left">
             <img src="images/ff_rename_wev8.gif" border=0  alt="<%=SystemEnv.getHtmlLabelName(18477,user.getLanguage())%>" onmouseover="this.style.cursor='hand';" onclick="window.location='PersonalDocRename.jsp?userCategory=<%=RecordSet.getString("id")%>&operation=folderRename'">	 
             <img src="images/ff_share2_wev8.gif" border=0 alt="<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%>" onmouseover="this.style.cursor='hand';"  onclick="window.location='PersonalDocShare.jsp?userCategory=<%=RecordSet.getString("id")%>'">
             </td>
	 </tr>
	<%
        islight=!islight;
        }
        if(userCategory==0)
            selectsql = "SELECT t1.id,t2.doctype,t1.docsubject,t1.doccreatedate,t1.doccreatetime FROM DocDetail t1,DocUserselfDocs t2 where t1.id = t2.docid  and t1.doccreaterid="+user.getUID() +" and t2.usercatalogid="+userCategory;
        else
            selectsql = "SELECT t1.id,t2.doctype,t1.docsubject,t1.doccreatedate,t1.doccreatetime FROM DocDetail t1,DocUserselfDocs t2 where t1.id = t2.docid and t2.usercatalogid="+userCategory ;
        
        RecordSet.executeSql(selectsql);
        //System.out.println("file select is "+selectsql);
        
        while(RecordSet.next()){
            String imgfilename = "ebdef_wev8.gif";
            int tmptype = RecordSet.getInt("doctype");
            if(tmptype ==1 )
                imgfilename = "ebhtml_wev8.gif";
            if(tmptype ==2 )
                imgfilename = "word_wev8.gif";//word
            if(tmptype ==3 )
                imgfilename = "excel_wev8.gif";
            if(tmptype ==4 )
                imgfilename = "ppt_wev8.gif";

	%>
	 <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
             <TD><input type=checkbox name="selectfile"  value="<%=RecordSet.getString("id")%>" ></TD>
             <td><img src="images/<%=imgfilename%>" width="16" height="16" align="absmiddle" border=0>&nbsp<a  href="DocDsp.jsp?from=personalDoc&userCategory=<%=userCategory%>&id=<%=RecordSet.getString("id")%>"><%=RecordSet.getString("docsubject")%></a></td>
             <td><%=RecordSet.getString("doccreatedate")%>&nbsp<%=RecordSet.getString("doccreatetime")%></td>
             <td align="left">
                 <img src="images/ff_rename_wev8.gif" border=0 alt="<%=SystemEnv.getHtmlLabelName(18477,user.getLanguage())%>" border=0 onmouseover="this.style.cursor='hand';" onclick="window.location='PersonalDocRename.jsp?docId=<%=RecordSet.getString("id")%>&userCategory=<%=userCategory%>&operation=docRename'">
                 <img src="images/ff_share2_wev8.gif" border=0 alt="<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%>" onmouseover="this.style.cursor='hand';"  onclick="window.location='PersonalDocShare.jsp?docId=<%=RecordSet.getString("id")%>'">
                 <img src="images/ff_move_wev8.gif" border=0 alt="<%=SystemEnv.getHtmlLabelName(78,user.getLanguage())%>" onmouseover="this.style.cursor='hand';"  onclick="window.location='PersonalMoveOut.jsp?docId=<%=RecordSet.getString("id")%>&userCategory=<%=userCategory%>'">
             </td>
	 </tr>
	<%
        islight=!islight;
        }
  }else if(userCategory==-1){
 
      selectsql = "select distinct doccreaterid from docdetail t1,"+tables+" t2 where t1.id = t2.sourceid and (t1.seccategory = 341  or t1.seccategory = 0 ) and t1.doccreaterid !="+user.getUID();
      selectsql +="Union select distinct t4.userid as doccreaterid from HrmResource t1 , DocShare as t2, HrmRoleMembers as t3,docuserselfcategory t4 where ( (t2.foralluser=1 ) or ( t2.userid= t1.id ) or (t2.departmentid=t1.departmentid ) ";
      selectsql +=" or (t2.subcompanyid=t1.subcompanyid1 ) or ( t3.resourceid=t1.id and t3.roleid=t2.roleid ) ) and t4.id = -t2.docid and t1.id <> 0 and docid <0 and t1.id =  "+user.getUID();
      RecordSet.executeSql(selectsql);
      
      
      while(RecordSet.next()){
          if(RecordSet.getInt("doccreaterid")==user.getUID())
              continue;
	%>
	 <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
             <TD><input type=checkbox name="selectfolder" disabled ></TD>
             <td><img src="images/folder1_wev8.gif" width="18" height="18" align="absmiddle" border=0>&nbsp<a href="PersonalDocRight.jsp?userCategory=<%=(-1)*RecordSet.getInt("doccreaterid")%>"><%=ResourceComInfo.getResourcename(""+RecordSet.getString("doccreaterid"))%></a></td>
             <td></td>
             <td></td>
	 </tr>
	<%
        islight=!islight;}
  }else if(userCategory<-1){
      
      String oldfolders = "0";
      selectsql = " select distinct (-1)*t2.docid as docid from HrmResource t1 , DocShare as t2, HrmRoleMembers as t3 ";
      selectsql += " where ( (t2.foralluser=1 ) or ( t2.userid= t1.id ) or (t2.departmentid=t1.departmentid ) ";
      selectsql += " or (t2.subcompanyid=t1.subcompanyid1 ) or ( t3.resourceid=t1.id and t3.roleid=t2.roleid ) ) ";
      selectsql += " and t1.id <> 0  and docid <0 and t1.id = "+user.getUID();
      
      RecordSet.executeSql(selectsql);
      while(RecordSet.next()){
          String tmpsecid = RecordSet.getString("docid");
          
          if(!DocUserSelfUtil.getUserIdForCataId(tmpsecid).equals(""+((-1)*userCategory))){
              continue;
          }
          oldfolders+=","+tmpsecid+DocUserSelfUtil.getParentids(tmpsecid);
      }
      //System.out.println("folder sql is "+selectsql);
      //System.out.println("oldfolders is "+oldfolders);
      if(shareparentid!=0)
          selectsql = "select distinct t3.usercatalogid from docdetail t1,"+tables+" t2 ,DocUserselfDocs t3 where t1.id=t3.docid and t1.id = t2.sourceid and (t1.seccategory = 341  or t1.seccategory = 0 ) and t3.userid ="+(((-1)*userCategory))+"  order by t3.usercatalogid desc";
      else
          selectsql = "select distinct t3.usercatalogid from docdetail t1,"+tables+" t2 ,DocUserselfDocs t3 where t1.id=t3.docid and t1.id = t2.sourceid and (t1.seccategory = 341  or t1.seccategory = 0 ) and t1.doccreaterid ="+((-1)*userCategory)+"  order by t3.usercatalogid desc";
      
      //System.out.println("selectsql2"+selectsql);
      
      RecordSet.executeSql(selectsql);
      while(RecordSet.next()){
          String tmpsecid = RecordSet.getString("usercatalogid");
          oldfolders+=","+tmpsecid+DocUserSelfUtil.getParentids(tmpsecid);
      }
      //System.out.println();
      selectsql = "select id,parentid,name from docuserselfcategory where id in ("+oldfolders+")";
      
      RecordSet.executeSql(selectsql);
      while(RecordSet.next()){
          String tmpsecid = RecordSet.getString("id");
          if(RecordSet.getString("parentid").equals(""+shareparentid)){

	%>	
		<tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
                    <TD><input type=checkbox name="selectfolder" value="<%=tmpsecid%>" onclick="onSelectFolder(this);" disabled ></TD>
                    <td><img src="images/folder1_wev8.gif" width="18" height="18" align="absmiddle" border=0>&nbsp<a href="PersonalDocRight.jsp?userCategory=<%=userCategory%>&shareparentid=<%=tmpsecid%>"><%=RecordSet.getString("name")%></a></td>
                    <td></td>
                    <td></td>
	  
		</tr>
	<%	
        islight=!islight;
                }
        }
        
        
        
        if(shareparentid!=0)
            selectsql = "select distinct t1.id,t3.doctype,t1.docsubject,t1.doccreatedate,t1.doccreatetime,t1.doccreaterid,t3.usercatalogid from docdetail t1,"+tables+" t2 ,DocUserselfDocs t3 where t1.id=t3.docid and t1.id = t2.sourceid and (t1.seccategory = 341  or t1.seccategory = 0 ) and t3.usercatalogid ="+(shareparentid)+"  order by t3.usercatalogid desc";
        else
            selectsql = "select distinct t1.id,t3.doctype,t1.docsubject,t1.doccreatedate,t1.doccreatetime,t1.doccreaterid,t3.usercatalogid from docdetail t1,"+tables+" t2 ,DocUserselfDocs t3 where t1.id=t3.docid and t1.id = t2.sourceid and (t1.seccategory = 341  or t1.seccategory = 0 ) and t1.doccreaterid ="+((-1)*userCategory)+"  order by t3.usercatalogid desc";
        
        //out.print(selectsql);
        RecordSet.executeSql(selectsql);
        
        String lastsecid = "0";
        while(RecordSet.next()){
            String tmpsecid = RecordSet.getString("usercatalogid");
            
            if(tmpsecid.equals(""+shareparentid)){
                
                String imgfilename = "ebdef_wev8.gif";
                int tmptype = RecordSet.getInt("doctype");
                if(tmptype ==1 )
                    imgfilename = "ebhtml_wev8.gif";
                if(tmptype ==2 )
                    imgfilename = "word_wev8.gif";//word
                if(tmptype ==3 )
                    imgfilename = "excel_wev8.gif";
                if(tmptype ==4 )
                    imgfilename = "ppt_wev8.gif";

		%>
		 <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
                     <TD><input type=radio name="selectfile"  value="<%=RecordSet.getString("id")%>"  onclick="onSelectFile1(this);"></TD>
                     <td><img src="images/<%=imgfilename%>" width="16" height="16" align="absmiddle" border=0>&nbsp<a href="DocDsp.jsp?from=personalDoc&userCategory=<%=userCategory%>&id=<%=RecordSet.getString("id")%>"><%=RecordSet.getString("docsubject")%></a></td>
                     <td><%=RecordSet.getString("doccreatedate")%>&nbsp<%=RecordSet.getString("doccreatetime")%></td>
                     <td align=right>&nbsp;</td>
		 </tr>
		<%
                
                islight=!islight;
            }
        }
  }
%> 
 </table>
</form>
<script language="javascript">
function onSelectFolder(objid){
	tmpvalue = window.parent.leftFrame.document.all('selectedCate').value;
	if(objid.checked){
		window.parent.leftFrame.document.all('selectedCate').value = tmpvalue + objid.value+",";
	}else{
		tmpvalue = tmpvalue.replace(","+objid.value+",",",");
		window.parent.leftFrame.document.all('selectedCate').value = tmpvalue;
	}
	//alert(window.parent.leftFrame.document.all('selectedCate').value);
	showItem();
	
}

function onSelectFile(objid){
	tmpvalue = window.parent.leftFrame.document.all('selectedFile').value;
	if(objid.checked){
		window.parent.leftFrame.document.all('selectedFile').value = tmpvalue + objid.value+",";
	}else{
		tmpvalue = tmpvalue.replace(","+objid.value+",",",");
		window.parent.leftFrame.document.all('selectedFile').value = tmpvalue;
	}
	//alert(window.parent.leftFrame.document.all('selectedFile').value);
	showItem();
}

function onSelectFile1(objid){
	//tmpvalue = window.parent.leftFrame.document.all('selectedFile').value;
	//if(objid.checked){
	//	window.parent.leftFrame.document.all('selectedFile').value =  ","+objid.value+",";
	//}else{
	//	tmpvalue = tmpvalue.replace(","+objid.value+",",",");
	//	window.parent.leftFrame.document.all('selectedFile').value = tmpvalue;
	//}
	//alert(window.parent.leftFrame.document.all('selectedFile').value);
	//showItem();
}
function showItem(){
	tmpcatevalue = window.parent.leftFrame.document.all('selectedCate').value;
	tmpfilevalue = window.parent.leftFrame.document.all('selectedFile').value;
	showtype = 1;
	if(tmpcatevalue.length > 1)
		showtype = 2;
	if(tmpfilevalue.length > 1)
		showtype = 3;
	if(tmpcatevalue.length > 1&& tmpfilevalue.length > 1)
		showtype = 4;
	if(<%=userCategory%> < 0)
		showtype=5;
	if(showtype==5 && tmpfilevalue.length > 1)
		showtype=6;
	
	
	
	valuechar = tmpcatevalue.split(",") ;
	if(valuechar.length>3)
		showtype = 4;
		
	valuechar = tmpfilevalue.split(",") ;
	if(valuechar.length>3)
		showtype = 4;
	
	allobj = window.parent.leftFrame.document.all;
	for(i=0 ; i<allobj.length ; i++) { 
       		if(allobj[i].id.indexOf("oTR_")!=-1)
       			allobj[i].style.display='none';
       			
	}
	for(i=0 ; i<allobj.length ; i++) { 
       		if(allobj[i].id.indexOf("oTR_1_")!=-1 && (showtype ==1||showtype==2||showtype==3||showtype==4))
       			allobj[i].style.display='';
       		if(allobj[i].id.indexOf("oTR_2_")!=-1 && (showtype ==1||showtype==3))
       			allobj[i].style.display='';
       		if(allobj[i].id.indexOf("oTR_3_")!=-1 && (showtype==2||showtype==3||showtype==4))
       			allobj[i].style.display='';
       		if(allobj[i].id.indexOf("oTR_4_")!=-1 && (showtype ==2))
       			allobj[i].style.display='';
       		if(allobj[i].id.indexOf("oTR_5_")!=-1 && (showtype ==3 || showtype ==6))
       			allobj[i].style.display='';
       		if(allobj[i].id.indexOf("oTR_6_")!=-1)
       			allobj[i].style.display='';
       		if(allobj[i].id.indexOf("oTR_7_")!=-1 && (showtype ==3 ))
       			allobj[i].style.display='';
	}
	
}


function onNewFolder(obj){
    obj.disabled = true
    document.URL = 'PersonalNewFolder.jsp?userCategory=<%=userCategory%>'
}

function onNewFile(obj){
    obj.disabled = true
    document.URL = 'DocAdd.jsp?userCategory=<%=userCategory%>&shareparentid=<%=shareparentid%>&from=personalDoc'
}

function onDelete(obj){
    if (isdel()){
        obj.disabled = true;
        frmPdocRight.operation.value="delete";
        frmPdocRight.submit();
    }
}
function onMove(obj){
    obj.disabled = true;
    frmPdocRight.action ="PersonalDocMove.jsp";
    frmPdocRight.submit();
}

function doCheckAll(obj){
    var _allselectcheckboxs = document.getElementsByName("selectfolder")  
    for (i=0;i<_allselectcheckboxs.length;i++){
        _allselectcheckboxs[i].checked = obj.checked ;
    }
    var _allselectcheckboxs1 = document.getElementsByName("selectfile")  
    for (i=0;i<_allselectcheckboxs1.length;i++){
        _allselectcheckboxs1[i].checked = obj.checked ;
    }
}
</script>

</body>
</html>

