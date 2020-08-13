package cn.scihi.app;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.service.IBaseService;
import cn.scihi.sdk.base.ucc.UccAdapter;
import cn.scihi.sdk.core.MyApiUtils;

/**
 * @author uplus
 *
 */
@Service
public class AppUcc extends UccAdapter {

	@Autowired
	private IBaseService appService;

	public void init() throws Exception {
		super.setBaseService(appService);
	}

	public int insert(Map map, HttpServletRequest request) throws Exception {
		Map<String, Object> resultMap = MyApiUtils.uploadFile(null, request);
		List<Map<String, Object>> files = (List<Map<String, Object>>) resultMap.get("files");
		for (Map<String, Object> file : files) {
			map.put("app_url", file.get("file_path"));
			return super.insert(map, null);
		}
		return 0;
	}

	public String getCodeUrl(String version) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		if (!StringUtils.isEmpty(version)) {
			map.put("version", version);
		}
		List<Map<String, Object>> dataList = this.appService.select(map);
		dataList = dataList.stream()
				.sorted((o1, o2) -> Integer.valueOf(o2.get("version").toString().replace(".", ""))
						.compareTo(Integer.valueOf(o1.get("version").toString().replace(".", ""))))
				.collect(Collectors.toList());

		String url = dataList.get(0).get("app_url").toString();
		return url;
	}
}
