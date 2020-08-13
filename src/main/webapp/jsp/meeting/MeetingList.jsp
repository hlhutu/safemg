<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
<script>
	var selectUrl = "${ctx}/meeting/selectForBean.do";
	var insertUrl = "${ctx}/meeting/insert.do";
	var updateUrl = "${ctx}/meeting/update.do";
	//var deleteUrl = "${ctx}/meeting/delete.do";
	var table, memberTable;
	$(window).ready(function() {
		var dtParam = {
			"keywords": $("#keywords").val()
		};
		$("#datas").wrapAll("<div style='overflow-x:auto'>");
		table = $("#datas").dataTable({
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
					return '<input type="checkbox" class="ids_" name="ids_" value="'+data+'" style="margin:0px;"/>';
				}
			}, {
				"orderable": false,
				"title": "状态",
				"data": "status",
				"render": function (data, type, row) {
					if("RUNNING"==data){
						return "<span style='color: #008B00;'>进行中，开始于 "+row.real_start+"</span>";
					}else if("FINISHED"==data){
						return "<span style='color: #8B0000'>结束于 "+row.real_end+"</span>";
					}else if("CREATED"==data){
						return "<span style='color: #DAA520;'>未开始"+(row.expected_start?"，计划于 "+row.expected_start+" 开始":"")+"</span>";
					}else{
						return data;
					}
				}
			},{
				"orderable": false,
				"title": "主持人",
				"data": "user_alias",
			},{
				"orderable": false,
				"title": "主持人手机号",
				"data": "mobile_phone",
			},{
				"orderable": false,
				"title": "会议主题",
				"data": "title",
			},{
				/*"orderable": false,
				"title": "会议分类",
				"data": "category",
			},{*/
				"orderable": false,
				"title": "创建时间",
				"data": "created",
			}, {
				"orderable": false,
				"title":"操作",
				"render": function (data, type, row) {
					return '<a class="info">详情</a>' +
							' <a class="member">参会人员<sup>'+(row.users&&row.users.length>0?""+row.users.length+"":"0")+'</sup></a>';
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

				$(".member").off("click").on("click", function () {
					var r = table.api().row($(this).parents('tr')).data();
					//memberTable.api().ajax.url("${ctx}/meeting/"+r.id+"/members.do").reload();
					memberTable.api().settings()[0].ajax.url = "${ctx}/meeting/"+r.id+"/members.do";
					memberTable.api().ajax.reload();
					$("#memberModel").modal("show");
				});
			}
		});

		memberTable = $("#memberTable").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": true,
			"autoWidth": false,
			"processing": true,
			"serverSide": false,
			"stateSave": false,
			"ajax": {
				"dataSrc": "datas",
				"url": "${ctx}/meeting/1/members.do",
				"data": dtParam,
			},
			"order": [],
			"columns": [{
				"orderable": false,
				"title": "账号",
				"data": "user_name"
			},{
				"orderable": false,
				"title": "昵称",
				"data": "user_alias",
			},{
				"orderable": false,
				"title": "参会状态",
				"data": "status",
				"render": function (data, type, row) {
					if(row.sort_no>=20){
						return "<span style='color: #8B0000'>"+data+"</span>";
					}else if(row.sort_no!=0){
						return "<span style='color: #DAA520'>"+data+"</span>";
					}else{
						return "<span style='color: #008B00'>"+data+"</span>";
					}
				}
			},{
				"orderable": false,
				"title": "签到时间",
				"data": "sign_date"
			}]
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
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else if(result.datas && result.datas.length == 1) {
					$("#editForm").fill(result.datas[0]);
					fillSelect("#editForm",result.datas[0]);
					if(result.datas[0].status!="CREATED"){//如果状态不是未开始，则禁止修改
						$("*", $("#editForm")).attr("disabled", true);
					}
				} else {
					layer.msg("未找到相关数据！", {icon: 7});
				}
			});
       	});
          
		$("#btn-delete").on("click", function() {
			var size = $(".ids_:checkbox:checked").length;
			if(size != 1) {
				layer.msg("请选择需要删除的一行数据！", {icon: 0});
				return;
			}
			layer.confirm("您确定要删除数据吗？", {icon: 3}, function() {
				var ids = [];
				$(".ids_:checkbox:checked").each(function(index, o) {
					ids.push($(this).val());
				});
				var obj = new Object();
				obj.id = ids.join(",");
				obj.url = "${ctx}/meeting/delete/"+obj.id+".do";
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
function showMember($this){
	var data = memberTable.api().row($this.parents('tr')).data();
	console.log(data.users);
	$("#memberModel").modal("show");
}
</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>
							<i class="fa fa-file-o"></i> 会议
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
								<s:access url="/meeting/insert.do">
									<%--<button class="btn btn-sm btn-success" id="btn-insert">
										<i class="fa fa-plus"></i> 新增
									</button>--%>
								</s:access>
								<s:access url="/meeting/update.do">
									<%--<button class="btn btn-sm btn-success" id="btn-update">
										<i class="fa fa-edit"></i> 修改
									</button>--%>
								</s:access>
								<s:access url="/meeting/delete.do">
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
						<input type="text" class="input-sm form-control" name="id" id="id" style="display: none;">
						<div class="form-group">
							<label class="col-sm-2 control-label">会议主题</label>
							<div class="col-sm-4">
								<input type="text" class="input-sm form-control" name="title" id="title">
							</div>
							<label class="col-sm-2 control-label">会议分类</label>
							<div class="col-sm-4">
								<input type="text" class="input-sm form-control" name="category" id="category">
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">状态</label>
							<div class="col-sm-4">
								<input type="text" class="input-sm form-control" name="status" id="status">
							</div>
							<label class="col-sm-2 control-label">计划开始时间</label>
							<div class="col-sm-4">
								<input type="text" class="input-sm form-control" name="expect_start" id="expect_start">
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">主持人</label>
							<div class="col-sm-4">
								<input type="text" class="input-sm form-control" name="username" id="username" style="display: none;">
								<input type="text" class="input-sm form-control" name="user_alias" id="user_alias">
							</div>
							<label class="col-sm-2 control-label">主持人手机号</label>
							<div class="col-sm-4">
								<input type="text" class="input-sm form-control" name="mobile_phone" id="mobile_phone">
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">简介</label>
							<div class="col-sm-10">
								<textarea type="text" class="input-sm form-control" name="description" id="description"></textarea>
							</div>
						</div>
						<%--<div class="form-group">
							<label class="col-sm-2 control-label">附件</label>
							<div class="col-sm-10">
								<input type="file" class="input-sm form-control" name="meeting_file"/>
							</div>
						</div>--%>
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
	<div class="modal fade" id="memberModel" tabindex="-1" role="dialog" >
		<div class="modal-dialog" style="width:70%;">
			<div class="modal-content ibox">
				<form id="editForm2" class="form-horizontal key-13" role="form" onsubmit="return false;">
					<div class="ibox-title">
						<h5><i class="fa fa-pencil-square-o"></i> 参会人员</h5>
						<div class="ibox-tools">
							<a class="close-link" data-dismiss="modal">
								<i class="fa fa-times"></i>
							</a>
						</div>
					</div>
					<table id="memberTable" class="table display" style="width: 100%"></table>
					<div class="modal-footer">
						<button type="button" class="btn btn-sm btn-success btn-13" data-dismiss="modal">
							<i class="fa fa-check"></i> 确定
						</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</body>
</html>