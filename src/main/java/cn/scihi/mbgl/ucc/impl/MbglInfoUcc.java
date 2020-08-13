/**
 * 
 */
package cn.scihi.mbgl.ucc.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import cn.scihi.comm.util.CONST;
import cn.scihi.mbgl.service.impl.PropService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;

import cn.scihi.mbgl.service.impl.MbglInfoService;
import cn.scihi.sdk.base.ucc.UccAdapter;
import org.springframework.util.CollectionUtils;

/**
 * @author 岳开
 *
 */
@Service
public class MbglInfoUcc extends UccAdapter {

	@Resource
	private MbglInfoService mbglInfoService;
	@Autowired
	private PropService propService;

	public void init() {
		super.baseService = mbglInfoService;
	}

	/**
	 * 新增发布
	 */
	@Override
	public int insert(Map<String, Object> map, HttpServletRequest request) throws Exception {
		int rs = 0;
		if (map.containsKey("id")) {// 已有数据
			Map<String, Object> para = new HashMap<String, Object>();
			String id = (String) map.get("id");
			/**
			 * 生成新版本
			 */
			map.remove("id");
			rs = mbglInfoService.insert(map);

			/**
			 * 修改历史版本
			 */
			para.put("status", 9);// 表示作废，历史版本
			para.put("row_hist_new", map.get("id"));// 历史版本指向新版id
			para.put("row_hist_old", id);// 历史版本id
			mbglInfoService.updateRowHist(para);
		} else {
			rs = mbglInfoService.insert(map);
		}

		return rs;
	}

	@Transactional(rollbackFor = Exception.class)
	public int insertFirst(Map<String, Object> map, HttpServletRequest request) throws Exception {
		List<Map<String, Object>> taskDefs = mbglInfoService.select(map);
		if(!CollectionUtils.isEmpty(taskDefs)){
			for (Map<String, Object> taskDef : taskDefs) {
				propService.remove(CONST.PROC_DEF_CONF, (String) taskDef.get("id"));
			}
			mbglInfoService.delete(map);
		}
		Map<?, ?> details = JSON.parseObject((String) map.get("mbgl_info_list"), Map.class);
		if(CollectionUtils.isEmpty(details)){
			return 0;
		}
		for (int i = 0; i < details.size(); i++) {
			Map<String, Object> detail = (Map) details.get(i + "");
			if(detail==null){
				break;
			}
			detail.put("glid", map.get("glid"));
			detail.put("status", "1");//默认状态为
			mbglInfoService.insert(detail);
			List<String> confs = (List<String>) detail.get("conf");
			if(!CollectionUtils.isEmpty(confs)){
				for (String conf : confs) {
					propService.add(CONST.PROC_DEF_CONF, (String) detail.get("id"), conf);
				}
			}
		}
		return details.size();
	}

	/**
	 * 修改保存
	 */
	@Override
	public int update(Map<String, Object> map, HttpServletRequest request) throws Exception {

		return mbglInfoService.update(map);
	}

	public List<Map<String, Object>> selectTaskDefs(String id, String username, String stat) throws Exception {
		return mbglInfoService.selectTaskDefs(id, username, stat);
    }

//	@Override
//	public int insert(Map<String, Object> map, HttpServletRequest request) throws Exception {
//		int size = Integer.valueOf((String) map.get("mbgl_info_size"));
//		if (size > 0) {
//			mbglInfoService.delete(map);
//			Map<?, ?> details = JSON.parseObject((String) map.get("mbgl_info_list"), Map.class);
//			for (int i = 0; i < size; i++) {
//				Map<String, Object> detail = (Map) details.get(i + "");
//				detail.put("glid", map.get("glid"));
//				detail.put("sfmb", map.get("sfmb"));
//				detail.put("status", "1");
//				mbglInfoService.insert(detail);
//			}
//		}
//		return size;
//	}
}
