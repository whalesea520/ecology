
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.BufferedReader" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="dci" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="hpes" class="weaver.homepage.HomepageExtShow" scope="page"/>
<jsp:useBean id="oDocManager" class="weaver.docs.docs.DocManager" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
	String typeID = ""+Util.getIntValue(request.getParameter("typeID"),0);
	String name="";
    

	RecordSet.executeSql("select name from  WebMagazineType where id="+typeID);
	if(RecordSet.next()) name=Util.null2String(RecordSet.getString("name"));
%>
<BODY>
<table  width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td height="40" align="center" style="color:#008000;font-size:18pt"><strong>《<%=name%>》</strong></td>
		<td width="5">&nbsp;</td>
	</tr>
	<tr> 
		<td> 
		<FORM name="Magazine"  action="tom_magazine.jsp" method="post">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			
			<tr>
				<td height="30" width="54%"><input type="hidden" name="typeID" value="<%=typeID%>"><input type="hidden" name="name" value="<%=name%>"></td>
				<td width="21%"><img src="images/tom/mail3_wev8.gif" width="117" height="20"></td>
				<td width="14%"> 
					<select name="id">
					<%
						String id = ""+Util.getIntValue(request.getParameter("id"),0);
						RecordSet.executeSql("select id  , releaseYear , name from WebMagazine where typeID = " + typeID + " order by id desc");
						while (RecordSet.next()){
							if(id.equals("0")) id = RecordSet.getString("id");
					%>
						<option value='<%=RecordSet.getString("id")%>' <%if (id.equals(RecordSet.getString("id"))){%>selected<%}%>><%=RecordSet.getString("releaseYear")%>年
						<%=RecordSet.getString("name")%>
						</option>
					<%}%>
					</select>				
				</td>
				<td width="11%"><img src="images/tom/search_wev8.gif" width="56" style="cursor:hand" onclick="Magazine.submit()"></td>
			</tr>
			
			</table>
			</FORM>
			
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td colspan="4" height="1" bgcolor="#63A80E"></td>
				</tr>
				<tr bgcolor="#C9E19F"> 
					<td colspan="4" height="4"></td>
				</tr>
				<tr> 
					<td width="4%" height="30" bgcolor="#F3FFE4">&nbsp;</td>
					<td width="58%" height="30" bgcolor="#F3FFE4">&nbsp;</td>
					<td width="13%" height="30" bgcolor="#F3FFE4"><img src="images/tom/icon_news_wev8.gif" width="63" height="42"></td>
					<td width="25%" height="30" bgcolor="#F3FFE4" style="font-size:9pt"> 
						<div align="center"><b>
					  <%
						String headDoc = "";
						RecordSet.executeSql("select releaseYear , name , docID from WebMagazine where id = " + id);
						if (RecordSet.next()){
							headDoc = Util.null2String(RecordSet.getString("docID"));
					  %>
						<%=RecordSet.getString("releaseYear")%>年
						<%=RecordSet.getString("name")%>
					  <%}%>
					  </b></div>
					</td>
				</tr>
				<tr> 
					<td colspan="4" height="1" bgcolor="#63A80E"></td>
				</tr>
				<tr> 
					<td colspan="4" height="1" bgcolor="#bbbbbb"></td>
				</tr>
				<tr> 
					<td colspan="4" height="30"> 
						<table width="100%" border="0" cellspacing="0" cellpadding="8">
					  <%
							String docsubject="";
							String doccontent="";
							String doclastmoddate="";
							String docid="";
							ConnStatement statement = null;
							try{
							if (!headDoc.equals("")) {
                               statement=new ConnStatement();  
                               String tempSql="";
                               headDoc=oDocManager.getNewDocids(headDoc);
                               if((statement.getDBType()).equals("oracle")){
                                    tempSql="select id , docsubject , d2.doccontent , doclastmoddate  from DocDetail d1,DocDetailcontent d2  where d1.id=d2.docid and id in ("+headDoc+")";
                               } else {
                                   tempSql="select id , docsubject , doccontent , doclastmoddate  from DocDetail where id in ("+headDoc+")";
                               }
                                statement.setStatementSql(tempSql) ;	
                                statement.executeQuery();


                                while (statement.next()){
                                //获取文档标题docsubject
                                docid=Util.null2String(statement.getString("id"));
                                docsubject=Util.null2String(statement.getString("docsubject"));
                                
                                //获取文档内容doccontent
                                if((statement.getDBType()).equals("oracle")){
                                    CLOB theclob = statement.getClob("doccontent");
                                    String readline = "";
                                    StringBuffer clobStrBuff = new StringBuffer("");
                                    BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
                                    while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline);
                                    clobin.close() ;
                                    doccontent = clobStrBuff.toString();
                                }else{
                                    doccontent=Util.null2String(statement.getString("doccontent"));
                                }
                              
					  %>
            	<tr> 
            		<td width="30%"> 
           				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
            				<tr> 
            					<td width="100%" height="115" background="images/tom/bg_wev8.gif"> 
								<%
									
									String strImgSrc="";
									String temppics="/images/homepage/noimgdefault_wev8.gif";
									String links="/images/homepage/noimgdefault_wev8.gif";

									int curpos = doccontent.indexOf("/weaver/weaver.file.FileDownload?fileid=");
									if(curpos!=-1){
									curpos =  doccontent.indexOf("?fileid=",curpos);
									int endpos = doccontent.indexOf("\"",curpos);
									String  tmppicid="";
									if(endpos!=-1)   tmppicid = doccontent.substring(curpos+8,endpos);

									if(!tmppicid.equals("")) {
									  ArrayList imgidList=new ArrayList();
									  imgidList.add(tmppicid);
									  ArrayList docidList=new ArrayList();
									  docidList.add(docid);
									  
									  //String servername = request.getHeader("Host");
									  //String servername ="127.0.0.1:"+request.getServerPort();
									  String servername="127.0.0.1";
									  String realSeaver=request.getHeader("Host");
									  int posPort=realSeaver.indexOf(":");
									  if(posPort!=-1) servername=servername+":"+realSeaver.substring(posPort+1);
									  
									  
									  strImgSrc=hpes.getPicImgs(docidList,servername,imgidList,"120","108");
										if(strImgSrc.indexOf("$")!=-1)
									  	{
											strImgSrc = strImgSrc.substring(0,strImgSrc.indexOf("$"));
									   	}

									 
									  if(!"#".equals(strImgSrc)){
											ArrayList picList=Util.TokenizerString(strImgSrc,"#");
											if(picList.size()==2) {
											   temppics=(String)picList.get(0);
											   links=(String)picList.get(1);
											}
										}  else {
										   temppics="/images/homepage/noimgdefault_wev8.gif";
										   links="/images/homepage/noimgdefault_wev8.gif";
										}


									}  else{
									 strImgSrc="/images/homepage/noimgdefault_wev8.gif";
									}
								%>		
								<%}%>
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr><td height="6" colspan="2"></td></tr>
                          	<tr> 
                              <td width="12">&nbsp;</td>
                              <td height="99">
								<a href="<%=links%>" target="_blank"><img border=0 src="<%=temppics%>" > </a> 
							  </td>
                            </tr>
                        </table>
                   		</td>
                 		</tr>
               		</table>
                </td>
                <td width="70%" valign="top" style="font-size:9pt"><a href="/docs/docs/DocDsp.jsp?id=<%=docid%>" target="_blank"><%=docsubject%></a>
	                <br>
	                <br>
	                <a href="/docs/docs/DocDsp.jsp?id=<%=docid%>" target="_blank">
									<%						
									String disptmp = "";
									int tmppos = doccontent.indexOf("!@#$%^&*");
									if(tmppos!=-1)	disptmp = doccontent.substring(0,tmppos);
									out.print(disptmp);
									%>
									</a>
								</td>
			          </tr>
									<%}
                                    }
							        }finally{
										try{
											if(statement != null){
			                                	statement.close();
											}
										}catch(Exception e){}
	                                }
							      
									%>
									</table>
								</td>
							</tr>
							<tr> 
								<td colspan="4" height="1" background="images/r_title_bg2_wev8.gif"></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
	
	
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr> 
          <td width="10">&nbsp;</td>
          <td> 

            <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<%
					String isView = "" ;
					String groupName = "" ;
					String groupDoc = "" ;
					int magazineDetailId = 0 ;
					RecordSet.executeSql("select * from WebMagazineDetail where mainID = " + id +" order by id asc");
					while(RecordSet.next()){
						isView = RecordSet.getString("isView");
						groupName = RecordSet.getString("name");
						groupDoc = RecordSet.getString("docID");
						magazineDetailId = Util.getIntValue(RecordSet.getString("id"),0) ;
						if(isView.equals("1")){
				%>
				<tr> 
					<td width="4%" height="30" bgcolor="#F3FFE4">&nbsp;</td>
					<td width="58%" height="30" bgcolor="#F3FFE4" style="font-size:9pt"><b><%=groupName%></b></td>
					<td width="13%" height="30" bgcolor="#F3FFE4">&nbsp; </td>
					<td width="25%" height="30" bgcolor="#F3FFE4"> 
						<div align="center"></div>
					</td>
				</tr>
				<tr> 
					<td colspan="4" height="1" bgcolor="#63A80E"></td>
				</tr>
				<tr> 
					<td colspan="4" height="1" bgcolor="#bbbbbb"></td>
				</tr>
			  <%}


                ArrayList docIdList=new ArrayList();
                if(!"".equals(groupDoc)) docIdList=Util.TokenizerString(groupDoc,",");

                for(int k=0;k<docIdList.size();k++){
                    int docId=Util.getIntValue((String)docIdList.get(k));
					RecordSet3.executeSql("select id from docdetail where id ="+docId);
                    if(!RecordSet3.next())
                    	continue;
                    int readCount_int = 0 ;
                    
                    docsubject=dci.getDocname(""+docId);
					doclastmoddate=dci.getDocLastModDate(""+docId);
				

                    readCount_int = 0 ;
					String sql_readCount ="select sum(readCount) from docreadtag where docid =" + docId;
					RecordSet3.execute(sql_readCount);
					if(RecordSet3.next()) readCount_int = Util.getIntValue(RecordSet3.getString(1),0) ;
			  %>
				<tr> 
					<td width="4%" height="30"> 
						<div align="center"><img src="images/icon3_wev8.gif" width="6" height="9"></div>
					</td>
					<td width="58%" height="30" style="font-size:9pt"><a href="/docs/docs/DocDsp.jsp?id=<%=docId%>"  target="_blank"><%=docsubject%></a></td>
					<td width="13%" height="30" style="font-size:9pt"> 
						<div align="center"><font face="Verdana" ><%=readCount_int%></font></div>
					</td>
					<td width="25%" height="30" style="font-size:9pt"> 
						<div align="center"><font face="Verdana" ><%=doclastmoddate%></font></div>
					</td>
				</tr>
				<tr> 
					<td colspan="4" height="1" background="images/r_title_bg2_wev8.gif"></td>
				</tr>
			  <%}}%>
				<tr> 
					<td colspan="4" height="3" bgcolor="#E6E6E6"></td>
				</tr>
				<tr> 
					<td colspan="4" height="1" bgcolor="#63A80E"></td>
				</tr>
			</table>
		</td>
		<td width="5">&nbsp;</td>
	</tr>
</table>
</body>
</html>
<script language="javaScript">
function imgSet(obj) {															
	var imgWidth = obj.width;
	var imgHeight = obj.height;
	if(155*imgHeight>=115*imgWidth)
		obj.width = imgWidth*115/imgHeight;
	else if(155*imgHeight<115*imgWidth)
		obj.width = 155;
}
</script>