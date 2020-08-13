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
	var selectUrl = "${ctx}/jsp/mbgl/mbgl/select.do";
	var insertUrl = "${ctx}/jsp/mbgl/mbgl/insert.do";
	var updateUrl = "${ctx}/jsp/mbgl/mbgl/update.do";
	var deleteUrl = "${ctx}/jsp/mbgl/mbgl/softDelete.do";
	
	var selectRolesByOrgUrl = "${ctx}/jsp/mbgl/mbgl/selectRolesByOrg.do";
	
	var selectOrgUrl = "${ups}/admin/org/select.do?token=${myUser.user.sys.token}";
	
	var zTree = null, parentNode = null;
	var roleId= null;
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
				var datas=result.datas;
				if(!datas||datas.length==0){
					roleId=null;
					$("#gwList").append('<li class="list-group-item">无数据</li> ');
					$("#btn-query").click();
					return;
				}
				$.each(datas,function(i,o){
					$("#gwList").append('<li class="list-group-item gw"  data-id="'+o.role_id+'"><a>'+o.role_name+'</a></li>');
				})
				$("#gwList li:first").click();
				
			}
		});
	}
	
	$(window).resize(function() {
		$("#treeDiv,#roleDiv").css("height", $(window).height() - 64);
	});
	
	$(window).ready(function() {
		var dtParam = {
				"org_id": ("-1"||"------"),
				"role_id": "",
				"status":1,
				"keywords": $("#keywords").val()
			};
		
		$("body").on("click",".gw",function(){
			$(".list-group-item").removeClass("check");
			$(this).addClass("check");
			roleId = $(this).data("id");
			$("#btn-query").click();
			//dtParam.role_id= $(this).data("id")
		})
		
		$("#treeDiv,#roleDiv").css("height", $(window).height() - 64);
		try {
			initTree();
		} catch(e) {}
		
		
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
			"order": [[1, "asc"]],
			"columnDefs": [{
				"targets": [0,2,3,7,8,9],
				"orderable" : false
			}],
			"columns": [ {
				"title":'<input type="checkbox" id="checkAll_" style="margin:0px;">',
				"data":"id",
				"render": function (data, type, row) {
					return '<input type="checkbox" class="ids_" name="ids_" value="'+data+'" style="margin:0px;"/>';
				}
			}, {
				"title":"序号",
				"data":"xh"
			}, {
				"title":"清单名称<i class='fa fa-search'></i>",
				"data":"mbmc"
			}, {
				"title":"类型",
				"data":"qdlx_desc"
				
			}, {
				"title":"生效时间",
				"data":"start_date"
			}, {
				"title":"失效时间",
				"data":"end_date"
			}, {
				"title":"修改时间 ",
				"data":"modified",
				"render": function (data, type, row) {
					return '<span title="'+row.modifierDesc+'">'+data+'</span>';
				}
			}, {
				"title":"状态",
				"data":"status",
				"render": function (data, type, row) {
					if("0" == data) {
						return '<span style="color:#FF0000">禁用</span>';
					}
					return '有效';
				}
			}, {
				"title":"操作",
				"data":"id",
				"render": function (data, type, row) {
					return '<a class="info" value="'+data+'" mbmc="'+row.mbmc+'"  rwsl="'+row.rwsl+'">职责</a><sup>'+row.rwsl+'</sup>';
					//return str += ' <a class="user_" role_id="'+data+'" role_name="'+row.role_name+'">成员</a><sup>'+(row.users||0)+'</sup>'
				}
			}]
			,"drawCallback": function(s) {
				$("#checkAll_").off("click").on("click", function() {
					$("input[name='ids_'],.ids").prop("checked", $(this).prop("checked"));
				});
				
				$(".info").off("click").on("click", function() {
					var id = $(this).attr("value");
					var mbmc = $(this).attr("mbmc");
					var rwsl = $(this).attr("rwsl");
					var tar = "${basePath}/jsp/mbgl/mbglInfo.jsp?glid=" + id+"&mbmc="+mbmc+"&rwsl="+rwsl+"&node=0&token=${param.token}";
					var o ={
							"action":"menuItem",
							"target":tar,
							"name":"职责详情"
							}
					doMessage(o);
		       	});
			}
		});

		$("#btn-query").on("click", function() {
			var b = $("#selectForm").validationEngine("validate");
			if(b) {
				if($("#childs").prop("checked")) {
					dtParam.org_id = "";
					dtParam.parent_ids = parentNode ? parentNode.parent_ids : (",-1,"||"------");
				} else {
					dtParam.parent_ids = "";
					dtParam.org_id = parentNode ? parentNode.id : ("-1"||"------");
				}
				dtParam.role_id = roleId;
				dtParam.keywords = $("#keywords").val();
				table.api().settings()[0].ajax.data = dtParam;
				table.api().ajax.reload();
			}
       	});
		$("#btn-insert").on("click", function() {
			/* layer.msg("功能建设中！", {icon: 4});
			return; */
			$("#id").val('');
			if(!parentNode) {
				layer.msg("请选择所属机构！", {icon: 0});
				return;
			}
			
			if(!roleId) {
				layer.msg("请选择所属岗位！", {icon: 0});
				return;
			}
			
			$("*", $("#editForm")).attr("disabled", false);
			$("#editForm").attr("action", insertUrl);
			$("#btn-save").addClass("hide");
			$("#myModal").modal("show");
			
			$("#org_id").val(parentNode.id);
			$("#role_id").val(roleId);
       	});
		
		$("body").on("click", "#btn-update" , function() {
			$("#org_id").val(parentNode.id);
			$("#role_id").val(roleId);
			
			$("#btn-save").removeClass("hide");
			
			$("*", $("#editForm")).attr("disabled", false);
			if("职责" ==  $(this).html()) {
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
				} else {
					layer.msg("未找到相关数据，请刷新页面！", {icon: 7});
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
		
		$(".btn-ok").on("click", function() {
			var b = $("#editForm").validationEngine("validate");
			if($(this).attr('id')=='btn-publish'){
				$("#editForm").attr("action", insertUrl);//发布新版本
			}else{
				$("#editForm").attr("action", updateUrl);//修改当前版本
			}
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

		
		$("#childs").on("click", function() {
			$("#btn-query").click();
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
	});
	
	// 清单列
	
</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
		<div class="row">
			<div class="col-sm-3" style="padding-right: 0;">
                <div class="ibox float-e-margins">
                	<div class="ibox-title">
	                    <h5><i class="fa fa-sitemap"></i> 机构</h5>
	                    <div class="ibox-tools">
	                    	<!-- <a><label><input type="checkbox" id="childs" style="vertical-align:-2px;"> All</label></a>
	                       	<a class="a-expand" title="展开"><i class="fa fa-plus-square-o"></i></a>
	                       	<a class="a-collapse" title="折叠"><i class="fa fa-minus-square-o"></i></a> -->
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
						<!-- <div class="ibox-tools">
							<a class="a-reload">
								<i class="fa fa-repeat"></i>
							</a>
						</div> -->
				</div>
            </div>
            
			<div class="col-sm-7" style="padding-left: 5px;">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>
							<i class="fa fa-list a-clear"></i> 清单列表
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
									<button class="btn btn-sm btn-success" id="btn-insert">
										<i class="fa fa-plus"></i> 新增
									</button>
								<s:access url="${ctx}/jsp/mbgl/mbgl/update.do">
									<button class="btn btn-sm btn-success" id="btn-update">
										<i class="fa fa-edit"></i> 修改
									</button>
								</s:access>
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
					    <label class="col-sm-2 control-label">清单名称</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" name="mbmc" id="mbmc" >
					    </div>
					    <label class="col-sm-2 control-label">清单类型</label>
					    <div class="col-sm-4">
					      <s:dict dictType="qdlx" name="qdlx" clazz="input-sm form-control validate[required]"></s:dict>
					    </div>
					  </div>
					  
					  <div class="form-group">
					   <label class="col-sm-2 control-label">序号</label>
					    <div class="col-sm-4">
					      <input type="number" class="input-sm form-control validate[required]" name="xh" id="xh" >
					    </div>
					  	<label class="col-sm-2 control-label">有效状态</label>
					    <div class="col-sm-4">
					      <label><input type="radio" name="status" value="1" checked="checked">有效</label>
					      <label><input type="radio" name="status" value="0">禁用</label>
					    </div>
					  </div>
					  
					  <div class="form-group">
					  	<label class="col-sm-2 control-label">生效时间</label>
					  	 <div class="col-sm-4">
					  		<input type="text" class="input-sm form-control date_select validate[required]" name="start_date" id="start_date" readonly="readonly" format="yyyy-MM-dd">
				  		</div>
					  	<label class="col-sm-2 control-label">失效时间</label>
					  	 <div class="col-sm-4">
					  		<input type="text" class="input-sm form-control date_select validate[required]" name="end_date" id="end_date"  maxDate='1' readonly="readonly" format="yyyy-MM-dd">
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
		                <button type="button" class="btn btn-sm btn-success btn-13 btn-ok hide" id="btn-save">
		                	<i class="fa fa-save"></i> 保存
		                </button>
		                <button type="button" class="btn btn-sm btn-success btn-13 btn-ok" id="btn-publish">
		                	<i class="fa fa-send-o"></i> 发布
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