<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>

<jsp:include page="/jsp/base/base.jsp"></jsp:include>  
<link href="${ctx}/js/bootstrap/css/bootstrap-table.css" type="text/css" rel="stylesheet">
<link href="${ctx}/js/bootstrap/css/bootstrap-datetimepicker.css" type="text/css" rel="stylesheet">
<link href="${ctx}/js/bootstrap/css/bootstrap-editable.css" type="text/css" rel="stylesheet">
<script type="text/javascript" src="${ctx}/js/bootstrap/js/bootstrap-table.js"></script>
<script type="text/javascript" src="${ctx}/js/bootstrap/js/bootstrap-table-zh-CN.js"></script>
<script type="text/javascript" src="${ctx}/js/bootstrap/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="${ctx}/js/bootstrap/js/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="${ctx}/js/bootstrap/js/bootstrap-editable.js"></script>
<script type="text/javascript" src="${ctx}/js/bootstrap/js/bootstrap-table-editable.js"></script>
 
<script>
	var selectUrl = "${ctx}/jsp/aqfxdzzh/zhd/select.do"; 
	var insertUrl = "${ctx}/jsp/aqfxdzzh/zhd/insert.do";
	var updateUrl = "${ctx}/jsp/aqfxdzzh/zhd/update.do";
	var selectJddUrl = "${ctx}/jsp/aqfxdzzh/jdd/select.do?draw=1";
	var o = { action : "click", target : ".a-back", result : "" };
	var closeItem = { action : "closeItem", target : decodeURI(document.location.toString()) };
	 
	var v = {action:"menuItem", name:"列表", target: "${basePath}/jsp/zhd/zhdList.jsp"}; 

	var obj = new Object();
	obj.node = "${param.node}";
	obj.id = "${param.orderId}"; 
	var jddId = "${param.jddId}";
	obj.delflag = '1'; 
	
	$(window).ready(function() {
		
		$("#thisform")[0].reset();  
		display();
		 
		initClientTable("jddTableLayout","jddTable","id",'get',selectJddUrl,"server",false,false,jddTableColumns,[],false,true);
		$("#jddTable").bootstrapTable("refresh",{url:selectJddUrl});
		if (obj.node == "0") { //新增
			$("#thisform").attr("action", insertUrl);
			
		} else { //修改/查看
			obj.url = selectUrl; 
			ajax(obj, function(result) { // 查询业务数据
				if ("error" == result.resCode) {
					layer.msg(result.resMsg);
				} else {
					$("#thisform").fill(result.datas[0]);
					fillSelect("#thisform",result.datas[0]);
					$("#attachmentList").html(result.datas[0].attachList);  
					display();
				}
			});
			$("#thisform").attr("action", updateUrl);
		}
		 
		

		$(".action button").on("click", function() {
			try {
				obj.result = $(this).attr("result");
				if ("取消" == obj.result) {
					$("#thisform")[0].reset(); 
					return doMessage(closeItem);
				}

				$("*", $("#thisform")).attr("disabled", false); 
				var b = $("#thisform").validationEngine("validate"); 
				if (b && confirm("您确定要" + obj.result + "吗？")) { 
					ajaxSubmit("#thisform", obj, function(result) {
						if ("error" == result.resCode) {
							layer.msg(result.resMsg);
						} else {
							layer.msg("数据处理成功！", {
								time:500,
								shade : [ 0.1, "#fff" ]  
							}, function() {
								return doMessage(closeItem);
							});
						}
					});
				}
				display();
			} catch (e) {
			}
		});
		
		$("#jddModel").on("click", function() {
			$("#myModal").modal("show"); 
		});
		$("#btn_jdd_query").on("click", function() { 
			$("#jddTable").bootstrapTable("refresh",{url:selectJddUrl});
		});
		$("#btn_zhd_ok").on("click", function() {
			var selectData = $("#jddTable").bootstrapTable("getSelections");	
			if (selectData.length!=0) {
				$("#jddmc").val(selectData[0].jddgl_mc)
				$("#zhd_parent_id").val(selectData[0].id)
				$("#jdddz").val(selectData[0].jddgl_dz)
			}
			$("#myModal").modal("hide");
		});


		$("#btn-insert-1").on("click", function() {
			var target = "${basePath}/jsp/aqfxdzzh/jddInfo.jsp?node=0";
			target = encodeURI(target);
			var v = {action:"menuItem", name:"监督点信息录入", target: target};
			doMessage(v);
		});
	});
	
	 
	
	

	var display = function() {
		var node = obj.node;
		if("0"==node){//新增
			$("#thisform").attr("action", insertUrl); 
			delete obj.id;
			$("#filespan").hide()
			$("*", $("#thisform")).attr("disabled", false);   
			$("#zhd_fssj").val(formatDate(new Date()));
			// jdd 跳转
			if(""!=jddId){
				$("#jddmc").val("${param.jddmc}")
				$("#zhd_parent_id").val(jddId)
				$("#jdddz").val("${param.jdddz}")   
			}
		} else if ("1" == node) { //修改
			$("#thisform").attr("action", updateUrl); 
			$("*", $("#thisform")).attr("disabled", false);  
		}else if ("-1"==node) { //查看
			$("*", $("#thisform")).attr("disabled", true);  
			$("#thisform").attr("action", "#"); 
			$("#attachmentUploadLayout").hide();
			$(".tj").hide();
			$("*",$(".action")).attr("disabled",false); 
			obj.delflag = '0'; 
			
		}
		
	}
	
	//初始化bootstrap表格 
	function initClientTable(tableLayout, tableId, uniqueId, method, url, sidePagination, editable, search, columns, data,
		detailView, clickToSelect) {
		$("#" + tableLayout).empty();
		$("#" + tableLayout).html('<table id="' + tableId +
			'" class="table table-bordered table-hover" style="table-layout: fixed;"></table>');
		$("#" + tableId).bootstrapTable({
			id: tableId,
			url: url, //请求后台的URL（*）
			method: method, //请求方式（*）
			dataType: 'json',
			singleSelect : true,//单选
			striped: true, //是否显示行间隔色
			cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			pagination: true, //是否显示分页（*）
			height: 275,
			sortable: false, //是否启用排序
			sortOrder: "asc", //排序方式
			sidePagination: sidePagination, //分页方式：client客户端分页，server服务端分页（*）
			pageNumber: 1, //初始化加载第一页，默认第一页
			pageSize: 5, //每页的记录行数（*）
			pageList: [5, 10, 20], //可供选择的每页的行数（*）
			showColumns: false, //是否显示所有的列选项
			showRefresh: false, //是否显示刷新按钮
			minimumCountColumns: 2, //最少允许的列数
			clickToSelect: clickToSelect, //是否启用点击选中行
			uniqueId: uniqueId, //每一行的唯一标识，一般为主键列
			showToggle: false, //是否显示详细视图和列表视图的切换按钮
			cardView: false, //是否显示详细视图
			detailView: detailView, //是否显示父子表
			search: search,
			editable: editable,
			columns: columns, 
			onUncheckAll: onBootStrapTableCheckAll, 
			queryParamsType: 'limit',
			//请求服务器数据
			queryParams: queryParams,
			//构建返回数据
			responseHandler: responseHandler
		});
		if (data != null) {
			$("#" + tableId).bootstrapTable("load", data);
		}
	}
	
	//bootstrap查询参数构建
	function queryParams(params) {
		var param = {
			offset: params.offset	,
			limit: params.limit
		};
		param.keywords = $("#jdd_keywords").val();
		param.start = params.offset;
		param.length =params.limit ; 
		return param;
	}
	//bootstrap返回数据格式构建
	function responseHandler(res) {
		var datas = {
			rows: res.datas, //数据
			total: res.recordsTotal
		};
		//param.start = params.offset;
		//param.length =params.limit ;
		//param.page = (params.offset/params.limit) +1;
		//param.pagesize =params.limit ; 
		return datas;
	}	
	//bootstrap表格行选中事件
	function onBootStrapTableCheck(row, $element) {
		if (typeof(rowTableCheck) == "function") {
			rowTableCheck(row, $element, $(this));
		}
	}
	//bootstrap表格行选中事件
	function onBootStrapTableCheckAll(row) {
		if (typeof(rowTableCheck) == "function") {
			rowTableCheck(row, null, $(this));
		}
	}
	
	// 危险监督点列
	var jddTableColumns = [ 
			{
	            checkbox: true, 
	        }, {
	            field: 'id',
	            title: '隐藏列(id)',
	            visible: false,
	            formatter: function(value, row, index) {
	                return index;
	            }
	        },  {
	            field: 'jddgl_mc',
	            title: '名称 (监督点)   <i class="fa fa-search"/>', 
	            formatter: function(value, row, index) {
	            	if (typeof(value)!='undefined'&&value.length>=20) {
		           		 return  "<span type='button' title='"+value+"'>"+value.substr(0, 20 )+"....."+"</span>";
						}else{
							 return value;
						} 
	            }
	        },  {
	            field: 'jddgl_dz',
	            title: '地址  <i class="fa fa-search"/>' , 
	            formatter: function(value, row, index) {
	            	if (typeof(value)!='undefined'&&value.length>=20) {
		           		 return  "<span type='button' title='"+value+"'>"+value.substr(0, 20 )+"....."+"</span>";
						}else{
							 return value;
						} 
	            }
	            
	        }, {
	            field: 'jddgl_bh',
	            title: '统一社会信用代码  <i class="fa fa-search"/>' 
	        }, {
	            field: 'jddgl_jgbm_desc',
	            title: '监管部门   <i class="fa fa-search"/> ' 
	        } 
	    ];
