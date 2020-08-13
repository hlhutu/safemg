<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
<script>
	var selectUrl = "${ctx}/jsp/template/user/select.do";
	var deleteUrl = "${ctx}/jsp/template/user/delete.do";

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
				},
				"width":25
			}, {
				"title":"执法用户 <i class='fa fa-search'></i> ",
				"data":"lawUserAlias",
				"width":100
			}, {
				"title":"执法对象 <i class='fa fa-search'></i>",
				"data":"org_name",
				"width":100
			}, {
				"title":"模板名称 <i class='fa fa-search'></i>",
				"data":"scale_name",
				"width":350
			}, {
				"title":"预计开始时间",
				"data":"est_start_time",
				"width":150
			}, {
				"title":"开始时间",
				"data":"start_time",
				"width":150
			}, {
				"title":"结束时间",
				"data":"end_time",
				"width":150
			}, {
				"title": "状态",
				"data": "status",
				"width":150,
				"render": function (value, type, row) {
					if(value == 0){ 
						return '<span style="color:#F24141">未开始</span>';
					}
					if(value == 1){ 
						return '<span style="color:#008B00">进行中</span>';
					}
					if(value == 2){ 
						return '<span style="color:#DAA520">已完成</span>';
					}
					return value;
				}
			}, {
				"title":"操作",
				"data":"id",
				"render": function (data, type, row) {
					var str = '<a class="info" value='+data+'>执行详情</a>';
					return str;
				}
			}]
			,"drawCallback": function(s) {
				$("#checkAll_").off("click").on("click", function() {
					$("input[name='ids_'],.ids").prop("checked", $(this).prop("checked"));
				});
				//详情
				$(".info").off("click").on("click", function() {
					var target = "${basePath}/jsp/yjsj/dangerTemplateTaskOrder_link.jsp?id="+$(this).attr("value");
					var v = {action:"menuItem", name:"执行详情查看", target: target};
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
							<class="fa fa-file-o a-clear"></i> 用户执法任务列表
						</h5>
						<div class="ibox-tools">
							<a class="a-reload"> <i class="fa fa-repeat"></i> 刷新
							</a>
						</div>
					</div>

					<div class="ibox-content">
						<div class="form-horizontal clearfix">
							<div class="col-sm-6 pl0">
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