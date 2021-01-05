
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 


<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>

<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <link href="/css/deepTree_wev8.css" rel="stylesheet" type="text/css">
    
</HEAD>

<%
String requestid=Util.null2String(request.getParameter("requestid"));
String receiveUnitIds=Util.null2String(request.getParameter("receiveUnitIds"));
String[] receiveUnitIdArray=Util.TokenizerString2(receiveUnitIds,",");

int uid=user.getUID();

String nodeid=null;
String nodeids=null;
Cookie[] cks= request.getCookies();
String rem="";        
for(int i=0;i<cks.length;i++){
	//System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
	if(cks[i].getName().equals("DocReceiveUnitBrowserMulti"+uid)){
		rem=cks[i].getValue();
		break;
	}
}

ArrayList selectids=Util.TokenizerString(receiveUnitIds,",");
for(int i=0;i<selectids.size();i++){
    String tempReceiveUnitId=(String)selectids.get(i);
    tempReceiveUnitId="|unit_"+tempReceiveUnitId;
    if((rem+"|").indexOf(tempReceiveUnitId+"|")==-1)   rem+=tempReceiveUnitId;
}
if(rem!=null&&rem.length()>1){
	nodeids=rem.substring(1);
}

boolean exist=false;
if(receiveUnitIdArray.length>=1){
	nodeid="unit_"+receiveUnitIdArray[receiveUnitIdArray.length-1];

    String receiveUnitName=DocReceiveUnitComInfo.getReceiveUnitName(receiveUnitIdArray[0]);
    if(!receiveUnitName.equals("")){
		exist=true;
	}
    else{
        exist=false;
	}
}

if(!exist){
	nodeid=null;
}

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
        RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClear(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
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
                            <FORM NAME=select STYLE="margin-bottom:0" action="DocReceiveCompanyBrowserXML.jsp" method=post>

      
                                <TABLE  ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0">     
                                     <TR class=Line1><TH colspan="4" ></TH></TR>
                                      <TR  >
                                          <TD height=400 colspan="4" >                                            
                                                <div id="deeptree" class="deeptree" CfgXMLSrc="/css/TreeConfig.xml" />                                             
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
	<BUTTON type="button" class=btn accessKey=O  id=btnok onclick="onSave()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
        <BUTTON type="button" class=btnReset accessKey=T  id=btncancel onclick="onClear()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
        </td>
        </tr>
    </table>
<FORM name="frmmain" action="/docs/change/ReSendOpterator.jsp" method="post" tagget="_self">
<input type="hidden" value="<%=requestid%>" name="requestid">
<input type="text" value="" name="cids">
</FORM>
</BODY>
<script language="javaScript">


var selectallflag=false;

//to use deeptree,you must implement following methods 
function initTree(){
	deeptree.init("/docs/change/DocReceiveCompanyBrowserXML.jsp?requestid=<%=requestid%><%if(nodeids!=null){%>&nodeids=<%=nodeids%><%}%>");
}

function top(){
<%
	if(nodeid!=null){
%>
        if(document.all("<%=nodeid%>")!=null){
            deeptree.scrollTop=<%=nodeid%>.offsetTop;
        }

<%
	    for(int i=0;i<receiveUnitIdArray.length;i++){
%>
            if(document.all('<%="unit_"+receiveUnitIdArray[i]%>')!=null){
                <%="unit_"+receiveUnitIdArray[i]%>.style.border='1px solid #0099CC';
                <%="unit_"+receiveUnitIdArray[i]%>.nextSibling.checked=true;
            }
<%
	    }
%>
        if(document.all("<%=nodeid%>")!=null){
            deeptree.ExpandNode(<%=nodeid%>.parentElement.parentElement);
        }
<%
	}
%>
}

//node is a DIV object
function showcom(node){

}

//node is a SPAN object
function check(node){
	highlight(node);

    if(selectallflag){
        deeptree.ExpandNode(node.parentElement);
		if(node.parentElement.getElementsByTagName("INPUT")[0].checked){
		    for(i=1;i<node.parentElement.getElementsByTagName("INPUT").length;i++){
			    if(!node.parentElement.getElementsByTagName("INPUT")[i].checked){
				    node.parentElement.getElementsByTagName("INPUT")[i].click();
				}
			}
        }else{
			for(i=1;i<node.parentElement.getElementsByTagName("INPUT").length;i++){
			    node.parentElement.getElementsByTagName("INPUT")[i].checked=false;
                highlight(node.parentElement.getElementsByTagName("INPUT")[i].previousSibling);
			}
        }
    }
}

//end

//node is a SPAN object
function highlight(node){

	if(node.nextSibling.checked){
		node.style.color='red';
	}
    else{
		node.style.color='black';
    }
}


   
function onSaveJavaScript(){      
        var idStr="";
        var nameStr="";
        var nodeidStr="";
        try {
	        if(typeof(select.selObj.length)=="undefined") {
				if(select.selObj.checked) {
					var kids = select.selObj.parentNode.childNodes;
					for(var j=0;j<kids.length;j++){
						if(kids[j].type=="label") {
								nameStr +=","+ kids[j].innerText;
								nodeidStr+="|"+ kids[j].id;
								var temp = select.selObj.value;
						                idStr+=","+temp;													
								break;
						}
					}
				}
			} else {
				for(var i=0;i<select.selObj.length;i++) {
					if(select.selObj[i].checked) {
					var kids = select.selObj[i].parentNode.childNodes;
						for(var j=0;j<kids.length;j++){
							if(kids[j].type=="label") {				    
								nameStr +=","+ kids[j].innerText;
								nodeidStr+="|"+ kids[j].id;
								var temp = select.selObj[i].value;
						                idStr+=","+temp;													
								break;
							}
						}				
					}
				}
			}
        }
        catch(e){}

	if(nodeidStr.length>1){
		setCookie("DocReceiveUnitBrowserMulti<%=uid%>",nodeidStr);
	}
	else {
		alert('<%=SystemEnv.getHtmlLabelName(23220,user.getLanguage())%>!');
		return;
	}
	document.all('cids').value = idStr;
    //alert(idStr +"$" + nameStr);
    document.frmmain.submit();  
} 
   
function needSelectAll(flag,obj){
   selectallflag=flag;
   showcom(deeptree);
   i=obj.value.indexOf('>');
   if(selectallflag){
       a=obj.value.substring(0,i+1)+' <%=SystemEnv.getHtmlLabelName(19324,user.getLanguage())%>';
   }
   else{
       a=obj.value.substring(0,i+1)+' <%=SystemEnv.getHtmlLabelName(19323,user.getLanguage())%>';
   }
   obj.value=a;
}

function setCookie(name,val){ 
	var Then = new Date();
	Then.setTime(Then.getTime() + 30*24*3600*1000 );
	document.cookie = name+"="+val+";expires="+ Then.toGMTString() ;
}

function onClear() {
	location.href = "ChangeDetailBrowser.jsp?requestid=<%=requestid%>";
}

</script>

<script language="vbScript">
 sub onSave()
    dim trunStr,returnVBArray
    trunStr =  onSaveJavaScript() 
end sub
</script>


</HTML>




