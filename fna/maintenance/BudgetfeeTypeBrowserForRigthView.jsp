
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
int filterlevel = Util.getIntValue(request.getParameter("level"),0);
int filterfeetype = 0;
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
if(sqlwhere.indexOf("feetype='1'")>0) filterfeetype=1;
else if(sqlwhere.indexOf("feetype='2'")>0) filterfeetype=2;
if(filterfeetype>0&&filterlevel==0) filterlevel=3;

int para1 = Util.getIntValue(request.getParameter("para1"),0);
int para2 = Util.getIntValue(request.getParameter("para2"),0);
%>

<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <link href="/css/deepTree_wev8.css" rel="stylesheet" type="text/css">
</HEAD>

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
    %>	
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(userightmenu_self == 1){%>
    <script>
     rightMenu.style.visibility='hidden'
    </script>
<%}%>
    </DIV>

    <table   width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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
                <TABLE  class=Shadow>
                    <tr>
                        <td valign="top">
                            <FORM NAME=select STYLE="margin-bottom:0" action="CityBrowser.jsp" method=post>


                                <TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0">     
                                     <TR class=Line1><TH colspan="4" ></TH></TR>
                                      <TR>
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
	<BUTTON class=btn accessKey=O  id=btnok onclick="onSave()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=2  id=btnclear onclick="onClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
        <BUTTON class=btnReset accessKey=T  id=btncancel onclick="window.parent.close()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
        </td>
        </tr>
    </table>
</BODY>
</HTML>

<script language="javaScript">
//to use deeptree,you must implement following methods 
function initTree(){
deeptree.init("/fna/maintenance/SubjectSingleXMLForRigthView.jsp?init=true&type=L0&level=<%=filterlevel%>&feetype=<%=filterfeetype%>&para1=<%=para1%>&para2=<%=para2%>");
}

function top(){

}

//node is a DIV object
function showcom(node){
}

function check(node){
if(typeof(select.selObj.length)=='undefined'){
highlight(node);
deeptree.ExpandNode(node.parentElement);
return;
}
for(i=0;i<select.selObj.length;i++){
highlight(select.selObj[i].previousSibling);
}
deeptree.ExpandNode(node.parentElement);
}


//end

//node is a SPAN object
function highlight(node){
if(node.nextSibling.checked)
node.style.color='red';
else
node.style.color='black';

}

function onSaveJavaScript(){     
    var idStr="";
    var nameStr="";
    var nodeidStr="";
    if(select.selObj==null) return "";
    if(typeof(select.selObj.length)=="undefined") {
		if(select.selObj.checked) {
			var kids = select.selObj.parentNode.childNodes;
			
			for(var j=0;j<kids.length;j++){
				if(kids[j].type=="label") {
					
						nameStr +=kids[j].innerText;
						nodeidStr+=kids[j].id;
						var temp = select.selObj.value;
				                idStr+=temp;													
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
					        				    
						nameStr +=kids[j].innerText;
						nodeidStr+=kids[j].id;
						var temp = select.selObj[i].value;
				                idStr+=temp;													
						break;
						
					}
				}
							
											
				
			}
		}
	}
	 

       
    return idStr +"_" + nameStr;   
} 
    



</script>

<script language="vbScript">
 sub onSave()    
    dim trunStr,returnVBArray
    trunStr = onSaveJavaScript()
	if trunStr<> "" then
    returnVBArray = Split(trunStr,"_",-1,0)
    window.parent.returnValue  = returnVBArray
    window.parent.close
	else
	window.alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())+SystemEnv.getHtmlLabelName(1462,user.getLanguage())+"!"%>")
	end if
end sub

sub onClear()
     window.parent.returnValue = Array(0,"","")
     window.parent.close
end sub
</script>