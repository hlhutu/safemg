/**
 * 
 */
package cn.scihi.mbgl.controller;

import cn.scihi.mbgl.ucc.impl.MbglUcc;
import cn.scihi.mbgl.ucc.impl.TaskUcc;
import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.util.SysAnnotation.SysLog;
import cn.scihi.yjsj.ucc.impl.DangerTemplateTaskUcc;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.validation.constraints.NotBlank;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author yove
 *
 */
@Controller
@SysLog(module = "模板管理")
@RequestMapping(value = "/jsp/mbgl/mbgl")
public class MbglController extends BizController {

	@Resource
	private MbglUcc mbglUcc;
	@Autowired
	private TaskUcc taskUcc;
	@Resource
	private DangerTemplateTaskUcc dangerTemplateTaskUcc;

	public void init() {
		super.baseUcc = mbglUcc;
	}

	/**
	 * showdoc
	 * @catalog 南充应急/模板
	 * @title 同步模板-任务数据
	 * @description 会刷新本人最新的岗位模板
	 * @method get
	 * @url /smg/jsp/mbgl/mbgl/sync.do
	 * @param - - - -
	 * @return {}
	 * @return_param datas Integer 刷新的任务数
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = "/sync.do", method = RequestMethod.POST)
	@SysLog(module = "模板管理", method = "同步模板-任务数据")
	public String sync(HttpServletRequest request, Map<String, Object> map, @NotBlank String username) throws Exception {
		int i = taskUcc.generatorForCurrentUser();
		Map<String, Object> result = new HashMap<>();
		result.put("datas", i);
		return toJSONString(result);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/模板
	 * @title 查询我的模板数
	 * @description 包含责任清单和临时清单数
	 * @method get
	 * @url /smg/jsp/mbgl/mbgl/select/count.do
	 * @param username 是 String 任务所属人
	 * @param org_id 是 String 该用户所属机构
	 * @param role_id 是 String 该用户所属角色，多个用逗号隔开
	 * @return {}
	 * @return_param zeren Integer 责任清单数
	 * @return_param zhifa Integer 执法清单数
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = "/select/count.do", method = RequestMethod.GET)
	@SysLog(module = "模板管理", method = "查询我的模板数")
	public String count(HttpServletRequest request, Map<String, Object> map, String username, String org_id, String role_id) throws Exception {
		Map<String, Object> r = new HashMap<>();
		//查询责任清单数
		map = getParameterMap(request, false);
		map.put("status", "2");//只查询发行的
		List<Map<String, Object>> list = mbglUcc.selectMyModels(map, "1", "daiban");
		r.put("zeren", CollectionUtils.isEmpty(list)?0:list.size());
		//查询执法监察数
		r.put("zhifa", dangerTemplateTaskUcc.getCountDealt(username));
		map.put("datas", r);
		return toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/模板
	 * @title 查询我的模板
	 * @description 包含待办和全部模板
	 * @method get
	 * @url /jsp/mbgl/mbgl/select/{qdlx}/{taskStat}.do
     * @param qdlx 路径参数 String 清单类型，字典值
     * @param taskStat 路径参数 String 任务状态，daiban表示查询待办清单。all表示查询本人所有清单
	 * @param username 是 String 任务所属人
     * @param org_id 是 String 该用户所属机构
     * @param role_id 是 String 该用户所属角色，多个用逗号隔开
	 * @return {}
	 * @return_param datas List 模板列表
     * @return_param datas[0].taskDefs List 模板的任务项列表
	 * @return_param datas[0].taskDefs[0].progress String 当前任务项的进度。已完成，进行中，未开始。
	 * @return_param datas[0].taskDefs[0].taskTotal Integer 当前任务项下的所有任务
	 * @return_param datas[0].taskDefs[0].taskFinished Integer 当前任务项下已完成的任务
     * @return_param datas[0].taskDefs[0].tasks List 当前用户的任务实例列表
	 * @return_param datas[0].taskDefs[0].tasks[0].task_req String 任务要求，会议，巡检，学习等
	 * @return_param datas[0].taskDefs[0].tasks[0].req_id String 任务要求对应的id
	 * @return_param datas[0].taskDefs[0].tasks[0].req_model_id String 任务要求对应的模板id
	 * @remark
	 * @number 0
	 */
    @ResponseBody
    @RequestMapping(value = "/select/{qdlx}/{taskStat}.do", method = RequestMethod.GET)
    @SysLog(module = "模板管理", method = "查询我的模板")
    public String insert(HttpServletRequest request, Map<String, Object> map, @PathVariable String qdlx, @PathVariable String taskStat) throws Exception {
		map = getParameterMap(request, false);
		map.put("status", "2");//只查询发行的
		map.put("datas", mbglUcc.selectMyModels(map, qdlx, taskStat));
        return toJSONString(map);
    }

