package cn.scihi.mbgl.ucc.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;

import cn.scihi.sdk.core.MyApiUtils;
import org.apache.log4j.LogManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import com.alibaba.fastjson.JSONObject;

import cn.scihi.mbgl.bean.Cycle;
import cn.scihi.mbgl.service.impl.CycleService;
import cn.scihi.mbgl.service.impl.MbglInfoService;
import cn.scihi.mbgl.service.impl.MbglService;
import cn.scihi.mbgl.service.impl.TaskInstanceService;
import cn.scihi.mbgl.service.impl.TaskService;
import cn.scihi.sdk.base.ucc.SdkUcc;
import cn.scihi.sdk.base.ucc.UccAdapter;
import cn.scihi.xjgl.service.impl.XjglService;
import cn.scihi.xxgl.service.impl.XxkglService;
import cn.scihi.xxgl.service.impl.XxrwglService;

/**
 * @author 岳开
 *
 */
@Service
public class TaskUcc extends UccAdapter {
	org.apache.log4j.Logger log = LogManager.getLogger(this.getClass());
	@Autowired
	private TaskService taskService;
	@Autowired
	private MbglService mbglService;
	@Autowired
	private MbglInfoService mbglInfoService;
	@Autowired
	private SdkUcc sdkUcc;
	@Autowired
	private CycleService cycleService;
	@Autowired
	private TaskInstanceService taskInstanceService;
	@Autowired
	private XjglService xjglService;
	@Autowired
	private XxrwglService xxrwglService;
	@Value("${app.sys_id}")
	private String SYS_ID;

	public void init() {
		super.baseService = taskService;
	}

	public int insertRealtions(Map<String, Object> map, HttpServletRequest request) throws Exception {
		List<Map> realtionList = JSONObject.parseArray((String) map.get("realtionList"), Map.class);
		int res = 0;
		if (null != realtionList && realtionList.size() != 0) {
			for (Map dtlObject : realtionList) {
				res += taskService.insert(dtlObject);
			}
		}
		return res;
	}

	public Integer generatorForCurrentUser() throws Exception {
		//查询所有启用的模板，
		List<Map<String, Object>> models = mbglService.getExecutableModelsForCurrentUser();
		log.info("生成任务，扫描到"+(models==null?0:models.size())+"个可执行模板");
		Map<String, Object> param = new HashMap<>();
		String username = MyApiUtils.getUser("user_name");
		param.put("zxr", username);
		int i = 0;
		for (Map<String, Object> model : models) {
			param.put("mbid", model.get("id"));
			List<Map<String, Object>> list = taskService.select(param);
			if(CollectionUtils.isEmpty(list)){//没有任务则进行生成
				this.generatorForModel(model, username, false);
				i++;
			}
		}
		return i;
	}

	/**
	 * 生成任务for所有
	 */
    public void generatorForAll() throws Exception {
    	//查询所有启用的模板
		List<Map<String, Object>> models = mbglService.getExecutableModels();
		log.info("生成任务，扫描到"+(models==null?0:models.size())+"个可执行模板");
		if(CollectionUtils.isEmpty(models)){
			return;
		}
		for (Map<String, Object> model : models) {
			this.generatorForModel(model, null, false);//不需要强制生成
		}
    }

	/**
	 * 生成任务for指定模板
	 */
	public void generatorForModel(Map<String, Object> model, String username, boolean bool) throws Exception {
		List<Map<String, Object>> taskDefs = mbglInfoService.getTaskDefsByModelId((String) model.get("id"));
		if(CollectionUtils.isEmpty(taskDefs)){
			return;
		}
		for (Map<String, Object> taskDef : taskDefs) {
			this.generatorForTaskDef(model, taskDef, username, bool);
		}
	}

	/**
	 * 生成任务for指定任务项目
	 */
	public void generatorForTaskDef(Map<String, Object> model, Map<String, Object> taskDef, String username, boolean bool) throws Exception {
		String token = MyApiUtils.token(SYS_ID, "admin");
		Map<String, Object> param = new HashMap<>();
		if(username!=null){
			param.put("user_name", username);
		}else{
			param.put("org_id", model.get("orgid"));
			param.put("role_id", model.get("roleid"));
			param.put("setRole", "left");
			param.put("token", token);
		}
		List<Map<String, Object>> users = sdkUcc.queryUser(param);
		if(CollectionUtils.isEmpty(users)){//没有用户
			return;
		}
		Integer repeat_ = (Integer) taskDef.get("repeat_");//周期内任务重复次数
		Map<String, Cycle> cycleMap = this.getCycleUserMap((String) taskDef.get("id"), users);//查询所有用户已经执行过的周期记录
		Cycle myCycle;
		for (Map<String, Object> user : users) {
			myCycle = cycleMap.get(user.get("user_name"));//当前人的周期记录
			if(cycleService.overVersion(myCycle, taskDef, (String) user.get("user_name"), bool)){//如果需要生成（即上个周期已经完了），则生成任务
				int i=0;
				do{
					i++;
					Map<String, Object> newTask = new HashMap<>();
					newTask.put("sys_id", model.get("sys_id"));
					newTask.put("mbid", model.get("id"));
					newTask.put("infoid", taskDef.get("id"));
					newTask.put("zxr", user.get("user_name"));
					newTask.put("zxjg", null);
					newTask.put("remark", null);
					newTask.put("status", 1);
					newTask.put("created", new Date());
					//关联具体任务项
					String task_req = (String) taskDef.get("task_req");
					newTask.put("task_req", task_req);
					String req_model_id = (String) taskDef.get("req_model_id");
					String req_id = null;
					if("学习".equals(task_req)){
						Map<String, Object> xxInstance = xxrwglService.newInstance(req_model_id, (String) user.get("user_name"), token);
						newTask.put("status", xxInstance.get("realStatus"));//获取真实的状态
						newTask.put("req_model_id", req_model_id);
						newTask.put("req_id", xxInstance.get("id"));
					}
					taskService.insert(newTask);
				}while (i<repeat_);
			}
		}
	}

