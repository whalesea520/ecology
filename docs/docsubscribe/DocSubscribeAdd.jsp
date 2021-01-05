
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.docSubscribe.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="SpopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%  
    DocSubscribe ds = new DocSubscribe("",user);
    String subscribeDocId = Util.null2String(request.getParameter("subscribeDocId"));
    String isdialog = Util.null2String(request.getParameter("isdialog"));
	String isclose = Util.null2String(request.getParameter("isclose"));
    String from = Util.null2String(request.getParameter("from"));//  DocRelation:文档相关资源
	
    ArrayList addDocLists = Util.TokenizerString(subscribeDocId,",");
    
    //String strSearchCase = ds.getSearchCase(request,user.getLanguage());
	String strSearchCase="";
	if(!from.equals("DocRelation")){
		strSearchCase = ds.getSearchCase(request,user.getLanguage());
	}

	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(611,user.getLanguage());
	String needfav ="1";
    String needhelp ="";
    
    //user info
    int userid = user.getUID();
    String logintype = user.getLogintype();
    String userSeclevel = user.getSeclevel();
    String userType = ""+user.getType();
    String userdepartment = ""+user.getUserDepartment();
    String usersubcomany = ""+user.getUserSubCompany1(); 
    //0:查看
    boolean canReader = false;
    String userInfo=logintype+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;    


%>
<%if("1".equals(isdialog)){ %>
         <SCRIPT LANGUAGE="JavaScript">

var dialog = parent.getDialog(window);
 <%if("1".equals(isclose)){%>
 	try{
 		dialog.callback(1);
 	}catch(e){}
 	dialog.close();
 <%}%>

        </SCRIPT>
<%}%>
<HTML>
  <HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  </HEAD>
  <BODY>
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="doc"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(32121,user.getLanguage()) %>"/>
</jsp:include>
<%if("1".equals(isdialog)){ %>
<div class="zDialog_div_content">


<%} %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%

    RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSubmit(this)',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
if(!"1".equals(isdialog)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18655,user.getLanguage())+",javascript:onResearch()',_top} " ;
	RCMenuHeight += RCMenuHeightStep ;


    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack()',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		    <table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%>" class="e8_btn_top" onclick="onSubmit(this);"/>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
                <form name="frmDocSubscribeAdd" method="post" action="DocSubscribeOperate.jsp">

                <input type="hidden" name="operation" value="add">
                <TEXTAREA NAME="searchCase" style="display:none"><%=strSearchCase%></TEXTAREA>
   <%if(isdialog.equals("1")){ %>
  <INPUT type="hidden" Name="isdialog" value="<%=isdialog %>">
  <%} %>                 
                  <wea:layout>
                  	<wea:group context='<%=SystemEnv.getHtmlLabelName(32121,user.getLanguage())%>'>
<%if(!from.equals("DocRelation")){%>
                  		
<%}%>
                  		<wea:item><%=SystemEnv.getHtmlLabelName(17517,user.getLanguage())%></wea:item>
                  		<wea:item>
                  			<%                                   
                               int tempLength = addDocLists.size();
                               for (int i=0 ;i<tempLength;i++){
                             	  String docidtemp = (String)addDocLists.get(i);
                             	  ArrayList PdocList = SpopForDoc.getDocOpratePopedom(""+(String)addDocLists.get(i),userInfo);
                             	  if (((String)PdocList.get(0)).equals("true")) canReader = true ;
                             	  
                             	  String statetemp = "";
                             	  rs.executeSql("select id,state from DocSubscribe where docid ="+docidtemp+" and hrmid ="+userid+" order by id desc");
                             	  if(rs.next()) statetemp = rs.getString("state");
                             	  if("1".equals(statetemp)) {
                             		  out.println(DocComInfo.getDocname(docidtemp)+"<span style='color:green'>("+SystemEnv.getHtmlLabelName(23694,user.getLanguage())+")</span>");
                             	  } else if ("2".equals(statetemp) || canReader) {
                             		  out.println(DocComInfo.getDocname(docidtemp)+"<span style='color:red'>("+SystemEnv.getHtmlLabelName(24412,user.getLanguage())+")</span>");
                             	  } else {
                             		  out.println(DocComInfo.getDocname((String)addDocLists.get(i)));
                             %>
                                      <input type="hidden" name="docids" value="<%=addDocLists.get(i)%>">
                             <%
                             	  }    	  
                                   out.println("<BR>");
                             %>
                                   
                             <% } 
                                   out.println("<BR>");
                                   out.println(SystemEnv.getHtmlLabelName(18998,user.getLanguage())+""+tempLength+SystemEnv.getHtmlLabelName(15015,user.getLanguage()));                                       
                             %>    
                  		</wea:item>
                  		<wea:item><%=SystemEnv.getHtmlLabelName(18664,user.getLanguage())%></wea:item>
                  		<wea:item><TEXTAREA class  ="inputstyle" NAME="subscribeDesc" ROWS="4" COLS="80"></TEXTAREA></wea:item>
                  	</wea:group>
                  </wea:layout>
                  <textarea id="txtShare" onclick="onSubmit(this)" style="visibility:hidden"></textarea>
                  </form>

<%if("1".equals(isdialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
				</wea:item>
			</wea:group>
		</wea:layout>
	
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>

          </BODY>
        </HTML>
         <SCRIPT LANGUAGE="JavaScript">


        <!--          
          function onSubmit(obj){      
<%if(!"1".equals(isdialog)){%>			  
             try{
				parent.disableTabBtn();
			}catch(e){}
<%}%>
             frmDocSubscribeAdd.submit();
          }

           function onBack(){ 
             window.history.go(-1);
          }
           function onResearch(){
              window.location="/docs/tabs/DocCommonTab.jsp?_fromURL=93&from=docsubscribe&ishow=false";
          }
         
        //-->
        </SCRIPT>
