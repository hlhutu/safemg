package cn.scihi.xjgl.ucc.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.annotations.Select;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSON;

import cn.scihi.mbgl.service.impl.TaskInstanceService;
import cn.scihi.mbgl.ucc.impl.TaskUcc;
import cn.scihi.sdk.base.service.IBaseService;
import cn.scihi.sdk.base.ucc.UccAdapter;
import cn.scihi.sdk.core.MyApiUtils;

/**
 * @author uplus
 *
 */
@Service
public class XjglInfoUcc extends UccAdapter {

	@Autowired
	private IBaseService xjglService;
	@Autowired
	private IBaseService xjglInfoService;
	@Autowired
	private TaskUcc taskUcc;

	public void init() throws Exception {
		super.setBaseService(xjglInfoService);
	}

	@Override
	public List<Map<String, Object>> select(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = xjglInfoService.select(map);
		if (map.containsKey("xj_id")) {
			for (Map<String, Object> m : list) {
				Map<String, Object> para = new HashMap<String, Object>();
				para.put("fk_id", m.get("id"));
				Map<String, Object> files = MyApiUtils.queryFile(para);
				m.put("files", (List) files.get("datas"));
			}
		}
		return list;
	}

	@Override
	public int insert(Map<String, Object> map, HttpServletRequest request) throws Exception {
		Map<String, Object> para = new HashMap<String, Object>();
		para.put("id", map.get("xj_id"));
		List<Map<String, Object>> list = xjglService.select(para);
		if (null == list || list.size() < 1) {
			throw new Exception("巡检清单数据不存在！id:" + para.get("id"));
		}
		String zxzt = list.get(0).get("zxzt") + "";
		if (!"0".equals(zxzt)) {
			throw new Exception("当前巡检任务不可再变更，当前状态：" + ("1".equals(zxzt) ? "执行中" : "已执行"));
		}
		xjglInfoService.delete(map);
		if (null != map.get("xjgl_info_size")) {
			int size = Integer.valueOf((String) map.get("xjgl_info_size"));
			if (size > 0) {
				Map details = JSON.parseObject((String) map.get("xjgl_info_list"), Map.class);
				for (int i = 0; i < size; i++) {
					Map detail = (Map) details.get(i + "");

					if (null != detail.get("lnglat")) {
						String lnglat = detail.get("lnglat") + "";
						detail.put("rwjd", StringUtils.substringBefore(lnglat, ","));// 任务经度
						detail.put("rwwd", StringUtils.substringAfter(lnglat, ","));// 任务纬度
					}

					detail.put("xj_id", map.get("xj_id"));
					detail.put("zxr", map.get("zxr"));
					detail.put("status", "1");
					xjglInfoService.insert(detail);
				}
			}
			return size;
		} else {
			return xjglInfoService.insert(map);
		}
	}

	@Override
	public int update(Map<String, Object> map, HttpServletRequest request) throws Exception {
		Map<String, Object> para = new HashMap<String, Object>();
		para.put("id", map.get("xj_id"));
		List<Map<String, Object>> list = xjglService.select(para);
		if (null == list || list.size() < 1) {
			throw new Exception("巡检清单数据不存在！id:" + para.get("id"));
		}
		para = list.get(0);
		String zxzt = para.get("zxzt") + "";
		if (!"1".equals(zxzt)) {
			throw new Exception("当前巡检清单暂时不能执行，有效时间：" + para.get("kssj") + "~" + para.get("jssj") + "当前状态："
					+ ("0".equals(zxzt) ? "未开始" : "已执行"));
		}
		taskUcc.statusByOther(TaskInstanceService.XUNJIAN, (String) map.get("xj_id"), 3);//更新关联的任务状态
		return super.update(map, request);
	}
}
