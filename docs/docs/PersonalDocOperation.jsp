
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="FileManage" class="weaver.file.FileManage" scope="page" />
<jsp:useBean id="DocUserSelfUtil" class="weaver.docs.docs.DocUserSelfUtil" scope="page" />
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page"/>

<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%

char flag = 2;
String Proc=""; 

int userid = user.getUID();
int userCategory= Util.getIntValue(request.getParameter("userCategory"),0);
int docId= Util.getIntValue(request.getParameter("docId"),0);

String folder_name = Util.fromScreen(request.getParameter("folder_name"),user.getLanguage());
int parentid= Util.getIntValue(request.getParameter("parentid"),0);
String parentids = Util.fromScreen(request.getParameter("parentids"),user.getLanguage());
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());

String[] selectFiles = request.getParameterValues("selectfile");
String[] selectFolders = request.getParameterValues("selectfolder");

if (operation.equals("docRename")){
	String sqltmp = "update docdetail set docsubject='"+Util.fromScreen2(folder_name,user.getLanguage())+"' where id = "+docId;
	RecordSet.executeSql(sqltmp);

	response.sendRedirect("PersonalDocRight.jsp?haspost=1&userCategory="+userCategory);	
} else if (operation.equals("folderRename")){
	String sqltmp = "update DocUserselfCategory set name='"+Util.fromScreen2(folder_name,user.getLanguage())+"' where id = "+userCategory;
	RecordSet.executeSql(sqltmp);
%>
     <script language="javascript">
       window.parent.pdocLeft.location.reload()
       window.location="PersonalDocRight.jsp?haspost=1&userCategory=<%=DocUserSelfUtil.getParentid(""+userCategory)%>";
   </script>

	
<%} else if (operation.equals("fileMoveOut")) {
    int secId= Util.getIntValue(request.getParameter("txtMoveTo"),0);
    int subId = Util.getIntValue(SecCategoryComInfo.getSubCategoryid(""+secId),-1);
    int mainId = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+subId),-1);

    if (subId!=-1 && mainId!=-1 ) {
        String strSql = "update docdetail set seccategory="+secId+",subcategory="+subId+",maincategory="+mainId+" where id="+docId;
        RecordSet.executeSql(strSql);
        
        // add cache
        DocManager.setSeccategory(secId);
        DocManager.setId(docId);
        DocManager.AddShareInfo() ;
        
        //add share
        DocViewer.setDocShareByDoc(""+docId);

        //rmove doc from userself catalog
        strSql = "delete DocUserselfDocs where docid="+docId;
        RecordSet.executeSql(strSql);       
    }
    response.sendRedirect("PersonalDocRight.jsp?userCategory="+userCategory);
  } else if (operation.equals("delete")){   
    int tempFile = 0;
    int tempFolder = 0;
    if (selectFiles != null){
        for(int i=0;i<selectFiles.length;i++){
           tempFile = Util.getIntValue(selectFiles[i],0);
           DocUserSelfUtil.deletePDoc(tempFile) ;       
        }
    }
    if (selectFolders != null){
        for(int i=0;i<selectFolders.length;i++){            
            tempFolder = Util.getIntValue(selectFolders[i],0);            
            if (tempFolder!=0){
                DocUserSelfUtil.deletePFolder(tempFolder);
            }
        }
    }%>
   <script language="javascript">
       window.parent.pdocLeft.location.reload()
       window.location="PersonalDocRight.jsp?userCategory=<%=userCategory%>";
   </script>
<%} else if (operation.equals("addfolder")){
    Date newdate = new Date() ;
    long datetime = newdate.getTime() ;
    Timestamp timestamp = new Timestamp(datetime) ;
    String createdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
    String formattime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16)+":"+(timestamp.toString()).substring(17,19);

    Proc=""+userid+flag+folder_name+flag+userCategory+flag+parentids+","+userCategory+flag+createdate+flag+formattime;
    RecordSet.executeProc("DocUserselfCategory_Insert",Proc);
    
    int newcate = 0;
    if(RecordSet.next())
        newcate = RecordSet.getInt(1);
    
    DocViewer.setPDocShareByDoc("-"+newcate);
  
   	%>
       <script language="javascript">
           window.parent.pdocLeft.location.reload()
           window.location="PersonalDocRight.jsp?haspost=1&userCategory=<%=userCategory%>";
       </script>
