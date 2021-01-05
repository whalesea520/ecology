/*H5数据库操作*/
var WebStorage = {}
WebStorage.webSql = function() {
	var _this = this;
    //数据库
    var _dataBase;
    //打开数据库连接或者创建数据库
    this.openDatabase = function (dbname, dbdes, dbsize, callback) {
        if (!!_dataBase) {
            return _dataBase;
        }
        _dataBase = openDatabase(dbname, "1.0", dbdes, dbsize, function () {
        	if(!!console){
        		console.log("创建数据库["+dbname+"]成功");
        	}
        	if (!_dataBase) {
	            console.log("数据库创建失败！");
	        } else {
	            console.log("数据库创建成功！");
	        }
	        if(typeof callback  == 'function'){
	        	callback();
	        }
        });
        return _dataBase;

    }
    //创建数据表
    this.createTable = function (createsql) {

        var dataBase = _this.openDatabase();
        // 创建表  "create table if not exists stu (id REAL UNIQUE, name TEXT)"
        dataBase.transaction(function (tx) {
            tx.executeSql(
        createsql,
        [],
        function () { 
        	if(!!console){
        		console.log("创建表成功");
        	}
        },
        function (tx, error) {
            if(!!console){
        		console.log("创建表失败:"+createsql);
        	}
        });
        });
    }
    //添加数据
    this.insert = function (sql,values) {
        var dataBase = _this.openDatabase();
        var id = Math.random();
        dataBase.transaction(function (tx) { 
            tx.executeSql(
	        sql,
	        values,
	        function () {
	        	if(!!console){
	        		//console.log("添加数据成功");
	        	}
	        },
	        function (tx, error) {
	            if(!!console){
	        		//console.error("添加数据失败 sql:"+sql);
	        		//console.error("error:"+error.message);
	        	}
	        });
        });

    }
    
    //删除数据
    this.del = function (sql) {
        var dataBase = _this.openDatabase();
        dataBase.transaction(function (tx) {
            tx.executeSql(
		        sql,
		        [],
		         function (tx, result) {
					//console.error("删除数据成功:"+sql);
		         },
		        function (tx, error) {
		           // console.error("删除数据失败 sql:"+sql);
	        		//console.error("error:"+error.message);
		        });
        });
    }
    
    // 查询
    this.query = function (sql,callback) {
        var dataBase = _this.openDatabase();
        dataBase.transaction(function (tx) {
            tx.executeSql(
        	sql, [],
         function (tx, result) {
         	callback(result);
         },
        function (tx, error) {
        	// alert('查询失败 sql: ' + sql);
            // alert('查询失败: ' + error.message);
        });
        });

    }

    //更新数据
    this.update = function (id, name) {

        var dataBase = _this.openDatabase();
        dataBase.transaction(function (tx) {
            tx.executeSql(
        "update stu set name = ? where id= ?",
        [name, id],
         function (tx, result) {
             _this.query();
         },
        function (tx, error) {
            // alert('更新失败: ' + error.message);
        });
        });
    }

    //删除数据表
    this.dropTable = function (sql) {
        var dataBase = _this.openDatabase();
        dataBase.transaction(function (tx) {
            tx.executeSql(sql);
        });
    }
}
var webSql=new WebStorage.webSql();
