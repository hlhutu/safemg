package cn.scihi.report.service;

import cn.scihi.report.mapper.DataInputMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.List;
import java.util.Map;

@Service
public class DataInputService extends ServiceAdapter {

	@Autowired
	private DataInputMapper dataInputMapper;

	public void init() throws Exception {
		super.setBaseMapper(dataInputMapper);
	}

	public List<Map<String, Object>> allDataInput(String p_org_id) {
		//1、查询机构人员统计
		List<Map<String, Object>> orgUserMap = dataInputMapper.queryOrgUsersReport(p_org_id);
		if(CollectionUtils.isEmpty(orgUserMap)){
			return orgUserMap;
		}
		//2、查询各机构的角色数
		List<Map<String, Object>> orgRoleMap = dataInputMapper.queryOrgRolesReport(orgUserMap, p_org_id);
		for (Map<String, Object> org : orgUserMap) {
			for (Map<String, Object> orgRole : orgRoleMap) {
				if(org.get("id").equals(orgRole.get("id"))){
					org.put("role_count", orgRole.get("role_count"));
					org.put("model_count", orgRole.get("model_count"));
				}
			}
		}
		return orgUserMap;
	}
}
