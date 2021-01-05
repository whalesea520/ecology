	function addNewRow(){
		$(".ListStyle").addNewRow();
	}
	
	function deleteSelectedRow(){
		$(".ListStyle").deleteSelectedRow();
	}
	function validateTable(){
		var passed=$(".ListStyle").validateTable();
		if(passed==true){
			alert("验证通过了！");
		}else{
			alert("验证没通过，表单有错误！");
		}
	}

	function addTableMax(){
		alert($("[name='tableMax']").val());
	}
	
	var plugin2={
		type:"input",
		name:"xxxinput",
		bind:[
			{type:"keyup",fn:function(){
				alert("input:值被改变了为"+this.value);
			}}
		],
		notNull:true
	};

	var plugin3={
		type:"select",
		name:"aaaselect",
		defaultValue:"bbb",
		notNull:true,
		bind:[
			{type:"change",fn:function(){
				alert("change:值被改变了为"+this.value);
			}}
		],
		options:[
		{text:"正常",value:"aaa"},
		{text:"紧急",value:"bbb"},
		{text:"一般",value:"eee"}
		]
	};
	
	var plugin5={
		type:"checkbox",
		defaultValue:"id1,id3",
		notNull:true,
		options:[
			{text:"张三",value:"id1",name:"zhangsan"},
			{text:"李四",value:"id2",name:"lisi"},
			{text:"王五",value:"id3",name:"wangwu"}
		]
	};
	
	var plugin6={
		type:"radio",
		name:"plugin6Name",
		notNull:true,
		options:[
			{text:"小学",value:"plugin6id1"},
			{text:"初中",value:"plugin6id2"}
		]
	};

	
	var pluginBrowser={
		type:"browser",
		attr:{
			name:"doclastmoduserid",
			viewType:"0",
			browserValue:"0",
			isMustInput:"1",
			browserSpanValue:"",
			hasInput:true,
			linkUrl:"javascript:openhrm($id$);",
			isSingle:true,
			completeUrl:"/data.jsp",
			browserOnClick:"onShowResource('doclastmoduseridspan','doclastmoduserid')",
			width:"90%",
			hasAdd:false,
			isSingle:false
		}
	};

