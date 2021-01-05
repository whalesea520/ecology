
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

   <script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
   <link rel="stylesheet" href="../css/WeaverEditTable_wev8.css">
    <script  src="../js/WeaverEditTable_wev8.js"></script>

<body style="margin: 0;padding: 0">
      <!--组一-->
       <div class="groupmain" style="width:100%"></div>
       <script>

           var subid=1;
           
		   var rowindex=0;

           var items=[
           {width:"10%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(84107,user.getLanguage()) %>",itemhtml:"<input type=\"text\" name='descinfo' style='width: 50px'><span class='mustinput'></span>"},
           {width:"15%",colname:"<%=SystemEnv.getHtmlLabelName(33510,user.getLanguage()) %>",itemhtml:"<button type='button' class='calendar' style='height: 16px;' id='SelectDate' onclick='getDate(createdatefromspan,createdatefrom)'></button><span  name='from'  class='weadate'></span><input type='hidden'  name='from' >"},
           {width:"15%",colname:"<%=SystemEnv.getHtmlLabelName(15456,user.getLanguage()) %>",itemhtml:"<input type='text' name='datalabel'>"},
           {width:"40%",colname:"<%=SystemEnv.getHtmlLabelName(84113,user.getLanguage()) %>",itemhtml:"<select name='datatype' style='width: 200px;height: 26px;display: none'><option value='0'><%=SystemEnv.getHtmlLabelName(688,user.getLanguage()) %></option><option value='1'><%=SystemEnv.getHtmlLabelName(32306,user.getLanguage()) %></option></select>" +
                   "<span style='vertical-align: middle'><%=SystemEnv.getHtmlLabelName(84115,user.getLanguage()) %>:</span><input name='datalength' type='text' style='width: 100px;vertical-align: middle' ><span class='mustinput'></span>" +
                   "<span style='vertical-align: middle'><%=SystemEnv.getHtmlLabelName(63,user.getLanguage()) %>:</span><select name='ctype' style='width: 100px'><option value='0'>文本</option><option value='1'>数据</option></select><input type='file'>"},
           {width:"15%",tdclass:"desclassone",colname:"<%=SystemEnv.getHtmlLabelName(84042,user.getLanguage()) %>",itemhtml:"<span class='browser' completeurl='/data.jsp' browserurl='/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp' isMustInput='1' name='dataorder' browservalue='3,7'  browserspanvalue='校招,啊啊' isSingle='false'></span>"}];

           var option= {
                         navcolor:"#003399",
                         basictitle:"<%=SystemEnv.getHtmlLabelName(84120,user.getLanguage()) %>",
                         toolbarshow:true,
                         colItems:items,
					     openindex:true,
                         addrowCallBack:function(tr) {
                           //  var descinfo=tr.find("input[name='descinfo']");
							// var newname="descinfo_"+subid+"_"+rowindex;
                          //   descinfo.attr("name",newname);
                           //  rowindex++;
                            // alert("回调函数!!!");
                         },
                        configCheckBox:true,
					    container:".groupmain",
                        checkBoxItem:{"itemhtml":'<input class="groupselectbox" type="checkbox" >',width:"5%"}
                       };

           var group=new WeaverEditTable(option);
           $(".groupmain").append(group.getContainer());
           var params=group.getTableSeriaData();
           //console.log(params);


		   var entry=  [
                 {name:"descinfo",value:"张三",iseditable:true,type:"input"}, 
                 {name:"from",value:"2012-12-12",iseditable:false,type:"date"},
                 {name:"datalabel",value:"字段显示名1",iseditable:true,type:"input"},
                 {name:"datatype",value:"0",iseditable:true,type:"select"},
                 {name:"datalength",value:"1",iseditable:true,type:"input"},
                 {name:"ctype",value:"1",iseditable:true,type:"select"},
                 {name:"dataorder",value:"3,7",label:"UBSS001 徐烨,UBSS063孟安琪",iseditable:true,type:"browser"}
                        ];

            group.addRow(entry);
           

       </script>

      <input type="button" value="<%=SystemEnv.getHtmlLabelName(84123,user.getLanguage()) %>" class="getSeriedata">

      <script>
           $(".getSeriedata").click(function(){

               console.dir(group.getSimpleTableJson());

           });

      </script>


      <!--组二-->
      <div class="subgroupmain" style="width: 100%"></div>
      <script>
          items=[
              {width:"10%",colname:"<%=SystemEnv.getHtmlLabelName(84107,user.getLanguage()) %>",itemhtml:"<input type='text'  style='width: 50px'>"},
              {width:"15%",colname:"<%=SystemEnv.getHtmlLabelName(33510,user.getLanguage()) %>",itemhtml:"<input type='text'>"},
              {width:"15%",colname:"<%=SystemEnv.getHtmlLabelName(15456,user.getLanguage()) %>",itemhtml:"<input type='text'>"},
              {width:"40%",colname:"<%=SystemEnv.getHtmlLabelName(84113,user.getLanguage()) %>",itemhtml:"<select style='width: 200px;height: 26px'><option><%=SystemEnv.getHtmlLabelName(688,user.getLanguage()) %></option><option><%=SystemEnv.getHtmlLabelName(32306,user.getLanguage()) %></option></select>" +
                      ""},
              {width:"15%",colname:"<%=SystemEnv.getHtmlLabelName(84042,user.getLanguage()) %>",itemhtml:"<input type='text'>"}];
          var option= {navcolor:"#00cc00",basictitle:"<%=SystemEnv.getHtmlLabelName(84125,user.getLanguage()) %>",toolbarshow:true,colItems:items};
          var group1=new WeaverEditTable(option);
          $(".subgroupmain").append(group1.getContainer());
      </script>

</body>