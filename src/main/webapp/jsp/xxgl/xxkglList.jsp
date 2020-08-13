<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
<script>
	var selectUrl = "${ctx}/jsp/xxkgl/select.do";
	var deleteUrl = "${ctx}/jsp/xxkgl/delete.do";

	$(window).ready(function() {
		var userName_="${myUser.user.user_name}";
		var dtParam = {
			"keywords": $("#keywords").val()
		};
		var table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": true,
			"autoWidth": false,
			"processing": true,
			"serverSide": true,
			"stateSave": false,
			"ajax": {
				"dataSrc": "datas",
				"url": selectUrl,
				"data": dtParam,
			},
			"order": [[3, "desc"]],
			"columnDefs": [{
				"targets": [0,4,5],
				"orderable" : false
			}],
			"columns": [ {
				"title":'<input type="checkbox" id="checkAll_" style="margin:0px;">',
				"data":"id",
				"render": function (data, type, row) {
					return '<input type="checkbox" class="ids_" name="ids_" value="'+data+'" style="margin:0px;"/>';
				}
			},{
				"title":"资料标题  <i class='fa fa-search'></i>",
				"data":"xxkgl_title",
				"render": function (data, type, row) {
					if (typeof(data)!='undefined'&&data.length>=20) {
	           			return  "<span type='button' title='"+data+"'>"+data.substr(0, 20 )+"....."+"</span>";
					}else{
						return data;
					}
				}
			}, {
				"title":"资料来源 <i class='fa fa-search'></i>",
				"data":"xxkgl_sources"
			}, {
				"title":"内容简介 <i class='fa fa-search'></i>",
				"data":"xxkgl_notes"
			}, {
				"title":"创建时间",
				"data":"created",
				"width":150
			}, {
				"title":"操作",
				"data":"id",
				"render": function (data, type, row) {
					var str = '<a class="info" value='+data+'>详情</a>';
					str += '&emsp;<a class="xxjl_info" value='+data+'>学习记录</a>';
					str += '&emsp;<a class="xxrw_rw" value='+data+'>学习任务</a>';
					return str;
				}
			}]
			,"drawCallback": function(s) {
				$("#checkAll_").off("click").on("click", function() {
					$("input[name='ids_'],.ids").prop("checked", $(this).prop("checked"));
				});
				//详情
				$(".info").off("click").on("click", function() {
					var target = "${basePath}/jsp/xxgl/xxkglInfo.jsp?node=-1&orderId="+$(this).attr("value");
					var v = {action:"menuItem", name:"学习库信息查看", target: target};
					doMessage(v);
		       	});
				//学习记录
				$(".xxjl_info").off("click").on("click", function() {
					var target = "${basePath}/jsp/xxgl/xxjlglList_link.jsp?xxkId="+$(this).attr("value");
					var v = {action:"menuItem", name:"学习记录查看", target: target};
					doMessage(v);
		       	});
				//学习任务
				$(".xxrw_rw").off("click").on("click", function() {
					var target = "${basePath}/jsp/xxgl/xxrwglList_link.jsp?req_model_id="+$(this).attr("value");
					var v = {action:"menuItem", name:"学习任务查看", target: target};
					doMessage(v);
		       	});
			}
		});
		//查询
		$("#btn-query").on("click", function() {
			var b = $("#queryForm").validationEngine("validate");
			if(b) {
				dtParam.keywords = $("#keywords").val();
				table.api().settings()[0].ajax.data = dtParam;
				table.api().ajax.reload();
			}
       	});
		//新增
		$("#btn-insert").on("click", function() {
			var target = "${basePath}/jsp/xxgl/xxkglInfo.jsp?node=0&orderId="+$(this).attr("value");
			var v = {action:"menuItem", name:"学习库信息新增", target: target};
			doMessage(v);
       	});
		//修改
		$("body").on("click", "#btn-update" , function() {
			var ids = [];
			$(".ids_:checkbox:checked").each(function(index, o) {
				ids.push($(this).val());
			});
			if(ids.length != 1) {
				layer.msg("请选择需要修改的一条数据！", {icon: 0});
				return;
			}
			
			var target = "${basePath}/jsp/xxgl/xxkglInfo.jsp?node=1&orderId="+ids[0];
			var v = {action:"menuItem", name:"学习库信息修改", target: target};
			doMessage(v);
       	});
        //删除
		$("#btn-delete").on("click", function() {
			var size = $(".ids_:checkbox:checked").length;
			if(size < 1) {
				layer.msg("请选择需要删除的数据！", {icon: 0});
				return;
			}
			
			layer.confirm("您确定要删除数据吗？", {icon: 3}, function() {
				var ids = [];
				$(".ids_:checkbox:checked").each(function(index, o) {
					ids.push($(this).val());
				});
				var obj = new Object();
				obj.url = deleteUrl;
				obj.id = ids.join(",");
				ajax(obj, function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						table.api().ajax.reload(null, false);
					}
				});
			});
		});
	});
</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>
							<class="fa fa-file-o a-clear"></i> 学习库列表
						</h5>
						<div class="ibox-tools">
							<a class="a-reload"> <i class="fa fa-repeat"></i> 刷新
							</a>
						</div>
					</div>

					<div class="ibox-content">
						<div class="form-horizontal clearfix">
							<div class="col-sm-6 pl0">
								<button class="btn btn-sm btn-success" id="btn-insert">
									<i class="fa fa-plus"></i> 新增
								</button>
							
								<button class="btn btn-sm btn-success" id="btn-update">
									<i class="fa fa-edit"></i> 修改
								</button>
							
								<button class="btn btn-sm btn-success" id="btn-delete">
									<i class="fa fa-trash-o"></i> 删除
								</button>
							</div>

							<div class="col-sm-6 form-inline" style="padding-right: 0; text-align: right">
								<form id="selectForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
									<input type="text" placeholder="关键字" class="input-sm form-control validate[custom[tszf]]" id="keywords" value="">
									<button id="btn-query" type="button" class="btn btn-sm btn-success btn-13">
										<i class="fa fa-search"></i> 查询
									</button>
								</form>
							</div>
						</div>

						<table id="datas" class="table display" style="width: 100%"></table>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>