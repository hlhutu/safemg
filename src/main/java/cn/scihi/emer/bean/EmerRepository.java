package cn.scihi.emer.bean;

import cn.scihi.sdk.base.pojo.BaseBean;
import lombok.Data;

import java.util.Date;

@Data
public class EmerRepository extends BaseBean {
    String id;
    String sys_id;
    String rep_no;//仓库编号
    String rep_name;//仓库名
    String category;//类型
    String address;//仓库地址
    String org_id;//所属机构
    String link_user;//联系人
    String link_phone;//联系电话
    String lon;//经度
    String lat;//维度
    String description;//简介
    Date created;//创建时间
}