	/**
	 * showdoc
	 * @catalog 南充应急/模板
	 * @title 查询我的临时模板
	 * @description 包含待办和全部模板
	 * @method get
	 * @url /jsp/mbgl/mbgl/select/time.do
	 * @param username 是 String 任务所属人
	 * @return {}
	 * @return_param datas List 模板列表
	 * @return_param datas[0].taskDefs List 模板的任务项列表
	 * @return_param datas[0].taskDefs[0].progress String 当前任务项的进度。已完成，进行中，未开始。
	 * @return_param datas[0].taskDefs[0].taskTotal Integer 当前任务项下的所有任务
	 * @return_param datas[0].taskDefs[0].taskFinished Integer 当前任务项下已完成的任务
	 * @return_param datas[0].taskDefs[0].tasks List 当前用户的任务实例列表
	 * @return_param datas[0].taskDefs[0].tasks[0].task_req String 任务要求，会议，巡检，学习等
	 * @return_param datas[0].taskDefs[0].tasks[0].req_id String 任务要求对应的id
	 * @return_param datas[0].taskDefs[0].tasks[0].req_model_id String 任务要求对应的模板id
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = "/select/time.do", method = RequestMethod.GET)
	@SysLog(module = "模板管理", method = "查询临时清单")
	public String selectTimt(HttpServletRequest request, Map<String, Object> map, String username) throws Exception {
		map = getParameterMap(request, false);
		map.put("datas", mbglUcc.selectMyTimeModels(username));
		return toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/模板
	 * @title 创建模板
	 * @description 支持全新创建和从发行版本创建。从发行版本创建，新版本具有现版本的所有任务项，旧版本将会被禁用（同一系列只有最新版会被激活）。新的模板为1-未发布状态，发布过后成为2-已发布状态。
	 * @method post
	 * @url /jsp/mbgl/mbgl/insert.do
	 * @param id 否 string 如上传则表示从当前版本创建新版本，如不上传，表示创建全新模板。
	 * @return {}
	 * @return_param datas Object 返回数据
	 * @remark 注意，只能从状态为2（已发布）的模板进行创建新版本。
	 * @number 0
	 */
	public String insert(HttpServletRequest request, Map<String, Object> map) throws Exception {
		map = getParameterMap(request, false);
		if(!StringUtils.isEmpty((String) map.get("id"))){//如果已有id，则表示从现有版本创建新版本。现有版本必须是已发布的版本
			if((Integer) map.get("status")!=2){
				throw new Exception("只能从发行版本创建新版本");
			}
			mbglUcc.createFromExistVersion(map, request);
		}else{
			mbglUcc.create(map, request);
		}
		map.put("datas", mbglUcc.selectRolesByOrg(map));
		return toJSONString(map);
	}

    /**
     * showdoc
     * @catalog 南充应急/模板
     * @title 发布模板
     * @description 发布后的模板才可以自动生成任务。发布后，模板的状态将从1变为2。
     * @method post
     * @url /jsp/mbgl/mbgl/publish/{modelId}.do
     * @param modelId 路径参数 string 模板id
	 * @param ext1 否 String 临时任务传1，默认非临时任务
     * @return {}
     * @return_param datas Object 返回数据
     * @remark
     * @number 0
     */
    @ResponseBody
    @RequestMapping(value = "/publish/{modelId}.do")
    @SysLog(module = "模板管理", method = "发布模板")
	@Transactional(rollbackFor = Exception.class)
    public String publish(HttpServletRequest request, Map<String, Object> map, @PathVariable String modelId, String ext1) throws Exception {
		Map<String, Object> modelMap;
    	if(StringUtils.isEmpty(ext1)){
			modelMap = mbglUcc.publish(modelId);
			taskUcc.generatorForModel(modelMap, null, true);//立即生成该模板的任务实例，强制生成
		}else{
			mbglUcc.publish(modelId, true);
		}
        return toJSONString(map);
    }

