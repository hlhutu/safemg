package cn.scihi.comm.controller;

import cn.scihi.comm.service.CheckcodeService;
import cn.scihi.comm.service.UserService;
import cn.scihi.comm.util.Result;
import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.base.ucc.IBaseUcc;
import cn.scihi.sdk.core.MyApiUtils;
import cn.scihi.sdk.util.SysAnnotation.SysLog;
import com.alibaba.fastjson.JSONObject;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.constraints.NotBlank;
import java.util.*;

/**
 * @author uplus
 *
 */
@RestController
@SysLog(module = "注册")
@RequestMapping("/user")
public class UserController extends BizController {

	@Autowired
	private IBaseUcc cycleUcc;

	public void init() {
		super.setBaseUcc(cycleUcc);
	}

	@Value("${app.sys_id}")
	private String SYS_ID;
	@Value("${app.normal_role}")
	private String NORMAL_ROLE_ID;
	@Autowired
	private CheckcodeService checkcodeService;
	@Autowired
	private UserService userService;

	/**
	 * showdoc
	 * @catalog 南充应急/用户
	 * @title 注册
	 * @description -
	 * @method post
	 * @url /smg/user/register
	 * @param mobile_phone 是 String 手机号，本地查重
	 * @param checkcode 是 String 验证码
	 * @param password 是 String 登录密码
	 * @param user_alias 是 String 用户姓名
	 * @param org_id 是 String 所属机构
	 * @param role_ids 否 String 该用户所属角色，多个用逗号隔开
	 * @return {}
	 * @return_param datas Object 注册后的用户信息
	 * @remark
	 * @number 0
	 */
	@RequestMapping(value = "/register", method = RequestMethod.POST)
	@SysLog(module = "用户", method = "注册")
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> register(HttpServletRequest request) throws Exception {
		Map<String, Object> param = this.getParameterMap(request, false);
		String user_name = (String)param.get("mobile_phone");
		String mobile_phone = (String)param.get("mobile_phone");
		String checkcode = (String)param.get("checkcode");
		if(StringUtils.isEmpty(user_name) || userService.exists(user_name)){
			throw new Exception("手机号重复");
		}
		Result r = checkcodeService.check(user_name, checkcode);
		if(!r.isSuccess()){
			throw new Exception(r.getMessage());
		}
		Map<String, Object> paramMap = new IdentityHashMap<>();
		paramMap.put("token", MyApiUtils.token(SYS_ID, "admin"));
		paramMap.put("flag", "sysManager");
		paramMap.put("user_name", user_name);
		paramMap.put("mobile_phone", mobile_phone);
		paramMap.put("password", (String)param.get("password"));
		paramMap.put("user_alias", (String)param.get("user_alias"));
		paramMap.put("org_id", (String)param.get("org_id"));
		paramMap.put("user_sex", "1");

		Set<String> roleIds = new HashSet<>();
		roleIds.add(NORMAL_ROLE_ID);
		if(!StringUtils.isEmpty((CharSequence) param.get("role_ids"))){
			for (String roleId : ((String)param.get("role_ids")).split(",")) {
				roleIds.add(roleId);
			}
		}
		for (String roleId : roleIds) {
			paramMap.put(new String("roles"), roleId);//添加角色
		}
		return MyApiUtils.post(MyApiUtils.ups+"/admin/user/insert.do", paramMap);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/用户
	 * @title 新增角色
	 * @description 如果角色已经存在，会直接返回存在的数据
	 * @method post
	 * @url /smg/user/add/role
	 * @param role_name 是 String 角色名
	 * @return {}
	 * @return_param id String 角色的id
	 * @remark
	 * @number 0
	 */
	@RequestMapping(value = "/add/role", method = RequestMethod.POST)
	@SysLog(module = "用户", method = "新增角色")
	@Transactional(rollbackFor = Exception.class)
	public synchronized Map<String, Object> addRole(@NotBlank String role_name) throws Exception {
		Map<String, Object> paramMap = new IdentityHashMap<>();
		paramMap.put("token", MyApiUtils.token(SYS_ID, "admin"));
		paramMap.put("flag", "sysManager");
		paramMap.put("role_name", role_name);
		Map<String, Object> res = MyApiUtils.queryRole(paramMap);
		if(res!=null && "success".equals(res.get("resCode"))){
			List<Map<String, Object>> roles = (List<Map<String, Object>>) res.get("datas");
			if(!CollectionUtils.isEmpty(roles)){
				Map<String, Object> role = roles.get(0);
				role.put("resMsg", "数据重复");
				role.put("resCode", "success");
				return role;
			}
		}
		paramMap.put("role_code", role_name);
		paramMap.put("role_type", "2");
		return MyApiUtils.post(MyApiUtils.ups+"/admin/role/insert.do", paramMap);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/用户
	 * @title 验证账号是否已存在
	 * @description -
	 * @method get
	 * @url /smg/user/exists/{mobile_phone}
	 * @param mobile_phone 路径参数 String 手机号
	 * @return {}
	 * @return_param datas Boolean 是否已存在，true存在，false不存在
	 * @remark
	 * @number 0
	 */
	@RequestMapping(value = "/exists/{mobile_phone}", method = RequestMethod.GET)
	@SysLog(module = "用户", method = "注册")
	public boolean checkUsername(HttpServletRequest request, @PathVariable String mobile_phone) throws Exception {
		return userService.exists(mobile_phone);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/用户
	 * @title 查询机构树
	 * @description -
	 * @method get
	 * @url /smg/user/orgs
	 * @param parent_id 是 String 机构id
	 * @param keywords 是 String 关键字查询
	 * @return {}
	 * @return_param datas Object 机构树
	 * @remark
	 * @number 0
	 */
	@RequestMapping(value = "/orgs", method = RequestMethod.GET)
	@SysLog(module = "用户", method = "查询机构树")
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> orgs(HttpServletRequest request, String parent_id, String keywords) throws Exception {
		Map<String, Object> paramMap = new IdentityHashMap<>();
		paramMap.put("token", MyApiUtils.token(SYS_ID, "admin"));
		if(StringUtils.isEmpty(parent_id)){
			parent_id = root_org_id;
		}
		if(!StringUtils.isEmpty(keywords)){
			paramMap.put("keywords", keywords);
		}else {
			paramMap.put("parent_id", parent_id);
		}
		return MyApiUtils.post(MyApiUtils.ups+"/admin/org/select.do", paramMap);
	}

	@Value("${app.root_org_id}")
	private String root_org_id;
	/**
	 * showdoc
	 * @catalog 南充应急/用户
	 * @title 查询角色列表
	 * @description -
	 * @method get
	 * @url /smg/user/roles
	 * @param - - - -
	 * @return {}
	 * @return_param datas Object 机构树
	 * @remark
	 * @number 0
	 */
	@RequestMapping(value = "/roles", method = RequestMethod.GET)
	@SysLog(module = "用户", method = "查询角色列表")
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> roles(HttpServletRequest request) throws Exception {
		Map<String, Object> paramMap = new IdentityHashMap<>();
		paramMap.put("token", MyApiUtils.token(SYS_ID, "admin"));
		return MyApiUtils.post(MyApiUtils.ups+"/admin/role/select.do", paramMap);
	}
}
