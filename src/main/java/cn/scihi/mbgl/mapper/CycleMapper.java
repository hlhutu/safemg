package cn.scihi.mbgl.mapper;

import cn.scihi.mbgl.bean.Cycle;
import cn.scihi.sdk.base.mapper.IBaseMapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

/**
 * @author uplus
 *
 */
public interface CycleMapper extends IBaseMapper {
    List<Cycle> getCycleList(@Param("taskDefId") String taskDefId, @Param("usernames") List<String> usernames);
}
