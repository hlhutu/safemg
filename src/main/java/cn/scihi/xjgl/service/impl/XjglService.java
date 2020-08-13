package cn.scihi.xjgl.service.impl;

import java.util.*;

import cn.scihi.aqfxdzzh.service.impl.JddService;
import cn.scihi.xjgl.mapper.XjglMapper;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.mapper.IBaseMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;
import cn.scihi.sdk.core.MyApiUtils;
import org.springframework.util.CollectionUtils;

/**
 * @author uplus
 *
 */
@Service
public class XjglService extends ServiceAdapter {

	@Autowired
	private XjglMapper xjglMapper;
	@Autowired
	private IBaseMapper xjglInfoMapper;
	@Autowired
	private IBaseMapper xjmbglMapper;
	@Autowired
	private IBaseMapper xjmbglInfoMapper;
	@Autowired
	private JddService jddService;
	@Autowired
	private XjglInfoService xjglInfoService;
	@Autowired
	private XjmbglService xjmbglService;

	public void init() throws Exception {
		super.setBaseMapper(xjglMapper);
	}

	/**
	 * 根据巡检模板id生成巡检实例
	 * 
	 * @param req_model_id
	 *            模板id
	 * @param username
	 *            模板的执行人username
	 * @return 生成的巡检实例，包含id
	 */
	public Map<String, Object> newInstance(String fxId, String req_model_id, String username, String pid) throws Exception {
		if(StringUtils.isEmpty(req_model_id)){//没有传巡检模板id
			Map<String, Object> fxd = jddService.selectById(fxId);
			if(CollectionUtils.isEmpty(fxd)){
				throw new Exception("请选择风险点");
			}
			Map<String, Object> newXJ = new HashMap<>();
			newXJ.put("xjmc", fxd.get("jddgl_mc")+"临时巡检");
			newXJ.put("xjmb", fxd.get("jddgl_ztjg"));
			newXJ.put("fxid", fxd.get("id"));
			newXJ.put("zxr", username);
			newXJ.put("kssj", new Date());
			newXJ.put("pid", pid);
			super.insert(preInsert(newXJ));
			Map<String, Object> newXJInfo = new HashMap<>();
			newXJInfo.put("xj_id", newXJ.get("id"));
			newXJInfo.put("rwx", fxd.get("jddgl_mc")+"临时巡检");
			newXJInfo.put("rwdd", fxd.get("jddgl_dz"));
			xjglInfoService.insert(preInsert(newXJInfo));
			return newXJ;
		}else {
			Map<String, Object> queryParam = new HashMap<>();
			queryParam.put("id", req_model_id);
			Map<String, Object> xjmodel = xjmbglService.selectOne(queryParam);// 清单模板
			if(CollectionUtils.isEmpty(xjmodel)){//没有选择模板
				throw new Exception("无效的巡检计划");
			}
			Map<String, Object> newXJ = xjmodel;
			newXJ.put("mbid", req_model_id);
			newXJ.put("zxr", username);
			newXJ.put("kssj", new Date());
			newXJ.put("pid", pid);
			newXJ.remove("id");
			super.insert(preInsert(newXJ));
			queryParam.clear();
			queryParam.put("xj_id", req_model_id);
			List<Map<String, Object>> infos = xjmbglInfoMapper.select(queryParam);// 任务项模板
			for (Map<String, Object> n : infos) {
				n.put("xj_id", newXJ.get("id"));
				n.put("zxr", username);
				n.remove("id");
				xjglInfoService.insert(preInsert(n));
			}
			return newXJ;
		}
	}

	private Map<String, Object> preInsert(Map<String, Object> map) throws Exception {
		if (StringUtils.isEmpty((String)map.get("id"))) {
		       map.put("id", UUID.randomUUID().toString());
	      }
		if ((map.get("sort_no") == null) || (StringUtils.isEmpty(map.get("id").toString()))) {
			map.put("sort_no", Integer.valueOf(1));
		}
		if (StringUtils.isEmpty((String) map.get("row_state"))) {
			map.put("row_state", "1");
		}
		if (StringUtils.isEmpty((String) map.get("row_default")))
			map.put("row_default", "0");
		try {
			map.put("creator", MyApiUtils.getUser("user_name"));
		} catch (Exception localException) {
		}
		map.put("created", new Date());
		map.put("modifier", map.get("creator"));
		map.put("modified", map.get("created"));
		map.put("row_version", Long.valueOf(((Date) map.get("modified")).getTime()));

		return map;
	}

    public Long countByJdd(String jddId) {
		return xjglMapper.countByJdd(jddId);
    }
}
