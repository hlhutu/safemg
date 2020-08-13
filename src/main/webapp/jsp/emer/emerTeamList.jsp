<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
<script>
	var selectUrl = "${ctx}/emerTeam/select.do";
	var insertUrl = "${ctx}/emerTeam/insert.do";
	var updateUrl = "${ctx}/emerTeam/update.do";
	var deleteUrl = "${ctx}/emerTeam/delete.do";

	$(window).ready(function() {
		var dtParam = {
			"keywords": $("#keywords").val()
		};
		$("#datas").wrapAll("<div style='overflow-x:auto'>");
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
			"order": [],
			"columns": [ {
				"orderable": false,
				"title":'<input type="checkbox" id="checkAll_" style="margin:0px;">',
				"data":"id",
				"render": function (data, type, row) {
					var s = '<input type="checkbox" ';
					if("1" == row.row_default) {
						s = s + 'disabled="disabled" '; 
					} else {
						s = s + 'class="ids_" name="ids_" value="'+data+'" '; 
					}
					return s +'style="margin:0px;"/>';
				}
			},
			{
				"orderable": false,
				"title": "队伍名称",
				"data": "team_name"
			},
			{
				"orderable": false,
				"title": "队伍编号",
				"data": "team_no"
			},
			{
				"orderable": false,
				"title": "队伍类型",
				"data": "category"
			},
			{
				"orderable": false,
				"title": "队伍地址",
				"data": "address"
			},
			{
				"orderable": false,
				"title": "所属机构",
				"data": "org_name"
			},
			{
				"orderable": false,
				"title": "联系人",
				"data": "link_user"
			},
			{
				"orderable": false,
				"title": "联系电话",
				"data": "link_phone"
			},
			{
				"orderable": false,
				"title":"操作",
				"render": function (data, type, row) {
					return '<a class="info">详情</a>';
				}
			}]
			,"drawCallback": function(s) {
				$("#checkAll_").off("click").on("click", function() {
					$("input[name='ids_'],.ids").prop("checked", $(this).prop("checked"));
				});
				
				$(".info").off("click").on("click", function () {
					var r = table.api().row($(this).parents('tr')).data();
					$("input[type='checkbox']").prop("checked", false);
					$(".ids_[value='"+r.id+"']").prop("checked", true);
				});
			}
		});

		$("#btn-query").on("click", function() {
			var b = $("#selectForm").validationEngine("validate");
			if(b) {
				dtParam.keywords = $("#keywords").val();
				table.api().settings()[0].ajax.data = dtParam;
				table.api().ajax.reload();
			}
		});
		
		$("#editForm .btn-13").on("click", function() {
			var b = $("#editForm").validationEngine("validate");
			if(b) {
				ajaxSubmit("#editForm", function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						table.api().ajax.reload(null, false);
						$("#myModal").modal("hide");
					}
				});
			}
		});
		
		$("#btn-insert").on("click", function() {
			$("*", $("#editForm")).attr("disabled", false);
			$("#attachmentList").html('');
			$("#editForm").attr("action", insertUrl);
			$("#myModal").modal("show");
		});
		
		$("body").on("click", "#btn-update, .info" , function() {
			$("*", $("#editForm")).attr("disabled", false);
			if("详情" ==  $(this).html()) {
				$("*", $("#editForm")).attr("disabled", true);
			}
			var size = $(".ids_:checkbox:checked").length;
			if(size != 1) {
				layer.msg("请选择需要修改的一行数据！", {icon: 0});
				return;
			}
			$("#editForm").attr("action", updateUrl);
			$("#myModal").modal("show");
			
			var obj = new Object();
			obj.url = selectUrl;
			obj.id = $(".ids_:checkbox:checked").val();
			obj.delflag = "详情" ==  $(this).html()?"0":"1";
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else if(result.datas && result.datas.length == 1) {
					$("#editForm").fill(result.datas[0]);
					fillSelect("#editForm",result.datas[0]);
					$("#attachmentList").html(result.datas[0].attachList);
				} else {
					layer.msg("未找到相关数据！", {icon: 7});
				}
			});
		});
		
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
							<i class="fa fa-file-o a-clear"></i> 应急-队伍
						</h5>
						<div class="ibox-tools">
							<a class="a-reload">
								<i class="fa fa-repeat"></i> 刷新
							</a>
						</div>
					</div>
					
					<div class="ibox-content">
						<!-- search start -->
						<div class="form-horizontal clearfix">
							<div class="col-sm-6 pl0">
								<s:access url="${basePath}/biz/emerTeam/insert.do">
									<button class="btn btn-sm btn-success" id="btn-insert">
										<i class="fa fa-plus"></i> 新增
									</button>
								</s:access>
								<s:access url="${basePath}/biz/emerTeam/update.do">
									<button class="btn btn-sm btn-success" id="btn-update">
										<i class="fa fa-edit"></i> 修改
									</button>
								</s:access>
								<s:access url="${basePath}/biz/emerTeam/delete.do">
									<button class="btn btn-sm btn-success" id="btn-delete">
										<i class="fa fa-trash-o"></i> 删除
									</button>
								</s:access>
							</div>
							
							<div class="col-sm-6 form-inline" style="padding-right: 0; text-align: right">
								<form id="selectForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
									<input type="text" placeholder="关键字" class="input-sm form-control validate[custom[tszf]]" id="keywords">
									<button id="btn-query" type="button" class="btn btn-sm btn-success btn-13">
										<i class="fa fa-search"></i> 查询
									</button>
								</form>
							</div>
						</div>
						<!-- search end -->
						
						<table id="datas" class="table display" style="width: 100%"></table>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- edit start-->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" >
		<div class="modal-dialog" style="width:70%;">
			<div class="modal-content ibox">
				<form id="editForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
					<div class="ibox-title">
						<h5><i class="fa fa-pencil-square-o"></i> 编辑数据</h5>
						<div class="ibox-tools">
							<a class="close-link" data-dismiss="modal">
								<i class="fa fa-times"></i>
							</a>
						</div>
					</div>
					
					<div class="ibox-content">
						<input type="text" id="id" name="id" style="display:none"/>
						<input type="text" id="row_version" name="row_version" style="display:none"/>
						<div class="form-group">
							<label class="col-sm-2 control-label">队伍名称</label>
							<div class="col-sm-10">
								<input type="text" class="input-sm form-control validate[required]" name="team_name" id="team_name">
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">队伍编号</label>
							<div class="col-sm-4">
								<input type="text" class="input-sm form-control" name="team_no" id="team_no">
							</div>
							<label class="col-sm-2 control-label">队伍类型</label>
							<div class="col-sm-4">
								<input type="text" class="input-sm form-control" name="category" id="category">
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">队伍地址</label>
							<div class="col-sm-4">
								<input type="text" class="input-sm form-control" name="address" id="address">
							</div>
							<label class="col-sm-2 control-label">所属机构</label>
							<div class="col-sm-4">
								<s:select beanName="sdkUcc" mothodName="queryOrg" name="org_id" k="org_name" v='id'  clazz="selectpicker form-control" />
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">联系人</label>
							<div class="col-sm-4">
								<input type="text" class="input-sm form-control" name="link_user" id="link_user">
							</div>
							<label class="col-sm-2 control-label">联系电话</label>
							<div class="col-sm-4">
								<input type="text" class="input-sm form-control" name="link_phone" id="link_phone">
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">简介</label>
							<div class="col-sm-10">
								<textarea class="input-sm form-control" name="description" id="description" rows="3"></textarea>
							</div>
						</div>
						<div class="form-group desc">
							<label class="col-sm-2 control-label">附件</label>
							<div class="col-sm-10">
								<div class="col-sm-11" id="attachmentList">
								</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label"></label>
							<div class="col-sm-10">
								<input type="file" name="file" id="file" multiple />
							</div>
						</div>
					</div>
					
					<div class="modal-footer">
						<button type="button" class="btn btn-sm btn-success btn-13">
							<i class="fa fa-check"></i> 确定
						</button>
						<button type="button" class="btn btn-sm btn-default" data-dismiss="modal">
							<i class="fa fa-ban"></i> 取消
						</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<!-- edit end-->
</body>
</html>
