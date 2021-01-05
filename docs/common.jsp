<jsp:useBean id="sharemanager" class="weaver.share.ShareManager" scope="page"/>
<% String tables=sharemanager.getShareDetailTableByUser("doc",user);
   String tablename=sharemanager.getTableNameByUser("doc",user);
  // String tablenameo=sharemanager.getTableName("doc",outer);
  // String wheresql=sharemanager.getShareDetailWhere("doc",user);
%>