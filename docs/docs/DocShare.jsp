
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="DocShare" class="weaver.docs.DocShare" scope="page" />
<jsp:useBean id="SpopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>

<% 

/*以下几个可能来自docdsp.jsp或dodshareoperation.jsp*/
String docsubject= "" ;
int docid = Util.getIntValue(request.getParameter("docid"),0);
boolean blnOsp="true".equals(request.getParameter("blnOsp"));

RecordSet.executeSql(" select docsubject from docdetail where id = " + docid ) ;
if( RecordSet.next() ) docsubject = Util.null2String(RecordSet.getString("docsubject"));

//禁止文档下载
String nodownload = "1";
boolean isAllowDownload = DocShare.getIsAllowDownload(""+docid);
if (isAllowDownload) {
	nodownload = "0";
}

//3:共享
//user info
int userid=user.getUID();
String logintype = user.getLogintype();
String userSeclevel = user.getSeclevel();
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();

boolean canEdit = false;
boolean canShare = false ;
String userInfo=logintype+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
ArrayList PdocList = SpopForDoc.getDocOpratePopedom(""+docid,userInfo);
if (((String)PdocList.get(1)).equals("true")) canEdit = true ;
if (((String)PdocList.get(3)).equals("true")) canShare = true ;
if(canEdit){
    canShare = true;
}
%>

<HTML><HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
    <script language="javascript" src="../../js/tablefilter_wev8.js"></script>
</HEAD>
    <%
    String imagefilename = "/images/hdReport_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+
            "-"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+
            ": <a href='DocDsp.jsp?id="+docid+"'>"+ docsubject + "</a>";
    String needfav ="1";
    String needhelp ="";
    docsubject = Util.toScreen(docsubject,user.getLanguage(),"0");
    
    
    %>
    <BODY onbeforeunload="beforeClose()">
        <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
        <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
        <%

        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSubmit(this),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
        
        if (DocShare.getIsAllowModiNMShare(""+docid)&&canShare){
            RCMenu += "{"+SystemEnv.getHtmlLabelName(18645,user.getLanguage())+",javascript:doAddShare(),_top} " ;
            RCMenuHeight += RCMenuHeightStep ;
        }
        if ((DocShare.getIsAllowModiNMShare(""+docid)||DocShare.getIsAllowModiMShare(""+docid))&&canShare){
            RCMenu += "{"+SystemEnv.getHtmlLabelName(18646,user.getLanguage())+",javascript:doDelShare(),_top} " ;
            RCMenuHeight += RCMenuHeightStep ;
        }      
    
        %>
        <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
        
        <FORM id=weaver name=weaver  method=post action="DocShareOperation.jsp?blnOsp=<%=blnOsp%>">
        <input type="hidden" name="method">
        <input type="hidden" name="docid" value="<%=docid%>">

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
                        <td valign="top">   
                               <TABLE CLASS=VIEWFORM CELLSPACING="1" >                                                              
                                     <TR>
                                        <TD width="4%"><b><%=SystemEnv.getHtmlLabelName(15168,user.getLanguage())%>：</b></TD>
                                        <TD width="96%"></TD>
                                    </TR>
                                    <TR>
                                        <TD width="4%"></TD>
                                        <TD width="96%"><font color="#ff0000"><%=SystemEnv.getHtmlLabelName(21250,user.getLanguage())%></font></TD>
                                    </TR>
                                    <tr>
                                        <td height=10></td>
                                    </tr>
                                </TABLE>
                                <!--默认共享-->
                                

                                <TABLE CLASS=VIEWFORM CELLSPACING="1" >                                                              
                                     <TR>
                                        <TD width="70%"><B><%=SystemEnv.getHtmlLabelName(15059,user.getLanguage())%></B></TD>
                                        <TD width="30%">
                                            <div align="right">                                                
                                                <img src="\images\up_wev8.jpg" style="cursor:hand" onclick="onHiddenImgClick(divShareSetting,this)" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>" objStatus="show">
                                            </div>
                                        </TD>
                                    </TR>
                                    <TR><TD CLASS=LINE1 COLSPAN=5></TD></TR>
                                </TABLE>

                                <!--与创建人相关的默认共享--> 
                              <DIV ID="divShareSetting">
                                <TABLE CLASS=VIEWFORM CELLSPACING="1" >
                                <COLGROUP> 
                               <COL WIDTH="3%"> 
                                <COL WIDTH="12%">                               
                                <COL WIDTH="30%">
                                <COL WIDTH="45%">
                                <COL WIDTH="10%">     
                                    <TR><TD COLSPAN=5><B><%=SystemEnv.getHtmlLabelName(18590,user.getLanguage())%></B></TD></TR>
                                    <TR><TD CLASS=LINE COLSPAN=5></TD></TR>                
                                     <%=DocShare.getShareTRString(1,docid,"true",user.getLanguage(),canShare)%>
                                     <%=DocShare.getShareTRString(4,docid,"true",user.getLanguage(),canShare)%>
                                </TABLE>

                                
                                <!--与创建人无关的默认共享-->
                                <TABLE CLASS=VIEWFORM CELLSPACING="1" >
                                <COLGROUP> 
                                <COL WIDTH="3%"> 
                                <COL WIDTH="12%">                               
                                <COL WIDTH="30%">
                                <COL WIDTH="45%">
                                <COL WIDTH="10%">
                                    <TR><TD COLSPAN=5><B><%=SystemEnv.getHtmlLabelName(18598,user.getLanguage())%></B></TD></TR>
                                    <TR><TD CLASS=LINE COLSPAN=5></TD></TR>
                                     <%=DocShare.getShareTRString(2,docid,"true",user.getLanguage(),canShare)%>
                                     <%=DocShare.getShareTRString(3,docid,"true",user.getLanguage(),canShare)%>
                                </TABLE>                              
                             </DIV>
                             
                             <br>
                              <TABLE CLASS=VIEWFORM CELLSPACING="1" >                                                              
                                     <TR>
                                        <TD width="70%"><B><%=SystemEnv.getHtmlLabelName(18574,user.getLanguage())%></B></TD>
                                        <TD width="30%">
                                            <div align="right">                                              
                                                <img src="\images\up_wev8.jpg" style="cursor:hand" onclick="onHiddenImgClick(divShareSettingNoMR,this)" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>" objStatus="show">
                                            </div>
                                        </TD>
                                    </TR>
                                    <TR><TD CLASS=LINE1 COLSPAN=5></TD></TR>
                                </TABLE>
                                
                                <div id="divShareSettingNoMR">
                                    <TABLE CLASS=VIEWFORM CELLSPACING="1" >
                                    <COLGROUP> 
                                    <COL WIDTH="3%"> 
                                    <COL WIDTH="12%">                               
                                    <COL WIDTH="30%">
                                    <COL WIDTH="45%">
                                    <COL WIDTH="10%">                                    
                                        <%=DocShare.getShareTRString(5,docid,"true",user.getLanguage(),canShare)%>
                                    </TABLE>
                                </div>
                                  <input type="checkbox" name="chkAll" onclick="chkAllClick(this)">(<%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>)
                                 
                                </TD>
                                </TR>
                            </TABLE>
                                
                                
                                
                        </td>
                    </tr>
                </TABLE>
        </form>
    </BODY>
