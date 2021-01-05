
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
	
<%@ page import="weaver.file.Prop" %>
<%@ page import="org.jdom.Document, org.jdom.Element, org.jdom.input.SAXBuilder,java.net.*,weaver.general.Util"%>
<%@ page import="java.util.*" %>

<script type="text/javascript" src="sortabletable_wev8.js"></script>
<link type="text/css" rel="StyleSheet" href="sortabletable_wev8.css" />
<style type="text/css">
body {
	font-family:	Verdana, Helvetica, Arial, Sans-Serif;
	font:			Message-Box;
}

code {
	font-size:	1em;
}
</style>
 <base   target="_self"/>
<br>
<%
	String flvServerIP=Prop.getPropValue("weaver","FLVSERVERIP");
	if("".equals(flvServerIP)){
		out.println(SystemEnv.getHtmlLabelName(127893,user.getLanguage()));
		return;
	}
	String flvServerUrl="http://"+flvServerIP+"/oflaDemo/list.jsp";


	String listDir=request.getParameter("listDir");
	String isShowParent=request.getParameter("isShowParent");


	if(listDir==null) listDir="streams";
	if(isShowParent==null) isShowParent="false";

	
	if("true".equals(isShowParent)){
		int pos=listDir.lastIndexOf("/");
		listDir=listDir.substring(0,pos);
	}

	String strUrl=flvServerUrl+"?listDir="+listDir;
	//System.out.println(strUrl);

	URL url=new URL(strUrl) ;
	SAXBuilder builder= new SAXBuilder();
	Document xmlDo = builder.build(url);
	Element rootNode = xmlDo.getRootElement();

	String cdir=rootNode.getChild("cdir").getAttributeValue("path");
	List itemList=rootNode.getChildren("file");	
	
	//out.println("listDir:"+listDir);

	if(listDir==null||"streams".equals(listDir)||"".equals(listDir)){
	} else {		
%>
	
	<a  href="UploadFlv.jsp?listDir=<%=listDir%>&isShowParent=true" style="text-decoration:none;width:80px;border:1px solid #060011"><%=SystemEnv.getHtmlLabelName(15317,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%></a>

	&nbsp;&nbsp;
<%}%>
<a  href="javascript:onCancel()"  style="text-decoration:none;width:80px;border:1px solid #060011"><%=SystemEnv.getHtmlLabelName(127894,user.getLanguage())%></a>


<br>
<br>

<table class="sort-table" id="table-1" cellspacing="0" width="100%">
	<col />
	<col />
	<col style="text-align: right" />
	<col />
	<col />
	<thead>
		<tr>		
			<td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
			<td><%=SystemEnv.getHtmlLabelName(82755,user.getLanguage())%></td>
			<td><%=SystemEnv.getHtmlLabelName(2036,user.getLanguage())%></td>
			<td><%=SystemEnv.getHtmlLabelName(723,user.getLanguage())%></td>
		</tr>
	</thead>
	<tbody>

		<%
			
			for (Iterator iter = itemList.iterator(); iter.hasNext();) {				 
					Element item = (Element) iter.next();		
					String name=item.getAttributeValue("name");
					String file=item.getAttributeValue("file");
					String link=item.getAttributeValue("link");
					String size=item.getAttributeValue("size");
					String moditime=item.getAttributeValue("moditime");
					String fileid=item.getAttributeValue("fileid");				
			
		%>

		

			<tr>				
				<td>				
					<%if("true".equals(file)){%>
						<img src="file_wev8.png">				
					<%} else {%>
						<img src="folder_wev8.png">	
					<%}%>
				</td>
				

				<td>				
					<%if("true".equals(file)){%>					
						<a href="javaScript:onSubmit('<%=link%>&id=<%=fileid%>')"><%=name%></a>							
					<% }else {
						fileid=URLEncoder.encode(fileid);
					%>
						<a href="<%=link+"?listDir="+fileid%>"><%=name%></a>	
					<% }%>
				</td>
				<td><%=size%></td>
				<td><%=moditime%></td>
				
			</tr>
		<%}%>


	</tbody>
</table>

<script type="text/javascript">

var st1 = new SortableTable(document.getElementById("table-1"),
	["String", "String", "Number", "Number"]);

</script>





<script language="vbscript">

Sub onSubmit(url) 
	 'msgbox(url)
     window.parent.returnvalue = url	
     window.parent.close
End Sub


Sub onCancel()
     window.close
End Sub


</script>