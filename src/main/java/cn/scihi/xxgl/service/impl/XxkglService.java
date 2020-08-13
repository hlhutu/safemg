package cn.scihi.xxgl.service.impl;

import javax.annotation.Resource;

import cn.scihi.xxgl.mapper.XxkglMapper;
import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.mapper.IBaseMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;
import org.springframework.util.CollectionUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
* @author xiongxiaojing
* @version 创建时间：2020年4月28日 下午5:06:10
*/
@Service
public class XxkglService extends ServiceAdapter{
	@Resource
	private XxkglMapper xxkglMapper;

	@Override
	public void init() throws Exception {
		super.baseMapper = xxkglMapper;
	}

    public Map<String, Object> selectById(String modelId) throws Exception {
		Map<String, Object> param = new HashMap<>();
		param.put("id", modelId);
		List<Map<String, Object>> list = this.select(param);
		if(CollectionUtils.isEmpty(list)){
			return null;
		}else {
			return list.get(0);
		}
    }

    @Override
	public List<Map<String, Object>> select(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = super.select(map);
		Long finished;
		for (Map<String, Object> xxk : list) {
			finished = xxkglMapper.countFinished((String) xxk.get("id"), (String) map.get("username"));
			xxk.put("finished", finished);
			if(finished>=(Long)xxk.get("total")){
				xxk.put("status", "0");//完成
			}else{
				xxk.put("status", "1");//进行中
			}
		}
		return list;
	}
}
