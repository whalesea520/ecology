<%@page import="weaver.page.RecordElement"%>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp"%>
<%@ page import="weaver.general.*,weaver.interfaces.datasource.*" %>
<%@ page import="weaver.interfaces.workflow.browser.*" %>
<%@ page import="weaver.systeminfo.*"%>
<%@ page import="weaver.page.RecordElement"%>
<%@ page import="weaver.page.GetDataByDefined"%>
<%@ page import="weaver.page.element.outdata.RecordElementComparator"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<html>
<%
/*Comparator<RecordElement> comparator = new Comparator<RecordElement>() {

			@Override
			public int compare(RecordElement o1, RecordElement o2) {
			try{
				int v1 = Integer.parseInt(o1.getBrowserBean().getId());
				int v2 = Integer.parseInt(o2.getBrowserBean().getId());
				return (v1 - v2);
			} catch (Exception e) {
				return 1;
			}	
			}
			
};*/
ArrayList sourceIdList = new ArrayList();
ArrayList<String> addressList = new ArrayList<String>();
ArrayList defIdList = new ArrayList();
ArrayList<RecordElement> dataList = new ArrayList<RecordElement>();
String prePage = "10";
int col = 1;//数据的栏数
int tempUserId = loginuser == null ? 1 : loginuser.getUID();
String tabId = Util.null2String(request.getParameter("tabId"));
String outdataCurrentTab = Util.null2String((String)session.getAttribute("outdataCurrentTab"));
if(!tabId.equals(outdataCurrentTab)){
	session.setAttribute("outdataCurrentTab",tabId);
}
String url = Util.null2String(request.getParameter("url"));
if(null == eid || "".equals(eid)) {
	eid = Util.null2String(request.getParameter("eid"));
	
}
int userid2 = tempUserId;
if(pc.getSubcompanyid(hpid).equals("-1")&&pc.getCreatortype(hpid).equals("0")){
	userid2 =1;
		
}else{
	userid2=pu.getHpUserId(hpid,""+subCompanyId,loginuser);
}
String getPrePage = "select perpage from hpElementSettingDetail where eid="+eid+" and userid='"+userid2+"'";
rs.executeSql(getPrePage);

if(rs.next()) {
	prePage = rs.getString("perpage");//每页显示数目
}

String getshowtype = "select sourceid,address from hpOutDataSettingAddr where eid="
	+eid+" and tabid="+tabId +" order by pos";
rs.executeSql(getshowtype);
while(rs.next()){
	sourceIdList.add(rs.getString("sourceid"));
	addressList.add(Util.null2String(rs.getString("address")));
}
for(int i = 0; i < sourceIdList.size(); i++) {
	BaseBrowser browser = new BaseBrowser();
	browser.initBaseBrowser(""+sourceIdList.get(i),"2","2");
	String href = Util.null2String(browser.getHref());//链接地址
	String datasourceid = browser.getDatasourceid();//外部数据源
	//注册数据库
	if(!"".equals(datasourceid)) {
		DataSource datasource = (DataSource) StaticObj.getInstance().getServiceByFullname(datasourceid, DataSource.class);
		browser.setDs(datasource);
	}
	
	String Search = browser.getSearch();//.toLowerCase();//
	List l = null;
	
	String uid=tempUserId+"";
	l=browser.search(uid,Search);
	for(int j = 0; j < l.size();j++) {
		RecordElement re = new RecordElement();
		re.setBrowser(browser);
		re.setBrowserBean((BrowserBean)l.get(j));
		re.setSysaddr(addressList.get(i));
		dataList.add(re);
	}
	//取得最大的列数
	Map showfieldMap = browser.getShowfieldMap();
	int tempCol = showfieldMap.size();
	if(tempCol > col) {
		col = tempCol;
	}
}


String selectStr2 = "select * from hpOutDataSettingDef where eid='"
	+eid+"' and tabid='"+tabId +"' order by id";
rs.executeSql(selectStr2);
baseBean.writeLog(selectStr2);
while(rs.next()) {
	defIdList.add(rs.getInt("id"));
	addressList.add(Util.null2String(rs.getString("sysaddr")));
} 
for(int i = 0; i < defIdList.size(); i++) {
	GetDataByDefined selfDef=new GetDataByDefined();
	selfDef.initBaseBrowser(""+defIdList.get(i),"2","2");
	String datasourceid1 = selfDef.getDatasourceid();//外部数据源
	
	//注册数据库
	if(!"".equals(datasourceid1)) {
		DataSource datasource = (DataSource) StaticObj.getInstance().getServiceByFullname(datasourceid1, DataSource.class);
		selfDef.setDs(datasource);
	}
	String Search1 = selfDef.getSearch();//.toLowerCase();//
	List defList = null;
	defList = selfDef.search(tempUserId+"",Search1);
	for(int t = 0; t < defList.size(); t++) {
		RecordElement re = new RecordElement();
		re.setBrowser(selfDef);
		re.setBrowserBean((BrowserBean)defList.get(t));
		re.setSysaddr(addressList.get(i));
		dataList.add(re);
		
	}
	//取得最大的列数
	Map showfieldMap2 = selfDef.getShowfieldMap();
		int tempCol = showfieldMap2.size();
		if(tempCol > col) {
			col = tempCol;
	}
}	

