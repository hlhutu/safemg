package cn.scihi.mbgl.mapper;

import cn.scihi.sdk.base.mapper.IBaseMapper;

import java.util.List;
import java.util.Map;

/**
 * @author uplus
 *
 */
public interface AssignLogMapper extends IBaseMapper {
    List<Map<String, Object>> queryAssignLogByModelId(String modelId);
}
