<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<style type="text/css">
.w-e-text-container{
    height: 300px !important; 
</style>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
<script>
	var selectUrl = "${ctx}/jsp/xxrwgl/select.do";

	var obj = new Object();
	if("${param.req_model_id}"!="undefined" && "${param.req_model_id}"!=undefined){
		obj.req_model_id = "${param.req_model_id}";
	}
	
	$(window).ready(function() {
		obj.url = selectUrl; 
		ajax(obj, function(result) { // 查询业务数据
			if ("error" == result.resCode) {
				layer.msg(result.resMsg);
			} else {
				//表格填充
				$("#xxrw_table").bootstrapTable("load",result.datas);
			}
		});
		//初始化表格框
		var params = {
			columns: [
				{
					field: "id",
					title: "ID",
					visible: false
				},{
					field: "user_name",
					title: "用户名"
				},{
					field: "creator_alias",
					title: "用户昵称"
				},{
					field: "created",
					title: "记录时间"
				},{
					field: "status",
					title: "状态",
					formatter: function(value, row, index){
						if(value == 0){ //已完成
							return '<span style="color:#008B00">已完成</span>';
						}
						if(value == 1){ //进行中
							return '<span style="color:#DAA520">进行中</span>';
						}
						return value;
					}
				},{
					field: "xxrw_endtime",
					title: "结束时间"
				}
			]
		}
		initBootStrapTable($("#xxrw_table"),params);
	});

	//初始化bootstrap表格
	function initBootStrapTable(tableObj, params) {
		var autoHeight;
		try{
			autoHeight = document.body.offsetHeight-$(".basicnav")[0].offsetHeight-$(".basicserch")[0].offsetHeight-15;
		}catch(ex){}
		tableObj.bootstrapTable({
			id: tableObj.attr("id"),
			url: params.url ? params.url : "", //请求后台的URL（*）
			method: params.method ? params.method : "get", //请求方式（*）
			dataType: 'json', //数据类型
			undefinedText: '-', //空数据显示
			striped: params.striped ? params.striped : true, //是否显示行间隔色
			cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			pagination: true,
			// width: params.width ? params.width : "auto", //是否显示分页（*）
			height: params.height ? params.height : autoHeight, //表格固定高度
			sortable: params.sortable ? params.sortable : false, //是否启用排序
			sortName: params.sortName ? params.sortName : null, //排序字段
			sortOrder: params.sortOrder ? params.sortOrder : "asc", //排序方式
			sidePagination: params.sidePagination ? params.sidePagination : "client", //分页方式：client客户端分页，server服务端分页（*）
			pageNumber: 1, //初始化加载第一页，默认第一页
			pageSize: params.pageSize ? params.pageSize : 5, //每页的记录行数（*）
			pageList: params.pageList ? params.pageList : [5, 10, 20], //可供选择的每页的行数（*）
			showColumns: false, //是否显示所有的列选项
			showRefresh: params.showRefresh ? params.showRefresh : false, //是否显示刷新按钮
			minimumCountColumns: 2, //最少允许的列数
			clickToSelect: params.clickToSelect ? params.clickToSelect : false, //是否启用点击选中行
			uniqueId: params.uniqueId ? params.uniqueId : "id", //每一行的唯一标识，一般为主键列
			showToggle: false, //是否显示详细视图和列表视图的切换按钮
			cardView: false, //是否显示详细视图
			detailView: params.detailView ? params.detailView : false, //是否显示父子表
			search: params.search ? params.search : false, //是否显示自带的搜索框,服务端分页方式一般不用
			columns: params.columns ? params.columns : [] //表格列定义
		});
	}
</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox float-e-margins">
					<form id="thisform" class="form-horizontal" role="form" onsubmit="return false;">
						<div class="ibox-title">
							<h5>
								<class="fa fa-file-o a-clear"></i> 学习任务列表
							</h5>
							<div class="ibox-tools">
								<a class="a-reload"> <i class="fa fa-repeat"></i> 刷新
								</a>
							</div>
						</div>
						<div class="ibox-content"> 
							  <div class="form-group" id="list_file_div">
							    <div class="col-sm-12">
							      <table id="xxrw_table" class="table" style="width: 100%"></table>
							    </div>
							  </div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>