</HTML>

<script language=javascript>
function doAddShare() { 
	//TD12005
	window.location.href='/docs/docs/DocShareAddBrowser.jsp?para=2_<%=docid%>&blnOsp=<%=blnOsp%>&noDownload=<%=nodownload%>'
}
function doSubmit(obj){   
    obj.disabled = true ; 
    window.location.href="DocShareOperation.jsp?method=finish&docid=<%=docid%>&blnOsp=<%=blnOsp%>";
}

function doDelShare(){
    document.weaver.method.value="delMShare"
    document.weaver.submit();
}

function enableFilter(){
    if(document.getElementById("chk").checked)    {
        attachFilter(document.getElementById('filterTable'), 2);   
    } else {
        document.getElementById('filterTable').detachFilter();
    }
}

function onHiddenImgClick(divObj,imgObj){
     if (imgObj.objStatus=="show"){
        divObj.style.display='none' ;       
        imgObj.src="/images/down_wev8.jpg";
        imgObj.title="<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>";
        imgObj.objStatus="hidden";       
     } else {        
        divObj.style.display='' ;    
        imgObj.src="/images/up_wev8.jpg";
        imgObj.title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>";
        imgObj.objStatus="show";      
     }
 }

 function chkAllClick(obj){   
    var chks = document.getElementsByName("chkShareId");    
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked=obj.checked;
    }    
}

function beforeClose(){  //TD4176
   //window.location.href="DocShareOperation.jsp?method=finish&docid=<%=docid%>&blnOsp=<%=blnOsp%>";
}
</script>

