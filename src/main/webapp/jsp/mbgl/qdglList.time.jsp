<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>

<link href="${ctx}/js/plugins/ztree/css/zTreeStyle/zTreeStyle.css?v=3.5.19" rel="stylesheet">
<script src="${ctx}/js/plugins/ztree/jquery.ztree.all.min.js?v=3.5.39"></script>
<script src="${ctx}/js/plugins/ztree/jquery.ztree.exhide.min.js"></script>
<script src="${ctx}/js/plugins/ztree/fuzzysearch.js"></script>

<link href="${ctx}/js/plugins/ztree/css/zTreeStyle/zTreeStyle.css?v=3.5.19" rel="stylesheet">
<script src="${ctx}/js/plugins/ztree/jquery.ztree.all.min.js?v=3.5.39"></script>
<script src="${ctx}/js/plugins/ztree/jquery.ztree.exhide.min.js"></script>
<script src="${ctx}/js/plugins/ztree/fuzzysearch.js"></script>
<style type="text/css">
.check{
	background-color: #607089
}
.check a{
	color: #FFFFFF;
}
</style>
<script>
	var deleteUrl = "${ctx}/jsp/mbgl/mbgl/softDelete.do";
	var table, userTable, assignLogTable;

	$(window).ready(function() {
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
				"url": "${ctx}/jsp/mbgl/mbgl/select.do",
				"data": {
					ext1: "1"
					,status: "0,1,2"
					,creator: "${myUser.user.user_name}"
				},
			},
			"columns": [ {
				"orderable": false,
				"title":'<input type="checkbox" id="checkAll_" style="margin:0px;">',
				"data":"id",
				"render": function (data, type, row) {
					return '<input type="checkbox" class="ids_" name="ids_" value="'+data+'" style="margin:0px;"/>';
				}
			}, {
				"orderable": false,
				"title":"序号",
				"data":"xh"
			}, {
				"orderable": false,
				"title":"清单名称<i class='fa fa-search'></i>",
				"data":"mbmc"
			}, {
				"orderable": false,
				"title":"类型",
				"data":"qdlx"
			}, {
				"orderable": false,
				"title":"备注",
				"data":"remark"
			},{
				"orderable": false,
				"title":"操作",
				"data":"id",
				"render": function (data, type, row) {
                    var html = '<a class="info" value="'+data+'" mbmc="'+row.mbmc+'"  rwsl="'+row.rwsl+'" modelStatus="'+row.status+'">职责</a><sup>'+row.rwsl+'</sup>';
					if(row["status"]=="1"){//未发布
						html += ' <a value="'+data+'" href=\'javascript:doPublish("'+data+'")\'>发布</a>';
					}else if(row["status"]=="2"){
						html += ' <a onclick="javascript:showAssignLog($(this));">指派历史</a>';
						html += ' <a onclick="javascript:showAssignPanel($(this));">指派</a>';
					}
                    return html;
				}
			}]
			,"drawCallback": function(s) {
				$("#checkAll_").off("click").on("click", function() {
					$("input[name='ids_'],.ids").prop("checked", $(this).prop("checked"));
				});

				$(".info").off("click").on("click", function() {
					var modelStatus = $(this).attr("modelStatus");
					var id = $(this).attr("value");
					var mbmc = $(this).attr("mbmc");
					var rwsl = $(this).attr("rwsl");
					var tar = "${basePath}/jsp/mbgl/sMbglInfoList.jsp?modelStatus="+modelStatus+"&glid=" + id+"&mbmc="+encodeURI(mbmc)+"&rwsl="+rwsl+"&node=0&token=${param.token}";
					var o ={
						"action":"menuItem",
						"target":tar,
						"name":"职责详情"
					}
					doMessage(o);
				});
			}
		});

		userTable = $("#userTable").dataTable({
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
				"url": "${ctx}/staff/users.do",
				"data": {
					orgId: -1
					,roleId: -1
				},
			},
			"columns": [ {
				"orderable": false,
				"title":'<input type="checkbox" id="checkAll_userTable" style="margin:0px;">',
				"data":"username",
				"render": function (data, type, row) {
					return '<input type="checkbox" name="ids_userTable" class="ids_userTable" value="'+data+'" style="margin:0px;"/>';
				}
			}, {
				"orderable": false,
				"title":"账号",
				"data":"username"
			}, {
				"orderable": false,
				"title":"用户名",
				"data":"user_alias"
			}, {
				"orderable": false,
				"title":"手机号",
				"data":"mobile_phone"
			}]
			,"drawCallback": function(s) {
				$("#checkAll_userTable").off("click").on("click", function() {
					$("input[name='ids_userTable']").prop("checked", $(this).prop("checked"));
				});
			}
		});

		assignLogTable = $("#assignLogTable").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": false,
			"autoWidth": false,
			"processing": true,
			"serverSide": false,
			"stateSave": false,
			"ajax": {
				"dataSrc": "datas",
				"url": "${ctx}/jsp/mbgl/mbgl/assignlog.do",
				"data": {
					modelId: -1
				},
			},
			"columns": [ {
				"orderable": false,
				"title":"账号",
				"data":"username"
			}, {
				"orderable": false,
				"title":"用户名",
				"data":"user_alias"
			}, {
				"orderable": false,
				"title":"指派时间",
				"data":"created"
			}]
		});

		//$("#treeDiv,#roleDiv,#userTable").css("height", $(window).height() - 64);
		try {
			initTree();
		} catch(e) {
			console.log(e);
		}

		$("#childs").on("click", function() {
			//$("#btn-query").click();
			console.log(9527);
		});

		$(".a-load").on("click", initTree);

		$(".a-expand").bind("click", function() {
			if(zTree) {
				zTree.expandAll(true);
			}
		});

		$(".a-collapse").bind("click", function() {
			if(zTree) {
				zTree.expandAll(false);
			}
		});

		$("#org_name").on("click", function() {
			var thiz = this;
			if ($("#zTreeDiv").is(":hidden")) {
				var obj = new Object();
				obj.url = selectOrgUrl;
				obj.parent_ids = ",-1,";
				ajax(obj, function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						var objOffset = $(thiz).offset();
						var w = $(thiz).outerWidth();
						w = w < 200 ? 200 : (w > 300 ? 300 : w - 12);
						$("#zTreeDiv ul").width(w);
						$("#zTreeDiv").css({
							left : objOffset.left + "px",
							top : objOffset.top + $(thiz).outerHeight() + "px"
						}).fadeToggle("fast", function() {
							var setting = {
								data: {
									key: {name: "org_name", title: "id"},
									simpleData: {enable: true, idKey: "id", pIdKey: "parent_id"}
								},
								view: {dblClickExpand: false, fontCss: function(treeId, treeNode){
										return "0" == treeNode.row_valid ? {'font-style':'italic'} : {};
									}},
								callback: {
									beforeClick: function(treeId, treeNode) {
										$("#org_id").val(treeNode.id);
										$("#org_name").val(treeNode.org_name);
									}
								}
							};
							var zTree = $.fn.zTree.init($("#zTreeul"), setting, result.datas);
							zTree.expandNode(zTree.getNodeByTId("zTreeul_1"), true);
							$("body").bind("mousedown", function(event) {
								if (!(event.target.id == "zTreeDiv" || $(event.target).parents("#zTreeDiv").length > 0 || event.target == thiz)) {
									$("#zTreeDiv").fadeOut("fast");
									$("body").unbind("mousedown");
								}
							});
						});
					}
				});
			}
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
				obj.ifTime = true;
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
	var assignModelId;
	function showAssignPanel($this){
		var row = table.api().row($this.parents('tr')).data();
		assignModelId = row.id;
		$("#assignPanel").modal("show");
	}
	function doAssign(){
		var size = $(".ids_userTable:checkbox:checked").length;
		if(size < 1) {
			layer.msg("请选择指派人！", {icon: 0});
			return;
		}
		var ids = "";
		$(".ids_userTable:checkbox:checked").each(function(){
			ids += ids.length>0? ","+$(this).val():$(this).val();
		});
		ajax({
			url: "${ctx}/jsp/mbgl/mbgl/assign.do"
			,modelId: assignModelId
			,usernames: ids
		}, function(result) {
			$("#assignPanel").modal("hide");
		});
	}
	function showAssignLog($this){
		var row = table.api().row($this.parents('tr')).data();
		assignLogTable.api().settings()[0].ajax.data = {
			modelId: row.id
		};
		assignLogTable.api().ajax.reload();
		$("#assignLogPanel").modal("show");
	}
	function addModel(){
		$("#editForm").attr("action", "${ctx}/jsp/mbgl/mbgl/insert.do");
		var length = table.api().data().length + 1;
		$("#xh").val(length);
		$("#myModal").modal("show");
	}
	function doSave(){
		if(!$("#editForm").validationEngine("validate")) {
			return;
		}
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
	function loadUsersByOrgAndRole(orgId, roleId) {
		userTable.api().settings()[0].ajax.data = {
			orgId: orgId, roleId: roleId
		};
		userTable.api().ajax.reload();
	}
	var zTree = null, parentNode = null;
	var roleId= null;
	var selectRolesByOrgUrl = "${ctx}/jsp/mbgl/mbgl/selectRolesByOrg.do";
	var selectOrgUrl = "${ups}/admin/org/select.do?token=${myUser.user.sys.token}";
	function initTree() {
		var obj = new Object();
		obj.url = selectOrgUrl;
		obj.parent_ids = ",${myUser.user.org_id},";
		if(!obj.parent_ids) {
			return;
		}
		ajax(obj, function(result) {
			if ("error" == result.resCode) {
				layer.msg(result.resMsg, {icon: 2});
			} else {
				var setting = {
					data: {
						key: { name: "org_name", title: "id"},
						simpleData: { enable: true, idKey: "id", pIdKey: "parent_id"}
					},
					view: {dblClickExpand: false, fontCss: function(treeId, treeNode){
							return "0" == treeNode.row_valid ? {'font-style':'italic'} : {};
						}},
					callback: {
						beforeClick: function(treeId, treeNode) {
							parentNode = treeNode;
							//TODO
							selectRolesByOrg(parentNode.id);
							//$("#btn-query").click();
						}
					}
				};
				zTree = $.fn.zTree.init($("#zTree"), setting, result.datas);
				zTree.expandNode(zTree.getNodeByTId("zTree_1"), true);
				fuzzySearch("zTree", "#key", false, false);
			}
		});
	}
	function selectRolesByOrg(org_id){
		var obj = new Object();
		obj.url = selectRolesByOrgUrl;
		obj.org_id = org_id;
		obj.role_type="2";//表示岗位
		ajax(obj, function(result) {
			if ("error" == result.resCode) {
				layer.msg(result.resMsg, {icon: 2});
			} else {
				$("#gwList").html("");
				userTable.api().settings()[0].ajax.data = {
					orgId: -1, roleId: -1
				};
				userTable.api().ajax.reload();
				var datas=result.datas;
				if(!datas||datas.length==0){
					roleId=null;
					$("#gwList").append('<li class="list-group-item">无数据</li> ');
					$("#btn-query").click();
					return;
				}
				$.each(datas,function(i,o){
					$("#gwList").append('<li class="list-group-item gw" data-id="'+o.role_id+'" onclick="loadUsersByOrgAndRole(\''+org_id+'\', \''+o.role_id+'\')"><a>'+o.role_name+'</a></li>');
				})
				$("#gwList li:first").click();

			}
		});
	}
	function doPublish(modelId){
		layer.confirm('确定发布清单？', {icon: 3, title:'提示'}, function(index){
			ajax({
				url: "${ctx}/jsp/mbgl/mbgl/publish/"+modelId+".do"
				,ext1: 1
			},function(data){
				if("success"!=data["resCode"]){
					layer.msg(data["resMsg"], {icon:0});
				}else{
					layer.msg(data["resMsg"], {icon:1});
					table.api().ajax.reload();
				}
			});
			layer.close(index);
		});
	}

</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
		<div class="col-sm-12" style="padding-left: 5px;">
			<div class="ibox float-e-margins">
				<div class="ibox-title">
					<h5>
						<i class="fa fa-list a-clear"></i> 临时任务列表
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
							<button class="btn btn-sm btn-success" id="btn-insert" onclick="addModel();">
								<i class="fa fa-plus"></i> 新增临时任务
							</button>
							<%--<s:access url="${ctx}/jsp/mbgl/mbgl/update.do">
								<button class="btn btn-sm btn-success" id="btn-update">
									<i class="fa fa-edit"></i> 修改
								</button>
							</s:access>--%>
							<s:access url="${ctx}/jsp/mbgl/mbgl/delete.do">
								<button class="btn btn-sm btn-success" id="btn-delete">
									<i class="fa fa-trash-o"></i> 删除
								</button>
							</s:access>
						</div>

						<div class="col-sm-6 form-inline" style="padding-right: 0; text-align: right">
							<form id="queryForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
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
	                  	<input type="text" id="row_version" name="row_version" style="display: none;"> 
	                  	<input type="text" name="org_id" id="org_id" style="display: none;">
	                  	<input type="text" name="role_id" id="role_id" style="display: none;">
	                  	<div class="form-group">
							<input type="text" class="input-sm form-control validate[required]" name="qdlx" id="qdlx" value="临时任务" style="display: none;"/>
							<input type="text" class="input-sm form-control validate[required]" name="ext1" id="ext1" value="1" style="display: none;"/>
							<label class="col-sm-2 control-label">清单名称</label>
							<div class="col-sm-4">
								<input type="text" class="input-sm form-control validate[required]" name="mbmc" id="mbmc" >
							</div>
							<label class="col-sm-2 control-label">序号</label>
							<div class="col-sm-4">
								<input type="number" class="input-sm form-control validate[required]" name="xh" id="xh" >
							</div>
					  </div>
					  <div class="form-group">
					    <label class="col-sm-2 control-label">备注</label>
					    <div class="col-sm-10">
					      <textarea class="form-control" name="remark" id="remark" ></textarea>
					    </div>
					  </div>
                  	</div>
		            
		            <div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success btn-13 btn-ok" onclick="doSave();">
		                	<i class="fa fa-save"></i> 保存
		                </button>
		                <button type="button" class="btn btn-sm btn-default btn-cancel" data-dismiss="modal">
		                	<i class="fa fa-ban"></i> 取消
		                </button>
		            </div>
				</form>
	        </div>
	    </div>
	</div>
	<!-- edit end-->

	<!-- edit start-->
	<div class="modal fade" id="assignPanel" tabindex="-1" role="dialog" >
		<div class="modal-dialog" style="width:70%;">
			<div class="modal-content ibox">
				<form id="" class="form-horizontal key-13" role="form" onsubmit="return false;">
					<div class="ibox-title">
						<h5><i class="fa fa-pencil-square-o"></i> 指派任务</h5>
					</div>
					<div class="ibox-title">
						<div class="col-sm-3" style="padding-right: 0;">
							<div class="ibox float-e-margins">
								<div class="ibox-title">
									<h5><i class="fa fa-sitemap"></i> 机构</h5>
									<div class="ibox-tools">
										<a class="a-load" title="刷新"><i class="fa fa-repeat"></i></a>
									</div>
								</div>
								<div class="ibox-content" id="treeDiv" style="overflow:auto; padding:15px 5px;">
									<input type="text" class="input-sm form-control" id="key" placeholder="关键字">
									<ul id="zTree" class="ztree"></ul>
								</div>
							</div>
						</div>

						<div class="col-sm-2" style="padding-left: 5px;padding-right: 0;">
							<div class="ibox float-e-margins">
								<div class="ibox-title">
									<h5>
										<i class="fa fa-users"></i> 岗位
									</h5>
								</div>
								<div class="ibox-content" id="roleDiv" style="overflow: auto;">
									<div class="form-horizontal clearfix">
										<ul class="list-group" id="gwList">
											<li class="list-group-item">无数据</li>
										</ul>
									</div>
								</div>
							</div>
						</div>
						<div class="col-sm-7" style="padding-left: 5px;">
							<div class="ibox float-e-margins">
								<div class="ibox-title">
									<h5>
										<i class="fa fa-list a-clear"></i> 人员列表
									</h5>
									<div class="ibox-tools">
										<a class="a-reload">
											<i class="fa fa-repeat"></i> 刷新
										</a>
									</div>
								</div>
								<div class="ibox-content">
									<table id="userTable" class="table display" style="width: 100%"></table>
								</div>
							</div>
						</div>
					</div>
					<div class="ibox-content" ></div>
					<div class="modal-footer">
						<button type="button" class="btn btn-sm btn-success btn-13" onclick="doAssign()">
							<i class="fa fa-check"></i> 指派
						</button>
						<button type="button" class="btn btn-sm btn-default btn-cancel" data-dismiss="modal">
							<i class="fa fa-ban"></i> 取消
						</button>
					</div>
				</form>
			</div>

		</div>
	</div>
	<!-- edit end-->

	<!-- edit start-->
	<div class="modal fade" id="assignLogPanel" tabindex="-1" role="dialog" >
		<div class="modal-dialog" style="width:70%;">
			<div class="modal-content ibox">
				<form id="" class="form-horizontal key-13" role="form" onsubmit="return false;">
					<div class="ibox-title">
						<h5><i class="fa fa-pencil-square-o"></i> 指派历史</h5>
						<div class="ibox-tools">
							<a class="close-link" data-dismiss="modal">
								<i class="fa fa-times"></i>
							</a>
						</div>
					</div>

					<div class="ibox-content">
						<table id="assignLogTable" class="table display" style="width: 100%"></table>
					</div>

					<div class="modal-footer">
						<%--<button type="button" class="btn btn-sm btn-success btn-13 btn-ok" onclick="doSave();">
							<i class="fa fa-save"></i> 保存
						</button>--%>
						<button type="button" class="btn btn-sm btn-default btn-cancel" data-dismiss="modal">
							<i class="fa fa-ban"></i> 取消
						</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<!-- edit end-->
	
	<div id="zTreeDiv" style="display: none; position: absolute; z-index: 9999">
		<ul id="zTreeul" class="ztree"></ul>
	</div>
</body>
<style type="text/css">
#zTreeDiv > ul {
	width: 200px;
	height: 300px;
	border: 1px solid #ccc;
	background: #f3f3f3;
	overflow: auto;
}
</style>
</html>