<%} else if (operation.equals("sharefiles")){   
          
    int safeLevel =  Util.getIntValue(request.getParameter("safeLevel"),0); 
    int itemnum = Util.getIntValue(request.getParameter("itemnum"),0);

	String docid = Util.null2String(request.getParameter("docId"));
	String foldid = "-"+Util.null2String(request.getParameter("foldId"));
    String tempDocId = ("").equals(docid)?foldid:docid;

	String sharetype= Util.null2String(request.getParameter("sharetype"));
    for (int i=0;i<itemnum;i++){
        String shareid = Util.null2String(request.getParameter("shareid_"+i));
        String sharelevel = Util.null2String(request.getParameter("share_"+i));	
            
        if (("0").equals(sharelevel)||("").equals(sharelevel)) continue;

        String shareuserid = "0" ;
        String departmentid = "0" ;
        String subcompanyid="0";
        String roleid = "0" ;
        String foralluser = "0" ;
        String seclevel = "0" ;
        String rolelevel = "0";

       
        if(sharetype.equals("1")) shareuserid = shareid ;
        if(sharetype.equals("2")) subcompanyid = shareid ;
        if(sharetype.equals("3")) departmentid = shareid ;
        if(sharetype.equals("4")) roleid = shareid ;
        if(sharetype.equals("5")) {
            foralluser = "1" ; 
            seclevel=""+safeLevel;
        }

        DocUserSelfUtil.addShare(tempDocId,sharetype,seclevel,rolelevel,sharelevel,shareuserid,subcompanyid,departmentid,roleid,foralluser);
        //RecordSet.executeProc("DocShare_IFromDocSecCategory",Proc);
    }   
    if (foldid.indexOf("-")!=-1) foldid = foldid.substring(1);
    response.sendRedirect("PersonalDocShare.jsp?docId="+docid+"&userCategory="+foldid);
   
} else if (operation.equals("shareDelete")){
    String docId1 = Util.null2String(request.getParameter("docId"));
	String foldId = Util.null2String(request.getParameter("userCategory"));
    String id = Util.null2String(request.getParameter("id"));
    DocUserSelfUtil.deleteShare(id);
    response.sendRedirect("PersonalDocShare.jsp?docId="+docId1+"&userCategory="+foldId);	    
} else if (operation.equals("movedoc")){
	String docids = Util.fromScreen(request.getParameter("docids"),user.getLanguage());
	String foldids = Util.fromScreen(request.getParameter("foldids"),user.getLanguage());
	ArrayList doclists = Util.TokenizerString(docids,",");
	ArrayList foldlists = Util.TokenizerString(foldids,",");	
	
	
	int tocategory = Util.getIntValue(request.getParameter("tocategory"),-1);
	String toparentids = DocUserSelfUtil.getParentids(""+tocategory)+","+tocategory;
	ArrayList toparentidsarray = Util.TokenizerString(toparentids,",");	
	
	for(int j=0;j<foldlists.size();j++){		
		if(toparentidsarray.indexOf(""+foldlists.get(j))!=-1){
			response.sendRedirect("PersonalDocMove.jsp?haspost=1&msg=1&docids="+docids+"&foldids="+foldids);	
			return;
		}
	}
	
	if(tocategory!=-1){
		for(int j=0;j<doclists.size();j++){
			int docid = Util.getIntValue(""+doclists.get(j),0);
			if(docid==0)
				continue;
			String sqlupdate = "update docuserselfdocs set userCatalogId = "+tocategory+" where docid = "+docid;
			RecordSet.executeSql(sqlupdate);
			//共享信息。。。
			
			String sqltmp = " select * from DocShare where docid = "+((-1)*tocategory);
			RecordSet.executeSql(sqltmp);
			while(RecordSet.next()){
				Proc = ""+docid;
				Proc += flag+RecordSet.getString("sharetype");
				Proc += flag+RecordSet.getString("seclevel");
				Proc += flag+RecordSet.getString("rolelevel");
				Proc += flag+RecordSet.getString("sharelevel");
				Proc += flag+RecordSet.getString("userid");
				Proc += flag+RecordSet.getString("subcompanyid");
				Proc += flag+RecordSet.getString("departmentid");
				Proc += flag+RecordSet.getString("roleid");
				Proc += flag+RecordSet.getString("foralluser");
				Proc += flag+"0" ;           
				
				rs.executeProc("DocShare_IFromDocSecCategory",Proc);
			}
			DocViewer.setDocShareByDoc(""+docid);			
		}
		
		
		for(int j=0;j<foldlists.size();j++){
			int foldid = Util.getIntValue(""+foldlists.get(j),0);			
			if(foldid==0)
				continue;
			String oldparentids = DocUserSelfUtil.getParentids(""+foldid);
			String newparentids = DocUserSelfUtil.getParentids(""+tocategory)+","+tocategory;
			
			String sqlupdate = "update docuserselfcategory set parentid = "+tocategory+",parentids='"+ newparentids+"' where id = "+foldid;
			RecordSet.executeSql(sqlupdate);			
			
			//下属子目录的parentids也要相应变化。。。
			sqlupdate = "update docuserselfcategory set parentids='"+ newparentids+"'+','+'"+foldid+"'+SUBSTRING(parentids,LEN('"+oldparentids+"'+','+'"+foldid+"')+1,LEN(parentids)) where parentids like '"+oldparentids+","+foldid+"%'";
			RecordSet.executeSql(sqlupdate);
			
			//共享信息。。。
				
			ArrayList tmpfoldids = new ArrayList();
			String tmpsqlfolders =  " select id FROM DocUserselfCategory WHERE id="+foldid+" or (parentids + ',' LIKE '%,"+foldid+",%')";
			//out.print(tmpsqlfolders);
			rs1.executeSql(tmpsqlfolders);
			while(rs1.next()){
				int tmpfoldid = rs1.getInt("id");
				
				if(tmpfoldids.indexOf(""+tmpfoldid)!=-1)
					continue;
				tmpfoldids.add(""+tmpfoldid);
				
				String sqltmp = " select * from DocShare where docid = "+((-1)*tocategory);
				//out.print(sqltmp);
				RecordSet.executeSql(sqltmp);
				while(RecordSet.next()){
					String tmpsharetype = RecordSet.getString("sharetype");
					String tmpseclevel = RecordSet.getString("seclevel");
					String tmprolelevel = RecordSet.getString("rolelevel");
					String tmpsharelevel = RecordSet.getString("sharelevel");
					String tmpuserid = RecordSet.getString("userid");
					String tmpsubcompanyid = RecordSet.getString("subcompanyid");
					String tmpdepartmentid = RecordSet.getString("departmentid");
					String tmproleid = RecordSet.getString("roleid");
					String tmpforalluser = RecordSet.getString("foralluser");
				
					Proc = ""+((-1)*tmpfoldid);
					Proc += flag+tmpsharetype;
					Proc += flag+tmpseclevel;
					Proc += flag+tmprolelevel;
					Proc += flag+tmpsharelevel;
					Proc += flag+tmpuserid;
					Proc += flag+tmpsubcompanyid;
					Proc += flag+tmpdepartmentid;
					Proc += flag+tmproleid;
					Proc += flag+tmpforalluser;
					Proc += flag+"0" ;           
					
					rs.executeProc("DocShare_IFromDocSecCategory",Proc);
					
					sqltmp = "  SELECT docid FROM DocUserselfDocs WHERE (userCatalogId = "+tmpfoldid+" )";
					//out.print(sqltmp);
					rs.executeSql(sqltmp);
					while(rs.next()){
						int docid = Util.getIntValue(""+rs.getString("docid"),0);
					
						if(docid==0)
							continue;
							
						Proc = ""+docid;
						Proc += flag+tmpsharetype;
						Proc += flag+tmpseclevel;
						Proc += flag+tmprolelevel;
						Proc += flag+tmpsharelevel;
						Proc += flag+tmpuserid;
						Proc += flag+tmpsubcompanyid;
						Proc += flag+tmpdepartmentid;
						Proc += flag+tmproleid;
						Proc += flag+tmpforalluser;
						Proc += flag+"0" ;              //  crmid 
					
						RecordSet1.executeProc("DocShare_IFromDocSecCategory",Proc);
						
						DocViewer.setDocShareByDoc(""+docid);
					}
				}
			}			
		}
	}
				
	response.sendRedirect("PersonalDocMove.jsp?haspost=1");		
}
%>
