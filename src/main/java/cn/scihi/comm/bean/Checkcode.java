package cn.scihi.comm.bean;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.Date;

@AllArgsConstructor
@Data
public class Checkcode {
    String code;
    Date expireTime;
}