</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox float-e-margins">
					<form id="thisform" class="form-horizontal" role="form" onsubmit="return false;" >
					<div class="ibox-title">
						<h5>
							<class="fa fa-file-o a-clear"></i> 详情
						</h5>
						<div class="ibox-tools">
							<a class="a-reload"> <i class="fa fa-repeat"></i> 刷新
							</a>
						</div>
					</div>
						<div class="ibox-content" > 
							<div class="form-group"  id="jddModel" >
			                  	<label class="col-sm-2 control-label">风险监督点</label>
							    <div class="col-sm-4"> 
							    	<input type="text" name="zhd_parent_id" id="zhd_parent_id"      style="display: none;">
							     	<input type="text" class="input-sm form-control validate[required]" name="jddmc" id="jddmc" maxtlenth='200' readonly="readonly" > 
							    </div>
							    <label class="col-sm-2 control-label">地址</label>
							    <div class="col-sm-4">  
							     	<input type="text" class="input-sm form-control validate[required]" name="jdddz" id="jdddz" maxtlenth='200' readonly="readonly" > 
							    </div>
							         
							 </div>	
							  
							  <div class="form-group"  >  
							  	<label class="col-sm-2 control-label">事故等级</label>
							    <div class="col-sm-4">
									<s:dict dictType="zh_jb" name="zh_jb" clazz="input-sm form-control validate[required]"></s:dict> 
							    </div>
							    
							    <label class="col-sm-2 control-label">发现人</label>
							    <div class="col-sm-4"> 
							    	<input type="text" name="zhd_fxr" id="zhd_fxr"  value="${myUser.username}" style="display: none;">
							    	<input type="text" class="input-sm form-control validate[required]" name="zhd_fxr_desc" id="zhd_fxr_desc" readonly="readonly" value="${myUser.user.user_alias}">
							     </div>
							  </div>
							   <div class="form-group"  >  
							    <label class="col-sm-2 control-label" class='publish_time'>发生时间</label>
							    <div class="col-sm-4" class='publish_time'>
							      <input type="text" class="input-sm form-control date_select  validate[required]" name="zhd_fssj" id="zhd_fssj" readonly="readonly" >
							    </div>
							    
							    <label class="col-sm-2 control-label" class='publish_time'>结束时间</label>
							    <div class="col-sm-4" class='publish_time'>
							      <input type="text" class="input-sm form-control date_select  " maxDate="0" name="zhd_jssj" id="zhd_jssj" readonly="readonly" >
							    </div>
							  </div>
			                  
							   <div class="form-group"  >
									<label class="col-sm-2 control-label">事故描述</label>
								    <div class="col-sm-10">
								   		<textarea class="form-control" name="zhd_ms" id="zhd_ms" maxlength="600"></textarea>
								    </div> 
							   </div>
							<div class="form-group"  >
								<label class="col-sm-2 control-label">处置情况</label>
								<div class="col-sm-10">
									<textarea class="form-control" name="zhd_result" id="zhd_result" maxlength="600"></textarea>
								</div>
							</div>
							    <div class="form-group desc" id="attachmentList_div">
								<label class="col-sm-2 control-label">附件列表</label>
								<div class="col-sm-10" id="filespan">
								
									<div class="col-sm-11" id="attachmentList">
									</div>
								</div>
							</div>

							<div class="form-group yc" id="attachmentUploadLayout">
								<label class="col-sm-2 control-label">附件上传 </label>
								<div class="col-sm-10">
									<input type="file" name="file" id="file" multiple />
								</div>
							</div>
					
							<div class="form-group action">
								<div class="col-sm-12" style="text-align: center">
									<button type="button" class="btn btn-sm btn-success btn-group1 tj" result="提交">
										<i class="fa fa-check"></i> 提交
									</button>
									<button type="button" class="btn btn-sm btn-warning btn-group1 qx" result="取消">
										<i class="fa fa-remove"></i> 取消
									</button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
	
	 <!-- 表格 edit start-->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" >
	    <div class="modal-dialog" style="width:70%;">
	        <div class="modal-content ibox">
                <form id="assetEditForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
           		<div class="ibox-title">
                    <h5><i class="fa fa-pencil-square-o"></i> 风险监督点数据</h5>
                </div>
		            
	            <div class="ibox-content">
	            	<div class="row clearfix">
				    	<div class="col-md-5">
							<button class="btn btn-sm btn-success" id="btn-insert-1">
								<i class="fa fa-plus"></i> 新增
							</button>
						</div>
						<div class="col-sm-7 form-inline" style="padding-right:5; text-align:right">
							<form id="queryFormAsset" class="form-horizontal key-13" role="form" onsubmit="return false;">
								<input type="text" placeholder="关键字" class="input-sm form-control validate[custom[tszf]]" id="jdd_keywords">
                                <button id="btn_jdd_query" type="button" class="btn btn-sm btn-success btn-13">
									<i class="fa fa-search"></i> 查询
								</button>
							</form>
						</div>
					</div>
					<!-- 表格 start -->
				    <div class="form-group">
					    <div class="col-sm-12" style="margin-top: 5px;margin-bottom: 5px;">
					    	<div id="jddTableLayout"></div>
					    </div>
				    </div>
                    <!-- 表格 end -->  
				</div>
				  
				<div class="modal-footer">
	                <button type="button" class="btn btn-sm btn-success btn-13" id="btn_zhd_ok">
	                	<i class="fa fa-check"></i> 确定
	                </button>
	                <button type="button" class="btn btn-sm btn-default" id="btn_zhd_cancel" data-dismiss="modal">
	                	<i class="fa fa-ban"></i> 取消
	                </button>
	            </div>
				</form>
	        </div>
	    </div>
	</div>
	<!-- 表格 edit end-->

</html>