//根据ID进行排序
RecordElementComparator comparator = new RecordElementComparator();
//Collections.sort(dataList, comparator);
%>
<head>
</head>
<body>
<%-- <div id="sysframe" style="display: none"> 
<%for(int i = 0; i < addressList.size(); i++) {%>
	<iframe name="iframes" src="/interface/Entrance.jsp?id=<%=addressList.get(i) %>" style="width:0px;height:0px;"></iframe>
<%} %>
</div> --%>
<TABLE ID=ListStyle class=ListStyle cellspacing="1" width="100%" style="table-layout: fixed;">
		<%-- 	<TR class=HeaderForXtalbe>
		<%for(int i = 0; i < col; i++) {%>
            <TH>
         <%
            String name = SystemEnv.getHtmlLabelName(6002, user.getLanguage());
            name = name + "" + (i+1);
         %><%=name %></TH>
        <%}%>
			</TR> --%>
			<TR class=Line style="height:1px;!important;"><TH style="height:1px;!important;" colspan="<%=col %>" ></TH></TR> 
		<%
		int i=0;
		int rows = 0;//计数器
		for(int k = 0; k < dataList.size()&&rows <= Util.getIntValue(prePage) - 1; k++) {
			Browser browser = dataList.get(k).getBrowser();
			String sysAddr = dataList.get(k).getSysaddr();
			String showfieldname = browser.getNamefield();
			String href = Util.null2String(browser.getHref());//链接地址
			href = Util.null2String(browser.getHref(""+tempUserId,href));
			Map showfieldMap = browser.getShowfieldMap();
			Set keyset = showfieldMap.keySet();
			
			List templist = new ArrayList<BrowserBean>();
			BrowserBean bean = dataList.get(k).getBrowserBean();
			rows++;
			String tempid = bean.getId();
			if(i==0){
				i=1;
		%>
			<TR style="vertical-align: middle;" class=DataLight>
		<%
			}else{
				i=0;
		%>
			<TR style="vertical-align: middle;" class=DataDark>
		<%}%>
		<%	
				Map tempvalueMap = bean.getValueMap();
				String tempvalue = "";
				if(null!=tempvalueMap) {
					Iterator it = keyset.iterator();
		            for(int m = 0; m < col; m++) {
		            	if(it.hasNext()) {
		            		String keyname = (String)it.next();
			            	String showname = (String)showfieldMap.get(keyname);
			            	
			            	tempvalue = Util.null2String((String)tempvalueMap.get(keyname));
			            	
			            	if(showfieldname.equals(keyname)&&!href.equals("")&&!"".equals(sysAddr)) {
			            		//tempvalue = "<a href='"+href+tempid+"' target='_blank'>"+tempvalue+"</a>";
			            		//目前暂不支持单点登录集成
			            		tempvalue = "<a href='/interface/Entrance.jsp?id="+sysAddr+"&gopage="+href+tempid+"' target='_blank'>"+tempvalue+"</a>";
							} else if(showfieldname.equals(keyname)&&!href.equals("")&&"".equals(sysAddr)) {
								tempvalue = "<a href='"+href+tempid+"' target='_blank'>"+tempvalue+"</a>";
							}else if(!"".equals(sysAddr)){
								tempvalue = "<a href='/interface/Entrance.jsp?id="+sysAddr+"' target='_blank'>"+tempvalue+"</a>";
							}
			            } else {
			            	tempvalue = "";
			            }
		            	
            %>
            	<TD style="height: 30px;!important"><%=tempvalue%></TD>
        	<%
        			}
        		}
			%>
			</TR>
		<%
		}
		%>
		</TABLE>
</body>

<script type="text/javascript">
function myrefresh()
{	
if("" != "<%=tabId%>" &&  "1" != "<%=tabId%>") {
	$("#tab_"+<%=eid%>+"_"+<%=tabId%>).click();
} else {
	$("#tab_"+<%=eid%>).click();
}

}
//setTimeout('myrefresh()',1000*60);//60秒刷新一次页面
</script>
</head>
</html>