	private Map<String, Cycle> getCycleUserMap(String taskDefId, List<Map<String, Object>> users) {
		List<String> usernames = new ArrayList<>(users.size());
		for (Map<String, Object> user : users) {
			usernames.add((String) user.get("user_name"));
		}
		List<Cycle> cycleList = cycleService.getCycleList(taskDefId, usernames);//查询任务定义下的所有周期记录
		if(CollectionUtils.isEmpty(cycleList)){
			return new HashMap(0);
		}
		Map<String, Cycle> cycleMap = cycleList.stream().collect(Collectors.toMap(Cycle::getUsername, a -> a, (key1, key2)-> key1));
		//Map<String, List<Cycle>> cycleMap = cycleList.stream().collect(Collectors.groupingBy(Cycle::getUsername));//分组的例子
		return cycleMap;
	}

	/**
	 * 完成任务
	 * @param taskId
	 */
	public Map<String, Object> complete(HttpServletRequest request, String taskId, Map<String, Object> map) throws Exception {
		Map<String, Object> taskMap = taskService.getTaskById(taskId);
		if(taskMap==null || !((Integer)taskMap.get("status")==1 || (Integer)taskMap.get("status")==3)){//1未开始，3进行中，才可以完成任务
			throw new Exception("任务不存在或不可处理");
		}
		//判断任务的关联项目是否完成
		String taskReq = (String) taskMap.get("task_req");
		String reqId = (String) taskMap.get("req_id");
		String reqModelId = (String) taskMap.get("req_model_id");
		if(!StringUtils.isEmpty(taskReq) && !taskInstanceService.check(taskReq, reqId, reqModelId)){
			throw new Exception("请先完成"+taskReq+"工作");
		}
		taskMap.put("status", "2");
		taskMap.put("zxjssj", new Date());
		taskMap.put("remark", map.get("remark"));
		super.update(taskMap, request);
		return taskMap;
	}

	/**
	 * 完成任务
	 * @param taskReq 任务要求：会议，巡检，学习。如：TaskInstanceService.XUNJIAN
	 * @param reqId 任务具体id
	 */
	public void completeByOther(String taskReq, String reqId) throws Exception {
		Map<String, Object> param = new HashMap<>();
		param.put("task_req", taskReq);
		param.put("req_id", reqId);
		List<Map<String, Object>> tasks = this.select(param);//根据会议id查询出对应的清单任务
		if(CollectionUtils.isEmpty(tasks)){//如果不存在，不做处理
			return;
		}
		for (Map<String, Object> task : tasks) {//否则将关联任务完成
			this.complete(MyApiUtils.getRequest(), (String) task.get("id"), new HashMap<>(0));
		}
	}

    public Map<String, Object> instance(String taskId, Map<String, Object> map) throws Exception {
		Map<String, Object> taskMap = taskService.getTaskById(taskId);
		if(taskMap==null || ((Integer)taskMap.get("status")!=1 && (Integer)taskMap.get("status")!=3)){
			throw new Exception("任务（"+taskId+"）不存在或已被处理");
		}
		taskMap.put("task_req", map.get("task_req"));
		taskMap.put("req_id", map.get("req_id"));
		taskMap.put("status", 3);//状态改为3：进行中
		taskService.update(taskMap);
		return taskMap;
    }

	public Integer status(String taskId, Integer status) throws Exception {
		Map<String, Object> param = new HashMap<>();
		param.put("status", status);
		param.put("id", taskId);
		return taskService.update(param);
	}

	/**
	 * 改变任务状态
	 * @param taskReq 任务要求：会议，巡检，学习。如：TaskInstanceService.XUNJIAN
	 * @param reqId 任务具体id
	 */
	public void statusByOther(String taskReq, String reqId, Integer status) throws Exception {
		Map<String, Object> param = new HashMap<>();
		param.put("task_req", taskReq);
		param.put("req_id", reqId);
		List<Map<String, Object>> tasks = this.select(param);//根据会议id查询出对应的清单任务
		if(CollectionUtils.isEmpty(tasks)){//如果不存在，不做处理
			return;
		}
		for (Map<String, Object> task : tasks) {//否则将关联任务完成
			this.status((String) task.get("id"), status);
		}
	}
}
