/**
 * 
 */
package cn.scihi.mbgl.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import cn.scihi.sdk.core.MyApiUtils;
import com.alibaba.fastjson.JSONObject;
import org.springframework.stereotype.Service;

import cn.scihi.mbgl.mapper.MbglMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

/**
 * @author wyc
 *
 */
@Service
public class MbglService extends ServiceAdapter {

	@Resource
	private MbglMapper mbglMapper;

	public void init() {
		super.baseMapper = mbglMapper;
	}
	
	public List<Map<String, Object>> selectRolesByOrg(Map<String, Object> map) throws Exception{
		try {
			return mbglMapper.selectRolesByOrg(map);
		} catch (Throwable e) {
			throw new Exception("查询角色信息失败"+e.getMessage(),e);
		}
	}
	
	public int softDelete(Map<String, Object> map) {
		return mbglMapper.softDelete(map);
	};

    public synchronized Integer getLastVersion(String key_) {
    	Integer v = mbglMapper.getLastVersion(key_);
    	return v==null?0:v;
    }

    public Map<String, Object> getModelById(String modelId) {
		return this.getModelById(modelId, false);
    }

	public Map<String, Object> getModelById(String modelId, boolean ifTime) {
		Map<String, Object> param = new HashMap<>();
		param.put("id", modelId);
		if(ifTime){
			param.put("ext1", "1");
		}
		List<Map<String, Object>> models = mbglMapper.select(param);
		if(CollectionUtils.isEmpty(models)){
			return null;
		}else{
			return models.get(0);
		}
	}

	public Integer updateForCondition(Map<String, Object> update, Map<String, Object> condition) {
    	return mbglMapper.updateForCondition(update, condition);
	}

	/**
	 * 查询可执行的模板列表
	 * @return
	 */
	public List<Map<String, Object>> getExecutableModels() {
		Map<String, Object> param = new HashMap<>();
		param.put("status", "2");
		param.put("ondate", true);
		return mbglMapper.select(param);
	}

	/**
	 * 查询可执行的模板列表
	 * @return
	 */
	public List<Map<String, Object>> getExecutableModelsForCurrentUser() {
		Map<String, Object> myUser = MyApiUtils.getMyUser();
		Map<String, Object> user = MyApiUtils.getUser();
		Map<String, Object> param = new HashMap<>();
		param.put("status", "2");
		param.put("ondate", true);
		param.put("org_id", user.get("org_id"));
		String str = null;
		List<JSONObject> authes = (List<JSONObject>) myUser.get("authorities");
		if(!CollectionUtils.isEmpty(authes)){
			for (JSONObject authe : authes) {
				if(StringUtils.isEmpty(str)){
					str = authe.getString("authority");
				}else{
					str += ","+authe.getString("authority");
				}
			}
			param.put("role_id", str);
		}

		return mbglMapper.select(param);
	}

	public void deleteModelById(String modelId) {
		Map<String, Object> param = new HashMap<>();
		param.put("status", -1);
		Map<String, Object> condition = new HashMap<>();
		condition.put("id", modelId);
		mbglMapper.updateForCondition(param, condition);
	}

	public List<Map<String, Object>> selectMyTimeModels(String username) {
		return mbglMapper.selectMyTimeModels(username);
	}
}
