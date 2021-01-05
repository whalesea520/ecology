
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowKeywordComInfo" class="weaver.docs.senddoc.WorkflowKeywordComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String tabid = Util.null2String(request.getParameter("tabid"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String parentId = Util.null2String(request.getParameter("parentId"));

if(tabid.equals("")) tabid="0";

int uid=user.getUID();
    String rem = null;
    Cookie[] cks = request.getCookies();

    for (int i = 0; i < cks.length; i++) {
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if (cks[i].getName().equals("WorkflowKeywordBrowserMulti" + uid)) {
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

Cookie ck = new Cookie("WorkflowKeywordBrowserMulti"+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

String[] atts=Util.TokenizerString2(rem,"|");
if(tabid.equals("0")&&atts.length>1){
   nodeid=atts[1];
   parentId=nodeid.substring(nodeid.lastIndexOf("_")+1);
}


String strKeyword = Util.null2String(request.getParameter("strKeyword"));
String intKeywords = "" ;


if(!strKeyword.equals("")){

	try{
		List strKeywordList=Util.TokenizerString(strKeyword," ");
		strKeyword="";
		String tempKeyword=null;
		String tempId="0";
		boolean keywordIsExists=false;

		for(int i=0;i<strKeywordList.size();i++){
			tempKeyword=(String)strKeywordList.get(i);

			if(tempKeyword!=null&&!tempKeyword.trim().equals("")){
				keywordIsExists=false;
				WorkflowKeywordComInfo.setTofirstRow();
				while(WorkflowKeywordComInfo.next()){
					if(tempKeyword.equals(WorkflowKeywordComInfo.getKeywordName())){
						tempId=WorkflowKeywordComInfo.getId();
						strKeyword+=","+tempKeyword;
						intKeywords+=","+tempId;
						keywordIsExists=true;
						break;
					}
				}

				if(!keywordIsExists){
					strKeyword+=","+tempKeyword;
					intKeywords+=","+(-i-1);
				}
			}
		}
	
	}catch(Exception e){
		intKeywords="";
		strKeyword="";
	}
}

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String keyWordName = Util.null2String(request.getParameter("keyWordName"));
String keywordDesc = Util.null2String(request.getParameter("keywordDesc"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));


if(parentId.equals("0"))    parentId="";




int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;

if(ishead==0){
	ishead = 1;
	sqlwhere += " where isKeyword='1' ";
}else{
	sqlwhere += " and isKeyword='1' ";
}

if(!keyWordName.equals("")){
	sqlwhere += " and keyWordName like '%" + Util.fromScreen2(keyWordName,user.getLanguage()) +"%' ";
}
if(!keywordDesc.equals("")){
	sqlwhere += " and keywordDesc like '%" + Util.fromScreen2(keywordDesc,user.getLanguage()) +"%' ";
}

if(tabid.equals("0")&&!parentId.equals("")){
	sqlwhere += " and parentId=" + parentId;
}

String sqlstr = " select id,keywordName  from Workflow_Keyword " + sqlwhere+" order by showOrder asc"; ;

%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/docs/multiSelectWKBrowser_wev8.js"></script>
<script type="text/javascript">
	var parentWin = parent.parent.getParentWindow(parent);
	var dialog = parent.parent.getDialog(parent);

	function onClose(){
		 if(dialog){
	    	dialog.close()
	    }else{
		    window.parent.parent.close();
		}
	}
</script>
</HEAD>
<BODY>

<div class="zDialog_div_content">
<FORM NAME=weaver id="weaver" STYLE="margin-bottom:0" action="WorkflowKeywordBrowserMultiSelect.jsp" method=post>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle id="strKeyword" type="hidden" name="strKeyword" value="<%=strKeyword%>">
  <input class=inputstyle type="hidden" id="tabid" name="tabid" value="<%=tabid %>">
  <input class=inputstyle type="hidden" id="nodeid" name="nodeid" value="<%=nodeid %>">
  <input class=inputstyle type="hidden" id="parentId" name="parentId" value="<%=parentId %>">
    <input class=inputstyle type="hidden" id="keyWordName" name="keyWordName" value="<%=keyWordName %>">
  <input class=inputstyle type="hidden" id="keywordDesc" name="keywordDesc" value="<%=keywordDesc %>" >
</FORM>
<div id="dialog">
	<div id='colShow' ></div>
</div>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="padding:0px!important;">
<div style="padding:5px 0px">
<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes='{\"groupDisplay\":\"none\"}'>
		<wea:item type="toolbar">
			<input type="button" class=zd_btn_submit accessKey=O  id=btnok value="O-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_submit accessKey=2  id=btnclear value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
	        <input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
		</wea:item>
	</wea:group>
</wea:layout>
<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
			showMultiDocDialog("<%=strKeyword%>");
		});
	</script>
	</div>
</div>

<!--########//Shadow Table End########-->

</BODY></HTML>