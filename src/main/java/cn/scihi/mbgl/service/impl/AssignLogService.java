package cn.scihi.mbgl.service.impl;

import cn.scihi.mbgl.mapper.AssignLogMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.mapper.IBaseMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;

import java.util.List;
import java.util.Map;

/**
 * @author uplus
 *
 */
@Service
public class AssignLogService extends ServiceAdapter {

	@Autowired
	private AssignLogMapper assignLogMapper;

	public void init() throws Exception {
		super.setBaseMapper(assignLogMapper);
	}

	public List<Map<String, Object>> queryAssignLogByModelId(String modelId) {
		return assignLogMapper.queryAssignLogByModelId(modelId);
	}
}
