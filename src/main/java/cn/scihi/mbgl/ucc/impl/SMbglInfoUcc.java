package cn.scihi.mbgl.ucc.impl;

import cn.scihi.mbgl.service.impl.SMbglInfoService;
import cn.scihi.mbgl.service.impl.TaskInstanceService;
import cn.scihi.sdk.core.MyApiUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.service.IBaseService;
import cn.scihi.sdk.base.ucc.UccAdapter;
import org.springframework.util.CollectionUtils;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * @author uplus
 *
 */
@Service
public class SMbglInfoUcc extends UccAdapter {

	@Autowired
	private SMbglInfoService sMbglInfoService;

	public void init() throws Exception {
		super.setBaseService(sMbglInfoService);
	}

	public int insert(Map<String, Object> map, HttpServletRequest request) throws Exception {
		if(TaskInstanceService.XUNJIAN.equals(map.get("zysx"))){
			if(map.get("req_model_id")==null){
				throw new Exception("请选择巡检模板");
			}
		}
		if(TaskInstanceService.STUDY.equals(map.get("zysx"))){
			if(map.get("req_model_id")==null){
				throw new Exception("请选择学习库");
			}
		}
		return super.insert(map, request);
	}

	public List<Map<String, Object>> select(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> dataList = super.select(map);
		// 查询附件
		if (!CollectionUtils.isEmpty(dataList)) {
			try {
				for (Map<String, Object> stringObjectMap : dataList) {
					String fk_id =  (String) stringObjectMap.get("id");

					Map<String, Object> parameter = new HashMap();
					parameter.put("fk_id", fk_id);
					List<Map> files = (List)MyApiUtils.queryFile(parameter).get("datas");
					if(!CollectionUtils.isEmpty(files)){
						stringObjectMap.put("files", files);
						Object attachListStr = this.getFileStr(files,(String)map.get("delflag"));
						stringObjectMap.put("attachList", attachListStr == null ? "" : attachListStr);
					}
				}
			} catch (Exception e) {
				throw new Exception("附件查询失败！");
			}
		}
		return dataList;
	}

	public static String getFileStr(List<Map> files, String delflag) throws Exception {
		String token = (String)MyApiUtils.getRequest().getSession().getAttribute("token");
		StringBuffer sb = new StringBuffer("");
		sb.append("<span class='viewer'>");
		for(Iterator var7 = files.iterator(); var7.hasNext(); sb.append("</span> ")) {
			Map file = (Map)var7.next();
			sb.append("<span class='" + file.get("id") + "'>");
			String url = MyApiUtils.ups + "/sys/file/download.do" + "?id=" + file.get("id") + "&token=" + token;
			if ("1".equals(file.get("image_"))) {
				sb.append("<img src='" + url + "'>");
			} else {
				sb.append("<a href='" + url + "' target='blank_'>");
				sb.append(file.get("file_name") + "." + file.get("file_ext"));
				sb.append("</a>");
			}
			if ("1".equals(delflag)) {
				sb.append("<sup fileid='" + file.get("id") + "');'>×</sup>");
			}
		}
		sb.append("</span>");
		return sb.toString();
	}
}