	/**
	 * showdoc
	 * @catalog 南充应急/模板
	 * @title 禁用模板
	 * @description 状态为2的模板才可禁用
	 * @method post
	 * @url /jsp/mbgl/mbgl/disable/{modelId}.do
	 * @param modelId 路径参数 string 模板id
	 * @return {}
	 * @return_param datas Object 返回数据
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = "/disable/{modelId}.do")
	@SysLog(module = "模板管理", method = "禁用模板")
	@Transactional(rollbackFor = Exception.class)
	public String disable(HttpServletRequest request, Map<String, Object> map, @PathVariable String modelId) throws Exception {
		mbglUcc.disable(modelId);
		return toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/模板
	 * @title 启用模板
	 * @description 状态为0的模板才可启用，启用后状态是2。禁用期间错过的周期任务，不会再生成。
	 * @method post
	 * @url /jsp/mbgl/mbgl/enable/{modelId}.do
	 * @param modelId 路径参数 string 模板id
	 * @return {}
	 * @return_param datas Object 返回数据
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = "/enable/{modelId}.do")
	@SysLog(module = "模板管理", method = "启用模板")
	@Transactional(rollbackFor = Exception.class)
	public String enable(HttpServletRequest request, Map<String, Object> map, @PathVariable String modelId) throws Exception {
		mbglUcc.enable(modelId);
		return toJSONString(map);
	}

	@ResponseBody
	@RequestMapping(value = "/selectRolesByOrg.do")
	@SysLog(module = "基础服务", method = "查询机构下角色数据")
	public String selectRolesByOrg(HttpServletRequest request, Map<String, Object> map) throws Exception {
		map = getParameterMap(request, true);
		map.put("datas", mbglUcc.selectRolesByOrg(map));
		return toJSONString(map);
	}
	
	@ResponseBody
	@RequestMapping(value = "/insertMyTask.do")
	@SysLog(module = "基础服务", method = "生成我的任务实体")
	public String insertMyTask(HttpServletRequest request, Map<String, Object> map) throws Exception {
		map = getParameterMap(request, true);
		map.put("datas", mbglUcc.insertMyTask(map));
		return toJSONString(map);
	}
	
	@ResponseBody
	@RequestMapping(value = "/softDelete.do")
	@SysLog(module = "模板管理", method = "逻辑删除")
	@Transactional(rollbackFor = Exception.class)
	public String delete(HttpServletRequest request, Map<String, Object> map) throws Exception {
		try{
			map = getParameterMap(request, true);
			map.put("datas", mbglUcc.softDelete(map));
		}catch (Exception e){
			e.printStackTrace();
		}
		return toJSONString(map);
	}
	
	@ResponseBody
	@RequestMapping(value = "/delete.do")
	@SysLog(module = "模板管理", method = "物理删除")
	public String realDelete(HttpServletRequest request, Map<String, Object> map) throws Exception {
		try{
			map = getParameterMap(request, true);
			map.put("datas", mbglUcc.delete(map));
		}catch (Exception e){
			e.printStackTrace();
		}
		return toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/模板
	 * @title 将模板指派到人
	 * @description -
	 * @method post
	 * @url /jsp/mbgl/mbgl/assign.do
	 * @param modelId 是 string 模板id
	 * @param usernames 是 String 用户名，多个用逗号隔开
	 * @return {}
	 * @return_param datas Object 返回数据
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = "/assign.do")
	@SysLog(module = "模板管理", method = "指派")
	@Transactional(rollbackFor = Exception.class)
	public String assign(HttpServletRequest request, Map<String, Object> map, String modelId, @NotBlank String usernames) throws Exception {
		map.put("datas", mbglUcc.assign(modelId, Arrays.asList(usernames.split(","))));
		return toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/模板
	 * @title 查询指派记录
	 * @description -
	 * @method get
	 * @url /jsp/mbgl/mbgl/assignlog.do
	 * @param modelId 是 string 模板id
	 * @return {}
	 * @return_param datas Object 返回数据
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = "/assignlog.do")
	@SysLog(module = "模板管理", method = "指派记录")
	@Transactional(rollbackFor = Exception.class)
	public String assignlog(HttpServletRequest request, Map<String, Object> map, String modelId) throws Exception {
		map.put("datas", mbglUcc.assignlog(modelId));
		return toJSONString(map);
	}
}
